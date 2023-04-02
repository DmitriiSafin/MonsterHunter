//
//  ViewController.swift
//  MonsterHunter
//
//  Created by Дмитрий on 05.02.2023.
//

import UIKit
import AVFoundation
import GoogleMaps

class ViewController: UIViewController {
        
    @IBOutlet weak var mapView: GMSMapView!
    
    private var locationManager = CLLocationManager()
    private var monsters = MonstersBrain.shared.getMonsters()
    private var currentLocation = CLLocation()
    private var player: AVAudioPlayer!
    private var zoom: Float = 15
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playSound()
        //DispatchQueue.global().async {
            self.checkLocationEnabled()
        //}
        setupManager()
        mapView.delegate = self

        Timer.scheduledTimer(withTimeInterval: 300, repeats: true) { _ in
            self.upateMonstersOnMap()
        }
    }
    
    @IBAction func btnZoomIn(_ sender: UIButton) {
        zoom = zoom + 1
        mapView.animate(toZoom: zoom)
    }
    
    @IBAction func btnZoomOut(_ sender: UIButton) {
        zoom = zoom - 1
        mapView.animate(toZoom: zoom)
    }
    
    private func addMonstersOnMap() {
        for i in self.monsters {
            let position = CLLocationCoordinate2D(
                latitude: self.currentLocation.coordinate.latitude + Double.random(in: -0.01...0.01),
                longitude: self.currentLocation.coordinate.longitude + Double.random(in: -0.012...0.012))
            let marker = GMSMarker(position: position)
            marker.icon = UIImage(named: i)
            marker.title = i
            marker.map = self.mapView
        }
    }
    
    private func upateMonstersOnMap() {
        monsters = MonstersBrain.shared.getMonsters()
        mapView.clear()
        addMonstersOnMap()
    }
    
    private func setupManager() {
        locationManager.delegate = self
        mapView.settings.myLocationButton = true
        mapView.padding = UIEdgeInsets(top: 0, left: 0, bottom: 100, right: 20)
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    private func playSound() {
        guard let url = Bundle.main.url(forResource: "music", withExtension: "mp3") else { return }
        
        player = try! AVAudioPlayer(contentsOf: url)
        player.play()
        player.numberOfLoops = -1
    }
}

//MARK: - Delegates
extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            currentLocation = location
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkAutorization()
    }
}

extension ViewController: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        
        let coordinate0 = CLLocation(
            latitude: currentLocation.coordinate.latitude,
            longitude: currentLocation.coordinate.longitude)
        let coordinate1 = CLLocation(
            latitude: marker.position.latitude,
            longitude: marker.position.longitude)
        
        let distanceInMeters = coordinate0.distance(from: coordinate1)

        if distanceInMeters <= 500 {
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let nextVC = storyBoard.instantiateViewController(withIdentifier: "CameraViewController") as! CameraViewController
            nextVC.nameMonster = marker.title
            if let name = marker.title {
                if let index = monsters.firstIndex(of: "\(name)") {
                    monsters.remove(at: index)
                }
            }
            marker.map = nil
            navigationController?.pushViewController(nextVC, animated: true)
            return true
        } else {
            marker.snippet = "Вы находитесь слишком далеко от монстра - \(Int(distanceInMeters)) метров"
            mapView.selectedMarker = marker
            return true
        }
    }
}

//MARK: - LocationAutorization
extension ViewController {
    func checkAutorization() {
        switch CLLocationManager.authorizationStatus() {
        case .authorizedAlways:
            break
        case .authorizedWhenInUse:
            mapView.isMyLocationEnabled = true
            locationManager.startUpdatingLocation()
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                self.mapView.camera = GMSCameraPosition(target: self.currentLocation.coordinate, zoom: self.zoom, bearing: 0, viewingAngle: 0)
                self.addMonstersOnMap()
            }
            
        case .denied:
            let alert = UIAlertController(title: "Вы запретили использование местоположения", message: "Хотите разрешить?", preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "Настройки", style: .default) { alert in
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
            alert.addAction(settingsAction)
            alert.addAction(cancelAction)
            present(alert, animated: true)
        case .restricted:
            break
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            break
        }
    }
    
    func checkLocationEnabled() {
        if CLLocationManager.locationServicesEnabled() {
            setupManager()
            checkAutorization()
        } else {
            let alert = UIAlertController(title: "У вас выключена служба геолокации", message: "Хотите включить?", preferredStyle: .alert)
            let settingsAction = UIAlertAction(title: "Настройки", style: .default) { alert in
                if let url = URL(string: "App-Prefs: root=LOCATION_ SERVICES") {
                    UIApplication.shared.open(url)
                }
            }
            let cancelAction = UIAlertAction(title: "Отмена", style: .cancel)
            alert.addAction(settingsAction)
            alert.addAction(cancelAction)
            present(alert, animated: true)
        }
    }
}
