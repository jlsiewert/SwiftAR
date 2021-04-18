//
//  Cylinder.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 15.04.21.
//

import Foundation
import SceneKit

public struct Cylinder: Model {
    let radius: CGFloat
    let height: CGFloat
    
    @Environment(\.material) var material: Material
    
    public init(radius: Float = 0.1, height: Float = 0.2) {
        self.radius = CGFloat(radius)
        self.height = CGFloat(height)
    }
}

extension Cylinder: PrimitiveModel { }
extension Cylinder: NodeReflectable {
    func create() -> SCNNode {
        let c = SCNCylinder(radius: radius, height: height)
        c.materials = [material.createMaterial()]
        return SCNNode(geometry: c)
    }
    
    func update(_ node: SCNNode) {
        guard let c = node.geometry as? SCNCylinder else {
            return
        }
        c.radius = radius
        c.height = height
        c.materials.first.map(material.update(material:))
    }
    
    
}
