//
//  File.swift
//  
//
//  Created by Jan Luca Siewert on 04.04.21.
//

import Foundation
import SceneKit

public final class SCNNodeRenderer: Renderer {
    typealias TargetType = SCNNode
    
    let scene: SCNScene
    var reconciler: StackReconciler<SCNNodeRenderer>!
    
    public init<E: Experience>(scene: SCNScene, experience: E) {
        self.scene = scene
        self.reconciler = StackReconciler(experience: experience, renderer: self)
    }
    
    func mount(_ element: MountedElement<SCNNodeRenderer>, to parent: SCNNode?) -> SCNNode {
        print("Mount \(element._type)")
        switch element.mounted {
            case .experience:
                return scene.rootNode
            case .anchor(let anchor):
                guard let parent = parent else {
                    fatalError("Attempting to mount anchor without parent")
                }
                guard let n = anchor.anchor as? NodeReflectable else {
                    let n = createEmpty(for: parent)
                    n.name = String(describing: element._type)
                    return n
                }
                let node = n.create()
                node.name = String(describing: element._type)
                parent.addChildNode(node)
                return node
            case .model(let model):
                guard let parent = parent else {
                    fatalError("Attempting to mount anchor without parent")
                }
                if let n = model.model as? NodeReflectable {
                    let node = n.create()
                    node.name = String(describing: element._type)
                    parent.addChildNode(node)
                    return node
                } else if let modifier = model.model as? NodeReflectableModifier {
                    parent.name = "\(parent.name ?? "")_\(String(describing: element._type))"
                    modifier.apply(to: parent)
                    return parent
                } else {
                    let n = createEmpty(for: parent)
                    n.name = String(describing: element._type)
                    return n
                }
        }
    }
    
    func apply(_ modifier: Any, to target: SCNNode) {
        guard let modifier = modifier as? NodeReflectableModifier else {
            return
        }
        print("Applying primitive modifier \(modifier) to \(target)")
        modifier.apply(to: target)
    }
    
    func update(_ element: MountedElement<SCNNodeRenderer>) {
        if case .model = element.mounted {
            if let model = element.model.model as? NodeReflectable {
                element.element.map(model.update)
            } else if let modifier = element.model.model as? NodeReflectableModifier {
                element.element.map(modifier.apply(to:))
            }
        }
    }
    
    func unmount(_ element: MountedElement<SCNNodeRenderer>) {
        guard case .model(let m) = element.mounted else { return }
        if let model = m.model as? NodeReflectable {
            element.element.map(model.remove(_:))
        }
    }
    
    func createEmpty(for parent: SCNNode) -> SCNNode {
        print("Creating empty node")
        let n = SCNNode()
        parent.addChildNode(n)
        return n
    }
}
