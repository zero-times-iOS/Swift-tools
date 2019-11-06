//
//  ViewController.swift
//  HoScrollWeb
//
//  Created by HOA on 2019/11/5.
//  Copyright © 2019 HOA. All rights reserved.
//  基于StoryBoard开发

import UIKit
import WebKit

class HoScrollWebViewController: UIViewController {
    
    @IBOutlet weak var containerScrollView: UIScrollView!
    private var containerView: UIScrollView!
    private var webView: WKWebView!
    private var contentView: UIView!
    @IBOutlet weak var bottomBar: UIView!
    
    private var lastWebViewContentHeight: CGFloat = 0
    
    /// TopView容器
    public var topView: UIView!
    /// TopView 高度 在super.viewDidLoad前设置
    public var topViewHeight: CGFloat = 400
   
    public var url: String? {
        didSet {
            
            if let urls = URL.init(string: url ?? "https://baidu.com") {
                webView.load(URLRequest.init(url: urls))
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        addObservers()
    }
    
    private func initView() {

        if containerScrollView == nil {
            containerView = UIScrollView(frame: self.view.bounds)
            containerView.backgroundColor = .white
            self.view.addSubview(containerView)
        }
        containerScrollView?.delegate = self
        containerView?.delegate = self
        
        let configuration = WKWebViewConfiguration()
        webView = WKWebView(frame: self.view.bounds, configuration: configuration)
        webView.scrollView.isScrollEnabled = false
        
        topView = UIView(frame: CGRect(x: 0, y: 0, width: self.view.frame.width, height: topViewHeight))
        topView.backgroundColor = .red
        
        contentView = UIView()
        contentView.addSubview(webView)
        contentView.addSubview(topView)
        
        containerView?.addSubview(contentView)
        containerScrollView?.addSubview(contentView)
        
        containerView?.frame = CGRect(x: 0, y: 0, width: self.view.bounds.w, height: self.view.bounds.h * 2)
        webView.frame.origin.y = topViewHeight
        webView.frame.size.height = view.frame.size.height
        
    }
    
    private func addObservers() {
        
        webView.addObserver(self, forKeyPath: "scrollView.contentSize", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    private func removeObservers() {
        
        webView.removeObserver(self, forKeyPath: "scrollView.contentSize")
    }
    
    deinit {
        removeObservers()
    }
}

extension HoScrollWebViewController {
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (object as? WKWebView) == webView {
            if keyPath == "scrollView.contentSize" {
                updateContainerScrollViewContentSize()
            }
        }
        
    }
    
    func updateContainerScrollViewContentSize() {
        
        let webViewCHeight = self.webView.scrollView.contentSize.height
        
        if webViewCHeight == lastWebViewContentHeight {
            return
        }
        
        lastWebViewContentHeight = webViewCHeight;
        
        containerView?.contentSize = CGSize(width: self.view.frame.w, height: webViewCHeight)
        containerScrollView?.contentSize = CGSize(width: self.view.frame.w, height: webViewCHeight)
        
        let webViewHeight = (webViewCHeight < self.view.frame.h) ? webViewCHeight : self.view.frame.h
        
        self.webView.frame.origin.y = topView.frame.size.height;
        self.webView.frame.h = webViewHeight <= 0.1 ? 0.1 : webViewHeight;
        self.contentView.frame.h = webViewHeight;
    }
    
}
extension HoScrollWebViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if containerView == nil {
            containerView = containerScrollView
        }
        if containerView != scrollView { return }
        let webViewTop = self.webView.frame.origin.y;
        
        let offsetY = scrollView.contentOffset.y - webViewTop
        
        let webViewHeight = webView.frame.h
        
        let webViewContentHeight = webView.scrollView.contentSize.height
        
        if offsetY <= 0 {
            contentView.frame.origin.y = 0
            webView.scrollView.contentOffset = CGPoint.zero
        }else if (offsetY < webViewContentHeight - webViewHeight){
            self.contentView.frame.origin.y = offsetY;
            self.webView.scrollView.contentOffset = CGPoint(x: 0, y: offsetY+webViewTop);
        }else {
            //do nothing
            print("do nothing");
        }
    }
}
