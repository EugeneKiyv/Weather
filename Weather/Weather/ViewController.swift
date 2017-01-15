//
//  ViewController.swift
//  Weather
//
//  Created by Eugene Kuropatenko on 1/15/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit
import AlamofireImage

class ViewController: UIViewController {
    @IBOutlet weak var mainScroll: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    var weatherLayer:WeatherLayer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.updateInfo), name: Names.networkReachableNotification, object: nil)
        if !API.reachabilityManager.isReachable {
            print("connection is absent")
        }
        weatherLayer = WeatherLayer(delegate: self, api: API())
        let count = weatherLayer!.citiesCount()
        pageControl.numberOfPages = count
        pageControl.currentPage = 0
        mainScroll.contentSize = CGSize(width: view.bounds.size.width * CGFloat(count), height: view.bounds.size.height)
        mainScroll.delegate = self
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    func updateInfo()  {
        weatherLayer?.getInfo()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func changePage(_ sender: UIPageControl) {
        mainScroll.contentOffset.x = CGFloat(sender.currentPage) * view.bounds.width
    }
}

extension ViewController:WeatherLayerDelegate {
    func forecast(index:Int, weather:WeatherModel) {
        let frame = CGRect(x:view.bounds.size.width * CGFloat(index) + (view.bounds.size.width - WeatherInfo.optimalSize)/2.0 , y: (view.bounds.size.height - WeatherInfo.optimalSize)/2.0, width: WeatherInfo.optimalSize, height: WeatherInfo.optimalSize)
        let weatherInfo = WeatherInfo.view(frame: frame)
        weatherInfo.tag = index
        weatherInfo.cityLabel.text = "Location: \(weather.country) - \(weather.city)"
        weatherInfo.tempLabel.text = "Temp: \(weather.temp)"
        weatherInfo.descLabel.text = weather.forecast
        weatherInfo.iconView.af_setImage(withURL: URL(string: weather.iconPath)!)
        mainScroll.addSubview(weatherInfo)
    }
}

extension ViewController:UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.x == 0 {
            pageControl.currentPage = 0
        } else {
            pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.bounds.width)
        }
    }
}
