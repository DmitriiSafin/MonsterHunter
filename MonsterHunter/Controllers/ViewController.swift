//
//  ViewController.swift
//  MonsterHunter
//
//  Created by Дмитрий on 05.02.2023.
//

import UIKit
import YandexMapsMobile
import CoreLocation

class ViewController: UIViewController, YMKUserLocationObjectListener {

    @IBOutlet weak var mapView: YMKMapView!
    
    var nativeLocationManager = CLLocationManager()
    var userLocation = YMKPoint()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setupNativeLocationManager()
        createMapObjects()
        
        mapView.mapWindow.map.isRotateGesturesEnabled = false
        mapView.mapWindow.map.move(with:
            YMKCameraPosition(target: YMKPoint(latitude: 0, longitude: 0), zoom: 14, azimuth: 0, tilt: 0))
        
        let scale = UIScreen.main.scale
        let mapKit = YMKMapKit.sharedInstance()
        let userLocationLayer = mapKit.createUserLocationLayer(with: mapView.mapWindow)
        
        userLocationLayer.setVisibleWithOn(true)
        userLocationLayer.isHeadingEnabled = true
        userLocationLayer.setAnchorWithAnchorNormal(
            CGPoint(x: 0.5 * mapView.frame.size.width * scale, y: 0.5 * mapView.frame.size.height * scale),
            anchorCourse: CGPoint(x: 0.5 * mapView.frame.size.width * scale, y: 0.83 * mapView.frame.size.height * scale))
        userLocationLayer.setObjectListenerWith(self)
        
    }
    
    func createMapObjects() {
        let mapObjects = mapView.mapWindow.map.mapObjects
        let placemark = mapObjects.addPlacemark(with: YMKPoint(latitude: userLocation.latitude + 0.004, longitude: userLocation.longitude + 0.004))
        placemark.opacity = 0.7
        placemark.isDraggable = true
        placemark.setIconWith(UIImage(named:"Morder")!)
        
    }
    
    func onObjectAdded(with view: YMKUserLocationView) {
        view.arrow.setIconWith(UIImage(named:"UserArrow")!)
        view.accuracyCircle.fillColor = UIColor.blue
        userLocation = view.pin.geometry
        print("-------------------------dgdrdrr----------------------")
    }
    
    func onObjectRemoved(with view: YMKUserLocationView) {}
    
    func onObjectUpdated(with view: YMKUserLocationView, event: YMKObjectEvent) {
    }
    
//    func setupNativeLocationManager() {
//        nativeLocationManager.delegate = self
//        nativeLocationManager.requestWhenInUseAuthorization()
//    }
}

//extension ViewController: CLLocationManagerDelegate {
//
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedWhenInUse {
//            nativeLocationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
//            nativeLocationManager.startUpdatingLocation()
//        }
//    }
//
//    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
//
//        userLocation = YMKPoint(
//            latitude: locations.last!.coordinate.latitude,
//            longitude: locations.last!.coordinate.longitude)
//    }
//}
