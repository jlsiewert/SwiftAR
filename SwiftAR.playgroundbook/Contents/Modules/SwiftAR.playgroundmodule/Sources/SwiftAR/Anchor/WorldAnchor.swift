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
    var raycast: ((simd_float4x4) -> ())?
    
    public init(@ModelBuilder _ model: @escaping () -> Body) {
        self.body = model()
    }
}

public extension World {
    func onTap( _ raycastHandler: @escaping (simd_float4x4) -> () ) -> Self {
        var s = self
        s.raycast = raycastHandler
        return s
    }
}
