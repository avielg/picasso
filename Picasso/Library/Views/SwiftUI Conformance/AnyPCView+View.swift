//
//  AnyPCView+View.swift
//  Picasso
//
//  Created by Aviel Gross on 09.12.2023.
//

import SwiftUI

extension AnyPCView: View {
    var body: some View {
        if let v = data as? PCText { v } else
        if let v = data as? PCStack { v } else
        if let v = data as? PCScrollView { v } else
        if let v = data as? PCShapeView { v } else
        if let v = data as? PCAsyncImage { v } else
        if let v = data as? PCButton { v } else
        if let v = data as? PCOptionalView { v } else
        if let v = data as? PCAsyncView { v } else
        if let v = data as? PCColor { v } else
        if let v = data as? PCPageView { v }
    }
}
