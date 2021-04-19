//
//  Plane.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 15.04.21.
//

import Foundation
import SceneKit
import simd

public struct Plane {
    let width: CGFloat
    let height: CGFloat
    
    @Environment(\.material) var material: Material
    @Environment(\.reducedVertexCount) var reducedVertexCount: Bool
    
    public init(width: Float = 0.1, height: Float = 0.1) {
        self.width = CGFloat(width)
        self.height = CGFloat(height)
    }
}

extension Plane: PrimitiveModel, NodeReflectable {
    func create() -> SCNNode {
        let p = SCNPlane(width: width, height: height)
        p.cornerSegmentCount = reducedVertexCount ? 2 : 10
        material.apply(to: p)
        let n = SCNNode(geometry: p)
        n.simdPivot = simd_float4x4(simd_quatf(euler: [0, 0, .pi/2]))
        return n
    }
    func update(_ node: SCNNode) {
        guard let p = node.geometry as? SCNPlane else {
            return
        }
        p.width = width
        p.height = height
        p.cornerSegmentCount = reducedVertexCount ? 2 : 10
        p.materials.first.map(material.update(material:))
    }
}
