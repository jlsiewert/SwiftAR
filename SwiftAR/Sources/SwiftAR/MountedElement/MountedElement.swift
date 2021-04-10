//
//  MountedElement.swift
//  
//
//  Created by Jan Luca Siewert on 04.04.21.
//

import Foundation

protocol ChildrenProvidingMountedElement {
    associatedtype R: Renderer
    associatedtype E: Experience
    func getChildren() -> [AnyMountedElement<R, E>]
}

class MountedElement<R: Renderer, E: Experience, M: Model> {
    /// Element is the type elements get rendered into
    typealias Element = R.TargetType
    /// Each mounted element has an array of `[TypeErased]` elements.
    /// They are type-earsed to store them in an array.
    /// Children always wrapp `Model` elements, never `Experience`
    typealias TypeErased = AnyMountedElement<R, E>
    
    enum ElementType {
        case experience(E)
        case model(M)
    }
    
    let mounted: ElementType
    var element: Element?
    
    weak var parent: TypeErased?
    var children: [TypeErased]?

    init(model: M, parent: TypeErased) {
        self.mounted = .model(model)
        self.parent = parent
    }
    
    init(experience: E) {
        self.mounted = .experience(experience)
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(element)
    }
    
    static func == (lhs: MountedElement, rhs: MountedElement) -> Bool {
        return lhs.element == rhs.element
    }
    
    func mount(with reconciler: StackReconciler<R, E>, to parent: R.TargetType? = nil) {
        switch mounted {
            case .experience(let e): createChild(for: e)
            case .model(let m): createChild(for: m)
        }
        
        element = reconciler.render(self, to: parent)

        children?.forEach {
            $0.mount(with: reconciler, parent: element)
        }
    }
    
    func createChild(for experience: E) {
        let element = MountedElement<R, E, E.Body.Body>(model: experience.body.body, parent: AnyMountedElement(element: self))
        self.children = [AnyMountedElement(element: element)]
    }
    
    func createChild(for model: M) {
        guard M.Body.self != Never.self else {
            return
        }
        let child = MountedElement<R, E, M.Body>(model: model.body, parent: AnyMountedElement(element: self))
        self.children = [AnyMountedElement(element: child)]
    }
}

