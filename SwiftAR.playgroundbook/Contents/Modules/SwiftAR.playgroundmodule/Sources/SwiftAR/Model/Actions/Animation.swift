//
//  Animation.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 15.04.21.
//

import Foundation

public struct AnimatedModel<Body: Model>: Model {
    public enum AnimationType {
        case easeInOut(TimeInterval)
        case easeIn(TimeInterval)
        case easeOut(TimeInterval)
        case linear(TimeInterval)
        
        public static var easeInOut: AnimationType { .easeInOut(0.4) }
        public static var easeIn: AnimationType { .easeIn(0.4) }
        public static var easeOut: AnimationType { .easeOut(0.4) }
        public static var linear:AnimationType { .linear(0.4) }
    }
    let animation: AnimationType?
    public let body: Body
    
    public init(_ type: AnimationType?, body: Body) {
        self.animation = type
        self.body = body
    }
    
}

public extension Model {
    func animation(_ type: AnimatedModel<Self>.AnimationType? = .easeInOut) -> some Model {
        AnimatedModel(type, body: self)
    }
}
