//
//  BackbaseViewController.swift
//  Backbase
//
//  Created by george liu on 10/23/18.
//  Copyright © 2018 george liu. All rights reserved.
//

import UIKit

class BackbaseViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    // MARK: Class constants  -------------------------------------------------
    
    
    
    // MARK: UI Controls  -----------------------------------------------------
    @IBOutlet weak var backbaseSearchBar: UISearchBar!
    @IBOutlet weak var backbaseTableView: UITableView!
    
    // MARK: Attributes  ------------------------------------------------------
    var cityStateJson = Dictionary<String, String>()
    var sortedKeysArray = [String]()
    var searching:Bool! = false
    var filtered:[String] = []
    var cityInfo = CityInfo()
    var selectedCityState = String()
    
    var citiesSearchResultsList: [String] = []
    
    // MARK: View Cycle Supporat Methods ---------------------------------------
    func readCitiesJson() -> [Any] {
        var jsonObjectArray = [Any]()
        
        do {
            if let file = Bundle.main.url(forResource: "cities", withExtension: "json") {
                let data = try Data(contentsOf: file)
                let json = try JSONSerialization.jsonObject(with: data, options: [])
                if let object = json as? [Any] {
                    // json is an array
                    jsonObjectArray = object
                } else {
                    print("JSON is invalid")
                }
            } else {
                print("no file")
            }
        } catch {
            print(error.localizedDescription)
        }
        
        return jsonObjectArray
    }
    
    func createCityStateJsonArray(jsonObjectArray: [Any]) -> Dictionary<String, String> {
        var cityCountryJson = Dictionary<String, String>()
        
        for item in jsonObjectArray as [Any] {

            if let dictionary = item as? [String: Any] {
                let stateName = dictionary["country"] as! String
                let cityName = dictionary["name"] as! String
                let coord = dictionary["coord"] as Any
                let id = dictionary["_id"] as! Int
                
                let props = ["_id": id, "name": cityName, "stateName": stateName, "coord": coord]
                var jsonValue = String()
                
                do {
                    let jsonData = try JSONSerialization.data(withJSONObject: props, options: .prettyPrinted)
                    jsonValue = String(data: jsonData, encoding: String.Encoding.utf8)!
                } catch let error {
                    print("error converting to json: \(error)")
                }
            
                let cityStateKey = "\(String(describing: cityName)), \(String(describing: stateName))"
                cityCountryJson[cityStateKey] = jsonValue
            
            }
            else {
                print("BACKBASEVC: createCityStateJsonArray: invalid JSON")
            }

        }   // end for

        return cityCountryJson
    }
    
    
    
    // MARK: View Cycle Methods ---------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backbaseTableView.dataSource = self
        self.backbaseTableView.delegate = self
        self.backbaseSearchBar.delegate = self // as? UISearchBarDelegate
    }
    
    override func viewDidAppear(_ animated: Bool) {
        var jsonObjectArray = [Any]()
        // Do any additional setup after loading the view.

        jsonObjectArray = readCitiesJson()
        if (jsonObjectArray.count != 0) {
            cityStateJson = createCityStateJsonArray(jsonObjectArray: jsonObjectArray)

            sortedKeysArray = cityStateJson.keys.sorted()
            citiesSearchResultsList = sortedKeysArray
            backbaseTableView.reloadData()

            print("\nLIST: \(citiesSearchResultsList)   COUNT: \(citiesSearchResultsList.count)")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /**********/
    // MARK: - Table view data source -----------------------------------------
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return citiesSearchResultsList.count  // sortedKeysArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "backbaseTableViewCell", for: indexPath)
        
        cell.textLabel?.text = citiesSearchResultsList[(indexPath as NSIndexPath).row]
        // Configure the cell...
        return cell
    }
    
    
    // MARK: UITableViewDelegate -----------------------------------------------
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedCityState = citiesSearchResultsList[(indexPath as NSIndexPath).row]
        self.performSegue(withIdentifier: "MapKitSegue", sender: selectedCityState)
        backbaseTableView.deselectRow(at: indexPath, animated: true)
    }
    
    

    
    // MARK: - Navigation  ------------------------------------------------------
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        super.prepare(for: segue, sender: sender)
        
        let cityState = selectedCityState
        let cityStateString = cityStateJson[cityState]
        let cityInfoJson = convertToDictionary(text: cityStateString!)
        
        let cityName = cityInfoJson!["name"] as! String
        let stateName = cityInfoJson!["stateName"] as! String
        let coordJson = cityInfoJson!["coord"] as! [String: Any]

        let lat = coordJson["lat"] as! Double
        let lon = coordJson["lon"] as! Double
        
        let vc = segue.destination as! MapKitViewController
        self.cityInfo = CityInfo(name: cityName, country: stateName, lat: lat, lon: lon)

        vc.myCityInfo = self.cityInfo

    }
 
    
    
    // MARK: Support Methods ----------------------------------------------------
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }




}   // end class BackbaseViewController


// MARK: UISEARCHBAR OPS  -------------------------------------------------------
extension BackbaseViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        citiesSearchResultsList = sortedKeysArray
        if (searchText == "") {
            searching = false
        }
        else {
            searching = true
            citiesSearchResultsList.removeAll()
            
            for index in 0 ..< self.sortedKeysArray.count {
                let cityState = self.sortedKeysArray[index] as String

                if cityState.lowercased().range(of: searchText.lowercased())  != nil {
                    self.citiesSearchResultsList.append(cityState)
                }
        
                self.citiesSearchResultsList.sort()
            }   // end for
        }
        self.backbaseTableView!.reloadData()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        backbaseSearchBar.showsScopeBar = true
        backbaseSearchBar.sizeToFit()
        return true
    }
    
    public func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        backbaseSearchBar.showsScopeBar = false
        backbaseSearchBar.sizeToFit()
        backbaseSearchBar.setShowsCancelButton(false, animated: true)
        return true
    }
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        backbaseSearchBar.becomeFirstResponder()
        self.backbaseTableView!.reloadData()
    }
    
    func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        self.view.endEditing(true)
        self.backbaseSearchBar.endEditing(true)
        backbaseSearchBar.resignFirstResponder()
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.backbaseSearchBar.endEditing(true)
        backbaseSearchBar.resignFirstResponder()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        backbaseSearchBar.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        backbaseSearchBar.text = ""
        self.backbaseTableView!.reloadData()
    }
    
}   // end extension

    












    
    


