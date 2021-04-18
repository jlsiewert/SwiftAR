//
//  PrimitiveModel.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 04.04.21.
//

import Foundation

protocol PrimitiveModel: Model {
    
}

extension PrimitiveModel {
    public var body: Never {
        fatalError("Can't get \(#function) of PrimitiveModel!")
    }
}
