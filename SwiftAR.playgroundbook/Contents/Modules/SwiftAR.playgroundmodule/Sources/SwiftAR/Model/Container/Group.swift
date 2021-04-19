//
//  Group.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 15.04.21.
//

import Foundation

public struct Group<Content: Model>: Model {
    let content: Content
    public init(@ModelBuilder content: () -> Content) {
        self.content = content()
    }
    
    public var body: some Model {
        content
    }
}
