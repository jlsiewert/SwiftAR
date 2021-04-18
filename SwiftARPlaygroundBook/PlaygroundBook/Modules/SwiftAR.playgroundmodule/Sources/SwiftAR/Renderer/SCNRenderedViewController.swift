//
//  SCNRenderedViewController.swift
//
//
//  Created by Jan Luca Siewert on 04.04.21.
//

import Foundation
import ARKit
#if canImport(PlaygroundSupport)
import PlaygroundSupport
#endif

class ARSCNViewObserver: NSObject, ARSCNViewDelegate {
    typealias DidAddNodeForAnchorCallback = (ARAnchor, SCNNode) -> ()
    var didAddNodeForAnchor: DidAddNodeForAnchorCallback
    init(callback: @escaping DidAddNodeForAnchorCallback) {
        self.didAddNodeForAnchor = callback
    }
    
    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
        didAddNodeForAnchor(anchor, node)
    }
}

public class SCNRenderedViewController<E: Experience>: UIViewController {
    enum State {
        case intitializing
        case waitingToAttach(ARAnchorAttachable, SCNNode)
        case attached
    }
    
    lazy var scnView = ARSCNView()
    
    var renderer: SCNNodeRenderer!
    
    let experience: E
    
    lazy var experienceNode: SCNNode = {
        let n = SCNNode()
        n.name = "Experience"
        return n
    }()
    
    lazy var coachingView: ARCoachingOverlayView = {
        let view = ARCoachingOverlayView()
        view.activatesAutomatically = true
        view.sessionProvider = scnView
        return view
    }()
    
    var session: ARSession {
        scnView.session
    }
    
    var scene: SCNScene {
        scnView.scene
    }
    
    var state = State.intitializing
    
    var observer: ARSCNViewObserver!
    
    public init(experience: E) {
        self.experience = experience
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        #if canImport(PlaygroundSupport)
        view.frame = self.liveViewSafeAreaGuide.layoutFrame
        #else
        scnView.showsStatistics = true
        #endif
        scnView.frame = view.frame
        scnView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        scnView.automaticallyUpdatesLighting = true
        let point = SCNLight()
        point.type = .ambient
        point.intensity = 300
        scnView.scene.rootNode.light = point
        view.addSubview(scnView)
        
        coachingView.frame = view.frame
        coachingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(coachingView)
        view.bringSubviewToFront(coachingView)
        
        observer = ARSCNViewObserver { [weak self] anchor, node in
            guard let self = self, case .waitingToAttach(let anyAnchor, let mountedNode) = self.state else {
                return
            }
            if anyAnchor.shouldAttach(to: anchor) {
                node.addChildNode(mountedNode)
                self.state = .attached
            }
        }
        scnView.delegate = observer
        
        renderer = SCNNodeRenderer(root: experienceNode, experience: experience, delegate: self)
        
        let gestureRecognoizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        scnView.addGestureRecognizer(gestureRecognoizer)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        guard sender.state == .ended else { return }
        let location = sender.location(in: scnView)
        
        // First, check nodes, then raycast
        if let first = scnView.hitTest(location, options: [:]).first {
            // Traverse up the hierachy until no more nodes or a `TappableNode` is found
            var element: SCNNode? = first.node
            while element != nil {
                if let tappable = element as? TappableNode {
                    tappable.onTapHandler()
                    return
                }
                element = element?.parent
            }
        }
    }
}

extension SCNRenderedViewController: SCNNodeRendererDelegate {
    func renderer(_ renderer: SCNNodeRenderer, didMountNode node: SCNNode, for anchor: AnyAnchor) {
        print("Starting AR experience")
         if case .attached = state { return }
        if let anchorAttachable = anchor.anchor as? ARAnchorAttachable {
            if case .intitializing = state {
                self.session.run(anchorAttachable.configuration(), options: [.resetTracking, .removeExistingAnchors])
                self.state = .waitingToAttach(anchorAttachable, node)
                anchorAttachable.guidanceHint().map { coachingView.goal = $0 }
            }
            
        } else if let nodeAttachable = anchor.anchor as? NodeAttachableAnchor,
                  nodeAttachable.shouldAttach(to: node),
                  case .intitializing = state {
            if case .intitializing = state {
                self.session.run(nodeAttachable.configuration(), options: [.resetTracking, .removeExistingAnchors])
                self.state = .attached
                self.scene.rootNode.addChildNode(node)
                nodeAttachable.guidanceHint().map { coachingView.goal = $0 }
            }
            
        }
    }
}


#if canImport(PlaygroundSupport)
extension SCNRenderedViewController: PlaygroundLiveViewSafeAreaContainer { }
#endif
