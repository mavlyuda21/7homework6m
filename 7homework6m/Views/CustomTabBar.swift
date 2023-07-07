//
//  CustomTabBar.swift
//  7homework6m
//
//  Created by mavluda on 7/7/23.
//

import Foundation
import UIKit

class CustomTabBar: UITabBar {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0,
                                         height: 2.0)
        self.layer.shadowRadius = 4.0
        self.layer.shadowOpacity = 0.4
        self.layer.masksToBounds = false

    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
    }
}
