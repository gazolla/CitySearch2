//
//  CitySearchController.swift
//  CitySearch2
//
//  Created by Gazolla on 31/03/2018.
//  Copyright © 2018 Gazolla. All rights reserved.
//

import UIKit
import MapKit

class CitySearchController: UIViewController {
    
    var selectedCity: ((_ destination:Destination)->())?
    
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
    
    lazy var cityDetail:CityDetailView = {
        let cdv = CityDetailView(frame: CGRect.zero)
        return cdv
    }()
    
    lazy var map:MKMapView = {
        let m = MKMapView()
        
        var longPress = UILongPressGestureRecognizer(target: self, action: #selector(addAnnotation))
        longPress.minimumPressDuration = 2.0
        
        m.addGestureRecognizer(longPress)
        return m
    }()
    
    @objc func addAnnotation(_ gestureRecognizer:UIGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizerState.began {
            let touchPoint = gestureRecognizer.location(in: map)
            let newCoordinates = map.convert(touchPoint, toCoordinateFrom: map)
            let annotation = MKPointAnnotation()
            annotation.coordinate = newCoordinates
            
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: newCoordinates.latitude, longitude: newCoordinates.longitude), completionHandler: {(placemarks, error) -> Void in
                if error != nil {
                    print("Reverse geocoder failed with error" + error!.localizedDescription)
                    return
                }
                
                if let placemarks = placemarks  {
                    self.map.removeAnnotations(self.map.annotations)
                    
                    let destination = Destination(placemark: placemarks[0])
                    self.cityDetail.destination = destination
                    
                    let annotation = MKPointAnnotation()  // <-- new instance here
                    annotation.coordinate = destination.coordinates!
                    annotation.title = destination.name!
                    self.map.addAnnotation(annotation)
                    
                    let aSpan = MKCoordinateSpan(latitudeDelta: 1.0,longitudeDelta: 1.0)
                    let Center =  destination.coordinates!
                    let region = MKCoordinateRegionMake(Center, aSpan)
                    
                    self.map.setRegion(region, animated: true)                }
            })
        }
    }
    
    lazy var mainView:UIView = {
        let v = UIView(frame:CGRect.zero)
        v.backgroundColor = .Snow
        
        v.layer.masksToBounds = false
        v.layer.shadowColor = UIColor.gray.cgColor
        v.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        v.layer.shadowRadius = 2.0
        v.layer.shadowOpacity = 1.0
        
        v.translatesAutoresizingMaskIntoConstraints = false
        
        v.addSubview(stack)
        
        return v
    }()
    
    lazy var stack:UIStackView = {
        let s = UIStackView(frame:CGRect.zero)
        s.alignment = .fill
        s.distribution = .fill
        s.axis = .vertical
        s.addArrangedSubview(cityDetail)
        s.addArrangedSubview(map)
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .Gainsboro
        view.addSubview(mainView)
        self.navigationItem.titleView = self.searchController.searchBar
        // cityDetail.destination = Destination(ident: "", name: "San Jose", administrativeArea: "CA", country: "United States", coordinates: nil, region: nil, flagIconURL: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.perform(#selector(showKeyboard), with: nil, afterDelay: 0.1)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        searchController.searchBar.resignFirstResponder()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        if let destination = cityDetail.destination {
            selectedCity?(destination)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchController.searchBar.placeholder = "Search your destination"
    }
    
    @objc func showKeyboard() {
        self.searchController.searchBar.becomeFirstResponder()
        self.searchController.searchBar.text = ""
        self.cityDetail.clear()
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        let layout = self.view.layoutMarginsGuide
        mainView.heightAnchor.constraint(equalTo: layout.heightAnchor, multiplier: 0.55).isActive = true
        mainView.topAnchor.constraint(equalTo: layout.topAnchor, constant: 5.0).isActive = true
     //   mainView.bottomAnchor.constraint(equalTo: layout.bottomAnchor).isActive = true
        mainView.rightAnchor.constraint(equalTo: layout.rightAnchor).isActive = true
        mainView.leftAnchor.constraint(equalTo: layout.leftAnchor).isActive = true
        
        stack.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: mainView.centerYAnchor).isActive = true
        stack.heightAnchor.constraint(equalTo: mainView.heightAnchor).isActive = true
        stack.widthAnchor.constraint(equalTo: mainView.widthAnchor).isActive = true
      //  stack.topAnchor.constraint(equalTo: mainView.topAnchor).isActive = true
      //  stack.bottomAnchor.constraint(equalTo: mainView.bottomAnchor).isActive = true
       // stack.rightAnchor.constraint(equalTo: mainView.rightAnchor).isActive = true
        //stack.leftAnchor.constraint(equalTo: mainView.leftAnchor).isActive = true
        
    }
}

extension CitySearchController: UISearchBarDelegate, UISearchResultsUpdating {
    // PRAGMA MARK: - UISearchBarDelegate
    func filterContentForSearchText(_ searchText: String) {
        guard let searchBarText = searchController.searchBar.text else { return }
        let geoCoder = CLGeocoder()
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
        }
        
    }
    
    
    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        filterContentForSearchText(searchBar.text!)
    }
    
    //PRAGMA MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        navigationController?.popViewController(animated: true)
    }
    
}


class CityDetailView: UIView {
    
    var width:CGFloat { return 200 }
    var titleFontSize:CGFloat { return  round(width * 0.09) }
    var fontSize:CGFloat  { return round(width * 0.045) }
    var textColor:UIColor { return UIColor.black }
    
    
    var destination:Destination?{
        didSet{
            guard let destination = destination else { return }
            let name = destination.name ?? ""
            let state = destination.administrativeArea ?? ""
            let country = destination.country ?? ""
            self.name.text = "\(name), \(state)"
            self.country.text = country
            if let flag = destination.flagIconURL {
                self.flagImage.image = UIImage(named:flag)
            }
        }
    }
    
    lazy var name:UILabel = {
        let lbl = UILabel()
        lbl.textColor =  self.textColor
        lbl.font = UIFont(name: "Arial-BoldMT", size:self.titleFontSize)
        return lbl
    }()
    
    lazy var country:UILabel = {
        let lbl = UILabel()
        lbl.textColor = self.textColor
        lbl.font = UIFont(name: "Arial", size: self.fontSize)
        return lbl
    }()
    
    lazy var flagImage:UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .center
        return iv
    }()
    
    lazy var stack:UIStackView = { [unowned self] in
        let s = UIStackView()
        s.axis = .vertical
        s.distribution = .fillEqually
        s.alignment = .fill
        s.addArrangedSubview(name)
        s.addArrangedSubview(country)
        s.addArrangedSubview(flagImage)
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
        }()
    
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        addSubview(stack)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        stack.widthAnchor.constraint(equalTo: layoutMarginsGuide.widthAnchor).isActive = true
        stack.topAnchor.constraint(equalTo: layoutMarginsGuide.topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: layoutMarginsGuide.bottomAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: layoutMarginsGuide.rightAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: layoutMarginsGuide.leftAnchor).isActive = true
    }
    
    func clear(){
        self.name.text = "   "
        self.country.text = "   "
        self.flagImage.image = nil
    }
    
    
}

extension UIColor {
    
    static let Gainsboro = UIColor(hex: "0xDCDCDC")
    static let Snow = UIColor(hex: "0xFFFAFA")
    
    convenience init(hex: String) {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        
        var rgbValue: UInt64 = 0
        
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(
            red: CGFloat(r) / 0xff,
            green: CGFloat(g) / 0xff,
            blue: CGFloat(b) / 0xff, alpha: 1
        )
    }
}
