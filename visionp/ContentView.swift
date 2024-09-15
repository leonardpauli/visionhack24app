import RealityKit
import RealityKitContent
import SwiftUI

struct ContentView: View {
  @Environment(AppModel.self) private var appModel

  var body: some View {
    @Bindable var appModel = appModel
    VStack {
      Text("Sphere Controller")
        .font(.title)
      ToggleImmersiveSpaceButton()
      if appModel.immersiveSpaceState == .open {
        Text("Tap the index finger sphere to instantiate a new sphere.")
          .font(.subheadline)
        Text("Currently \(appModel.additionalSpheres.count) spheres.")
          .font(.subheadline)
      }
    }
    .padding()
  }
}

#Preview(windowStyle: .automatic) {
  ContentView()
    .environment(AppModel())
}
