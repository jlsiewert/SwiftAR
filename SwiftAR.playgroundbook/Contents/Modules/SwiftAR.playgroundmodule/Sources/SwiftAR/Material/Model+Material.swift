//
//  Model+Material.swift
//  SwiftAr
//
//  Created by Jan Luca Siewert on 13.04.21.
//

import Foundation
import SwiftUI

public extension Model {
    
    @_disfavoredOverload
    func material(_ material: Material) -> some Model {
        self.environment(\.material, material)
    }
    
    func material<V: SwiftUI.View>(_ view: V) -> some Model {
        self.environment(\.material, Material.view(AnyView(erasing: view)))
    }
    
}
