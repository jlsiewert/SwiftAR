//
//  OnAppear.swift
//  SwiftAR
//
//  Created by Jan Luca Siewert on 19.04.21.
//

import Foundation

protocol OnAppearElement {
    func onAppear()
    func onDisappear()
}

struct OnAppearModel<Content: Model>: Model, OnAppearElement {
    func onAppear() {
        _onAppear()
    }
    func onDisappear() {
        _onDisappear()
    }
    
    let _onAppear: () -> ()
    let _onDisappear: () -> ()
    let body: Content
    
    init(onAppear: @escaping () -> () = {}, onDisappear: @escaping () -> () = {}, @ModelBuilder body: () -> (Content)) {
        self.body = body()
        self._onAppear = onAppear
        self._onDisappear = onDisappear
    }
}

public extension Model {
    
    /// Registers an event handler that is triggered when the model is first added to the scene
    func onAppear(_ callback: @escaping () -> ()) -> some Model {
        OnAppearModel(onAppear: callback, body: {self})
    }
    
    /// Registers an event handler that is triggered when the model is removed from the scene
    func onDisappear(_ callback: @escaping () -> ()) -> some Model {
        OnAppearModel(onDisappear: callback, body: { self})
    }
}
