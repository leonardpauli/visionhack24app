import SwiftUI

@main
struct visionpApp: App {

  @State private var appModel = AppModel()

  var body: some Scene {
    WindowGroup {
      ContentView()
        .environment(appModel)
    }
    .windowResizability(.contentSize)

    WindowGroup(id: AppModel.immersiveSphereDetailID, for: Sphere.self) { sphere in
      SphereDetail(sphere: sphere.wrappedValue!)
        .environment(appModel)
    }

    ImmersiveSpace(id: AppModel.immersiveSpaceID) {
      ImmersiveView(gestureModel: HandGestureModelContainer.handGestureModel)
        .environment(appModel)
        .onAppear {
          appModel.immersiveSpaceState = .open
          if appModel.additionalSpheres.count == 0 {
            appModel.addSphere(at: .init(x: 0.0, y: 0.0, z: 0.0))
            appModel.addSphere(at: .init(x: 0.0, y: 1.0, z: 0.0))
            appModel.addSphere(at: .init(x: 0.0, y: 1.0, z: -1.0))
            appModel.addSphere(at: .init(x: -1.0, y: 1.0, z: -1.0))
            appModel.addSphere(at: .init(x: 1.0, y: 1.0, z: -1.0))
          }
        }
        .onDisappear {
          appModel.immersiveSpaceState = .closed
        }
    }
    .immersionStyle(selection: .constant(.mixed), in: .mixed)
  }
}

// why?
@MainActor
enum HandGestureModelContainer {
  private(set) static var handGestureModel = HandGestureModel()
}
