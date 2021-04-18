//
//  Sphere.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 15.04.21.
//

import Foundation
import SceneKit

public struct Sphere: Model {
    let radius: Float
    
    @Environment(\.material) var material: Material
    
    public init(radius: Float = 0.1) {
        self.radius = radius
    }
}

extension Sphere: PrimitiveModel { }
extension Sphere: NodeReflectable {
    func create() -> SCNNode {
        let sphere = SCNSphere(radius: CGFloat(radius))
        sphere.materials = [material.createMaterial()]
        return SCNNode(geometry: sphere)
    }
    
    func update(_ node: SCNNode) {
        guard let s = node.geometry as? SCNSphere else { return }
        s.radius = CGFloat(radius)
        s.materials.first.map(material.update(material:))
    }
    
    
}
