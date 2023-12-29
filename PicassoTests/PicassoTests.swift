//
//  PicassoTests.swift
//  PicassoTests
//
//  Created by Aviel Gross on 13.11.2023.
//

import XCTest
import AnyCodable
import SwiftUI
import ZippyJSON
import MessagePacker // hirotakan/MessagePacker
import MessagePack // fumoboy007/msgpack-swift

@testable import Picasso

struct EncodeExample {
    static var modifier1 = FontModifier(
        font: .system(.footnote, design: .monospaced, weight: .light)
    )

    static var modifier2 = ForegroundColorModifier(foregroundColor: .orange)

    static var modifier3 = FontModifier(font: .body)

    static var modifier4 = ForegroundColorModifier(foregroundColor: .primary)


    static var text1 = PCText(text: "Check") {
            modifier1
            modifier2
        }

    static var text2 = PCText(text: "Check Simple") {
            modifier3
            modifier4
        }

    static var text3 = PCText(text: "Check Simple")

    static var stack1 = PCStack(.vStack, spacing: 20, alignment: .listRowSeparatorLeading) { 
        text1
        text2
    }

    static var stack2 = PCStack(.hStack, alignment: .firstTextBaseline) { text1 }

    static var stack3 = PCStack(.zStack, alignment: .bottomTrailing) { text1 }

    static var scrollview1 = PCScrollView(axes: .vertical) {
        text1
        text2
    }

    static var image1 = 
    PCAsyncImage(URL(string: "https://picsum.photos/200/300"), scale: 1, mode: .fill)

    static var image2 =
    PCAsyncImage(URL(string: "https://picsum.photos/200"))

    static var page1 = PCPageView(indexDisplay: .never) {
        image1
        image2
    }
}


final class PicassoTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testEncode() throws {
        let data = try JSONEncoder().encode(EncodeExample.text1)
        //        let json = String(data: data, encoding: .utf8) ?? "NA"
        //        print(json)

        let jsonObj = try data.dictionary()

        let data2 = """
    {"text":"Check","modifiers":{"foregroundColor":"orange","font":{"design":"monospaced","weight":"light","style":"footnote"}}}
    """.data(using: .utf8)!

        let jsonObj2 = try data2.dictionary()

