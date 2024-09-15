//
//  ContentView.swift
//  visionp
//
//  Created by Leonard Pauli on 2024-09-14.
//

import RealityKit
import RealityKitContent
import SwiftUI

struct ContentView: View {
  @Environment(AppModel.self) private var appModel

  var body: some View {
    
    @Bindable var appModel = appModel
    
    VStack {
      Text("Hello, world!")
      ToggleImmersiveSpaceButton()
      
      // Sliders panel
      VStack {
        Text("Blue Sphere Controls")
          .font(.headline)
        
        SliderView(value: $appModel.sphereX, range: -1...1, label: "X")
        SliderView(value: $appModel.sphereY, range: -1...1, label: "Y")
        SliderView(value: $appModel.sphereZ, range: -1...1, label: "Z")
        SliderView(value: $appModel.sphereRadius, range: 0.01...2, label: "Radius", step: 0.01)
      }
      .padding()
      .background(RoundedRectangle(cornerRadius: 10).fill(Color.secondary.opacity(0.2)))
    }
    .padding()
    .frame(width: 480)
  }
}

struct SliderView: View {
  @Binding var value: Float
  let range: ClosedRange<Float>
  let label: String
  var step: Float = 0.1
  
  var body: some View {
    HStack {
      Text(label)
        .frame(width: 50, alignment: .leading)
      Slider(value: $value, in: range, step: step)
      Text(String(format: "%.2f", value))
        .frame(width: 50, alignment: .trailing)
    }
  }
}

#Preview(windowStyle: .automatic) {
  ContentView()
    .environment(AppModel())
}
