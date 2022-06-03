//
//  OnTapModel.swift
//  SwifAR
//
//  Created by Jan Luca Siewert on 14.04.21.
//

import Foundation

struct OnTapModel<Body: Model>: Model {
    let handler: () -> ()
    let body: Body
    
    init(body: Body, handler: @escaping () -> ()) {
        self.body = body
        self.handler = handler
    }
}

public extension Model {
    
    /// Registers an event handler that is executed every time the user taps on a rendered model
    /// - Parameter handler: The event handler
    /// - Returns:
    func onTap(perform handler: @escaping () -> ()) -> some Model {
        OnTapModel<Self>(body: self, handler: handler)
    }
}
