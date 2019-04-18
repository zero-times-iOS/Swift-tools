//
//  HoFlowerHelper.swift
//  swift-tools
//
//  Created by 叶长生 on 2019/4/18.
//  Copyright © 2019 Hoa. All rights reserved.
//

import UIKit

struct HoFlowerHelper {
    
    fileprivate struct Contant {
        static let host = "https://zhiwu.market.alicloudapi.com"
        static let appcode = "c723df6664d7417d99c13acb3a535b47"
    }
    
    static func commit(img: UIImage,_ maxCount: Int = 5,_ completionHandler: @escaping (_ result: [String: Any]?, _ error: Error? ) -> Void) {
        
        let path = "/do";
        let method = "POST";
        let querys = "";
        let url = Contant.host + path + querys
        
        guard let baseUrl = img.pngData()?.base64EncodedString(options: Data.Base64EncodingOptions.endLineWithLineFeed).addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else {
            debugPrint("img error!")
            return
        }
        
        let bodys = "baike=\(maxCount)&image=\(baseUrl)"
        
        let request = NSMutableURLRequest(url: URL.init(string: url)!, cachePolicy: NSURLRequest.CachePolicy.init(rawValue: 1)!, timeoutInterval: 10)
        request.httpMethod = method
        request.addValue("APPCODE \(Contant.appcode)", forHTTPHeaderField: "Authorization")
        request.addValue("application/x-www-form-urlencoded; charset=UTF-8", forHTTPHeaderField: "Content-Type")
        let data = bodys.data(using: String.Encoding.utf8)
        request.httpBody = data
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        let task = session.dataTask(with: request as URLRequest) { (result, respon, error) in
            if let result = result {
                
                do {
                    if let dic = try JSONSerialization.jsonObject(with: result, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: Any] {
                        completionHandler(dic,nil)
                    }
                } catch {
                    print(error)
                }
            }
            else {
                completionHandler(nil,error)
            }
        }
        task.resume()
        
    }
    
}
