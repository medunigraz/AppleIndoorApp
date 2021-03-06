//
//  EventTableViewController.swift
//  MedCampusNaviWithExtras
//
//  Created by o_rossmanf on 01.08.17.
//  Copyright © 2017 mug. All rights reserved.
//

import UIKit

class EventTableViewController: UITableViewController {
    let urlString:String=Util().GLOBAL_URL.appending("events/?format=json")
    
    //Variables for adding cells to the table view
    var events = [Event]()
    var url = String()
    var state = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //HTTPAdapter init
        let httpad = HTTP()
        //Get Request for the data
        httpad.get(urlStr:urlString){ getJson in
            if (getJson["error"] as? Int) == nil {
                //Getting the event Data as an Array of dictionaries
                let resultArray = getJson["results"] as! Array<[String:Any]>
                //Loop for processing the data
                for dict in resultArray {
                    //Disable Selection and Indicator if there is no URL
                    //) && ((dict["url"] as? String) != ""
                    if let str = dict["url"] as? String
                    {
                        //self.url=dict["url"] as! String
                        self.url=str
                        if  !self.url.hasPrefix("http://") && !self.url.hasPrefix("https://"){
                            let httpStr="http://"
                            self.url = httpStr.appending(self.url)
                        }
                        self.state=true
                    }else{
                        self.url = ""
                        self.state = false
                    }
                    //Init of Model
                    var urlObj:URL?
                    
                    if self.url == ""{
                        urlObj = nil
                    }else{
                        urlObj=URL(string: self.url)
                    }
                    
                    let eventObject = Event(start:dict["start"] as! String, end:dict["end"] as! String, title:dict["title"]as! String, desc:dict["teaser"]as! String, allday: (dict["allday"] != nil),url: urlObj,state: self.state)
                    
                    //add the Model to the table View
                    self.events += [eventObject]
                }
            }else{
              self.events += [Event(start: "00.00.0000T0000", end:"00.00.0000T0000", title:"Error", desc:getJson["desc"] as! String, allday: false,url: nil,state: false)]  
            }
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        return events.count
    }
    
    //execution on tableView.reloadData() call
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "eventCell"
        
        //Creating the tableView with the given identifier
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EventTableViewCell  else {
            //Error occurs if the identifier is not existing
            fatalError("The dequeued cell is not an instance of EventTableViewCell.")
        }
        
        // Configure the cell...
        let event = self.events[indexPath.row]
        cell.accessoryType=UITableViewCellAccessoryType.disclosureIndicator
        
        //if no valid URL exists selection/interaction/selector Btn are disabled
        if event.state == false {
            cell.selectionStyle=UITableViewCellSelectionStyle.none
            cell.isUserInteractionEnabled=false
            cell.accessoryType=UITableViewCellAccessoryType.none
        }else{
            cell.selectionStyle=UITableViewCellSelectionStyle.blue
            cell.isUserInteractionEnabled=true
            cell.accessoryType=UITableViewCellAccessoryType.disclosureIndicator
  
        }
        
        //Setting the cell attributes
        cell.time.text=event.getTimeString()
        if event.getTimeString() == "00.00.0000-00.00.0000" {
            cell.time.isHidden=true
        }
        cell.title.text=event.title
        cell.eventdesc.text=event.description
        
        //Returning the Cell to the View
        return cell
    }
    
    //Happens if the user touches a cell with a valid cell with an URL
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIApplication.shared.open(events[indexPath.row].url!)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    
}
