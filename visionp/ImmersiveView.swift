//
//  ImmersiveView.swift
//  visionp
//
//  Created by Leonard Pauli on 2024-09-14.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {

    var body: some View {
        RealityView { content in
            add_sphere(to: content).position.x = 1.0
            add_sphere(to: content).position.y = 1.0
            add_sphere(to: content).position.z = 1.0
            add_sphere(to: content).position.x = 0.0
        }
    }
    
    func add_sphere(to parent: any RealityViewContentProtocol) -> ModelEntity {
        let sphere = ModelEntity(mesh: .generateSphere(radius: 0.05), materials: [SimpleMaterial(color: .black, roughness: 0.5, isMetallic: true)])
        parent.add(sphere)
        return sphere
    }
}

#Preview(immersionStyle: .mixed) {
    ImmersiveView()
        .environment(AppModel())
}
