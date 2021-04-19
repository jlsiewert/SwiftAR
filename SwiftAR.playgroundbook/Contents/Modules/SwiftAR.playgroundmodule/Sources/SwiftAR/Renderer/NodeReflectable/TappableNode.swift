//
//  TappableNode.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 14.04.21.
//

import Foundation
import SceneKit

class TappableNode: SCNNode {
    var onTapHandler: () -> ()
    
    init(handler: @escaping () -> ()) {
        self.onTapHandler = handler
        super.init()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}

extension OnTapModel: NodeReflectable {
    func create() -> SCNNode {
        TappableNode(handler: self.handler)
    }
    
    func update(_ node: SCNNode) {
        (node as? TappableNode)?.onTapHandler = self.handler
    }
    
    
}
