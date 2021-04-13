//
//  StackReconciler.swift
//  
//
//  Created by Jan Luca Siewert on 04.04.21.
//
//  Based On: https://github.com/TokamakUI/Tokamak/blob/0e89ea9529dd0302f521ff48f2f21f88063dbe30/Sources/TokamakCore/StackReconciler.swift
// Copyright 2018-2021 Tokamak contributors
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.
//
//  Created by Max Desiatov on 28/11/2018.
//


import Foundation

class StackReconciler<R: Renderer> {
    typealias Callback = () -> ()
    private let scheduler: (@escaping Callback) -> ()
    private(set) weak var renderer: R!
    
    private var base: MountedElement<R>!
    
    init<E: Experience>(
        experience: E,
        renderer: R,
        scheduler: @escaping (@escaping Callback) -> () = { closure in DispatchQueue.main.async { closure() } }
    ) {
        self.renderer = renderer
        self.scheduler = scheduler
        
        base = MountedElement(experience: experience)
        performInitialMount()
    }
    
    func performInitialMount() {
        base.mount(with: self)
    }
    
    func updateStateAndReconcile() {
        
    }
    
    func reconcile(_ element: MountedElement<R>) {
        
    }
    
    func queueUpdate(for element: MountedElement<R>) {
        
    }
    
    func mount(_ element: MountedElement<R>, to parent: R.TargetType? = nil) -> R.TargetType {
        let result: R.TargetType
        switch element.mounted {
            case .experience:
                result = renderer.mount(element, to: nil)
            case .model:
                guard let parent = parent else {
                    fatalError("Call to render before parent was mounted!")
                }
                
                result = renderer.mount(element, to: parent)
                
                if let modified = element.model.model as? ModifiedModelContentDeferredToRenderer {
                    modified.applyToModifier {
                        renderer.apply($0, to: result)
                    }
                }
            case .anchor:
                guard let parent = parent else {
                    fatalError("Call to render before parent was mounted!")
                }
                
                result = renderer.mount(element, to: parent)
        }
      
        return result
    }
    
}
