//
//  TupelModel.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 15.04.21.
//

import Foundation

/// A `TupelModel` combines children while preserving their type information.
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
    
    public init<
        M1: Model,
        M2: Model,
        M3: Model,
        M4: Model,
        M5: Model,
        M6: Model
        >(m1: M1, m2: M2, m3: M3, m4: M4, m5: M5, m6: M6) {
        self.children = [
            AnyModel(erasing: m1),
            AnyModel(erasing: m2),
            AnyModel(erasing: m3),
            AnyModel(erasing: m4),
            AnyModel(erasing: m5),
            AnyModel(erasing: m6)
        ]
    }
    
    public init<
        M1: Model,
        M2: Model,
        M3: Model,
        M4: Model,
        M5: Model,
        M6: Model,
        M7: Model
    >(m1: M1, m2: M2, m3: M3, m4: M4, m5: M5, m6: M6, m7: M7) {
        self.children = [
            AnyModel(erasing: m1),
            AnyModel(erasing: m2),
            AnyModel(erasing: m3),
            AnyModel(erasing: m4),
            AnyModel(erasing: m5),
            AnyModel(erasing: m6),
            AnyModel(erasing: m7)
        ]
    }
    
    public init<
        M1: Model,
        M2: Model,
        M3: Model,
        M4: Model,
        M5: Model,
        M6: Model,
        M7: Model,
        M8: Model
    >(m1: M1, m2: M2, m3: M3, m4: M4, m5: M5, m6: M6, m7: M7, m8: M8) {
        self.children = [
            AnyModel(erasing: m1),
            AnyModel(erasing: m2),
            AnyModel(erasing: m3),
            AnyModel(erasing: m4),
            AnyModel(erasing: m5),
            AnyModel(erasing: m6),
            AnyModel(erasing: m7),
            AnyModel(erasing: m8)
        ]
    }
    
    public init<
        M1: Model,
        M2: Model,
        M3: Model,
        M4: Model,
        M5: Model,
        M6: Model,
        M7: Model,
        M8: Model,
        M9: Model
    >(m1: M1, m2: M2, m3: M3, m4: M4, m5: M5, m6: M6, m7: M7, m8: M8, m9: M9) {
        self.children = [
            AnyModel(erasing: m1),
            AnyModel(erasing: m2),
            AnyModel(erasing: m3),
            AnyModel(erasing: m4),
            AnyModel(erasing: m5),
            AnyModel(erasing: m6),
            AnyModel(erasing: m7),
            AnyModel(erasing: m8),
            AnyModel(erasing: m9)
        ]
    }
    
    public init<
        M1: Model,
        M2: Model,
        M3: Model,
        M4: Model,
        M5: Model,
        M6: Model,
        M7: Model,
        M8: Model,
        M9: Model,
        M10: Model
    >(m1: M1, m2: M2, m3: M3, m4: M4, m5: M5, m6: M6, m7: M7, m8: M8, m9: M9, m10: M10) {
        self.children = [
            AnyModel(erasing: m1),
            AnyModel(erasing: m2),
            AnyModel(erasing: m3),
            AnyModel(erasing: m4),
            AnyModel(erasing: m5),
            AnyModel(erasing: m6),
            AnyModel(erasing: m7),
            AnyModel(erasing: m8),
            AnyModel(erasing: m9),
            AnyModel(erasing: m10)
        ]
    }
}

extension TupelModel: PrimitiveModel { }
extension TupelModel: ChildProvidingModel { }
