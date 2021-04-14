//
//  Renderer.swift
//  
//
//  Created by Jan Luca Siewert on 04.04.21.
//

import Foundation

protocol Renderer: AnyObject {
    associatedtype TargetType: Hashable & AnyObject
    
    func mount(_ element: MountedElement<Self>, to parent: TargetType?) -> TargetType
    func apply(_ modifier: Any, to target: TargetType)
    func update(_ element: MountedElement<Self>)
    func unmount(_ element: MountedElement<Self>)
}
