//
//  SCNRenderedViewController.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 04.04.21.
//

import Foundation
import ARKit
#if swift(>=5.4)
#elseif canImport(PlaygroundSupport)
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

/**
 A ``UIKit/UIViewController`` that renders a specific ``Experience``.
 */
public class SCNRenderedViewController<E: Experience>: UIViewController {
    enum State {
        case intitializing
        case waitingToAttach(ARAnchorAttachable, SCNNode)
        case attached
    }
    
    #if targetEnvironment(simulator)
    lazy var scnView = SCNView()
    #else
    lazy var scnView = ARSCNView()
    #endif
    
    var renderer: SCNNodeRenderer!
    
    let experience: E
    
    lazy var experienceNode: SCNNode = {
        let n = SCNNode()
        n.name = "Experience"
        return n
    }()
    
    #if targetEnvironment(simulator)
    var scene: SCNScene {
        scnView.scene!
    }
    #else
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
    #endif
    
    var state = State.intitializing
    
    var observer: ARSCNViewObserver!
    
    var raycastHandler: ((simd_float4x4) -> ())?
    
    var gestureRecognizerInstalled = false
    
    /// Create a renderer for a specific ``Experience``
    /// - Parameter experience: The experience to render.
    public init(experience: E) {
        self.experience = experience
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Not implemented")
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        #if swift(>=5.4)
        #elseif canImport(PlaygroundSupport)
        view.frame = self.liveViewSafeAreaGuide.layoutFrame        
        #endif
        scnView.frame = view.frame
        scnView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        #if targetEnvironment(simulator)
        scnView.allowsCameraControl = true
        scnView.showsStatistics = true
        #else
        scnView.automaticallyUpdatesLighting = true
        #endif
        let point = SCNLight()
        point.type = .ambient
        point.intensity = 300
        #if targetEnvironment(simulator)
        scnView.scene = SCNScene()
        #endif
        scene.rootNode.light = point
        view.addSubview(scnView)
        
        #if !targetEnvironment(simulator)
        coachingView.frame = view.frame
        coachingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(coachingView)
        view.bringSubviewToFront(coachingView)
        self.registerGestureRecognizer()
        
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
        #endif
        
        renderer = SCNNodeRenderer(root: experienceNode, experience: experience, delegate: self)
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
        #if !targetEnvironment(simulator)
        if let raycastHandler = self.raycastHandler,
        let raycast = scnView.raycastQuery(from: location, allowing: .estimatedPlane, alignment: .any),
        let result = session.raycast(raycast).first {
            raycastHandler(result.worldTransform)
        }
        #endif
    }
    
    func registerGestureRecognizer() {
        let gestureRecognoizer = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        scnView.addGestureRecognizer(gestureRecognoizer)
    }
}

extension SCNRenderedViewController: SCNNodeRendererDelegate {
    func renderer(_ renderer: SCNNodeRenderer, didMountNode node: SCNNode, for anchor: AnyAnchor) {
        print("Starting AR experience")
        #if !targetEnvironment(simulator)
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
        if let raycastHandler = (anchor.anchor as? RaycastHandlingAnchor)?.raycast {
            self.raycastHandler = raycastHandler
        }
        #else
        scene.rootNode.addChildNode(node)
        #endif
    }
    
    var pointOfView: SCNNode? {
        scnView.pointOfView
    }
}


#if swift(>=5.4)
#elseif canImport(PlaygroundSupport)
extension SCNRenderedViewController: PlaygroundLiveViewSafeAreaContainer { }
#endif
