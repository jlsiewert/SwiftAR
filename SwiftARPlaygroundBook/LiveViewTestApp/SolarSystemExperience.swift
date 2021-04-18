import SwiftAR
import Combine
import Foundation
import simd
import SwiftUI

typealias EnvironmentObject = SwiftAR.EnvironmentObject
typealias StateObject = SwiftAR.StateObject
typealias State = SwiftAR.State
typealias Anchor = SwiftAR.Anchor
typealias Group = SwiftAR.Group

class UniverseController: ObservableObject {
    static let planetRadiusFactor: Double = 1 / 200_000
    static let planetDistanceFactor: Double = 1 / 2_000
    
    public static func radius(from radius: Double) -> Float {
        Float( radius * planetRadiusFactor )
    }
    
    public static func distance(from distance: Double) -> Float {
        Float( distance * planetDistanceFactor )
    }
    
    let refreshRate: TimeInterval
    let secondsPerEarthYear: TimeInterval
    
    @Published var time: TimeInterval
    
    init(secondsPerEarthYear: TimeInterval = 20, refreshRate: TimeInterval = 1) {
        self.refreshRate = refreshRate
        self.secondsPerEarthYear = secondsPerEarthYear
        self.time = 0
        Timer.publish(every: 1/refreshRate, on: .main, in: .default)
            .prepend(Date())
            .map(\.timeIntervalSince1970)
            .assign(to: &$time)
    }
    
    func angle(for daysPerYear: Double) -> Float {
        Float( ( time * daysPerYear * secondsPerEarthYear / 365 ).remainder(dividingBy: 2 * .pi) )
    }
}

struct PlanetInformationView: View {
    struct PlanetInformationLabel: View {
        static var formatter: NumberFormatter = {
            let f = NumberFormatter()
            f.numberStyle = .decimal
            f.maximumFractionDigits = 0
            return f
        }()
        
        let value: Double?
        let label: String
        let unit: String
        
        var body: some View {
            VStack(alignment: .leading, spacing: 8) {
                Text(label).bold()
                Text("\(value.map { Text(NSNumber(value: $0), formatter: PlanetInformationLabel.formatter) } ?? Text("-")) \(Text(unit))")
            }
        }
    }
    
    let name: String
    let diameter: Double
    let distanceFromSun: Double?
    let daysInYear: Double?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(name).font(.title)
            PlanetInformationLabel(value: diameter, label: "Diameter", unit: "km")
            PlanetInformationLabel(value: distanceFromSun, label: "Distance to Sun", unit: "km")
            PlanetInformationLabel(value: daysInYear, label: "Year Length", unit: "days")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.white.cornerRadius(25))
    }
}

struct AnnotationPlane: Model {
    let name: String
    let diameter: Double
    let distanceFromSun: Double?
    let daysInYear: Double?
    
    var body: some Model {
        Plane(width: 1, height: 1)
            .material(.view(PlanetInformationView(name: name, diameter: diameter, distanceFromSun: distanceFromSun, daysInYear: daysInYear)))
    }
}

struct Planet: Model {
//    @EnvironmentObject var controller: UniverseController
    
    let distance: Double
    let yearLength: Double
    let radius: Double
    
    var body: some Model {
        Sphere(radius: UniverseController.radius(from: radius))
            .translate(z: UniverseController.distance(from: distance))
//            .animation(.linear(1/controller.refreshRate))
    }
}

struct AnnotatedOrb<Orb: Model>: Model {
    @State var annotationShown = false
//    @EnvironmentObject var controller: UniverseController
    
    let name: String
    let diameter: Double
    let daysInYear: Double?
    let distanceFromSun: Double?
    
    var orb: Orb
    
    init(name: String, diameter: Double, daysInYear: Double? = nil, distanceFromSun: Double? = nil, @ModelBuilder orb: () -> (Orb)) {
        self.name = name
        self.diameter = diameter
        self.daysInYear = daysInYear
        self.distanceFromSun = distanceFromSun
        self.orb = orb()
    }
    
    var body: some Model {
        Group {
            orb
            if annotationShown {
                AnnotationPlane(name: name, diameter: diameter, distanceFromSun: distanceFromSun, daysInYear: daysInYear)
                    .translate(x: UniverseController.radius(from: diameter/2) + 0.6)
                    .rotate(yaw: .pi/2)
                    .lookAt(.camera)
            }
        }
        .onTap {
            annotationShown.toggle()
        }
    }
}

struct AnnotatedPlanet: Model {
    let name: String
    let diameter: Double
    let daysInYear: Double
    let distanceFromSun: Double
    
    var body: some Model {
        AnnotatedOrb(name: name, diameter: diameter, daysInYear: daysInYear, distanceFromSun: distanceFromSun) {
            Planet(distance: distanceFromSun, yearLength: daysInYear, radius: diameter/2)
        }
    }
}

struct Sun: Model {
//    @EnvironmentObject var controller: UniverseController
    var body: some Model {
        AnnotatedOrb(name: "Sun", diameter: 1_392_684) {
            Sphere(radius: UniverseController.radius(from: 696_342))
        }
            .material(.color(.orange))
    }
}

struct Mercury: Model {
    var body: some Model {
        AnnotatedPlanet(name: "Mercury", diameter: 4_879.4, daysInYear: 88, distanceFromSun: 57_909_00)
            .material(.color(.cyan))
    }
}

struct Venus: Model {
    var body: some Model {
        AnnotatedPlanet(name: "Venus", diameter: 12_103.6, daysInYear: 225, distanceFromSun: 108_160_000)
    }
}

struct Earth: Model {
    var body: some Model {
        AnnotatedPlanet(name: "Earth", diameter: 12_765.3, daysInYear: 365, distanceFromSun: 149_600_000)
            .material(.color(.blue))
    }
}

struct Mars: Model {
    var body: some Model {
        AnnotatedPlanet(name: "Mars", diameter: 6_792.4, daysInYear: 687, distanceFromSun: 227_990_000)
    }
}

struct Jupiter: Model {
    var body: some Model {
        AnnotatedPlanet(name: "Jupiter", diameter: 142_984, daysInYear: 4333, distanceFromSun: 778_360_000)
    }
}

struct Saturn: Model {
    var body: some Model {
        AnnotatedPlanet(name: "Saturn", diameter: 120__536, daysInYear: 10_759, distanceFromSun: 1_433_500_00)
    }
}

struct Uranus: Model {
    var body: some Model {
        AnnotatedPlanet(name: "Uranus", diameter: 51_118, daysInYear: 30_687, distanceFromSun: 2_872_400_00)
    }
}

struct Neptune: Model {
    var body: some Model {
        AnnotatedPlanet(name: "Neptune", diameter: 49_528, daysInYear: 60_190, distanceFromSun: 4_498_400_000)
    }
}

struct SolarSystemExperience: Experience {
//    @State var controller = UniverseController(distanceToRadiusFactor: 100)
    var body: some Anchor {
        World {
            Group {
                Sun()
                Mercury()
                Venus()
                Earth()
                Mars()
                Jupiter()
                Saturn()
                Uranus()
                Neptune()
            }
            .translate(z: -5)
//            .environmentObject(controller)
        }
    }
}
