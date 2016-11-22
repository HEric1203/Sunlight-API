//
//  LegiTableViewController.swift
//  HW9.01
//
//  Created by apple on 11/21/16.
//  Copyright © 2016 韩青烽. All rights reserved.
//

import Foundation
import AlamofireImage
import SwiftyJSON
import Alamofire

class LegiTableViewController: UITableViewController {
    @IBOutlet var barbutton: UITabBarItem!
    
    //var legi:[String] = ["legi1","legi2","legi3","legi4","legi5","legi6"]

    var arr :[[String: AnyObject]] = []
    var arrListGrouped = NSDictionary() as! [String : [[String: AnyObject]]]
    // array of section titles
    var sectionTitleList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set font of bar button item
        barbutton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Helvetica", size: 17.0)!], for: UIControlState.normal)
        
        //retrieve data
        let url = "http://hqf-env1.us-west-2.elasticbeanstalk.com/"
        let parameters: Parameters = ["action": 1]
        Alamofire.request(url, method: .post, parameters: parameters).responseJSON { response in
            let swiftjsondata = JSON(response.result.value!)
            if let resData = swiftjsondata["results"].arrayObject {
                self.arr = resData as! [[String: AnyObject]]
                self.arr.sort{
                    let name1 = $0["first_name"] as? String
                    let name2 = $1["first_name"] as? String
                    let lname1 = $0["last_name"] as? String
                    let lname2 = $1["last_name"] as? String
                    if((name1?[(name1?.startIndex)!])! == (name2?[(name2?.startIndex)!])!){
                        if((lname1?[(lname1?.startIndex)!])! == (lname2?[(lname2?.startIndex)!])!){
                            if(lname1 == lname2){return name1! < name2!}
                            else{return lname1! < lname2!}
                        }
                        else{return lname1! < lname2!}
                    }
                    else{return name1! < name2!}
                }
            }
            self.splitDataInToSection()
            self.tableView.reloadData()
        }
        
        
    }
    
    
    fileprivate func splitDataInToSection() {
        
        // set section title "" at initial
        var sectionTitle: String = ""
        
        // iterate all records from array
        for i in 0..<self.arr.count {
            
            // get current record
            let currentRecord = self.arr[i]
            
            // find first character from current record
            let firstChar = (currentRecord["first_name"]as! String!)[(currentRecord["first_name"]as! String!).startIndex]
            
            // convert first character into string
            let firstCharString = "\(firstChar)"
            
            // if first character not match with past section title then create new section
            if firstCharString != sectionTitle {
                
                // set new title for section
                sectionTitle = firstCharString
                
                // add new section having key as section title and value as empty array of string
                self.arrListGrouped[sectionTitle] = [[String: AnyObject]]()
                
                // append title within section title list
                self.sectionTitleList.append(sectionTitle)
            }
            
            // add record to the section
            self.arrListGrouped[firstCharString]?.append(currentRecord)
        }
        
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.arrListGrouped.count
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.sectionTitleList[section]
    }
    
    override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return self.sectionTitleList
    }

    override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return index
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let sectionTitle = self.sectionTitleList[section]
        
        let arrs = self.arrListGrouped[sectionTitle]
        
        return arrs!.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! LegiTableViewCell
        
        let sectionTitle = self.sectionTitleList[(indexPath as NSIndexPath).section]
        let arrs = self.arrListGrouped[sectionTitle]
        
        cell.name.text = (arrs?[indexPath.row]["first_name"] as! String?)! + " "
        + (arrs![indexPath.row]["last_name"] as! String?)!
        cell.state.text = statehash[(arrs![indexPath.row]["state"] as! String?)!]
        
       
        if let url = URL(string: "https://theunitedstates.io/images/congress/original/"+(arrs![indexPath.row]["bioguide_id"] as! String?)!+".jpg"){
        cell.photo.af_setImage(withURL: url)
        }
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    var statehash: [String:String] = [
        "AL": "Alabama","AK": "Alaska","AS": "American Samoa","AZ": "Arizona","AR": "Arkansas","CA": "California","CO": "Colorado","CT": "Connecticut","DE": "Delaware","DC": "District Of Columbia","FM": "Federated States Of Micronesia","FL": "Florida","GA": "Georgia","GU": "Guam","HI": "Hawaii","ID": "Idaho","IL": "Illinois","IN": "Indiana","IA": "Iowa","KS": "Kansas","KY": "Kentucky","LA": "Louisiana","ME": "Maine","MH": "Marshall Islands","MD": "Maryland", "MA": "Massachusetts","MI": "Michigan","MN": "Minnesota","MS": "Mississippi","MO": "Missouri","MT": "Montana","NE": "Nebraska","NV": "Nevada","NH": "New Hampshire","NJ": "New Jersey","NM": "New Mexico","NY": "New York","NC": "North Carolina","ND": "North Dakota",
        "MP": "Northern Mariana Islands","OH": "Ohio","OK": "Oklahoma","OR": "Oregon","PW": "Palau","PA": "Pennsylvania","PR": "Puerto Rico","RI": "Rhode Island","SC": "South Carolina",
        "SD": "South Dakota","TN": "Tennessee","TX": "Texas","UT": "Utah","VT": "Vermont","VI": "Virgin Islands","VA": "Virginia","WA": "Washington","WV": "West Virginia","WI": "Wisconsin","WY": "Wyoming"
    ]
}
