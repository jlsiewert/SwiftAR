//
//  WorldAnchor.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 02.04.21.
//

import Foundation
import simd

public struct World<M: Model>: Anchor {
    
    let transform: simd_float4x4
    let model: () -> M
    
    public init(transform: simd_float4x4, @ModelBuilder _ model: @escaping () -> M) {
        self.transform = transform
        self.model = model
    }
    
    public init(translation: simd_float3, @ModelBuilder _ model: @escaping () -> M) {
        self.transform = simd_float4x4(translation: translation)
        self.model = model
    }

    public var body: M {
        model()
    }
}
