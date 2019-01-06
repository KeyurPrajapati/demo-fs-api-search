//
//  ViewController.swift
//  DemoRetrofit
//
//  Created by KEYUR PRAJAPATI on 05/01/19.
//  Copyright © 2019 keyur. All rights reserved.
//

import UIKit
import CoreLocation

let CientID = "CJ3DT3LZN4FYKX4NEJRLV2R1W2TAX4E52AYV3URXBS2BAXKE"
let SecretID = "OKZGL5NSKNZSBMFJA041FQIVW33YA5J2RUZV3DVHQOHAWYR0"

class ViewController: UIViewController, CLLocationManagerDelegate, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Declare Variables
    let locationManager = CLLocationManager()
    private var strDate: String = ""
    private var strLatLong: String = ""
    private var arrayResponse: [Response] = []
    private let apiClient = APIClient.shared
    
    //MARK: - Declare IBOutlet Variables
    @IBOutlet private var srchBar: UISearchBar!
    @IBOutlet private var tblVResult: UITableView!
    
    //MARK: - Implementation Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblVResult.delegate = self
        tblVResult.dataSource = self
        srchBar.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
        
        isAuthorizedtoGetUserLocation()
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyyMMdd"
        strDate = dateFormatterGet.string(from: Date())
        
    }
    //MARK: - CLLocationManager Delegate Methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("Locatiobn detect")
        let userLocation :CLLocation = locations[0] as CLLocation
        var boolCanSearchYN = false
        if strLatLong == "" {
            boolCanSearchYN = true
        }
        strLatLong = "\(userLocation.coordinate.latitude),\(userLocation.coordinate.longitude)"
        if boolCanSearchYN {
            loadNearByVenues(strSearch: srchBar.text ?? "")
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Did location updates is called but failed getting location \(error)")
    }
    //MARK: - UISearchBar Delegate Methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        loadNearByVenues(strSearch: searchText)
    }
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        srchBar.resignFirstResponder()
    }
    // MARK: - UITableView Delegate Methods
    private let strCellID = "CellID" as String
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayResponse.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: strCellID)
        
        let lblName = cell?.contentView.viewWithTag(1) as! UILabel
        let lblAddress = cell?.contentView.viewWithTag(2) as! UILabel
        let lblDistance = cell?.contentView.viewWithTag(3) as! UILabel
        
        let objResponse = arrayResponse[indexPath.row]
        
        lblName.text = objResponse.name
        lblAddress.text = objResponse.location?.address != nil ? objResponse.location?.address : objResponse.location?.formattedAddress.joined(separator: ", ")
        lblDistance.text = String(format: "%f",objResponse.location?.distance ?? 0)
        
        return cell!
    }
    //MARK: - Custom Methods
    func isAuthorizedtoGetUserLocation() {
        if CLLocationManager.authorizationStatus() != .authorizedWhenInUse     {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    func loadNearByVenues(strSearch: String) {
        if strLatLong != "" {
            apiClient.loadFSResponse(strPath: "venues/search?client_id=\(CientID)&client_secret=\(SecretID)&ll=\(strLatLong)&query=\(strSearch)&v=\(strDate)") { (response, error) in
                    if response != nil {
                        self.arrayResponse = response ?? []
                    }
                    if error != nil {
                        print("error:\(String(describing: error))")
                    }
                    if response==nil && error==nil {
                        print("Network error")
                    }
                DispatchQueue.main.async {
                    self.tblVResult.reloadData()
                }
            }
        }
    }
    
}
