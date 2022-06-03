//
//  Model+Material.swift
//  SwiftAr
//
//  Created by Jan Luca Siewert on 13.04.21.
//

import Foundation
import SwiftUI

public extension Model {
    /// Adds the specific material to the model. It is used by the entire hierachy.
    @_disfavoredOverload
    func material(_ material: Material) -> some Model {
        self.environment(\.material, material)
    }
    
    /// Adds the specific view as a texture to the model.
    func material<V: SwiftUI.View>(_ view: V) -> some Model {
        self.environment(\.material, Material.view(AnyView(erasing: view)))
    }
    
}
