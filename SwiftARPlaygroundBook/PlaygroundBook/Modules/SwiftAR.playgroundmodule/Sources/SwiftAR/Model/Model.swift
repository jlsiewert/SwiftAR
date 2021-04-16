//
//  Model.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 02.04.21.
//

import Foundation

public protocol Model {
    associatedtype Body: Model
    
    var body: Body { get }
}

extension Never: Model { }
