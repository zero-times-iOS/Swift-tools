//
//  MusicViewController.swift
//  swift-tools
//
//  Created by 叶长生 on 2018/12/25.
//  Copyright © 2018 Hoa. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxAtomic
import RxDataSources

class MusicViewController: UIViewController {

    fileprivate struct Identifier {
        static let cell = "Music"
    }
    
    fileprivate let musicListViewModel = MusicListViewModel()
    
    /// 负责对象销毁
    fileprivate let disposeBag = DisposeBag()
    
    @IBOutlet weak var refreshButton: UIButton!
    @IBOutlet weak var numberTF: UITextField!
    @IBOutlet weak var areaTF: UITextField!
    @IBOutlet weak var displayPhone: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var displays: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        initTableViewRe()
        
        let variable = Variable("111")
        variable.asObservable().bind(to: label.rx.text).disposed(by: disposeBag)
    
        getPlaylist("1").subscribe { event in
            switch event {
            case .success(let json):
                print("JSON: \(json)")
            case .error(let error):
                print("发生错误: \(error)")
            }
        }.disposed(by: disposeBag)
        
        let timer = Observable<Int>.interval(0.1, scheduler: MainScheduler.instance)
        //将已过去的时间格式化成想要的字符串，并绑定到label上
//        timer.map{ String(format: "%0.2d:%0.2d.%0.1d",
//                          arguments: [($0 / 600) % 600, ($0 % 600 ) / 10, $0 % 10]) }
//            .bind(to: label.rx.text)
//            .disposed(by: disposeBag)
        
        timer.map(formatTimeInterval)
            .bind(to: label.rx.attributedText)
            .disposed(by: disposeBag)
        
        textField.rx.text.orEmpty.asObservable().subscribe({
            print("\($0)")
        }).disposed(by: disposeBag)
        
        textField.rx.text.orEmpty.changed.subscribe({
            print(":: \($0)")
        }).disposed(by: disposeBag)
        
        let input = textField.rx.text.orEmpty.asDriver().throttle(0.3)
        
        input.drive(displays.rx.text).disposed(by: disposeBag)
        
        
        Observable.combineLatest(areaTF.rx.text.orEmpty, numberTF.rx.text.orEmpty, textField.rx.text.orEmpty) {
            area, number, n -> String in
            return "你输入的号码：\(area) - \(number) + \(n)"
            }.map{ $0 }
            .bind(to: displayPhone.rx.text)
            .disposed(by: disposeBag)
        
