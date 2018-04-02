//
//  VenueSearchController.swift
//  CitySearch2
//
//  Created by Gazolla on 01/04/2018.
//  Copyright © 2018 Gazolla. All rights reserved.
//

import UIKit
import MapKit

class VenueSearchController: UIViewController {
    
    var destination:Destination?
    var matchingItems:[MKMapItem] = []{
        didSet{
            self.tableView.reloadData()
        }
    }

    lazy var searchController:UISearchController = {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.searchBar.delegate = self
        search.dimsBackgroundDuringPresentation = false
        search.hidesNavigationBarDuringPresentation = false
        search.definesPresentationContext = true
        search.searchBar.sizeToFit()
        return search
    }()
    
    lazy var tableView: UITableView = { [unowned self] in
        let c = UITableView(frame: CGRect.zero)
        c.backgroundColor = .white
        c.translatesAutoresizingMaskIntoConstraints = false
        c.delegate = self
        c.dataSource = self
        c.register(VenueCell.self, forCellReuseIdentifier: "id")
        return c
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .Gainsboro
        view.addSubview(self.tableView)
        self.navigationItem.titleView = self.searchController.searchBar
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.perform(#selector(showKeyboard), with: nil, afterDelay: 0.1)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.searchBar.resignFirstResponder()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        let layout = self.view.safeAreaLayoutGuide
        tableView.topAnchor.constraint(equalTo: layout.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: layout.bottomAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: layout.rightAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: layout.leftAnchor).isActive = true

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchController.searchBar.placeholder = "Search your place"
    }
    
    @objc func showKeyboard() {
        self.searchController.searchBar.becomeFirstResponder()
        self.searchController.searchBar.text = ""
    }
    
    deinit{
        print("deinit")
        self.tableView.delegate = nil
        self.tableView.dataSource = nil
    }
    

}

extension VenueSearchController:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.matchingItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "id", for: indexPath) as! VenueCell
        cell.selectionStyle = UITableViewCellSelectionStyle.none
        cell.accessoryType = .detailButton
        let place = self.matchingItems[indexPath.item]
        cell.venue = place

        return cell
    }
    
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
            let venue = self.matchingItems[indexPath.item]
            let detail = VenueDetailController()
            detail.venue = venue
            navigationController?.pushViewController(detail, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print((indexPath as NSIndexPath).row)
        let item:MKMapItem = matchingItems[indexPath.item]
        print(item)
    }
    
}

extension VenueSearchController: UISearchBarDelegate, UISearchResultsUpdating {
    // PRAGMA MARK: - UISearchBarDelegate
    func filterContentForSearchText(_ searchText: String) {
        guard let searchBarText = searchController.searchBar.text, let destination = destination  else { return }
        
        let request = MKLocalSearchRequest()
        
        let aSpan = MKCoordinateSpan(latitudeDelta: 1.0,longitudeDelta: 1.0)
        let Center =  destination.coordinates!
        let region = MKCoordinateRegionMake(Center, aSpan)
        
        request.naturalLanguageQuery = searchBarText
        request.region = region
        
        let search = MKLocalSearch(request: request)
        search.start { response, _ in
            guard let response = response else {
                return
            }
            self.matchingItems = response.mapItems
        }
        
        
      /*  let geoCoder = CLGeocoder()
        let location = searchBarText
        geoCoder.geocodeAddressString(location) { (placemark, error) in
            if error != nil {
                print(error!)
            }
            if placemark != nil {
                self.map.removeAnnotations(self.map.annotations)
                
                let destination = Destination(placemark: placemark![0])
                self.cityDetail.destination = destination
                
                let annotation = MKPointAnnotation()  // <-- new instance here
                annotation.coordinate = destination.coordinates!
                annotation.title = destination.name!
                self.map.addAnnotation(annotation)
                
                let aSpan = MKCoordinateSpan(latitudeDelta: 1.0,longitudeDelta: 1.0)
                let Center =  destination.coordinates!
                let region = MKCoordinateRegionMake(Center, aSpan)
                
                self.map.setRegion(region, animated: true)
            } else {
                self.map.removeAnnotations(self.map.annotations)
                self.cityDetail.clear()
            }
        }*/
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!)
    }
    
    //PRAGMA MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
       // navigationController?.popViewController(animated: true)
    }
    
}

class VenueCell: UITableViewCell {
    
    var venue:MKMapItem? {
        didSet{
            guard let venue = venue else { return }
            self.textLabel?.text = venue.name
            self.detailTextLabel?.text = "\(venue.placemark.description)"
            self.detailTextLabel?.textColor = .lightGray
        }
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?){
        super.init(style: UITableViewCellStyle.subtitle, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
