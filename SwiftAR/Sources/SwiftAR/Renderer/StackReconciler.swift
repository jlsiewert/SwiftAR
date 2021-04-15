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
    /// A type that can be invoked
    typealias Callback = () -> ()
    /// The scheduler is responsible for running callbacks, usually `DispatchQueue`
    private let scheduler: (@escaping Callback) -> ()
    /// The renderer actually transforms `MountedElements` into rendered elements
    private(set) weak var renderer: R!
    /// A set of objects that need to be updated because of state changes
    private var queuedRenders: Set<MountedElement<R>> = []
    /// The base objects of the render graph, usually the `Experience`
    private var base: MountedElement<R>!
    
    /// Creates a new objects from the Experience as root object
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
    
    /// Mounts the experience and all childs
    func performInitialMount() {
        base.mount(with: self)
    }
    
    /// Updates the state of all MountedElements queued for rerender
    func updateStateAndReconcile() {
        let queuedRenders = self.queuedRenders
        self.queuedRenders.removeAll()
        
        for mountedElement in queuedRenders {
            mountedElement.update(with: self)
        }
    }
    
    /// Checks and updates the children of `element`
    /// if necessary by either modifying, un- and remounting
    func reconcile<Element>(
        _ mountedElement: MountedElement<R>,
        with element: Element,
        getElementType: (Element) -> Any.Type,
        updateChild: (MountedElement<R>) -> (),
        mountChild: (Element) -> MountedElement<R>
    ) {
        guard let parent = mountedElement.element else { return }
        if mountedElement.children?.isEmpty ?? true {
            // There was no child, create and mount
            let child = mountChild(element)
            mountedElement.children = [child]
            child.mount(with: self, to: parent)
        } else if mountedElement.children?.count == 1,
                  let mountedChild = mountedElement.children?.first {
            // Compare old and new type
            // If the same, just update
            // Else unmount and mount new child
            let oldChildType = TypeInfo.typeConstructorName(mountedChild._type)
            let newChildtype = TypeInfo.typeConstructorName(getElementType(element))
            
            if oldChildType == newChildtype {
                // Just update
                updateChild(mountedChild)
                mountedChild.update(with: self)
            } else {
                // Unmount and remount
                mountedChild.unmount(with: self)
                
                let newChild = mountChild(element)
                mountedElement.children = [newChild]
                newChild.mount(with: self, to: parent)
            }
        } else {
            // TODO: Handle elements with multiple children
            // IDEA: Require that the list is identifiable, then
            //       - update every existing child, then
            //       - unmount all old ones, then
            //       - mount all new one
            //       since the order of children is irrelevant to SceneKit!
        }
    }
    
    /// Marks the element to be rerendered
    func queueUpdate(for element: MountedElement<R>) {
        let shouldSchedule = queuedRenders.isEmpty
        queuedRenders.insert(element)
        
        if shouldSchedule {
            scheduler({ [weak self] in
                self?.updateStateAndReconcile()
            })
        }
    }
    
    /// Mounts the element to the renderer
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
                
                if let modified = element.model.model as? AppyableModel {
                    modified.applyModifier {
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
    
    func unmountFromRenderer(_ element: MountedElement<R>) {
        switch element.mounted {
            case .experience:
                fatalError("Experiences can't be unmounted")
            case .anchor:
                fatalError("Anchors can't be unomunted")
            case .model:
                renderer.unmount(element)
        }
    }
    
    func updateWithRenderer(_ element: MountedElement<R>) {
        renderer.update(element)
    }
    
    /// Updates the storage and queues a rerender
    private func queueStorageUpdate(
        for mountedElement: MountedElement<R>,
        id: Int,
        updater: (inout Any) -> ()
    ) {
        updater(&mountedElement.store[id])
        queueUpdate(for: mountedElement)
    }
    
    /// Setup a `State` object in the `MountedElement`
    func setupStorage(
        id: Int,
        for property: PropertyInfo,
        of compositeElement: MountedElement<R>,
        body bodyKeypath: ReferenceWritableKeyPath<MountedElement<R>, Any>
    ) {
        // `ValueStorage` property already filtered out, so safe to assume the value's type
        // swiftlint:disable:next force_cast
        var storage = property.get(from: compositeElement[keyPath: bodyKeypath]) as! ValueStorage
        
        if compositeElement.store.count == id {
            compositeElement.store.append(storage.anyInitialValue)
        }
        
        if storage.getter == nil {
            storage.getter = { compositeElement.store[id] }
            
            guard var writableStorage = storage as? WritableValueStorage else {
                return property.set(value: storage, on: &compositeElement[keyPath: bodyKeypath])
            }
            
            // Avoiding an indirect reference cycle here: this closure can be owned by callbacks
            // owned by view's target, which is strongly referenced by the reconciler.
            writableStorage.setter = { [weak self, weak compositeElement] newValue in
                guard let element = compositeElement else { return }
                self?.queueStorageUpdate(for: element, id: id) { $0 = newValue }
            }
            
            property.set(value: writableStorage, on: &compositeElement[keyPath: bodyKeypath])
        }
    }
    
    /// Applies State, Environment etc to the body and updates the body
    /// of the elment.
    /// - Returns: The type erased but applied body ( `AnyExperience`, `AnyAnchor`, `AnyModel`)
    private func render<T>(
        compositeElement: MountedElement<R>,
        body bodyKeypath: ReferenceWritableKeyPath<MountedElement<R>, Any>,
        result: KeyPath<MountedElement<R>, (Any) -> T>
    ) -> T {
        compositeElement.updateEnvironment()
        if let info = TypeInfo.typeInfo(of: compositeElement._type) {
            var stateIdx = 0
            let dynamicProps = info.dynamicProperties(
                &compositeElement.environmentValues,
                source: &compositeElement[keyPath: bodyKeypath]
            )
            
//            compositeElement.transientSubscriptions = []
            for property in dynamicProps {
                // Setup state/subscriptions
                if property.type is ValueStorage.Type {
                    setupStorage(id: stateIdx, for: property, of: compositeElement, body: bodyKeypath)
                    stateIdx += 1
                }
//                if property.type is ObservedProperty.Type {
//                    setupTransientSubscription(for: property, of: compositeElement, body: bodyKeypath)
//                }
            }
        }
        
        return compositeElement[keyPath: result](compositeElement[keyPath: bodyKeypath])
    }
    
    /// Applies state to the body and creates an `AnyModel` from it
    func render(mountedModel: MountedElement<R>) -> AnyModel {
        render(compositeElement: mountedModel, body: \.model.model, result: \.model.bodyClosure)
    }
    
    /// Applies state to the body and creates an `AnyModel` from it
    func render(mountedAnchor: MountedElement<R>) -> AnyModel {
        render(compositeElement: mountedAnchor, body: \.anchor.anchor, result: \.anchor.bodyClosure)
    }
    
    /// Applies state to the body and creates an `AnyModel` from it
    func render(mountedExperience: MountedElement<R>) -> AnyAnchor {
        render(compositeElement: mountedExperience, body: \.experience.experience, result: \.experience.bodyClosure)
    }
    
}
