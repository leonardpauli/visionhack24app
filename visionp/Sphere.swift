import SwiftUI

struct Sphere: Identifiable, Encodable, Decodable, Hashable {
  var id = UUID()
  var position: SIMD3<Float>
  var radius: Float
  var isPointer: Bool
  private var colorInner: HSB = HSB(h: 0.0, s: 0.0, b: 0.0)
  var color: Color {
    get {
      colorInner.color
    }
    set {
      colorInner.color = newValue
    }
  }

  init(position: SIMD3<Float>, radius: Float = 0.05, color: Color = .blue, isPointer: Bool = false) {
    self.position = position
    self.radius = radius
    self.isPointer = isPointer
    self.color = color
  }
}

struct HSB: Encodable, Decodable, Hashable {
  var h: Double
  var s: Double
  var b: Double

  var color: Color {
    get {
      Color(hue: h, saturation: s, brightness: b)
    }
    set {
      let uic = UIColor(newValue)
      var uic_h: CGFloat = 0
      var uic_s: CGFloat = 0
      var uic_b: CGFloat = 0
      uic.getHue(&uic_h, saturation: &uic_s, brightness: &uic_b, alpha: nil)
      h = Double(uic_h)
      s = Double(uic_s)
      b = Double(uic_b)
    }
  }
}
