//
//  Coders.swift
//  Picasso
//
//  Created by Aviel Gross on 12.12.2023.
//

import Foundation

extension JSONEncoder: SomeEncoder {}
extension JSONDecoder: SomeDecoder {}

import ZippyJSON
extension ZippyJSONDecoder: SomeDecoder {}

import MessagePacker
extension MessagePacker.MessagePackEncoder: SomeEncoder {}
extension MessagePacker.MessagePackDecoder: SomeDecoder {}

import MessagePack
extension MessagePack.MessagePackEncoder: SomeEncoder {}
extension MessagePack.MessagePackDecoder: SomeDecoder {}


extension Parser {
    static var shared: Parser = Parser(encoder: JSONEncoder(), decoder: ZippyJSONDecoder())
}