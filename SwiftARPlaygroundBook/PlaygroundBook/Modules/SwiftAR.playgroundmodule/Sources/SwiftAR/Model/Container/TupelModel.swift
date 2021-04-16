//
//  TupelModel.swift
//  
//
//  Created by Jan Luca Siewert on 15.04.21.
//

import Foundation

public struct TupelModel: Model {
    let children: [AnyModel]
    
    public init<
        M1: Model,
        M2: Model
    >(m1: M1, m2: M2) {
        self.children = [
            AnyModel(erasing: m1),
            AnyModel(erasing: m2)
        ]
    }
    
    public init<
        M1: Model,
        M2: Model,
        M3: Model
    >(m1: M1, m2: M2, m3: M3) {
        self.children = [
            AnyModel(erasing: m1),
            AnyModel(erasing: m2),
            AnyModel(erasing: m3)
        ]
    }
    
    public init<
        M1: Model,
        M2: Model,
        M3: Model,
        M4: Model
    >(m1: M1, m2: M2, m3: M3, m4: M4) {
        self.children = [
            AnyModel(erasing: m1),
            AnyModel(erasing: m2),
            AnyModel(erasing: m3),
            AnyModel(erasing: m4)
        ]
    }
    
    public init<
        M1: Model,
        M2: Model,
        M3: Model,
        M4: Model,
        M5: Model
    >(m1: M1, m2: M2, m3: M3, m4: M4, m5: M5) {
        self.children = [
            AnyModel(erasing: m1),
            AnyModel(erasing: m2),
            AnyModel(erasing: m3),
            AnyModel(erasing: m4),
            AnyModel(erasing: m5)
        ]
    }
}

extension TupelModel: PrimitiveModel { }
extension TupelModel: ChildProvidingModel { }
