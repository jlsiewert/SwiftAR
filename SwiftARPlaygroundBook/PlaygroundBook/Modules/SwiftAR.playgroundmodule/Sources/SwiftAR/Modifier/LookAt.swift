//
//  LookAt.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 18.04.21.
//

import Foundation
import simd

public struct LookAtModifier: PrimitiveModifier {
    public enum Target {
        case origin
        case camera
        case point(simd_float4x4)
    }
    
    public typealias Body = Never
    let target: Target
    
    public init(_ target: Target) {
        self.target = target
    }
}

public extension Model {
    func lookAt(_ target: LookAtModifier.Target) -> some Model {
        modifier(LookAtModifier(target))
    }
}
