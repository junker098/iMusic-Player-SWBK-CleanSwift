//
//  FooterView.swift
//  iMusic Player
//
//  Created by Юрий Могорита on 06.10.2020.
//  Copyright © 2020 Yuri Mogorita. All rights reserved.
//

import UIKit

class FooterView: UIView {
    
    private let myLabel: UILabel = {
       let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
         label.textColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        return label
    }()
    
    private let activityIndicator: UIActivityIndicatorView = {
       let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    func setupElements() {
        addSubview(myLabel)
        addSubview(activityIndicator)
        
        activityIndicator.topAnchor.constraint(equalTo: topAnchor, constant: 8).isActive = true
        activityIndicator.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20).isActive = true
        activityIndicator.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20).isActive = true
        
        myLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        myLabel.topAnchor.constraint(equalTo: activityIndicator.bottomAnchor, constant: 8).isActive = true
    }
    
    func showLoader() {
        activityIndicator.startAnimating()
        myLabel.text = "Loading..."
    }
    
    func stopLoader() {
        activityIndicator.stopAnimating()
        myLabel.text = ""
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
