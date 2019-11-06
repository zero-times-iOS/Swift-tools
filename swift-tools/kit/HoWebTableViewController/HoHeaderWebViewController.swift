//
//  HoHeaderWebViewController.swift
//  HoScrollWeb
//
//  Created by HOA on 2019/11/6.
//  Copyright © 2019 HOA. All rights reserved.
//

import UIKit
import WebKit

class HoHeaderWebViewController: UIViewController {
    
    @IBOutlet weak var toolBar: UIView!
    @IBOutlet private weak var webView: WKWebView!
    
    public var topView: UIView!
    public var topViewHeight: CGFloat = 400
    
    open var url: String? {
        didSet {
            
            if let urls = URL.init(string: url ?? "https://baidu.com") {
                webView.load(URLRequest.init(url: urls))
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initView()
    }
    
    private func initView() {
        
        topView = UIView(frame: CGRect(x: 0, y: -topViewHeight, width: self.view.frame.width, height: topViewHeight))
        topView.backgroundColor = .red
        
        webView.scrollView.contentInset = UIEdgeInsets(top: topViewHeight, left: 0, bottom: 0, right: 0)
        webView.scrollView.addSubview(topView)
        
        webView.alpha = 0
        webView.navigationDelegate = self
    }
    
    
}
extension HoHeaderWebViewController: WKNavigationDelegate {
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        UIView.animate(withDuration: 0.3) {
            self.webView.alpha = 1
        }
    }
    
}
