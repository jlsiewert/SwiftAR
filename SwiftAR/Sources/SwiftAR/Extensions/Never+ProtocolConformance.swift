//
//  Never+ProtocolConformance.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 02.04.21.
//

import Foundation

extension Never {
    public var body: Never {
        fatalError()
    }
}