        textField.rx.controlEvent([.editingChanged]).asObservable()
            .subscribe { [weak self] in
                print("\($0) 正改变\(self?.textField.text)")
        }.disposed(by: disposeBag)
    }
    
    //将数字转成对应的富文本
    func formatTimeInterval(ms: NSInteger) -> NSMutableAttributedString {
        let string = String(format: "%0.2d:%0.2d.%0.1d",
                            arguments: [(ms / 600) % 600, (ms % 600 ) / 10, ms % 10])
        //富文本设置
        let attributeString = NSMutableAttributedString(string: string)
        //从文本0开始6个字符字体HelveticaNeue-Bold,16号
        attributeString.addAttribute(NSAttributedString.Key.font,
                                     value: UIFont(name: "HelveticaNeue-Bold", size: 16)!,
                                     range: NSMakeRange(0, 5))
        //设置字体颜色
        attributeString.addAttribute(NSAttributedString.Key.foregroundColor,
                                     value: UIColor.white, range: NSMakeRange(0, 5))
        //设置文字背景颜色
        attributeString.addAttribute(NSAttributedString.Key.backgroundColor,
                                     value: UIColor.orange, range: NSMakeRange(0, 5))
        return attributeString
    }
   
    /// TableView 用法 刷新
    fileprivate func initTableViewRe() {
        
        // 随机数据
        let randomResult = refreshButton.rx.tap.asObservable()
        .startWith(())
        .flatMapLatest(getRandomResult)
        .share(replay: 1)
        
        //创建数据源
        let dataSource = RxTableViewSectionedReloadDataSource
            <SectionModel<String, Int>>(configureCell: {
                (dataSource, tv, indexPath, element) in
                let cell = tv.dequeueReusableCell(withIdentifier: Identifier.cell)!
                cell.textLabel?.text = "条目\(indexPath.row)：\(element)"
                return cell
            })
        
        
        randomResult.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
        
    }
    
    
    /// TableView 1用法
    fileprivate func initTableView() {
        
        // 初始化数据
        let items = Observable.just([
            MySection(header: "基本控件",footer: "base", items: [
                "UILable的用法",
                "UIText的用法",
                "UIButton的用法"
                ]),
            MySection(header: "高级控件", footer: "high", items: [
                "UITableView的用法",
                "UICollectionViews的用法"
                ])
            ])
        
        // 创建数据源
        let dataSource = RxTableViewSectionedReloadDataSource<MySection> (configureCell: { (datasource, tablev, indexpath, mySection) -> UITableViewCell in
            
            let cell = tablev.dequeueReusableCell(withIdentifier: Identifier.cell, for: indexpath)
            cell.textLabel?.text = mySection
            cell.detailTextLabel?.text = "\(indexpath.row)"
            return cell
        })
        
        // 设置分区头
        dataSource.titleForHeaderInSection = { $0.sectionModels[$1].header }
        // 设置分区尾
        dataSource.titleForFooterInSection = { $0.sectionModels[$1].footer }
        
        items.bind(to: tableView.rx.items(dataSource: dataSource)).disposed(by: disposeBag)
    }
    
    
    
    /// 获取豆瓣歌曲信息
    ///
    /// - parameter channel: 频道
    /// - returns:
    func getPlaylist(_ channel: String) -> Single<[String: Any]> {
        return Single<[String: Any]>.create(subscribe: { (single) -> Disposable in
            
            let url = "https://douban.fm/j/mine/playlist?"
                + "type=n&channel=\(channel)&from=mainsite"
            let task = URLSession.shared.dataTask(with: URL(string: url)!) {data, _, error in
                if let error = error {
                    single(.error(error))
                    return
                }
                
                guard let data = data,
                    let json = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves),
                    let result = json as? [String: Any] else {
                        single(.error(DataError.cantParseJSON))
                        return
                }
                
                single(.success(result))
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        })
    }
    
    //与数据相关的错误类型
    enum DataError: Error {
        case cantParseJSON
    }
    
    // 获取随机数据
    func getRandomResult() -> Observable<[SectionModel<String, Int>]> {
        print("正在请求数据......")
        let items = (0 ..< 5).map {_ in
            Int(arc4random())
        }
        let observable = Observable.just([SectionModel(model: "S", items: items)])
        return observable.delay(2, scheduler: MainScheduler.instance)
    }

    
}
extension Reactive where Base: UILabel {
    
    public var fontSize: Binder<CGFloat> {
        return Binder(self.base) { label, fontSize in
            label.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
    
    public var text: Binder<String> {
        return Binder(self.base) { label, text in
            label.text = text
        }
    }
    
    public var music: Binder<Music> {
        return Binder(self.base) { label, m in
            label.text = "\(m.name) - \(m.singer)"
        }
    }
}

extension UILabel {
    public var fontSize: Binder<CGFloat> {
        return Binder(self) { label, fontSize in
            print("\(fontSize)")
            label.font = UIFont.systemFont(ofSize: fontSize)
        }
    }
}
//自定义Section
struct MySection {
    var header: String
    var footer: String
    var items: [Item]
}

extension MySection : AnimatableSectionModelType {
    typealias Item = String
    
    var identity: String {
        return header
    }
    
    init(original: MySection, items: [Item]) {
        self = original
        self.items = items
    }
}
