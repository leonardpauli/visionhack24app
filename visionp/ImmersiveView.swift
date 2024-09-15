//
//  ImmersiveView.swift
//  visionp
//
//  Created by Leonard Pauli on 2024-09-14.
//

import RealityKit
import RealityKitContent
import SwiftUI

struct ImmersiveView: View {
  @Environment(AppModel.self) private var appModel
  @ObservedObject var gestureModel: HandGestureModel
  
  class SceneObjects {
    var coloredSphere: ModelEntity?
  }
  
  @State private var sceneObjects = SceneObjects()

  var body: some View {
    RealityView { content in
      // Existing spheres
      add_sphere(to: content).position.x = 1.0
      add_sphere(to: content).position.y = 1.0
      add_sphere(to: content).position.z = 1.0
      _ = add_sphere(to: content)
      self.sceneObjects.coloredSphere = add_colored_sphere(to: content)
    } update: { content in
      guard let pointer1 = gestureModel.computeIndexFingerTipPositionGlobal(for: gestureModel.latestHandTracking.right) else { return }
      guard let pointer2 = gestureModel.computeIndexFingerTipPositionGlobal(for: gestureModel.latestHandTracking.left) else { return }
      
      if let sphere = sceneObjects.coloredSphere { // content.entities.first(where: { $0.name == "ColoredSphere" }) as? ModelEntity {
        sphere.position = [appModel.sphereX, appModel.sphereY, appModel.sphereZ]
        sphere.scale = .one * appModel.sphereRadius
        sphere.position = pointer1
        
        let distance = distance(pointer1, pointer2)
        let color = UIColor(hue: CGFloat(distance / 2.0), saturation: 1.0, brightness: 1.0, alpha: 1.0)
        sphere.model?.materials = [SimpleMaterial(color: color, roughness: 0.5, isMetallic: true)]
        
        if distance < appModel.sphereRadius {
          Task { @MainActor in
            appModel.sphereRadius /= 2.0
          }
        }
      }
    }
    .task {
      await gestureModel.start()
    }
    .task {
      await gestureModel.publishHandTrackingUpdates()
    }
    .task {
      await gestureModel.monitorSessionEvents()
    }
  }

  func add_sphere(to parent: any RealityViewContentProtocol) -> ModelEntity {
    let sphere = ModelEntity(
      mesh: .generateSphere(radius: 0.05),
      materials: [SimpleMaterial(color: .black, roughness: 0.5, isMetallic: true)])
    parent.add(sphere)
    return sphere
  }

  func add_colored_sphere(to parent: any RealityViewContentProtocol) -> ModelEntity {
    let sphere = ModelEntity(
      mesh: .generateSphere(radius: 1.00),
      materials: [SimpleMaterial(color: UIColor(.blue), roughness: 0.5, isMetallic: true)])
    sphere.name = "ColoredSphere"
    parent.add(sphere)
    return sphere
  }
}

#Preview(immersionStyle: .mixed) {
  ImmersiveView(gestureModel: HandGestureModelContainer.handGestureModel)
    .environment(AppModel())
}
