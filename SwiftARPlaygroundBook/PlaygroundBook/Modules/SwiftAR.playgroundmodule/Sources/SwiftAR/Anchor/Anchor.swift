//
//  Anchor.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 02.04.21.
//

import Foundation

/**
 An `Anchor` is, together with ``Experience`` and ``Model`` one of the basic buildung blocks of `SwiftAR`.
 It describes, to what kind of real-world objects the virtual content should be attached.
 */
public protocol Anchor {
    associatedtype Body: Model
    
    @ModelBuilder var body: Body { get }
}
