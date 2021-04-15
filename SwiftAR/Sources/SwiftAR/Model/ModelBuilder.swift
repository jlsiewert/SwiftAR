//
//  ModelBuilder.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 02.04.21.
//

import Foundation
@_functionBuilder
public struct ModelBuilder {
    public static func buildBlock<M: Model>(_ components: M) -> M {
        components
    }
    
    public static func buildBlock<M1: Model, M2: Model>(_ m1: M1, _ m2: M2) -> TupelModel {
        TupelModel(m1: m1, m2: m2)
    }
    
    public static func buildBlock<M1: Model, M2: Model, M3: Model>(_ m1: M1, _ m2: M2, _ m3: M3) -> TupelModel {
        TupelModel(m1: m1, m2: m2, m3: m3)
    }
    
    public static func buildBlock<M1: Model, M2: Model, M3: Model, M4: Model>(_ m1: M1, _ m2: M2, _ m3: M3, _ m4: M4) -> TupelModel {
        TupelModel(m1: m1, m2: m2, m3: m3, m4: m4)
    }
    
    public static func buildBlock<M1: Model, M2: Model, M3: Model, M4: Model, M5: Model>(_ m1: M1, _ m2: M2, _ m3: M3, _ m4: M4, _ m5: M5) -> TupelModel {
        TupelModel(m1: m1, m2: m2, m3: m3, m4: m4)
    }
}
