//
//  visionpApp.swift
//  visionp
//
//  Created by Leonard Pauli on 2024-09-14.
//

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

    ImmersiveSpace(id: appModel.immersiveSpaceID) {
      ImmersiveView(gestureModel: HandGestureModelContainer.handGestureModel)
        .environment(appModel)
        .onAppear {
          appModel.immersiveSpaceState = .open
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
