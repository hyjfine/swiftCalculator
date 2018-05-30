//
// Created by heyongjian on 2018/4/24.
// Copyright (c) 2018 heyongjian. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa
import RxDataSources
import Differentiator

class NewsLatestController: UIViewController {

    var viewModel: NewsLatestViewModel!
    private let disposeBag: DisposeBag = DisposeBag()
    private var data: NewsLatest?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.gray

        setUpView()
        setUpBinding()
    }

    private func setUpView() {
        self.view.addSubview(button)
        self.view.addSubview(tableView)

        button.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(-30)
            maker.height.equalTo(30)
        }

        tableView.snp.makeConstraints { (make) in
            make.left.right.top.equalTo(0)
            make.bottom.equalTo(self.button.snp.top)
        }

    }

    private func setUpBinding() {
        let input = NewsLatestViewModel.Input(buttonTitle: button.rx.tap.asDriver())
        let output = viewModel.transform(input: input)

        output.newsList.drive(self.tableView.rx.items(dataSource: self.dataSource())).disposed(by: disposeBag)

    }

    private lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
//        tableView.dataSource = self
        tableView.delegate = self
        tableView.backgroundColor = UIColor.white
//        tableView.separatorStyle = .none
        tableView.showsHorizontalScrollIndicator = false
        tableView.showsVerticalScrollIndicator = false
        tableView.register(NewsLatestCell.self)

        return tableView
    }()

    private lazy var button: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("click", for: .normal)
        button.addTarget(self, action: #selector(btnClick), for: .touchUpInside)
        return button
    }()

    @objc func btnClick() {
        print("-----hello")
        getNewsLatest()
    }

    private func getNewsLatest() {
        APIProvider.rx.request(.getNewsLatest)
                .mapToObject(type: NewsLatest.self)
                .subscribe { (event) in
                    switch event {
                    case .success(let result):
                        self.data = result
                        print("---success", result.toJSON())
                        self.tableView.reloadData()
                    case .error(let error):
                        print("----error ", error)
                    }
                }.disposed(by: disposeBag)

    }

    private func getNewsDetails(id: Int) {
        APIProvider.rx.request(.getNewsDetails(id))
                .mapToObject(type: NewsDetailInfo.self)
                .subscribe { (event) in
                    switch event {
                    case .success(let result):
                        print("-----success ", result)
                    case .error(let error):
                        print("----error ", error)
                    }
                }.disposed(by: disposeBag)

    }

}

extension NewsLatestController {
    private func dataSource() -> RxTableViewSectionedAnimatedDataSource<NewsLatestSection> {
        return RxTableViewSectionedAnimatedDataSource<NewsLatestSection>(
                configureCell: { (data, table, indexPath, item) in
                    let cell: NewsLatestCell = table.dequeueReusableCell(NewsLatestCell.self)
                    cell.data = item
                    return cell
                })
    }
}

extension NewsLatestController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


//extension TableViewController: UITableViewDataSource {
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return data?.stories.count ?? 0
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 44
//    }

//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let newsInfo = data?.stories[indexPath.row]
//        let cell: NewsLatestCell = tableView.dequeueReusableCell(NewsLatestCell.self)
//        cell.data = newsInfo?.title
//        return UITableViewCell()
//    }
//}

public extension UITableView {
    /**
     Reusable Cell
     - parameter aClass:    class
     - returns: cell
     */
    func dequeueReusableCell<T: UITableViewCell>(_ aClass: T.Type) -> T! {
        let name = String(describing: aClass)
        guard let cell = dequeueReusableCell(withIdentifier: name) as? T else {
            fatalError("\(name) is not registered")
        }
        return cell
    }

    /**
     Register cell class
     - parameter aClass: class
     */

    func register<T: UITableViewCell>(_ aClass: T.Type) -> Void {
        let name = String(describing: aClass)
        self.register(aClass, forCellReuseIdentifier: name)
    }
}
