//
//  File.swift
//  
//
//  Created by Jan Luca Siewert on 04.04.21.
//

import Foundation
import SceneKit

protocol SCNNodeRendererDelegate: AnyObject {
    func renderer(_ renderer: SCNNodeRenderer, didMountNode node: SCNNode, for anchor: AnyAnchor)
}

final class SCNNodeRenderer: Renderer {
    
    typealias TargetType = SCNNode
    
    let root: SCNNode
    var reconciler: StackReconciler<SCNNodeRenderer>!
    weak var delegate: SCNNodeRendererDelegate?
    
    init<E: Experience>(root: SCNNode, experience: E, delegate: SCNNodeRendererDelegate) {
        self.root = root
        self.reconciler = StackReconciler(experience: experience, renderer: self)
        self.delegate = delegate
    }
    
    func mount(_ element: MountedElement<SCNNodeRenderer>, to parent: TargetType? = nil) -> SCNNode {
        self.mount(element, to: parent, whileApplyingOptional: nil)
    }
    
    func mount(_ element: MountedElement<SCNNodeRenderer>, to parent: TargetType? = nil, whileApplying modifier: Any) -> SCNNode {
        self.mount(element, to: parent, whileApplyingOptional: modifier)
    }
    
    func mount(_ element: MountedElement<SCNNodeRenderer>, to parent: SCNNode?, whileApplyingOptional modifier: Any?) -> SCNNode {
        print("Mount \(element._type)")
        switch element.mounted {
            case .experience:
                return root
            case .anchor(let anchor):
                guard let parent = parent else {
                    fatalError("Attempting to mount anchor without parent")
                }
                let node = SCNNode()
                node.name = String(describing: element._type)
                parent.addChildNode(node)
                delegate?.renderer(self, didMountNode: parent, for: anchor)
                return node
            case .model(let model):
                guard let parent = parent else {
                    fatalError("Attempting to mount anchor without parent")
                }
                if let n = model.model as? NodeReflectable {
                    let node = n.create()
                    node.name = String(describing: element._type)
                    if let modifier = modifier as? NodeReflectableModifier {
                        modifier.apply(to: node)
                    }
                    parent.addChildNode(node)
                    return node
                } else if let modifier = model.model as? NodeReflectableModifier {
                    parent.name = "\(parent.name ?? "")_\(String(describing: element._type))"
                    modifier.apply(to: parent)
                    return parent
                } else {
                    let n = SCNNode()
                    n.name = String(describing: element._type)
                    if let modifier = modifier as? NodeReflectableModifier {
                        modifier.apply(to: n)
                    }
                    parent.addChildNode(n)
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
