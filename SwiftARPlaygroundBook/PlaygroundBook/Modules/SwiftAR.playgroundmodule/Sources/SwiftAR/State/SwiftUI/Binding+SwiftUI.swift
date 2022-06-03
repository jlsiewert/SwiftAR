//
//  Binding+SwiftUI.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 15.04.21.
//

import Foundation
import SwiftUI

public extension SwiftUI.State {
    /// Create a ``SwiftAR/Binding`` from a ``SwiftUI/Binding``
    var binding: Binding<Value> {
        Binding(get: { wrappedValue }, set: { wrappedValue = $0 })
    }
}

public extension Binding {
    /// Create a ``SwiftUI/Binding`` from a ``SwiftAR/Binding``
    var binding: SwiftUI.Binding<Value> {
        .init(get: { wrappedValue }, set: { wrappedValue = $0 })
    }
}

public extension SwiftUI.Binding {
    /// Create a ``SwiftAR/Binding`` from a ``SwiftUI/State``
    var binding: Binding<Value> {
        .init(get: { wrappedValue }, set: { wrappedValue = $0 })
    }
}
