//
//  NewsViewController.swift
//  MedCampusNaviWithExtras
//
//  Created by o_rossmanf on 01.08.17.
//  Copyright © 2017 mug. All rights reserved.
//

import UIKit

class NewsViewController: UITableViewController {
    
    //MARK: Properties
    var news = [News]()
    var nextURL = String()
    var url = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let httpad = HTTP()
        httpad.get(urlStr:"https://api.medunigraz.at/v1/typo3/news/?format=json"){ getJson in
            let resultArray = getJson["results"] as! Array<[String:Any]>
            if (getJson["next"] as? String) != nil {
                self.nextURL = getJson["next"] as! String
            }else{
                self.nextURL = "END"
            }
            
            for dict in resultArray {
                if (dict["url"] as? String) != nil {
                    self.url = dict["url"] as! String
                }else{
                    self.url = "www.noSite.com"
                }
                let newsObject = News(title: dict["title"] as! String, desc: dict["teaser"] as! String, url: URL(string: self.url)!,date: dict["datetime"] as! String)
                self.news += [newsObject]
 
            }
            self.tableView.reloadData()
        }
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return news.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "NewsCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NewsTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        // Configure the cell...
        let news = self.news[indexPath.row]
        
        cell.selectionStyle=UITableViewCellSelectionStyle.none
        cell.accessoryType=UITableViewCellAccessoryType.none
        cell.isUserInteractionEnabled=false
        cell.title.text=news.title
        cell.desc.text=news.desc
        cell.date.text=news.date
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,forRowAt indexPath: IndexPath) {
        let lastElement = news.count - 1
        if indexPath.row == lastElement {
            if self.nextURL != "END" {
                let httpad = HTTP()
                httpad.get(urlStr:self.nextURL){ getJson in
                    if getJson["count"] == nil{
                        _ = self.navigationController?.popToRootViewController(animated: true)
                    }
                    let resultArray = getJson["results"] as! Array<[String:Any]>
                    if (getJson["next"] as? String) != nil {
                        self.nextURL = getJson["next"] as! String
                    }else{
                        self.nextURL = "END"
                    }
                    for dict in resultArray {
                        let newsObject = News(title: dict["title"] as! String, desc: dict["teaser"] as! String, url: URL(string: "https://api.medunigraz.at/")!, date: dict["datetime"] as! String)
                        self.news += [newsObject]
                    }
                    self.tableView.reloadData()
                    
                }
                
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIApplication.shared.open(news[indexPath.row].url, options: [:])
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
     super.prepare(for: segue, sender: sender)
     
     }
     */
    
}
