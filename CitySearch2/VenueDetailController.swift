//
//  VenueDetailController.swift
//  CitySearch2
//
//  Created by Gazolla on 01/04/2018.
//  Copyright © 2018 Gazolla. All rights reserved.
//

import UIKit
import MapKit

class VenueDetailController: UIViewController {
   
    var venue:MKMapItem?{
        didSet{
            venueDetail.venue = venue
            let destination = Destination(placemark: venue!.placemark)
            let annotation = MKPointAnnotation()  // <-- new instance here
            annotation.coordinate = destination.coordinates!
            annotation.title = destination.name!
            self.map.addAnnotation(annotation)
            
            let aSpan = MKCoordinateSpan(latitudeDelta: 0.02,longitudeDelta: 0.02)
            let Center =  destination.coordinates!
            let region = MKCoordinateRegionMake(Center, aSpan)
            self.map.setRegion(region, animated: true)
        }
    }
    
    lazy var venueDetail:VenueDetailView = {
        let cdv = VenueDetailView(frame: CGRect.zero)
        return cdv
    }()
    
    lazy var map:MKMapView = {
        let m = MKMapView()
        return m
    }()

    lazy var btnPlaces:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.clear
        btn.layer.borderWidth = 1.0
        btn.layer.borderColor = btn.tintColor?.cgColor
        btn.layer.cornerRadius = 10
        btn.setTitleColor(btn.tintColor, for: UIControlState())
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        btn.setTitle("Add Place", for: UIControlState())
        btn.addTarget(self, action: #selector(placesTap), for: .touchDown)
        
        return btn
    }()

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
    
    lazy var btnStack:UIStackView = {
        let s = UIStackView(frame:CGRect.zero)
        s.alignment = .fill
        s.distribution = .fillEqually
        s.axis = .horizontal
        s.addArrangedSubview(UIView())
        s.addArrangedSubview(btnPlaces)
        s.addArrangedSubview(UIView())
        return s
    }()

    
    lazy var stack:UIStackView = {
        let s = UIStackView(frame:CGRect.zero)
        s.alignment = .fill
        s.distribution = .fill
        s.axis = .vertical
        s.addArrangedSubview(venueDetail)
        s.addArrangedSubview(map)
        s.addArrangedSubview(btnStack)
        s.addArrangedSubview(UIView())
        s.translatesAutoresizingMaskIntoConstraints = false
        
        s.spacing = 15
        return s
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .Gainsboro
        view.addSubview(mainView)
    }

    override func updateViewConstraints() {
        super.updateViewConstraints()
        let layout = self.view.layoutMarginsGuide
        mainView.heightAnchor.constraint(equalTo: layout.heightAnchor, multiplier: 0.8).isActive = true
        mainView.topAnchor.constraint(equalTo: layout.topAnchor, constant: 5.0).isActive = true
        mainView.widthAnchor.constraint(equalTo: layout.widthAnchor).isActive = true
        mainView.centerXAnchor.constraint(equalTo: layout.centerXAnchor).isActive = true

        stack.centerXAnchor.constraint(equalTo: mainView.centerXAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: mainView.centerYAnchor).isActive = true
        stack.heightAnchor.constraint(equalTo: mainView.heightAnchor).isActive = true
        stack.widthAnchor.constraint(equalTo: mainView.widthAnchor).isActive = true
        
    }
    
    @objc func placesTap(){

    }
}

class VenueDetailView: UIView {
    
    var width:CGFloat { return 200 }
    var titleFontSize:CGFloat { return  round(width * 0.09) }
    var fontSize:CGFloat  { return round(width * 0.045) }
    var textColor:UIColor { return UIColor.black }
    
    
    var venue:MKMapItem?{
        didSet{
            guard let venue = venue else { return }
            let name = venue.name ?? ""
            let state = venue.placemark.description
            self.name.text = "\(name)"
            self.country.text = " \(state)"
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
    
    lazy var stack:UIStackView = { [unowned self] in
        let s = UIStackView()
        s.axis = .vertical
        s.distribution = .fillEqually
        s.alignment = .fill
        s.addArrangedSubview(name)
        s.addArrangedSubview(country)
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
    }
    
    
}

