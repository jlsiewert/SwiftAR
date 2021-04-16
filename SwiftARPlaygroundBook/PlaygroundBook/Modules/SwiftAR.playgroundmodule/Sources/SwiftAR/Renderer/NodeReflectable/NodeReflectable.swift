//
//  NodeReflectable.swift
//  
//
//  Created by Jan Luca Siewert on 04.04.21.
//

import Foundation
import SceneKit

protocol NodeReflectable {
    func create() -> SCNNode
    func update(_ node: SCNNode)
    func remove(_ node: SCNNode)
}

extension NodeReflectable {
    func remove(_ node: SCNNode) {
        node.removeFromParentNode()
    }
}
