//
//  MountedElement.swift
//  
//
//  Created by Jan Luca Siewert on 04.04.21.
//

import Foundation

class MountedElement<R: Renderer>: Hashable {
    // MARK: - Initialization
    /// Element is the type elements get rendered into
    typealias Element = R.TargetType
    typealias Mounted = MountedElement<R>

    enum ElementType {
        case experience(AnyExperience)
        case anchor(AnyAnchor)
        case model(AnyModel)
    }
    
    var mounted: ElementType
    
    var experience: AnyExperience {
        get {
            guard case .experience(let e) = mounted else {
                fatalError("Can't get experience from \(mounted)")
            }
            return e
        }
        set {
            mounted = .experience(newValue)
        }
    }
    
    var model: AnyModel {
        get {
            guard case .model(let m) = mounted else {
                fatalError("Can't get model from \(mounted)")
            }
            return m
        }
        set {
            mounted = .model(newValue)
        }
    }
    
    var anchor: AnyAnchor {
        get {
            guard case .anchor(let a) = mounted else {
                fatalError("Can't get anchor from \(mounted)")
            }
            return a
        }
        set {
            mounted = .anchor(newValue)
        }
    }
    
    var _type: Any.Type {
        switch mounted {
            case .anchor(let a): return a.type
            case .experience(let e): return e.type
            case .model(let m): return m.type
        }
    }
    
    var element: Element?
    
    weak var parent: Mounted?
    var children: [Mounted]?

    init<M: Model>(model: M, parent: Mounted, environment: EnvironmentValues? = nil) {
        self.mounted = .model(AnyModel(erasing: model))
        self.parent = parent
        self.environmentValues = environment ?? parent.environmentValues
    }
    
    init<A: Anchor>(anchor: A, parent: Mounted, environment: EnvironmentValues? = nil) {
        self.mounted = .anchor(AnyAnchor(erasing: anchor))
        self.parent = parent
        self.environmentValues = environment ?? parent.environmentValues
    }
    
    init<E: Experience>(experience: E, environment: EnvironmentValues = EnvironmentValues()) {
        self.mounted = .experience(AnyExperience(erasing: experience))
        self.environmentValues = environment
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(element)
    }
    
    static func == (lhs: MountedElement, rhs: MountedElement) -> Bool {
        return lhs.element == rhs.element
    }
    
    // MARK: - Mounting
    
    func mount(with reconciler: StackReconciler<R>, to parent: R.TargetType? = nil) {
        updateEnvironment()
        switch mounted {
            case .experience(let e):
                children = createChild(for: e, reconciler: reconciler)
            case .model(let m):
                children = createChild(for: m, reconciler: reconciler)
            case .anchor(let a):
                children = createChild(for: a, reconciler: reconciler)
        }
        // Todo: Inject state and environment!
        
        element = reconciler.mount(self, to: parent)
    
        children?.forEach {
            $0.mount(with: reconciler, to: element)
        }
    }
    
    func createChild(for experience: AnyExperience, reconciler: StackReconciler<R>) -> [MountedElement] {
        print("Creating child for \(String(describing: experience.type)) of type \(String(describing: type(of: experience.bodyType.self)))")
        let body = reconciler.render(mountedExperience: self)
        let element = MountedElement(anchor: body, parent: self)
        return [element]
    }
    
    func createChild(for anchor: AnyAnchor, reconciler: StackReconciler<R>) -> [MountedElement] {
        print("Creating child for \(String(describing: anchor.type)) of type \(String(describing: type(of: anchor.bodyType.self)))")
        let body = reconciler.render(mountedAnchor: self)
        let element = MountedElement(model: body, parent: self)
        return [element]
    }
    
    func createChild(for model: AnyModel, reconciler: StackReconciler<R>) -> [MountedElement] {
        if let m = model.model as? ChildProvidingModel {
            print("Creating Child for ChildProvidingModel \(model.type)")
            return m.children.map { MountedElement(model: $0, parent: self) }
        }
        print("Creating child for \(String(describing: model.type))")
        guard model.bodyType != Never.Type.self else {
            print("Skipping child for \(model.type)")
            return []
        }
        print("Mounting children for \(model.type)")
        let body = reconciler.render(mountedModel: self)
        let child = MountedElement<R>(model: body, parent: self)
        return [child]
    }
    
    func update(with reconciler: StackReconciler<R>) {
        guard let element = element else { return }
        updateEnvironment()
        switch mounted {
            case .experience(let e): self.update(experience: e, with: reconciler, element: element)
            case .anchor(let a): self.update(anchor: a, with: reconciler, element: element)
            case .model(let m): self.update(model: m, with: reconciler, element: element)
        }
    }
    
    private func update(experience: AnyExperience, with reconciler: StackReconciler<R>, element target: R.TargetType) {
        let element = reconciler.render(mountedExperience: self)
        reconciler.reconcile(
            self,
            with: element,
            getElementType: { $0.type },
            updateChild: {
                $0.environmentValues = environmentValues
                $0.anchor = AnyAnchor(erasing: element)
            },
            mountChild: {
                let child = MountedElement(anchor: $0, parent: self)
//                child.mount(with: reconciler, to: target)
                return child
            }
        )
    }
    
    private func update(anchor: AnyAnchor, with reconciler: StackReconciler<R>, element target: R.TargetType) {
        let element = reconciler.render(mountedAnchor: self)
        reconciler.reconcile(
            self,
            with: element,
            getElementType: { $0.type },
            updateChild: {
                $0.environmentValues = environmentValues
                $0.model = AnyModel(erasing: element)
                reconciler.updateWithRenderer(self)
            },
            mountChild: {
                let child = MountedElement(model: $0, parent: self)
//                child.mount(with: reconciler, to: target)
                return child
            }
        )
    }
    
