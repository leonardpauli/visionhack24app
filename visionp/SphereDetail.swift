import SwiftUI

struct SphereDetail: View {
  @State var title: String
  @Environment(\.dismissWindow) private var dismissWindow

  var body: some View {
    VStack {
      Text("Sphere \(title)")
        .font(.title)
        .padding()
      Button {
        dismissWindow(id: AppModel.immersiveSphereDetailID)
      } label: {
        Text("Close")
      }
    }
  }
}
