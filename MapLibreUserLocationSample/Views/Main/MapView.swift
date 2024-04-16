import SwiftUI
import MapLibre
import MapKit

struct MapView: UIViewRepresentable {

  func makeUIView(context: Context) -> some UIView {
    // MapTilerのキーを取得
    let mapTilerKey = getMapTilerKey()

    // スタイルのURLを定義
    let styleURL = URL(string: "https://api.maptiler.com/maps/jp-mierune-dark/style.json?key=\(mapTilerKey)")

    // Viewを定義
    let mapView = MLNMapView(frame: .zero, styleURL: styleURL)
    mapView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    mapView.logoView.isHidden = true
    mapView.setCenter(
      CLLocationCoordinate2D(latitude: 35.681111, longitude: 139.766667),
      zoomLevel: 15.0,
      animated: false
    )

    // ユーザーの現在位置を表示
    mapView.showsUserLocation = true

    // DelegateはCoordinatorを指定します
    mapView.delegate = context.coordinator

    return mapView
  }

  func updateUIView(_ uiView: UIViewType, context: Context) {
    /// Viewがアップデートされたときの処理
    /// 現状は特に何も処理をします
  }

  func makeCoordinator() -> Coordinator {
    Coordinator(control: self)
  }

  class Coordinator: NSObject, MLNMapViewDelegate {
    var control: MapView

    init(control: MapView) {
      self.control = control
    }

    func mapViewDidFinishLoadingMap(_ mapView: MLNMapView) {
      // マップのローディングが終わったときの処理
    }

    /// 現在位置が変更されたときの処理
    /// - Parameters:
    ///   - mapView: MapLibreのMapView
    ///   - userLocation: ユーザーの現在位置
    func mapView(_ mapView: MLNMapView, didUpdate userLocation: MLNUserLocation?) {

      // ユーザーの位置情報を取得
      guard let location = userLocation?.location else {
        return
      }

      let lat = location.coordinate.latitude
      let lon = location.coordinate.longitude

      // 地図の中心をユーザーの位置情報に移動
      mapView.setCenter(
        CLLocationCoordinate2D(latitude: lat, longitude: lon),
        animated: false
      )
    }
  }

  /// MapTilerのキーを取得します
  /// - Returns: MapTilerのAPIキー
  func getMapTilerKey() -> String {
    let key = Bundle.main.object(forInfoDictionaryKey: "MapTilerKey") as? String

    guard let key = key else {
      preconditionFailure("Failed to read MapTiler Key")
    }

    return key
  }

}
