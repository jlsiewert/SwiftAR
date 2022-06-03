/*:
 # Interactivity
 
 `SwiftAR` allows you to build interactive
 experiences using the `@State`, `@Binding`, `@StateObject`
 `@ObservedObject` and `@EnvironmentObject` modifiers.
 
 In this example, we use the `World` anchor type
 that just starts a world tracking.
 Objects can then be placed using the `transform`,
 `translate`, `rotate` and `scale` modifiers.
 
 For interactivity, the `onTap` modifier on a `Model`
 triggers when the model is tapped on.
 
 Similarly, the `onTap` modifier on the `World` anchor
 performs a raycast against the world.
 
 Here, a sphere can be placed wherever the user taps.
 The `animation()` modifier is used to animate between state changes.
 
 */

import Foundation
import SwiftAR
import simd

struct PlaygroundExperience: Experience {
    @State var currentTransform: simd_float4x4?
    
    var body: some Anchor {
        World {
            Group {
                if let currentTransform = currentTransform {
                    Sphere(radius: 0.05)
                        .material(.color(.red))
                        .transform(currentTransform)
                }
            }
            .animation()
        }
        .onTap { transform in
           currentTransform = transform
        }
    }
}

import PlaygroundSupport
PlaygroundPage.current.liveView = SCNRenderedViewController(experience: PlaygroundExperience())
