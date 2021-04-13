//
//  File.swift
//  
//
//  Created by Jan Luca Siewert on 10.04.21.
//

import Foundation
import SceneKit

extension TransformModifier: NodeReflectableModifier {
    func apply(to node: SCNNode) {
        let m = SCNMatrix4(transform)
        node.transform = m
    }
    
    
}
