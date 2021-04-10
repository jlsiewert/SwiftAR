//
//  File.swift
//  
//
//  Created by Jan Luca Siewert on 04.04.21.
//

import Foundation
import SceneKit

extension Cube: NodeReflectable {
    func create() -> SCNNode {
        let geometry = SCNBox(width: CGFloat(width), height: CGFloat(height), length: CGFloat(length), chamferRadius: 0)
        return SCNNode(geometry: geometry)
    }
    
    func update(_ node: SCNNode) {
        guard let box = node.geometry as? SCNBox else { return }
        box.width = CGFloat(width)
        box.height = CGFloat(height)
        box.length = CGFloat(length)
    }
    
    
}
