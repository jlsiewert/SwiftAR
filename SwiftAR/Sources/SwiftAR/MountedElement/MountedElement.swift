//
//  MountedElement.swift
//  
//
//  Created by Jan Luca Siewert on 04.04.21.
//

import Foundation

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
    
    public var model: M? {
        guard case .model(let model) = mounted else { return nil }
        return model
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
    
    @_disfavoredOverload
    func createChild<M: Model>(for model: M) {
        let parent = AnyMountedElement(element: self)
        
        if M.Body.self == Never.self {
            if let model = model as? ModifiedModelContentDeferredToRenderer {
                self.children = [ model.createMountedElement(for: parent) ]
                return
            } else {
                print("Skipping child for \(type(of: model))")
                return
            }
        }
        print("Mounting children for \(type(of: model))")
        let child = MountedElement<R, E, M.Body>(model: model.body, parent: parent)
        self.children = [AnyMountedElement(element: child)]
    }
    
    func createChild<Modifier: ModelModifier, Content: Model>(for model: ModifiedContent<Modifier, Content>) {
        print("Creating child for ModelModifier \(model)")
        let applied = model.applied
        let child = MountedElement<R, E, Content.Body>(model: applied, parent: AnyMountedElement(element: self))
        self.children = [AnyMountedElement(element: child)]
    }
}
