//
//  WorldAnchor.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 02.04.21.
//

import Foundation
import simd

public struct World<Body: Model>: Anchor {
    
    public let body: Body
    
    public init(@ModelBuilder _ model: @escaping () -> Body) {
        self.body = model()
    }
}
