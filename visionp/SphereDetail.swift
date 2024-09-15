import SwiftUI

struct SphereDetail: View {
  let sphere: Sphere
  @State private var editedSphere: Sphere
  @Environment(AppModel.self) private var appModel
  @Environment(\.dismissWindow) private var dismissWindow

  init(sphere: Sphere) {
    self.sphere = sphere
    self._editedSphere = State(initialValue: sphere)
  }

  var body: some View {
    VStack {
      Text("Sphere Properties")
        .font(.title)
        .padding()
      Text("ID: \(editedSphere.id)")
        .padding()

      VStack(alignment: .leading) {
        SliderView(value: $editedSphere.position.x, range: -1...1, label: "X")
        SliderView(value: $editedSphere.position.y, range: -1...1, label: "Y")
        SliderView(value: $editedSphere.position.z, range: -1...1, label: "Z")
        SliderView(value: $editedSphere.radius, range: 0.01...0.5, label: "Radius", step: 0.01)
      }
      .padding()

      ColorPicker("Color", selection: $editedSphere.color)
        .padding()

      Button("Delete Sphere") {
        appModel.deleteSphere(sphere)
        dismissWindow(id: AppModel.immersiveSphereDetailID)
      }
      .foregroundColor(.red)
      .padding()

      Button("Close") {
        dismissWindow(id: AppModel.immersiveSphereDetailID)
      }
      .padding()
    }
    .onChange(of: editedSphere) { _, newValue in
      appModel.updateSphere(newValue)
    }
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
