//
//  File.swift
//  
//
//  Created by Jan Luca Siewert on 13.04.21.
//

import Foundation
import SwiftUI
import SceneKit

public extension SCNMaterialProperty {
    static func view<V: SwiftUI.View>(view: V, size: CGSize = CGSize(width: 500, height: 500)) -> Any {
        let vc = UIHostingController(rootView: view)
        vc.view.backgroundColor = .clear
        vc.view.isOpaque = false
        vc.view.frame = CGRect(origin: .zero, size: size)
        vc.viewWillAppear(false)
        return vc.view!
    }
    
    convenience init<V: View>(contents view: V) {
        self.init(contents: view as Any)
    }
}
