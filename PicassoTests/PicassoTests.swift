//
//  PicassoTests.swift
//  PicassoTests
//
//  Created by Aviel Gross on 13.11.2023.
//

import XCTest
import AnyCodable
import SwiftUI

@testable import Picasso

struct EncodeExample {
    static var modifier1: PCModifiersData = try! FontModifier(
        font: .system(.footnote, design: .monospaced, weight: .light)
    ).jsonData().dictionary()

    static var modifier2: PCModifiersData = try! ForegroundColorModifier(foregroundColor: .orange)
        .jsonData().dictionary()

    static var modifier3 = try! FontModifier(font: .body)
        .jsonData().dictionary()

    static var modifier4 = try! ForegroundColorModifier(foregroundColor: .primary)
        .jsonData().dictionary()


    static var text1 = PCText(text: "Check", modifiers: [modifier1, modifier2].merged)

    static var text2 = PCText(text: "Check Simple", modifiers: [modifier3, modifier4].merged)

    static var text3 = PCText(text: "Check Simple")

    static var stack1 = PCStack(.vStack, spacing: 20, alignment: .listRowSeparatorLeading, content: [text1, text2])

    static var stack2 = PCStack(.hStack, alignment: .firstTextBaseline, content: [text1])

    static var stack3 = PCStack(.zStack, alignment: .bottomTrailing, content: [text1])

    static var scrollview1 =
        PCScrollView(axes: .vertical, views: [text1, text2])

    static var image1 = 
    PCAsyncImage(image: URL(string: "https://picsum.photos/200/300"), scale: 1, mode: .fill, modifiers: [:])

    static var image2 =
    PCAsyncImage(image: URL(string: "https://picsum.photos/200"), scale: nil, mode: nil, modifiers: [:])
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
            XCTAssertNoThrow(Parser.view(from: json))
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
    }

    func _test<V: Codable>(fileName: String, rootType: V.Type) throws {
        let url = Bundle.main.url(forResource: fileName, withExtension: "json")!
        let data = try Data(contentsOf: url)
        XCTAssertNoThrow(Parser.view(from: data))

        let codableView = try JSONDecoder().decode(V.self, from: data)
        let dataFromView = try codableView.jsonData()
        XCTAssertNoThrow(Parser.view(from: dataFromView))
    }

    func testRemoteViews() throws {
        try _test(fileName: "Example", rootType: PCStack.self)
        try _test(fileName: "Example2", rootType: PCScrollView.self)
    }

    func testPerformanceExample() throws {
        measure {
            try! testDecode()
            try! testViews()
        }
    }

}

extension [String: AnyCodable] {
    var description: String {
        let data = try! JSONEncoder().encode(self)
        return String(data: data, encoding: .utf8) ?? "NA"
    }
}
