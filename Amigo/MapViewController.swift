//
//  MapViewController.swift
//  Amigo
//
//  Created by אביעד on 05/01/2020.
//  Copyright © 2020 Shiran Klein. All rights reserved.
//

import MapKit
import Firebase
extension MapViewController: MKMapViewDelegate {
    // 1
    //
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        // 2
        guard let annotation = annotation as? Artwork else { return nil }
        // 3
        let identifier = "marker"
        var view: MKMarkerAnnotationView
        // 4
        if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            as? MKMarkerAnnotationView {
            dequeuedView.annotation = annotation
            view = dequeuedView
        } else {
            // 5
            view = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            view.canShowCallout = true
            view.calloutOffset = CGPoint(x: -5, y: 5)
            view.rightCalloutAccessoryView = UIButton(type: .system)
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(buttonAction))
            view.addGestureRecognizer(tapGestureRecognizer)
        }
        return view
    }
    
    //press on pin and go to table post vc
    @objc func buttonAction(sender: AnyObject)
    {
        self.performSegue(withIdentifier: "MoveNext", sender: nil)
    }
    
    //which pin did the user press and save it to db
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView)
    {
        if let annotationTitle = view.annotation?.title
        {
            var db : Firestore!
            db = Firestore.firestore()
            print("User tapped on annotation with title: \(annotationTitle!)")
            db.collection("cities").document("city").setData(["title" : annotationTitle])
            
        }
    }
}



class MapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    
    var table = TablePostTableViewController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.showsUserLocation = true
        //where we start
        let initialLocation = CLLocation(latitude: 31.961020, longitude: 34.801620)
        centerMapOnLocation(location: initialLocation)
    }
    //requst to see your location
    let locationManager = CLLocationManager()
    func checkLocationAuthorizationStatus() {
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    
    
    ////////////////
    func locationManager(manager: CLLocationManager, locations: [CLLocation]) {
        let location = locations.last
        let center = CLLocationCoordinate2D(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        mapView!.setRegion(region, animated: true)
        mapView!.setCenter(mapView!.userLocation.coordinate, animated: true)
        
        
    }
    
    @IBAction func refLocation(_ sender: Any) {
        mapView!.setCenter(mapView!.userLocation.coordinate, animated: true)
    }
    
    
    
    ////////////////////
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        checkLocationAuthorizationStatus()
    }
    //distans of the screen -zoom
    let regionRadius: CLLocationDistance = 250000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
        
        // show artwork on map - where marker in the map
        let rishonLezion = Artwork(title: "Rishon-Lezion",
                                   locationName: "Rishon-Lezion",
                                   discipline: "Rishon-Lezion",
                                   coordinate: CLLocationCoordinate2D(latitude: 31.961020, longitude: 34.801620))
        
        let haifa = Artwork(title: "Haifa",
                            locationName: "Haifa",
                            discipline: "Haifa",
                            coordinate: CLLocationCoordinate2D(latitude: 32.794044, longitude: 34.989571))
        
        let telaviv = Artwork(title: "Tel-Aviv",
                                locationName: "Tel-Aviv",
                                discipline: "Tel-Aviv",
                                coordinate: CLLocationCoordinate2D(latitude: 32.085300, longitude: 34.781769))
        
        let eilat = Artwork(title: "Eilat",
                                    locationName: "Eilat",
                                    discipline: "Eilat",
                                    coordinate: CLLocationCoordinate2D(latitude: 29.557669, longitude: 34.951923))
        
        let bersheva = Artwork(title: "Ber-Sheva",
                               locationName: "Ber-Sheva",
                               discipline: "Ber-Sheva",
                               coordinate: CLLocationCoordinate2D(latitude: 31.243870, longitude: 34.793990))
        
        
        
        
        mapView.addAnnotation(rishonLezion)
        mapView.addAnnotation(haifa)
        mapView.addAnnotation(telaviv)
        mapView.addAnnotation(eilat)
        mapView.addAnnotation(bersheva)
        
        
        
        mapView.delegate = self
        
        
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    
    
}

