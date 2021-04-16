//
//  File.swift
//  
//
//  Created by Jan Luca Siewert on 13.04.21.
//

import Foundation
import SwiftUI
import SceneKit

extension SCNMaterialProperty {
    static func view<V: SwiftUI.View>(view: V, size: CGSize = CGSize(width: 200, height: 200)) -> Any {
        #if targetEnvironment(simulator)
        return UIColor.lightGray
        #else
        let vc = UIHostingController(rootView: view)
        vc.viewWillAppear(true)
        
        vc.view.backgroundColor = .clear
        vc.view.isOpaque = false
        vc.view.frame = CGRect(origin: .zero, size: size)
        
        return vc.view!
        #endif
    }
}
