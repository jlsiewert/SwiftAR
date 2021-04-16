//
//  Anchor.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 02.04.21.
//

import Foundation

public protocol Anchor {
    associatedtype Body: Model
    
    @ModelBuilder var body: Body { get }
}
