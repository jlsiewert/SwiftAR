//
//  Group.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 15.04.21.
//

import Foundation

/// Use a `Group` to combine multiple models together.
///
/// A `Group` does not have an effect on the rendering hierachy,
/// alghough modifiers applied to the group are applied to all its children.
public struct Group<Content: Model>: Model {
    let content: Content
    public init(@ModelBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some Model {
        content
    }
}
