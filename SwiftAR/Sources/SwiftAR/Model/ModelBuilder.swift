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
}
