//
//  SwiftAR.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 02.04.21.
//

import UIKit

public protocol Experience {
    associatedtype Body: Anchor
    var body: Body { get }
    
    init()
}
