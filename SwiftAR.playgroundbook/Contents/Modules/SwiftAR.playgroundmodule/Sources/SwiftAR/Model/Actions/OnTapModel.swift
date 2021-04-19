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
    func onTap(perform handler: @escaping () -> ()) -> some Model {
        OnTapModel<Self>(body: self, handler: handler)
    }
}
