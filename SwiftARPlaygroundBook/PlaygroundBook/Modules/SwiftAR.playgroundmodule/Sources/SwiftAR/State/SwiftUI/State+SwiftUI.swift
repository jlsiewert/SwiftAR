//
//  State+SwiftUI.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 15.04.21.
//

import Foundation
import SwiftUI

public extension State {
    /// Create a `SwiftUI.Binding` binding from a `State`.
    var binding: SwiftUI.Binding<Value> {
        SwiftUI.Binding(get: { wrappedValue }, set: { wrappedValue = $0 })
    }
}