        XCTAssertEqual(jsonObj, jsonObj2, "\nNot Equal:\n\n-> \(jsonObj.description)\n-> \(jsonObj2.description)")

    }

    func testDecode() throws {
        let viewJsons = [
            text_json1, text_json2, text_json3, text_json4,
            stack_json1, stack_json2,
            scrollview_example1, scrollView_example2,
            shape_json1,
            image_json1, image_json2
        ]
        for json in viewJsons {
            XCTAssertNoThrow(Parser.shared.view(from: json))
        }
    }

    func test<V: View>(view: V) throws where V: Codable {
        let decoder = JSONDecoder()
        let encoder = JSONEncoder()

        // View to Data
        let dataFromView = try view.jsonData()

        // Data to Dictionary
        let jsonObjFromView = try dataFromView.dictionary()

        // Dictionary to Data
        let dataFromJsonObj = try encoder.encode(jsonObjFromView)

        // Data to view
        let viewFromData = try decoder.decode(V.self, from: dataFromView)

        let viewFromDataFromJsonObj = try decoder.decode(V.self, from: dataFromJsonObj)

        XCTAssertEqual(
            try viewFromData.jsonData().dictionary(),
            try viewFromDataFromJsonObj.jsonData().dictionary()
        )
    }

    func testViews() throws {
        for view in [EncodeExample.text1, EncodeExample.text2, EncodeExample.text3] {
            try test(view: view)
        }
        for view in [EncodeExample.stack1, EncodeExample.stack2, EncodeExample.stack3] {
            try test(view: view)
        }
        for view in [EncodeExample.scrollview1] {
            try test(view: view)
        }
        for view in [EncodeExample.image1, EncodeExample.image2] {
            try test(view: view)
        }
        for view in [EncodeExample.page1] {
            try test(view: view)
        }
    }

    func _test<V: Codable>(fileName: String, rootType: V.Type) throws {
        let url = Bundle.main.url(forResource: fileName, withExtension: "json")!
        let data = try Data(contentsOf: url)
        XCTAssertNoThrow(Parser.shared.view(from: data))

        let codableView = try JSONDecoder().decode(V.self, from: data)
        let dataFromView = try codableView.jsonData()
        XCTAssertNoThrow(Parser.shared.view(from: dataFromView))
    }

    func testRemoteViews() throws {
        try _test(fileName: "Example", rootType: PCStack.self)
        try _test(fileName: "Example2", rootType: PCScrollView.self)
    }

    func testPerformanceExample() throws {
        Parser.shared.encoder = JSONEncoder()
        Parser.shared.decoder = JSONDecoder()
        measure {
            try! testDecode()
            try! testViews()
        }
    }

    // MARK: - Performance Tests
    
    /// Last measurement:
    ///
    /// JSONE ENCODE  NM 0.072
    /// JSON DECODE NM 0.202
    /// JSON DECODE WM 0.286
    /// ZIPPY DECODE NM 0.232
    /// ZIPPY DECODE WM 0.231
    /// PACKER ENCODE NM 0.076
    /// PACKER DECODE NM 0.330
    /// PACKER ENCODE WM 0.068
    /// PACKER ENCODE WM 0.153
    /// MSGPACK ENCODE NM 0.083
    /// MSGPACK DECODE NM 0.219

    // MARK: Baseline - JSONDecoder/Encoder

    func testJSONEncodePerformanceLargeView() throws {
        Parser.shared.encoder = JSONEncoder()
        Parser.shared.decoder = JSONDecoder()
        measure {
            let view = noModifiersLargeView(count: 2_500)
            _ = try! Parser.shared.encoder.encode(view)
        }
    }

    func testJSONDecodePerformanceNoModifiersLargeView() throws {
        Parser.shared.encoder = JSONEncoder()
        Parser.shared.decoder = JSONDecoder()
        let view = noModifiersLargeView(count: 2_500)
        let dataFromView = try Parser.shared.encoder.encode(view)

        measure {
            _ = Parser.shared.view(from: dataFromView)
        }
    }

    func testJSONDecodePerformanceLargeView() throws {
        Parser.shared.encoder = JSONEncoder()
        Parser.shared.decoder = JSONDecoder()
        let view = largeView(count: 250)
        let dataFromView = try Parser.shared.encoder.encode(view)

        measure {
            _ = Parser.shared.view(from: dataFromView)
        }
    }

    // MARK: ZippyJSON (Decode only)

    func testZippyJSONDecodePerformanceNoModifiersLargeView() throws {
        Parser.shared.encoder = JSONEncoder()
        Parser.shared.decoder = ZippyJSONDecoder()
        let view = noModifiersLargeView(count: 2_500)
        let dataFromView = try Parser.shared.encoder.encode(view)

        measure {
            _ = Parser.shared.view(from: dataFromView)
        }
    }

    func testZippyJSONDecodePerformanceLargeView() throws {
        Parser.shared.encoder = JSONEncoder()
        Parser.shared.decoder = ZippyJSONDecoder()
        let view = largeView(count: 250)
        let dataFromView = try Parser.shared.encoder.encode(view)

        measure {
            _ = Parser.shared.view(from: dataFromView)
        }
    }

    // MARK: MessagePacker

    func testMessagePackerEncodePerformanceNoModifiersLargeView() throws {
        Parser.shared.encoder = MessagePacker.MessagePackEncoder()
        Parser.shared.decoder = MessagePacker.MessagePackDecoder()
        measure {
            let view = noModifiersLargeView(count: 2_500)
            _ = try! Parser.shared.encoder.encode(view)
        }
    }

    func testMessagePackerDecodePerformanceNoModifiersLargeView() throws {
        Parser.shared.encoder = MessagePacker.MessagePackEncoder()
        Parser.shared.decoder = MessagePacker.MessagePackDecoder()
        let view = noModifiersLargeView(count: 2_500)
        let dataFromView = try Parser.shared.encoder.encode(view)
        measure {
            _ = Parser.shared.view(from: dataFromView)
        }
    }

    func testMessagePackerEncodePerformanceLargeView() throws {
        Parser.shared.encoder = MessagePacker.MessagePackEncoder()
        Parser.shared.decoder = MessagePacker.MessagePackDecoder()
        measure {
            let view = largeView(count: 250)
            _ = try! Parser.shared.encoder.encode(view)
        }
    }

    func testMessagePackerDecodePerformanceLargeView() throws {
        Parser.shared.encoder = MessagePacker.MessagePackEncoder()
        Parser.shared.decoder = MessagePacker.MessagePackDecoder()
        let view = largeView(count: 250)
        let dataFromView = try Parser.shared.encoder.encode(view)
        measure {
            _ = Parser.shared.view(from: dataFromView)
        }
    }

    // MARK: msgpack-swift

    func testMsgPackEncodePerformanceNoModifiersLargeView() throws {
        Parser.shared.encoder = MessagePack.MessagePackEncoder()
        Parser.shared.decoder = MessagePack.MessagePackDecoder()
        measure {
            let view = noModifiersLargeView(count: 2_500)
            _ = try! Parser.shared.encoder.encode(view)
        }
    }

    func testMsgPackDecodePerformanceNoModifiersLargeView() throws {
        Parser.shared.encoder = MessagePack.MessagePackEncoder()
        Parser.shared.decoder = MessagePack.MessagePackDecoder()
        let view = noModifiersLargeView(count: 2_500)
        let dataFromView = try Parser.shared.encoder.encode(view)
        measure {
            _ = Parser.shared.view(from: dataFromView)
        }
    }
}

