//
//  CountryPickerView.swift
//  CountryPickerView
//
//  Created by Nikhil Bhownani on 23/03/19.
//  Copyright © 2019 Nikhil Bhownani. All rights reserved.
//

import UIKit

class CountryPickerView: UIView {
    
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    var cellHeight:CGFloat = 50 {
        didSet {
            tableView.reloadData()
        }
    }
    var isModal:Bool = true {
        didSet {
            if (isModal) {
                positionViewCentrally()
                leadingConstraint.constant = 20
                trailingConstraint.constant = 20
            } else {
                leadingConstraint.constant = 0
                trailingConstraint.constant = 0
            }
        }
    }
    
    var array:[Country] = []
    var nibName:String!
    var allCountryCodes:[String] = []
    var filteredArray:[Country]!
    var onDidSelect:((_ country:Country)->())?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    init() {
        super.init(frame: .zero)
        commonInit()
    }
    
    func commonInit() {
        setupFromXib()
        setupCountryArray()
        setupTableView()
        backgroundColor = UIColor.black.withAlphaComponent(0.2)
    }
    
    func positionViewCentrally() {
        layoutIfNeeded()
        let contentHeight:CGFloat = cellHeight * CGFloat(filteredArray.count)
        let viewHeight:CGFloat = self.bounds.size.height
        
        var margin:CGFloat = 0.0
        if (contentHeight - 50 > viewHeight) {
            margin = 50
        } else {
            margin = (viewHeight - contentHeight) / 2
        }
        
        
        topConstraint.constant = margin
        bottomConstraint.constant = margin
    }
    
    func setupCountryArray() {
        guard let jsonPath = Bundle.main.path(forResource: "Data/countryCodes", ofType: "json"), let jsonData = try? Data(contentsOf: URL(fileURLWithPath: jsonPath)) else {
            return
        }
        
        do {
            if let jsonObjects = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? NSArray {
                
                for jsonObject in jsonObjects {
                    
                    guard let countryObj = jsonObject as? NSDictionary else {
                        return
                    }
                    
                    guard let code = countryObj["code"] as? String, let phoneCode = countryObj["dial_code"] as? String, let name = countryObj["name"] as? String else {
                        return
                    }
                    
                    let flagName = "Images/\(code.uppercased())"
                    self.allCountryCodes.append(code)
                    let country = Country(code: code, name: name, phoneCode: phoneCode, flagName: flagName)
                    array.append(country)
                }
                filteredArray = array
                
            }
        } catch {
            return
        }
    }
    
    func setupFromXib() {
        let view = Bundle.main.loadNibNamed("CountryPickerView", owner: self, options: nil)?.first as! UIView
        self.addSubview(view)
        self.translatesAutoresizingMaskIntoConstraints = false
        view.translatesAutoresizingMaskIntoConstraints = false
        view.leftAnchor.constraint(equalTo: self.leftAnchor).isActive = true
        view.rightAnchor.constraint(equalTo: self.rightAnchor).isActive = true
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
    }
    
    func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    func setupView(nibName:String = "CountryPickerTableViewCell") {
        self.nibName = nibName
        tableView.register(UINib(nibName: self.nibName!, bundle: nil), forCellReuseIdentifier: "cellId")
    }
    
    func showAllCountries() {
        filteredArray = []
        for code in allCountryCodes {
            for country in array {
                if code == country.code {
                    filteredArray.append(country)
                }
            }
        }
        tableView.reloadData()
    }
    
    
    func showCountries(codes:[String]) {
        filteredArray = []
        for code in codes {
            for country in array {
                if code == country.code {
                    filteredArray.append(country)
                }
            }
        }
        
        tableView.reloadData()
    }
    
    
}

extension CountryPickerView:UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellId", for: indexPath) as! UITableViewCell
        (cell as! CountryPickerCellProtocol).setup(country: filteredArray![indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        onDidSelect?(filteredArray[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeight
    }
}


struct Country {
    var code:String
    var name:String
    var phoneCode:String
    var flagName:String
}


protocol CountryPickerCellProtocol {
    func setup(country:Country)
}
