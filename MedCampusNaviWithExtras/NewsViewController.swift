//
//  NewsViewController.swift
//  MedCampusNaviWithExtras
//
//  Created by o_rossmanf on 01.08.17.
//  Copyright © 2017 mug. All rights reserved.
//

import UIKit

class NewsViewController: UITableViewController {
    
    //Variables for adding cells to the table view
    var news = [News]()
    var nextURL = String()
    var url = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //HTTPAdapter init
        let httpad = HTTP()
        //Get Request for the data
        httpad.get(urlStr:"https://api.medunigraz.at/v1/typo3/news/?format=json"){ getJson in
            //Getting the event Data as an Array of dictionaries
            let resultArray = getJson["results"] as! Array<[String:Any]>
            //Getting the URL for the next site
            //"END" --> no next site
            if (getJson["next"] as? String) != nil {
                self.nextURL = getJson["next"] as! String
            }else{
                self.nextURL = "END"
            }
            //Loop for processing the data
            for dict in resultArray {
                //Disable Selection and Indicator if there is no URL
                if (dict["url"] as? String) != nil {
                    self.url = dict["url"] as! String
                }else{
                    //Creating an Dummy URL
                    self.url = "www.foo.com"
                }
                //Init of Model
                let newsObject = News(title: dict["title"] as! String, desc: dict["teaser"] as! String, url: URL(string: self.url)!,date: dict["datetime"] as! String)
                //add the Model to the table View
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
        // return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // return the number of rows
        return news.count
    }
    
    //execution on tableView.reloadData() call
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Table view cells are reused and should be dequeued using a cell identifier.
        let cellIdentifier = "NewsCell"
        //Creating the tableView with the given identifier
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NewsTableViewCell  else {
            //Error occurs if the identifier is not existing
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        // Configure the cell...
        let news = self.news[indexPath.row]
        //Disabled, because no URLs are available at this time 07.08.2017
        cell.selectionStyle=UITableViewCellSelectionStyle.none
        cell.accessoryType=UITableViewCellAccessoryType.none
        cell.isUserInteractionEnabled=false
        
        //Setting the cell attributes
        cell.title.text=news.title
        cell.desc.text=news.desc
        cell.date.text=news.date
        
        //Returning the Cell to the View
        return cell
    }
    
    //View Update at the end of the site
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell,forRowAt indexPath: IndexPath) {
        let lastElement = news.count - 1
        //if the user hits the bottom of the view the update is executed
        if indexPath.row == lastElement {
            //Update only works with valid URL
            if self.nextURL != "END" {
                //Init of HTTPAdapter
                let httpad = HTTP()
                //HTTP get
                httpad.get(urlStr:self.nextURL){ getJson in
                    let resultArray = getJson["results"] as! Array<[String:Any]>
                    //Getting the URL for the next site
                    //"END" --> no next site
                    if (getJson["next"] as? String) != nil {
                        self.nextURL = getJson["next"] as! String
                    }else{
                        self.nextURL = "END"
                    }
                    //Loop for processing the data
                    for dict in resultArray {
                        //Disable Selection and Indicator if there is no URL
                        if (dict["url"] as? String) != nil {
                            self.url = dict["url"] as! String
                        }else{
                            //Creating an Dummy URL
                            self.url = "www.foo.com"
                        }
                        //Init of Model
                        let newsObject = News(title: dict["title"] as! String, desc: dict["teaser"] as! String, url: URL(string: "https://api.medunigraz.at/")!, date: dict["datetime"] as! String)
                        //Add model to View
                        self.news += [newsObject]
                    }
                    self.tableView.reloadData()
                    
                }
                
            }
        }
    }
    
    //Happens if the user touches a cell with a valid cell with an URL
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        UIApplication.shared.open(news[indexPath.row].url, options: [:])
    }

    
}
