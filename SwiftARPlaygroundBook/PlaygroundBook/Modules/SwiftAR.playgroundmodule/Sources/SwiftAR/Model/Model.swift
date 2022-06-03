//
//  Model.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 02.04.21.
//

import Foundation
/**
 A `Model` is the basic building block for virtual content.
 
 
 */
public protocol Model {
    /// The return value of this Model's `body`
    associatedtype Body: Model
    
    /// The `body` describing the virtual conent.
    ///
    /// You create virtual content from <doc:Primitives> and
    /// <doc:ModelModifiers> using result builders (``ModelBuilder``)
    ///
    ///
    var body: Body { get }
}

extension Never: Model { }
