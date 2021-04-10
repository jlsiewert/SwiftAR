//
//  File.swift
//  
//
//  Created by Jan Luca Siewert on 04.04.21.
//

import Foundation

class AnyMountedElement<R: Renderer, E: Experience> {
    private let _mount: (StackReconciler<R, E>, R.TargetType?) -> ()
    
    
    init<M: Model>(element: MountedElement<R, E, M>){
        _mount = element.mount(with:to:)
    }
    
    func mount(with stackReconciler: StackReconciler<R, E>, parent: R.TargetType? = nil) {
        _mount(stackReconciler, parent)
    }
}
