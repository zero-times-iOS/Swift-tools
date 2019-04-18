//
//  HoWebTableViewController.swift
//  swift-tools
//
//  Created by 叶长生 on 2019/4/17.
//  Copyright © 2019 Hoa. All rights reserved.
//

import UIKit
import WebKit

class HoWebTableViewController: UIViewController {

    /// webview tableview父视图
    @IBOutlet weak var containerScrollView: UIScrollView!
    fileprivate var containerView: UIScrollView!
    var webView: WKWebView!
    var tableView: UITableView!
    var contentView: UIView!
    
    fileprivate var lastWebViewContentHeight: CGFloat = 0
    fileprivate var lastTableViewContentHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        addObservers()
        // Do any additional setup after loading the view.
    }
    
    deinit {
        removeObservers()
    }
    
    fileprivate func initView() {
        
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
        
        tableView = UITableView(frame: self.view.bounds, style: UITableView.Style.plain)
        tableView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        tableView.tableFooterView = UIView()
        tableView.isScrollEnabled = false
        
        contentView = UIView()
        contentView.addSubview(webView)
        contentView.addSubview(tableView)
        
        containerView?.addSubview(contentView)
        containerScrollView?.addSubview(contentView)
        
        contentView.frame = CGRect(x: 0, y: 0, width: self.view.bounds.w, height: self.view.bounds.h * 2)
        webView.frame.origin.y = 0
        webView.frame.size.height = view.frame.size.height
        tableView.frame.origin.y = webView.frame.maxY
    }

    fileprivate func addObservers() {
        
        webView.addObserver(self, forKeyPath: "scrollView.contentSize", options: NSKeyValueObservingOptions.new, context: nil)
        tableView.addObserver(self, forKeyPath: "contentSize", options: NSKeyValueObservingOptions.new, context: nil)
    }
    
    fileprivate func removeObservers() {
        
        webView.removeObserver(self, forKeyPath: "scrollView.contentSize")
        tableView.removeObserver(self, forKeyPath: "contentSize")
    }
   
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        
        if (object as? WKWebView) == webView {
            if keyPath == "scrollView.contentSize" {
                updateContainerScrollViewContentSize(flag: 0, webViewContentHeight: 0)
            }
        }
        else if (object as? UITableView) == tableView {
            if keyPath == "contentSize" {
                updateContainerScrollViewContentSize(flag: 0, webViewContentHeight: 0)
            }
        }
    }
    
    func updateContainerScrollViewContentSize(flag: Int, webViewContentHeight: CGFloat) {
        
        if containerView == nil {
            containerView = containerScrollView
        }
        
        let webViewCHeight = flag == 1 ? webViewContentHeight : self.webView.scrollView.contentSize.height
        let tableViewContentHeight = self.tableView.contentSize.height
        
        if webViewCHeight == lastWebViewContentHeight && tableViewContentHeight == lastTableViewContentHeight {
            return
        }
        
        lastWebViewContentHeight = webViewCHeight;
        lastTableViewContentHeight = tableViewContentHeight;
        
        containerView.contentSize = CGSize(width: self.view.frame.w, height: webViewCHeight + tableViewContentHeight)
        
        let webViewHeight = (webViewCHeight < self.view.frame.h) ? webViewCHeight : self.view.frame.h
        let tableViewHeight = tableViewContentHeight < self.view.frame.h ? tableViewContentHeight :self.view.frame.h;
        
        self.webView.frame.h = webViewHeight <= 0.1 ? 0.1 : webViewHeight;
        self.contentView.frame.h = webViewHeight + tableViewHeight;
        self.tableView.frame.h = tableViewHeight;
        self.tableView.frame.origin.y = self.webView.frame.maxY;
    }
    
}
// MARK: - UIScrollViewDelegate
extension HoWebTableViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if containerView == nil {
            containerView = containerScrollView
        }
        if containerView != scrollView { return }
        
        
        let offsetY = scrollView.contentOffset.y
        
        let webViewHeight = webView.frame.h
        let tableViewHeight = tableView.frame.h
        
        let webViewContentHeight = webView.scrollView.contentSize.height
        let tableViewContentHeight = tableView.contentSize.height
        
        if offsetY < 0 {
            contentView.frame.origin.y = 0
            webView.scrollView.contentOffset = CGPoint.zero
            tableView.contentOffset = CGPoint.zero
        }else if (offsetY < webViewContentHeight - webViewHeight){
            self.contentView.frame.origin.y = offsetY;
            self.webView.scrollView.contentOffset = CGPoint(x: 0, y: offsetY);
            self.tableView.contentOffset = CGPoint.zero;
        }else if(offsetY < webViewContentHeight){
            self.contentView.frame.origin.y = webViewContentHeight - webViewHeight;
            self.webView.scrollView.contentOffset = CGPoint(x: 0, y: webViewContentHeight - webViewHeight);
            self.tableView.contentOffset = CGPoint.zero;
        }else if(offsetY < webViewContentHeight + tableViewContentHeight - tableViewHeight){
            self.contentView.frame.origin.y = offsetY - webViewHeight;
            self.tableView.contentOffset = CGPoint(x: 0, y: offsetY - webViewContentHeight);
            self.webView.scrollView.contentOffset = CGPoint(x: 0, y: webViewContentHeight - webViewHeight);
        }else if(offsetY <= webViewContentHeight + tableViewContentHeight ){
            self.contentView.frame.origin.y = self.containerView.contentSize.height - self.contentView.frame.height;
            self.webView.scrollView.contentOffset = CGPoint(x: 0, y: webViewContentHeight - webViewHeight);
            self.tableView.contentOffset = CGPoint(x: 0, y: tableViewContentHeight - tableViewHeight);
        }else {
            //do nothing
            print("do nothing");
        }
        
    }
}