extension [String: AnyCodable] {
    var description: String {
        let data = try! JSONEncoder().encode(self)
        return String(data: data, encoding: .utf8) ?? "NA"
    }
}

func noModifiersLargeView(count: Int) -> some PCView {
    let stack = PCStack(.hStack, alignment: .bottom) {
        PCText(text: "lorem ipsum")
        PCButton(
            title: "blah blah blah",
            action: .presentURL(URL(string: "www.google.com")!)
        )
        PCShapeView(
            shape: .capsule(style: .circular),
            fill: .gradient(gradient: .init(colors: [.red, .blue]), spread: .elliptical(center: .bottom, startRadiusFraction: 0.1, endRadiusFraction: 0.2)),
            stroke: .color(value: .accentColor),
            lineWidth: 3
        )
        PCAsyncImage(URL(string: "www.google.com")!, scale: 2, mode: .fit)
    }

    return PCScrollView(axes: .horizontal) {
        [any PCView](repeating: stack, count: count)
    }
}

@ModifierBuilder
func manyModifiers() -> some PCModifier {
    FontModifier(font: .callout)
    ForegroundColorModifier(foregroundColor: .red)
    LineLimitModifier(lineLimit: 1...5)
    TextAlignModifier(alignment: .trailing)
    PaddingModifier(padding: .init(top: 1, leading: 2, bottom: 3, trailing: 4))
    FrameModifier(frame: .init(width: 10, height: 20, minWidth: 30, idealWidth: 40, maxWidth: 40, minHeight: nil, idealHeight: nil, maxHeight: 60, alignment: .bottomLeading))
}

func largeView(count: Int) -> some PCView {
    let text = PCText(text: "lorem ipsum") {
        manyModifiers()
    }

    let btn = PCButton(
        title: "blah blah blah",
        action: .presentURL(URL(string: "www.google.com")!)
    ) {
        BackgroundModifier(content: text)
        manyModifiers()
    }

    let shape = PCShapeView(
        shape: .capsule(style: .circular),
        fill: .gradient(gradient: .init(colors: [.red, .blue]), spread: .elliptical(center: .bottom, startRadiusFraction: 0.1, endRadiusFraction: 0.2)),
        stroke: .color(value: .accentColor),
        lineWidth: 3) {
            OverlayModifier(content: text, alignment: .centerFirstTextBaseline)
            manyModifiers()
        }


    let image = PCAsyncImage(URL(string: "www.google.com")!, scale: 2, mode: .fit) {
        FontModifier(font: .callout)
        ForegroundColorModifier(foregroundColor: .red)
        LineLimitModifier(lineLimit: 1...5)
        TextAlignModifier(alignment: .trailing)
        PaddingModifier(padding: .init(top: 1, leading: 2, bottom: 3, trailing: 4))
        FrameModifier(frame: .init(width: 10, height: 20, minWidth: 30, idealWidth: 40, maxWidth: 40, minHeight: nil, idealHeight: nil, maxHeight: 60, alignment: .bottomLeading))
    }

    let stack = PCStack(.hStack, alignment: .bottom) {
        text
        btn
        shape
        image
    }

    let scrollView = PCScrollView(axes: .horizontal) {
        manyModifiers()
    } views: {
        [any PCView](repeating: stack, count: count)
    }

    return scrollView
}
