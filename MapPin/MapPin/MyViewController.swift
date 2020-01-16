//
//  MyViewController.swift
//  MapPin
//
//  Created by MacStudent on 2020-01-16.
//  Copyright © 2020 MacStudent. All rights reserved.
//

import UIKit
import CoreData
import MapKit
class MyViewController: UIViewController,MKMapViewDelegate{
    
    var selectPinView: MKAnnotation!
    var managedContext: NSManagedObjectContext!
    let appdelegate = UIApplication.shared.delegate as! AppDelegate
    var locatonSingle = Location()
    var pTitle = ""
    var pSubTitle = 0
    var pLatitude = 0.0
    var pLongitude = 0.0
    var locationDataArray = [Location]()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        
    }
    
    
    // Button Actions
    @IBAction func editBtnPressed(_ sender: Any) {
        
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyEditViewController") as? MyEditViewController {
            
//            viewController.latitude = pLatitude
//            viewController.longitude = pLongitude
            
            
            if let navigator = navigationController {
                navigator.pushViewController(viewController, animated: true)
            }
        }
    }
    func setPins() {
        
        var locValue:CLLocationCoordinate2D = CLLocationCoordinate2D()
        
        print("latitude" + "\(locValue.latitude)")
        print("latitude" + "\(locValue.longitude)")
        
        
        var pinPoint = [MKPointAnnotation]()
        
        locationDataArray = fetchRecords()
           mapView.removeAnnotations(mapView.annotations)
        for i in 0..<locationDataArray.count{
            let annotation = MKPointAnnotation()
            
            locValue.latitude = locationDataArray[i].latitude
            locValue.longitude = locationDataArray[i].longitude
            
            annotation.coordinate = locValue
            mapView.isZoomEnabled = false
            
         
            
            annotation.title = locationDataArray[i].title
            annotation.subtitle = locationDataArray[i].subtitle.description
            
            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
            
            pinPoint.append(annotation)
            //  mapView.addAnnotation(annotation)
        }
        mapView.addAnnotations(pinPoint)
        
        let loca = CLLocationCoordinate2DMake(locValue.latitude,
                                              locValue.longitude)
        let coordinateRegion = MKCoordinateRegion(center: loca,
                                                  latitudinalMeters: 4000000, longitudinalMeters: 4000000)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //     mapDelegate()
        setPins()
    }
    
    
    // Map Functions To get the location for the user
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        selectPinView = annotation
        if !(annotation is MKUserLocation) {
            let pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: String(annotation.hash))

            
            let rightButton = UIButton(type: .infoDark)
            rightButton.tag = annotation.hash
            rightButton.addTarget(self, action: #selector(annoBtnPressed), for: .touchDown)
            pinView.animatesDrop = true
            pinView.canShowCallout = true
            pinView.rightCalloutAccessoryView = rightButton
            
            let leftButton = UIButton(type: .close)
            leftButton.tag = annotation.hash
            leftButton.addTarget(self, action: #selector(deleteBtnPressed), for: .touchDown)
            pinView.animatesDrop = true
            pinView.canShowCallout = true
            pinView.leftCalloutAccessoryView = leftButton
            
            return pinView
        }
        else {
            return nil
        }
    }
    
    @objc func annoBtnPressed(){
        self.view.layoutIfNeeded()
        if let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MyUpdatePinController") as? MyUpdatePinController {
                   
                   
                   for i in 0..<self.locationDataArray.count{
                       if(self.locationDataArray[i].subtitle ==  Int32(((selectPinView?.subtitle)!)!) ){
                           self.locatonSingle = self.locationDataArray[i]
                           break
                       }}
                   viewController.locaton = self.locatonSingle
                   
                   
                   if let navigator1 = self.navigationController {
                       navigator1.pushViewController(viewController, animated: true)
                   }
  
        }}
    @objc func deleteBtnPressed(){
        self.view.layoutIfNeeded()
        for i in 0..<self.locationDataArray.count{
                       if(self.locationDataArray[i].subtitle ==  Int32(((selectPinView?.subtitle)!)!) ){
                           self.deleteRecord(location: self.locationDataArray[i])
                           
                           self.setPins()
                           break
                       }
                   }
     
    }
 
    func insertRecord(title:String, subTitle:Int,latitude: Double,longitude: Double){
                 let location = Location(context: managedContext)
           
                 location.title = title
                 location.subtitle = Int32(subTitle)
                 location.latitude = latitude
                 location.longitude = longitude
                 
        try! managedContext.save()
             }
       
       func fetchRecords() -> [Location]{
          var arrLocation = [Location]()
          let fetchRequest = NSFetchRequest<Location>(entityName: "Location")
          
              do{
                  arrLocation = try managedContext.fetch(fetchRequest)
              }catch{
                  print(error)
              }
              return arrLocation
          }

          func deleteRecord( location : Location){
            managedContext.delete(location)
         try! managedContext.save()
          }
          
          func updateRecord(location:Location,title:String,subTitle:Int,latitude: Double,longitude: Double){
              
              
                  location.title = title
                  location.subtitle = Int32(subTitle)
                  location.latitude = latitude
                  location.longitude = longitude
             try! managedContext.save()
          }
    
    
}

// Map Delegate functons




