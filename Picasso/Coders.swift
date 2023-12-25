//
//  Coders.swift
//  Picasso
//
//  Created by Aviel Gross on 12.12.2023.
//

import Foundation

import ZippyJSON
extension ZippyJSONDecoder: SomeDecoder {}

import MessagePacker
extension MessagePacker.MessagePackEncoder: SomeEncoder {}
extension MessagePacker.MessagePackDecoder: SomeDecoder {}

import MessagePack
extension MessagePack.MessagePackEncoder: SomeEncoder {}
extension MessagePack.MessagePackDecoder: SomeDecoder {}
