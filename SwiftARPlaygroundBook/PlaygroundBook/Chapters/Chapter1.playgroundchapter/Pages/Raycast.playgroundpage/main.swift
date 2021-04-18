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
 
 In this example, green spheres are placed whenever you
 tap on the screen.
 Tapping on a sphere (`RaycastResultVisualization`)
 toggles its color between `.green` and `.gray`.
 
 */

import Foundation
import SwiftAR
import simd

/*:
 `RaycastResult` wraps a `transform` into a
 `Hashable` and `Identifiable` struct
 */

struct RaycastResult: Hashable, Identifiable {
    let id = UUID()
    let transform: simd_float4x4
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

/*:
 The raycast results gets visualized by a
 small sphere whose color can be toggled
 between `.green` and `.gray`.
 The `animation` modifiers animates these
 changes in the material.
 */

struct RaycastResultVisualization: Model {
    let transform: simd_float4x4
    @State var tapped = false
    
    var body: some Model {
        Sphere(radius: 0.02)
            .material(.color(tapped ? .gray : .green))
            .transform(transform)
            .animation()
            .onTap {
                tapped.toggle()
            }
    }
}

/*:
 The experience stores an array of `RaycastResults`
 and displays a sphere whenever the user taps on the screen.
 */

struct PlaygroundExperience: Experience {
    @State var raycasts: [RaycastResult] = []
    var body: some Anchor {
        World {
            ForEach(raycasts) { r in
                RaycastResultVisualization(transform: r.transform)
            }
        }
        .onTap {
            raycasts.append(RaycastResult(transform: $0))
        }
    }
}

PlaygroundExperience.liveView()
