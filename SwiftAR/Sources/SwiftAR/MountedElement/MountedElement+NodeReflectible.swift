//
//  File.swift
//  
//
//  Created by Jan Luca Siewert on 07.04.21.
//

import Foundation
import SceneKit

extension MountedElement: NodeReflectable where M: NodeReflectable, Element == SCNNode {
    private var model: M {
        guard case .model(let m) = mounted else {
            fatalError("Can't get model for an experience")
        }
        return m
    }
    
    func create() -> SCNNode {
        model.create()
    }
    
    func update(_ node: SCNNode) {
        model.update(node)
    }
    
    func remove(_ node: SCNNode) {
        model.remove(node)
    }
}
