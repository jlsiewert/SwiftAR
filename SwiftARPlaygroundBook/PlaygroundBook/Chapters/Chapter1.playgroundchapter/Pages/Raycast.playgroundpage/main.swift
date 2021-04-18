/*:
 # Interactivity
 
 */

import Foundation
import SwiftAR
import simd

struct RaycastResult: Hashable, Identifiable {
    let id = UUID()
    let transform: simd_float4x4
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

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
