//
//  TransformModifier+NodeReflectable.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 10.04.21.
//

import Foundation
import SceneKit

extension TransformModifier: NodeReflectableModifier {
    func apply(to node: SCNNode) {
        node.simdTransform = transform
    }
    
    
}
