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
        TupelModel(m1: m1, m2: m2, m3: m3, m4: m4, m5: m5)
    }
    
    public static func buildBlock<M1: Model, M2: Model, M3: Model, M4: Model, M5: Model, M6: Model>(_ m1: M1, _ m2: M2, _ m3: M3, _ m4: M4, _ m5: M5, _ m6: M6) -> TupelModel {
        TupelModel(m1: m1, m2: m2, m3: m3, m4: m4, m5: m5, m6: m6)
    }
    
    public static func buildBlock<M1: Model, M2: Model, M3: Model, M4: Model, M5: Model, M6: Model, M7: Model>(_ m1: M1, _ m2: M2, _ m3: M3, _ m4: M4, _ m5: M5, _ m6: M6, _ m7: M7) -> TupelModel {
        TupelModel(m1: m1, m2: m2, m3: m3, m4: m4, m5: m5, m6: m6, m7: m7)
    }
    
    public static func buildBlock<M1: Model, M2: Model, M3: Model, M4: Model, M5: Model, M6: Model, M7: Model, M8: Model>(_ m1: M1, _ m2: M2, _ m3: M3, _ m4: M4, _ m5: M5, _ m6: M6, _ m7: M7, _ m8: M8) -> TupelModel {
        TupelModel(m1: m1, m2: m2, m3: m3, m4: m4, m5: m5, m6: m6, m7: m7, m8: m8)
    }
    
    public static func buildBlock<M1: Model, M2: Model, M3: Model, M4: Model, M5: Model, M6: Model, M7: Model, M8: Model, M9: Model>(_ m1: M1, _ m2: M2, _ m3: M3, _ m4: M4, _ m5: M5, _ m6: M6, _ m7: M7, _ m8: M8, _ m9: M9) -> TupelModel {
        TupelModel(m1: m1, m2: m2, m3: m3, m4: m4, m5: m5, m6: m6, m7: m7, m8: m8, m9: m9)
    }
    
    public static func buildBlock<M1: Model, M2: Model, M3: Model, M4: Model, M5: Model, M6: Model, M7: Model, M8: Model, M9: Model, M10: Model>(_ m1: M1, _ m2: M2, _ m3: M3, _ m4: M4, _ m5: M5, _ m6: M6, _ m7: M7, _ m8: M8, _ m9: M9, _ m10: M10) -> TupelModel {
        TupelModel(m1: m1, m2: m2, m3: m3, m4: m4, m5: m5, m6: m6, m7: m7, m8: m8, m9: m9, m10: m10)
    }
    
    public static func buildIf<M: Model>(_ m: M?) -> _OptionalModel<M> {
        _OptionalModel(m)
    }
    
    public static func buildEither<TrueContent: Model, FalseContent: Model>(first: TrueContent) -> _ConditionalModel<TrueContent, FalseContent> {
        _ConditionalModel(content: .true(first))
    }
    
    public static func buildEither<TrueContent: Model, FalseContent: Model>(second: FalseContent) -> _ConditionalModel<TrueContent, FalseContent> {
        _ConditionalModel(content: .false(second))
    }
}
