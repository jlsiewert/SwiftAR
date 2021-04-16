//
//  File.swift
//  
//
//  Created by Jan Luca Siewert on 15.04.21.
//

import Foundation
import SceneKit

public struct Plane {
    let width: CGFloat
    let height: CGFloat
    
    @Environment(\.material) var material: Material
    
    public init(width: Float = 0.1, height: Float = 0.1) {
        self.width = CGFloat(width)
        self.height = CGFloat(height)
    }
}

extension Plane: PrimitiveModel, NodeReflectable {
    func create() -> SCNNode {
        let p = SCNPlane(width: width, height: height)
        p.materials = [material.createMaterial()]
        return SCNNode(geometry: p)
    }
    func update(_ node: SCNNode) {
        guard let p = node.geometry as? SCNPlane else {
            return
        }
        p.width = width
        p.height = height
        p.materials.first.map(material.update(material:))
    }
}
