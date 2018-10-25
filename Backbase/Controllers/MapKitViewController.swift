//
//  MapKitViewController.swift
//  Backbase
//
//  Created by george liu on 10/24/18.
//  Copyright © 2018 george liu. All rights reserved.
//

import UIKit
import MapKit


class MapKitViewController: UIViewController {

    
    
    // MARK: Class constants  -------------------------------------------------
    
    // MARK: Attributes -------------------------------------------------------
    var myCityInfo = CityInfo()

    // MARK: UI Components -------------------------------------------------------
    
    // MARK: UI Components -------------------------------------------------------
    @IBOutlet weak var mapView: MKMapView!
    @IBAction func mapKitCancelButtonPressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBOutlet weak var mapKitNavBar: UINavigationBar!
    
    // MARK: UI Methods ---------------------------------------------------------
    let regionRadius: CLLocationDistance = 1000
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate,
                                                                  regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    // MARK: UI View Cycle ----------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        // set initial location in Honolulu
        let initialLocation = CLLocation(latitude: myCityInfo.lat, longitude: myCityInfo.lon)
            
        centerMapOnLocation(location: initialLocation)
        
        // show artwork on map
        let cli = CityLocationInfo(title: "\(myCityInfo.name), \(myCityInfo.country)",
                              locationName: myCityInfo.country,
                              discipline: "Location",
                              coordinate: CLLocationCoordinate2D(latitude: myCityInfo.lat, longitude: myCityInfo.lon))
        mapView.addAnnotation(cli)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    
    // MARK: Helper Methods ------------------------------------------------------

    
    


}
