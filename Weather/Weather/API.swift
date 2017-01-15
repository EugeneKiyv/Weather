//
//  API.swift
//  Weather
//
//  Created by Eugene Kuropatenko on 1/15/17.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation
import Alamofire

fileprivate typealias succesResponse = (_ request:DataResponse<Any>, _ response:[String:Any]) -> ()
fileprivate typealias failureResponse = (_ request:DataResponse<Any>?, _ error:NSError) -> ()
fileprivate typealias voidCloser = () -> ()

class API {
    fileprivate static let baseURLString = "http://api.openweathermap.org/data/2.5"
    fileprivate static let appId: String? = "e31174176f561d14cd51e8d877c6466d"
    fileprivate static let kForecast = "forecast"
    
    static let reachabilityManager: NetworkReachabilityManager = {
        let manager = NetworkReachabilityManager(host: "www.apple.com")
        
        manager?.listener = { status in
            print("Network Status Changed: \(status)")
            switch status {
            case .reachable( _) : NotificationCenter.default.post(name: Names.networkReachableNotification, object: nil)
            default: break
            }
        }
        
        manager?.startListening()
        return manager!
    }()
    
    @discardableResult fileprivate
    static func performRequest(_ path:String, method:HTTPMethod, parameters:[String:Any]?, sender:UIViewController! , succes: succesResponse?, failure: failureResponse?) -> URLSessionTask? {
        let fullPath = getFullPath(forMethod: path)
        return Alamofire.request(fullPath, method:method, parameters: parameters, encoding: JSONEncoding.default).validate(statusCode: 200..<300).validate(contentType: ["application/json"]).responseJSON { (response) in
            handleJSONResponse(response, sender: sender, succes: succes, failure: failure)
            }.task
    }
    
    fileprivate static func getFullPath(forMethod path:String) -> String {
        var path = "\(API.baseURLString)/\(path)"
        
        if let appid = appId {
            if path.contains("?") {
                path += "&appid=\(appid)"
            } else {
                path += "?appid=\(appid)"
            }
        }
        return path
    }
    
    fileprivate static func handleJSONResponse(_ response:DataResponse<Any>,sender:UIViewController! , succes: succesResponse?, failure: failureResponse?)  {
        switch response.result {
        case .success:
            if let responseJSON = response.result.value as? Dictionary<String,Any> {
                succes?(response,responseJSON)
            }
        case .failure(let error):
            print(error)
            failure?(response, error as NSError)
        }
    }
    
    fileprivate static func performRequest(_ path:String, method:HTTPMethod, parameters:Dictionary<String, Any>?, succes: succesResponse?, failure: failureResponse?) {
        performRequest(path, method: method, parameters: parameters, sender: nil, succes: succes, failure: failure)
    }
    
}

extension API:ApiAgreement {

    func updateWeather(city:String ,success:(( _ response:[String:Any]) -> ())?, failure:((_ error:NSError) -> ())?) {
        API.performRequest(API.kForecast+"?q=\(city)&units=metric",  method: .get, parameters: nil , succes: { (request, response) in
            success?(response)
        }) { (request, error) in
            print(error)
            failure?(error)
        }
    }
    
}
