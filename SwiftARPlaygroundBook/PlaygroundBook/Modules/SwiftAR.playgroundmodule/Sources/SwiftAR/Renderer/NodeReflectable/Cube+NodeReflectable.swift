//
//  Cube+NodeReflectable.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 04.04.21.
//

import Foundation
import SceneKit

extension Cube: NodeReflectable {
    func create() -> SCNNode {
        let geometry = SCNBox(width: CGFloat(self.width), height: CGFloat(self.height), length: CGFloat(self.length), chamferRadius: 0)
        geometry.materials = [ self.self.material.createMaterial() ]
        let node = SCNNode(geometry: geometry)
        return node
        
    }
    
    func update(_ node: SCNNode) {
        guard let box = node.geometry as? SCNBox else { return }
        if let m = box.materials.first {
            self.material.update(material: m)
        }
        
        box.width = CGFloat(self.width)
        box.height = CGFloat(self.height)
        box.length = CGFloat(self.length)
    }
    
    
}
