//
//  MyUpdatePinController.swift
//  MapPin
//
//  Created by MacStudent on 2020-01-16.
//  Copyright © 2020 MacStudent. All rights reserved.
//

import UIKit
import CoreData

class MyUpdatePinController: UIViewController {
    
    
    var managedContext: NSManagedObjectContext!
    @IBOutlet weak var tileTxt: UITextField!
    
    @IBOutlet weak var longTxt: UITextField!
    @IBOutlet weak var latTxt: UITextField!
    @IBOutlet weak var subtitleTxt: UITextField!
    
    
      var coreDataStack = CoreDataStack(modelName: "MapData")
    @IBAction func updatePindata(_ sender: Any) {
        
        
        self.updateRecord(location: locaton, title: tileTxt.text!, subTitle: Int(subtitleTxt.text!)!, latitude: Double(latTxt.text!)!, longitude: Double(longTxt.text!)!)
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    var locaton = Location()
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tileTxt.text = locaton.title
        subtitleTxt.text = locaton.subtitle.description
        longTxt.text = locaton.longitude.description
        latTxt.text = locaton.latitude.description
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
               managedContext = coreDataStack.managedContext
        
        
    }
    
    

          func updateRecord(location:Location,title:String,subTitle:Int,latitude: Double,longitude: Double){
              
              
                  location.title = title
                  location.subtitle = Int32(subTitle)
                  location.latitude = latitude
                  location.longitude = longitude
             try! managedContext.save()
          }
    
}
// Tableview Datasource and Delegate



