//
//  HoMasterViewController.swift
//  swift-tools
//
//  Created by 叶长生 on 2018/12/19.
//  Copyright © 2018 Hoa. All rights reserved.
//

import StarWars
import UIKit

class HoMasterViewController: UIViewController {
    @IBOutlet var tableView: UITableView!

    fileprivate var datas: [(String, UIViewController.Type)] {
        return [("NumberMorphView", NumberMorphViewController.self),
                ("StarWars", UIViewController.self),
                ("Macaw", MacawViewController.self),
                ("EasyAnimation", EasyAnimationViewController.self),
                ("ViewAnimator", ViewAnimatorTableViewController.self),
                ("IBAnimatable", IBAnimatableViewController.self),
//                ("Expanding_collection", Expanding_collectionViewController.self),
                ("RxSwift", MusicViewController.self),
                ("ViewController", ViewController.self),
                ("WebTableViewController", WebTableViewController.self),
                ("TopWebViewController", TopWebViewController.self)]
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }

    @IBAction func click(_ sender: UIBarButtonItem) {
        splitVC()?.openLeftMenu()
    }

    @IBAction func right(_ sender: Any) {
        splitVC()?.openRightMenu()
    }

    fileprivate func setupUI() {
        tableView.rowHeight = tableView.estimatedRowHeight
        tableView.rowHeight = UITableView.automaticDimension
    }

    fileprivate struct Identifier {
        static let starWarsSegue = "StarWars"
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifier.starWarsSegue {
            let destination = segue.destination
            destination.transitioningDelegate = self
        }
    }
}

extension HoMasterViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datas.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        if let cell = cell as? HoTableViewCell {
            cell.displayTitle.text = datas[indexPath.row].0
        }
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if indexPath.row == 1 {
            performSegue(withIdentifier: Identifier.starWarsSegue, sender: nil)
            return
        }

        let vc = UIStoryboard.main!.instantiateVC(datas[indexPath.row].1)
        vc.title = datas[indexPath.row].0

        navigationController?.pushViewController(vc, animated: true)
    }
}

extension HoMasterViewController: UIViewControllerTransitioningDelegate {
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        let animator = StarWarsGLAnimator()
        animator.duration = 1.5
        animator.spriteWidth = 20
        return animator
    }
}
