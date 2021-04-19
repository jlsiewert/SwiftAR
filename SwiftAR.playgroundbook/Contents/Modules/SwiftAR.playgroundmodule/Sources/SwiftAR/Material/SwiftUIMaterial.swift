//
//  SwiftUIMaterial.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 13.04.21.
//

import Foundation
import SwiftUI
import SceneKit

extension SCNMaterialProperty {
    static var size: CGSize = CGSize(width: 300, height: 300)
    static var renderer = UIGraphicsImageRenderer(size: size)
    
    static func view<V: SwiftUI.View>(view: V) -> Any {
        #if targetEnvironment(simulator)
        return UIColor.lightGray
        #else
        let vc = UIHostingController(rootView: view)
        
        
        vc.view.backgroundColor = .clear
        vc.view.isOpaque = false
        vc.view.frame = CGRect(origin: .zero, size: SCNMaterialProperty.size)
        
//        vc.viewWillAppear(true)
//
//        let image = SCNMaterialProperty.renderer.image { ctx in
//            vc.view.drawHierarchy(in: vc.view.bounds, afterScreenUpdates: true)
//        }
//
//        return image
        vc.viewWillAppear(true)
        return vc.view!
        #endif
    }
}
