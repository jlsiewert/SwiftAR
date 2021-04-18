/*:
 # A Model of our Solar System
 
 This last page showcases some more features
 of `SwiftAR` to create a modal of our solar system.
  
 */

import SwiftAR
import Combine


struct SolarSystemExperience: Experience {
    var body: some Anchor {
        World {
            Sphere()
        }
    }
}

SolarSystemExperience.liveView()
