//
//  MyEditViewController.swift
//  MapPin
//
//  Created by MacStudent on 2020-01-16.
//  Copyright © 2020 MacStudent. All rights reserved.
//

import UIKit
import CoreData

class MyEditViewController: UIViewController {
    var managedContext: NSManagedObjectContext!
      var coreDataStack = CoreDataStack(modelName: "MapData")
    @IBAction func doneBtnPressed(_ sender: Any) {
             
     self.navigationController?.popToRootViewController(animated: true)
        
    }
    var refreshControl = UIRefreshControl()


    var locaton = Location()
    
    var pTitle = ""
    var pSubTitle = 0
    var pLatitude = 0.0
    var pLongitude = 0.0
       
    var locationArray = [Location]()
    var pinsArray = [Location]()
    
    @IBOutlet weak var titleTxtField: UITextField!
    @IBOutlet weak var subTitleTxtField: UITextField!
    @IBOutlet weak var latitudeTxtField: UITextField!
    @IBOutlet weak var longitudeTxtField: UITextField!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var donebarbtn: UIBarButtonItem!
    
    @IBAction func submitBtnPress(_ sender: Any) {
        self.donebarbtn.isEnabled = true

        let name = titleTxtField.text
        let age = subTitleTxtField.text
        let tution = latitudeTxtField.text
        let startDate = longitudeTxtField.text
        
         self.fetchAndUpdateTable()
        pTitle = name!
        pSubTitle =  Int(age!)!
        pLatitude =  Double(tution!)!
        pLongitude =  Double(startDate!)!
        self.insertRecord(title: pTitle, subTitle: pSubTitle, latitude: pLatitude, longitude: pLongitude)
               self.fetchAndUpdateTable()
        self.view.setNeedsLayout()
        self.tableView.reloadData()

        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        pinsArray = locationArray
        self.donebarbtn.isEnabled = false

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        managedContext = coreDataStack.managedContext
    refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        tableView.addSubview(refreshControl)
        fetchAndUpdateTable()

          
    }

    @objc func refresh() {
       // Code to refresh table view
        self.tableView.reloadData()
        self.refreshControl.endRefreshing()
    }
    func fetchAndUpdateTable(){
           locationArray = fetchRecords()
           pinsArray = locationArray

           tableView.reloadData()
       }
    
}
// Tableview Datasource and Delegate

extension MyEditViewController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pinsArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! MapCell
        let location = pinsArray[indexPath.row]
        cell.placeNameLbl?.text = location.title!
        cell.subtitleLbl?.text =  String(location.subtitle)
        cell.latitudeLbl.text = String(location.latitude)
        cell.longitudeLbl.text = String(location.longitude)
  
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if editingStyle == .delete{
            let location = locationArray[indexPath.row]
            deleteRecord(location: location)
            fetchAndUpdateTable()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
               
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


class MapCell: UITableViewCell{
    
    @IBOutlet weak var placeNameLbl: UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var latitudeLbl: UILabel!
    @IBOutlet weak var longitudeLbl: UILabel!
    
    
}
