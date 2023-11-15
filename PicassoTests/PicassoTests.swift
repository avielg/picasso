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
    static var modifier1: PCModifierData = try! FontModifier(
        font: .system(.footnote, design: .monospaced, weight: .light)
    ).jsonData().dictionary()

    static var modifier2: PCModifierData = try! ForegroundColorModifier(foregroundColor: .orange)
        .jsonData().dictionary()

    static var modifier3 = try! FontModifier(font: .body)
        .jsonData().dictionary()

    static var modifier4 = try! ForegroundColorModifier(foregroundColor: .primary)
        .jsonData().dictionary()


    static var text1: PCText {
        PCText(text: "Check", modifiers: [modifier1, modifier2])
    }

    static var text2: PCText {
        PCText(text: "Check Simple", modifiers: [modifier3, modifier4])
    }

    static var text3: PCText {
        PCText(text: "Check Simple", modifiers: [])
    }

    static var stack1: PCStack {
        PCStack(layout: VStackLayout(alignment: .listRowSeparatorLeading, spacing: 20), views: [
            try! text1.jsonData().dictionary(),
            try! text2.jsonData().dictionary()
        ])
    }

    static var stack2: PCStack {
        PCStack(layout: HStackLayout(alignment: .firstTextBaseline), views: [
            try! text1.jsonData().dictionary(),
        ])
    }

    static var stack3: PCStack {
        PCStack(layout: ZStackLayout(alignment: .bottomTrailing), views: [
            try! text1.jsonData().dictionary(),
        ])
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

        let decoder = JSONDecoder()
        let jsonObj = try decoder.decode([String: AnyCodable].self, from: data)

        let data2 = """
    {"text":"Check","modifiers":[{"font":{"design":"monospaced","weight":"light","style":"footnote"}},{"foregroundColor":"#000000"}]}
    """.data(using: .utf8)!

        let jsonObj2 = try decoder.decode([String: AnyCodable].self, from: data2)
        XCTAssertEqual(jsonObj, jsonObj2, "\nNot Equal:\n\n-> \(jsonObj.description)\n-> \(jsonObj2.description)")

    }

    func testDecode() throws {
        let viewJsons = [
            text_json1, text_json2, text_json3, text_json4,
            stack_json1, stack_json2
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
        let dataFromJsonObj = try! encoder.encode(jsonObjFromView)

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
    }

    func testPerformanceExample() throws {
        measure {
            try! testViews()
        }
    }

}

extension Encodable {
    func jsonData() throws -> Data {
        try JSONEncoder().encode(self)
    }
}

extension Data {
    func dictionary() throws -> [String: AnyCodable] {
        try JSONDecoder().decode([String: AnyCodable].self, from: self)
    }
}

extension [String: AnyCodable] {
    var description: String {
        let data = try! JSONEncoder().encode(self)
        return String(data: data, encoding: .utf8) ?? "NA"
    }
}
