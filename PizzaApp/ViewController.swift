//
//  ViewController.swift
//  PizzaApp
//
//  Created by Bryan Ayllon on 7/27/16.
//  Copyright © 2016 Bryan Ayllon. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate,MKMapViewDelegate {
    
    var pizza = [Pizza]()
    
    
    @IBOutlet weak var mapView :MKMapView!
    @IBOutlet weak var pizzaView :UIView!
    
    var locationManager :CLLocationManager!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pizzaInfo()

        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.mapView.delegate = self
        
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.distanceFilter = kCLDistanceFilterNone
        
        self.locationManager.requestAlwaysAuthorization()
        
        self.locationManager.startUpdatingLocation()
        
        self.mapView.showsUserLocation = true
        
        
        
    }
    
    private func pizzaInfo() {
        let populateAPI = "https://dl.dropboxusercontent.com/u/20116434/locations.json"
        guard let url = NSURL(string: populateAPI) else {
            fatalError("Invalid URL")
        }
        let session = NSURLSession.sharedSession()
        session.dataTaskWithURL(url) { (data :NSData?, response :NSURLResponse?, error :NSError?) in
            guard let jsonResult = NSString(data: data!, encoding: NSUTF8StringEncoding) else {
                fatalError("Unable to format data")
            }
            
            let jsonArray = try! NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.AllowFragments) as! [AnyObject]
            for item in jsonArray {
                
                let pizza = Pizza()
                pizza.name = item.valueForKey("name") as! String
                
                pizza.photoUrl = item.valueForKey("photoUrl") as! String
                pizza.latitude = item.valueForKey("latitude") as! Double
                pizza.longitude = item.valueForKey("longitude") as! Double

                self.pizza.append(pizza)


            }
            
            
            dispatch_async(dispatch_get_main_queue(),{
                for locations in self.pizza {
                    
                    
        let pinAnnotation = MKPointAnnotation()
                    pinAnnotation.title = locations.name
                    pinAnnotation.coordinate = CLLocationCoordinate2D(latitude: locations.latitude, longitude: locations.longitude)
                    
                    //        pinAnnotation.coordinate = self.mapView.userLocation.coordinate
                    
                    self.mapView.addAnnotation(pinAnnotation)
                    
   
                    
                }
                
                
                
                
                
                
            })
            

        }.resume()
    }
    func mapView(mapView: MKMapView, didAddAnnotationViews views: [MKAnnotationView]) {
        
        if let annotationView = views.first {
            
            if let annotation = annotationView.annotation {
                if annotation is MKUserLocation {
                    
                    let region = MKCoordinateRegionMakeWithDistance(annotation.coordinate, 250, 250)
                    self.mapView.setRegion(region, animated: true)
                    
                }
            }
        }
        
    }
    
    
    //end of API
  
    
    private func createAccessoryView() -> UIView {
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
        view.backgroundColor = UIColor.redColor()
        
        let widthConstraint = NSLayoutConstraint(item: view, attribute: .Width, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 300)
        view.addConstraint(widthConstraint)
        
        let heightConstraint = NSLayoutConstraint(item: view, attribute: .Height, relatedBy: .Equal, toItem: nil, attribute: .NotAnAttribute, multiplier: 1, constant: 300)
        view.addConstraint(heightConstraint)
        
        return view
        
    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation is MKUserLocation {
            return nil
        }
        
        var pizzaAnnotationView = self.mapView.dequeueReusableAnnotationViewWithIdentifier("PizzaAnnotationView")
        
        if pizzaAnnotationView == nil {
            // create the annotation view
            pizzaAnnotationView = PizzaAnnotationView(annotation: annotation, reuseIdentifier: "PizzaAnnotationView")
        }
        
        pizzaAnnotationView?.canShowCallout = true
        
        
        return pizzaAnnotationView
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
