//
//  WebTableViewController.swift
//  swift-tools
//
//  Created by 叶长生 on 2019/4/17.
//  Copyright © 2019 Hoa. All rights reserved.
//

import UIKit

class WebTableViewController: HoWebTableViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView.load(URLRequest.init(url: URL.init(string: "https://zero-times.github.io")!))
        
        tableView.delegate = self
        tableView.dataSource = self
    }
}
extension WebTableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "CELL")
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "CELL")
        }
        cell?.textLabel?.text = "ROW \(indexPath.row)"
        return cell!
    }
}
