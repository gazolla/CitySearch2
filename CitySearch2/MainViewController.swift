//
//  MainViewController.swift
//  CitySearch2
//
//  Created by Gazolla on 01/04/2018.
//  Copyright © 2018 Gazolla. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    var destination:Destination? {
        didSet{
            guard let destination = destination else { return }
            self.destinationDetail.destination = destination
        }
    }

    lazy var destinationController:CitySearchController = {
        let d = CitySearchController()
        d.selectedCity = { [weak self] (_ destination:Destination) in
            self?.destination = destination
        }
        return d
    }()
    
    lazy var destinationDetail:CityDetailView = {
        let cdv = CityDetailView(frame: CGRect.zero)
        return cdv
    }()
    
    lazy var venueSearch:VenueSearchController = {
        let vs = VenueSearchController()
        return vs
    }()


    lazy var btnDestination:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.clear
        btn.layer.borderWidth = 1.0
        btn.layer.borderColor = btn.tintColor?.cgColor
        btn.layer.cornerRadius = 10
        btn.setTitleColor(btn.tintColor, for: UIControlState())
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        btn.setTitle("Add Destination", for: UIControlState())
        btn.addTarget(self, action: #selector(destinationTap), for: .touchDown)
        return btn
    }()
    
    lazy var btnPlaces:UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.clear
        btn.layer.borderWidth = 1.0
        btn.layer.borderColor = btn.tintColor?.cgColor
        btn.layer.cornerRadius = 10
        btn.setTitleColor(btn.tintColor, for: UIControlState())
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        btn.setTitle("Add Places", for: UIControlState())
        btn.addTarget(self, action: #selector(placesTap), for: .touchDown)
        return btn
    }()
    
    lazy var stack:UIStackView = {
        let s = UIStackView(frame:CGRect.zero)
        s.alignment = .fill
        s.distribution = .fill
        s.axis = .vertical
        s.addArrangedSubview(destinationDetail)
        s.addArrangedSubview(btnDestination)
        s.addArrangedSubview(btnPlaces)
        s.spacing = 5
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(stack)
    }
    
    override func updateViewConstraints() {
        super.updateViewConstraints()
        let layout = self.view.layoutMarginsGuide
        
        stack.centerXAnchor.constraint(equalTo: layout.centerXAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: layout.centerYAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: layout.rightAnchor).isActive = true
        stack.leftAnchor.constraint(equalTo: layout.leftAnchor).isActive = true
    }
    
    @objc func destinationTap(){
        navigationController?.pushViewController(destinationController, animated: true)
    }
    
    @objc func placesTap(){
        venueSearch.destination = destination
        navigationController?.pushViewController(venueSearch, animated: true)
    }
}
