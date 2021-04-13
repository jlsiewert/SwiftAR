//
//  Material.swift
//  
//
//  Created by Jan Luca Siewert on 13.04.21.
//

import Foundation
import UIKit
import SwiftUI

public enum Material: Equatable {
    case color(UIColor)
    case texture(UIImage)
    case _swiftUIview(SwiftUI.AnyView)
    
    static func view<V: View>(_ view: V) -> Material {
        ._swiftUIview(AnyView(erasing: view))
    }
}

extension Material {
    public static func == (lhs: Material, rhs: Material) -> Bool {
        switch (lhs, rhs) {
            case (.color(let l), .color(let r)):
                return l == r
            case (.texture(let l), .texture(let r)):
                return l == r
            case (._swiftUIview, ._swiftUIview):
                return true
            default:
                return false
        }
    }
}

public struct MaterialEnvrionmentKey: EnvironmentKey {
    public static let defaultValue: Material = .color(.lightGray)
}

public extension EnvironmentValues {
    var material: Material {
        get { self[MaterialEnvrionmentKey.self] }
        set { self[MaterialEnvrionmentKey.self] = newValue }
    }
}
