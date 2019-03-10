//
//  Dao.swift
//  BibliOS
//
//  Created by Salih Topcu on 8.03.2019.
//  Copyright © 2019 Akead Bilişim. All rights reserved.
//

import Foundation

public protocol DaoDelegate: NSObjectProtocol {
    func dao(didSuccess dao: Dao, data: Any?)
}

public extension DaoDelegate {
    public func dao(didFail dao: Dao, error: DaoError?) { }
}

public class Dao: NSObject {
    var url: String
    var headers: [String: String] = [:]
    var urlData: [String: String] = [:]
    var bodyData: KVP = KVP()
    var delegate: DaoDelegate?
    
    var _finalUrl: String?
    var finalUrl: String {
        if self._finalUrl == nil {
            self._finalUrl = self.url
            for (key, value) in self.urlData {
                self._finalUrl! += String(format: "&%@=%@", key, String(value))
            }
            if self._finalUrl!.range(of: "&") != nil && self._finalUrl!.range(of: "?") == nil {
                self._finalUrl = self._finalUrl!.replacingOccurrences(of: "&", with: "?", options: .literal, range: self._finalUrl!.range(of: "&"))
            }
        }
        return self._finalUrl!
    }
    
    
    
    // override and run the http request here
    public func execute() { }
    
    init(url: String, delegate: DaoDelegate?) {
        self.url = url
        self.delegate = delegate
    }
    
    public func addUrlData(key: String, value: Any) {
        if value is String {
            self.urlData.updateValue(value as! String, forKey: key)
        } else if value is Int {
            self.urlData.updateValue(String(value as! Int), forKey: key)
        } else if value is Double {
            self.urlData.updateValue(String(value as! Double), forKey: key)
        }
        self._finalUrl = nil
    }
    
    public func addHeader(key: String, value: Any) {
        if value is String {
            self.headers.updateValue(value as! String, forKey: key)
        } else if value is Int {
            self.headers.updateValue(String(value as! Int), forKey: key)
        } else if value is Double {
            self.headers.updateValue(String(value as! Double), forKey: key)
        }
    }
    
    public func addBodyData(key: String, value: Any) {
        self.bodyData.updateValue(value, forKey: key)
    }
    
    public func setBodyData(_ data: KVP) {
        self.bodyData = data
    }
    
}
