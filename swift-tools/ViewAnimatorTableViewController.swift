//
//  ViewAnimatorTableViewController.swift
//  swift-tools
//
//  Created by 叶长生 on 2018/12/25.
//  Copyright © 2018 Hoa. All rights reserved.
//

import UIKit
import ViewAnimator

class ViewAnimatorTableViewController: UITableViewController {

    var count = 0
    var isTap = true
    private let animations = [AnimationType.from(direction: .bottom, offset: 30.0)]

    override func viewDidLoad() {
        super.viewDidLoad()
        //        let fromAnimation = AnimationType.from(direction: .right, offset: 30.0)
        //        let zoomAnimation = AnimationType.zoom(scale: 0.2)
        //        let rotateAnimation = AnimationType.rotate(angle: CGFloat.pi/6)

        self.navigationController?.isToolbarHidden = false
        tableView.rowHeight = tableView.estimatedRowHeight
        tableView.rowHeight = UITableView.automaticDimension
    }
    @IBAction func click(_ sender: Any) {
        
        if isTap == false {
            stop()
        }
        else if isTap == true {
            start()
        }
        
        isTap = !isTap
    }
   
    fileprivate func start() {
        count = 200
        tableView.reloadData()
        UIView.animate(views: tableView.visibleCells, animations: animations, completion: nil)
    }
    
    fileprivate func stop() {
        count = 0
        UIView.animate(views: tableView.visibleCells, animations: animations, reversed: true,
                       initialAlpha: 1.0, finalAlpha: 0.0) {
                        self.tableView.reloadData()
        }
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 1
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ViewCell", for: indexPath)
        
        // Configure the cell...
        return cell
    }
 
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
