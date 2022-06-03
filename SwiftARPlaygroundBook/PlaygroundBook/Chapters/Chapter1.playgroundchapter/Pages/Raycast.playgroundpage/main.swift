/*:
 # Hierachies
 
 `SwiftAR` supports building custom hiearchys of models.
 
 In this example, green spheres are placed whenever you
 tap on the screen.
 Tapping on a sphere (`RaycastResultVisualization`)
 toggles its color between `.green` and `.gray`.
 
 This example builds on the previous page, but first defines
 a custom `RaycastResultVisualization` model that is then
 displayed on every position the user has tapped on.
 This is done using a `ForEach` block.
 
 Because `ForEach` requires elements to conform to `Identifiable`
 the raycast result is wrapped in a custom `RaycastResult` struct.
 
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

import PlaygroundSupport
PlaygroundPage.current.liveView = SCNRenderedViewController(experience: PlaygroundExperience())
