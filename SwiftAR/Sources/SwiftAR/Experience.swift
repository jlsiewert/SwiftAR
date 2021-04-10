//
//  SwiftAR.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 02.04.21.
//

import UIKit

public protocol Experience {
    associatedtype Body: Anchor
    var body: Body { get }
    
    init()
}

public extension Experience {
    static func preview(size: CGSize = CGSize(width: 500, height: 500)) -> UIView {

    let experience = Self()
    let rendererViewController = SCNRenderedViewController(experience: experience)
    rendererViewController.view.frame = CGRect(origin: .zero, size: size)
    #if canImport(PlaygroundSupport)
    PlaygroundPage.current.liveView = renderedViewController.view
    PlaygroundPage.current.needsInfiniteExecution = true
    #endif
        return rendererViewController.view
    }
}
