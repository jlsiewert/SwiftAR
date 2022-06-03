//
//  Material.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 13.04.21.
//

import Foundation
import UIKit
import SwiftUI

/// The material that is used for the ``Model``.
///
/// Use the ``Model/material(_:)-3ah50`` method to add a material to the model.
public enum Material: Equatable {
    /// Use a ``UIKit/UIColor``
    case color(UIColor)
    /// Use an ``UIKit/UIImage`` as a texture
    case texture(UIImage)
    case _swiftUIview(SwiftUI.AnyView)
    
    /// Use an interactive ``SwiftUI/View`` as a texture
    public static func view<V: View>(_ view: V) -> Material {
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