    private func update(model: AnyModel, with reconciler: StackReconciler<R>, element target: R.TargetType) {
        
        guard model.bodyType != Never.Type.self else {
            reconciler.updateWithRenderer(self)
            let newChildren = (model.model as? ChildProvidingModel)?.children
            
            switch (children, newChildren) {
                case (nil, nil):
                    break // Nothing to do
                case (nil, .some(let newChildren)):
                    let newElements = newChildren.map { Mounted(model: $0, parent: self) }
                    self.children = newElements
                    newElements.forEach { $0.mount(with: reconciler, to: target) }
                case (.some, nil):
                    self.children?.forEach( { $0.unmount(with: reconciler) })
                    self.children = []
                case (.some(let children), .some(let newChildren)):
                    for i in 0..<children.count {
                        guard i < newChildren.count else {
                            // Some childs were removed, unmount them later after the loop
                            break
                        }
                        reconciler.reconcile(children[i], with: newChildren[i], getElementType: {$0.type}, updateChild: {
                            $0.environmentValues = self.environmentValues
                            $0.updateEnvironment()
                            $0.update(with: reconciler)
                        }, mountChild: {
                            MountedElement(model: $0, parent: self)
                        })
                    }
                    
                    if children.count > newChildren.count {
                        for i in newChildren.count..<children.count {
                            children[i].unmount(with: reconciler)
                        }
                        self.children?.removeLast(children.count - newChildren.count)
                    } else if newChildren.count > children.count {
                        var newElements: [Mounted] = []
                        for i in children.count..<newChildren.count {
                            let new = Mounted(model: newChildren[i], parent: self)
                            new.mount(with: reconciler, to: target)
                            newElements.append(new)
                        }
                        self.children?.append(contentsOf: newElements)
                    }
                    
            }
            
            children?.forEach({
                $0.environmentValues = environmentValues
                $0.updateEnvironment()
                $0.update(with: reconciler)
            })
            
            if let modifier = model.model as? AppyableModel {
                modifier.applyModifier({
                    reconciler.renderer.apply($0, to: target)
                })
            }
            
            return
        }
        let element = reconciler.render(mountedModel: self)
        reconciler.reconcile(
            self,
            with: element,
            getElementType: { $0.type },
            updateChild: {
                $0.environmentValues = self.environmentValues
                $0.model = AnyModel(erasing: element)
                $0.update(with: reconciler)
            },
            mountChild: {
                let child = MountedElement(model: $0, parent: self)
//                child.mount(with: reconciler, to: target)
                return child
            }
        )
    }
    
    func unmount(with reconciler: StackReconciler<R>) {
        children?.forEach( { $0.unmount(with: reconciler) } )
        reconciler.unmountFromRenderer(self)
    }
    
    // MARK: Storage
    /// A type erased storage for `@State` values
    var store: [Any] = []
    var environmentValues: EnvironmentValues

    func updateEnvironment() {
        switch mounted {
            case .experience(let e):
                environmentValues.inject(into: &experience.experience, e.type)
            case .model(let m):
                environmentValues.inject(into: &model.model, m.type)
            case .anchor(let a):
                environmentValues.inject(into: &anchor.anchor, a.type)
        }
    }

}

extension EnvironmentValues {
    mutating func inject(into element: inout Any, _ type: Any.Type) {
        guard let info = TypeInfo.typeInfo(of: type) else { return }
        
        // Extract the view from the AnyView for modification, apply Environment changes:
        if let container = element as? ModifierContainer {
            container.environmentModifier?.modifyEnvironment(&self)
        }
        
        // Inject @Environment values
        // swiftlint:disable force_cast
        // `DynamicProperty`s can have `@Environment` properties contained in them,
        // so we have to inject into them as well.
        for dynamicProp in info.properties.filter({ $0.type is DynamicProperty.Type }) {
            guard let propInfo = TypeInfo.typeInfo(of: dynamicProp.type) else { return }
            var propWrapper = dynamicProp.get(from: element) as! DynamicProperty
            for prop in propInfo.properties.filter({ $0.type is EnvironmentReader.Type }) {
                var wrapper = prop.get(from: propWrapper) as! EnvironmentReader
                wrapper.setContent(from: self)
                prop.set(value: wrapper, on: &propWrapper)
            }
            dynamicProp.set(value: propWrapper, on: &element)
        }
        for prop in info.properties.filter({ $0.type is EnvironmentReader.Type }) {
            var wrapper = prop.get(from: element) as! EnvironmentReader
            wrapper.setContent(from: self)
            prop.set(value: wrapper, on: &element)
        }
        // swiftlint:enable force_cast
    }
}

extension TypeInfo {
    /// Extract all `DynamicProperty` from a type, recursively.
    /// This is necessary as a `DynamicProperty` can be nested.
    /// `EnvironmentValues` can also be injected at this point.
    func dynamicProperties(
        _ environment: inout EnvironmentValues,
        source: inout Any
    ) -> [PropertyInfo] {
        var dynamicProps = [PropertyInfo]()
        for prop in properties where prop.type is DynamicProperty.Type {
            dynamicProps.append(prop)
            guard let propInfo = TypeInfo.typeInfo(of: prop.type) else { continue }
            
            environment.inject(into: &source, prop.type)
            var extracted = prop.get(from: source)
            dynamicProps.append(
                contentsOf: propInfo.dynamicProperties(
                    &environment,
                    source: &extracted
                )
            )
            // swiftlint:disable:next force_cast
            var extractedDynamicProp = extracted as! DynamicProperty
            extractedDynamicProp.update()
            prop.set(value: extractedDynamicProp, on: &source)
        }
        return dynamicProps
    }
}
