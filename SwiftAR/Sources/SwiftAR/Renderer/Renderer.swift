//
//  Renderer.swift
//  
//
//  Created by Jan Luca Siewert on 04.04.21.
//

import Foundation

protocol Renderer: AnyObject {
    associatedtype TargetType: Hashable & AnyObject
    
    func mount<E: Experience, M: Model>(_ element: MountedElement<Self, E, M>, to parent: TargetType) -> TargetType
    func renderRoot<E: Experience>(_ experience: E) -> TargetType
    func apply(_ modifier: Any, to target: TargetType)
}
