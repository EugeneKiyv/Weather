//
//  WeatherInfo.swift
//  Weather
//
//  Created by Eugene Kuropatenko on 1/15/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit

class WeatherInfo: UIView {
    @IBOutlet weak var iconView: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    static let optimalSize:CGFloat = 300.0
    
    static func view(frame:CGRect) -> WeatherInfo {
        let viewFromNib = Bundle.main.loadNibNamed("WeatherInfo", owner: nil, options: nil)?.first as! WeatherInfo
        viewFromNib.frame = frame
        return viewFromNib
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.cornerRadius = 10.0
    }
}

