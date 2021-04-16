import SwiftAR
import PlaygroundSupport
import UIKit

struct PlaygroundExperience: Experience {
    var body: some Anchor {
        Surface {
            Cube()
                .rotate(yaw: .pi / 4)
        }
    }
}

extension Experience {
    /// Presents the experience in the Playground live view.
    public static func liveView() {
        #if canImport(PlaygroundSupport)
        let e = Self()
        let r = SCNRenderedViewController(experience: e)
        PlaygroundPage.current.liveView = r.view
        #else
        fatalError("PlaygroundSupport not available")
        #endif
    }
}



PlaygroundExperience.liveView()
