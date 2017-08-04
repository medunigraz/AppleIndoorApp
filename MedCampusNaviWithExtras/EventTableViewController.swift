//
//  EventTableViewController.swift
//  MedCampusNaviWithExtras
//
//  Created by o_rossmanf on 01.08.17.
//  Copyright © 2017 mug. All rights reserved.
//

import UIKit

class EventTableViewController: UITableViewController {
    
    var events = [Event]()
    var url = String()
    var state = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let httpad = HTTP()
        print("Start of .get")
        httpad.get(urlStr:"https://api.medunigraz.at/v1/typo3/events/?format=json"){ getJson in
                let resultArray = getJson["results"] as! Array<[String:Any]>
                for dict in resultArray {
                    if (dict["url"] as? String) != "" {
                        self.url = dict["url"] as! String
                        self.state=true
                    }else{
                        self.url = "www.DISABLE.com"
                        self.state = false
                    }
                    
                    let eventObject = Event(start:dict["start"] as! String, end:dict["end"] as! String, title:dict["title"]as! String, desc:dict["teaser"]as! String, allday: (dict["allday"] != nil),url: URL(string: self.url)!,state: self.state)
                    self.events += [eventObject]
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
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return events.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "eventCell"
        print("Cell init")
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? EventTableViewCell  else {
            fatalError("The dequeued cell is not an instance of EventTableViewCell.")
        }
        // Configure the cell...
        let event = self.events[indexPath.row]
        if event.state == false {
            cell.selectionStyle=UITableViewCellSelectionStyle.none
            cell.isUserInteractionEnabled=false
        }
        cell.time.text=event.getTimeString()
        cell.title.text=event.title
        cell.eventdesc.text=event.description
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("lappen")
        UIApplication.shared.open(events[indexPath.row].url, options: [:])
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
