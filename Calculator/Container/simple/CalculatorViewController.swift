//
// Created by heyongjian on 2018/4/24.
// Copyright (c) 2018 heyongjian. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift
import RxCocoa

class CalculatorViewController: UIViewController {

    var viewModel: CalculatorViewModel!
    private let disposeBag: DisposeBag = DisposeBag()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setUpBinding()
    }

    private func setUpView() {
        self.view.addSubview(board)
        board.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
            maker.height.equalTo(board.superview!.snp.height).multipliedBy(2 / 3.0)
        }

        self.view.addSubview(screen)
        screen.snp.makeConstraints { (maker) in
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.top.equalTo(0)
            maker.bottom.equalTo(board.snp.top)
        }

        viewModel = CalculatorViewModel(screen: screen, navigator: CalculatorNavigator(navigationController: self.navigationController))

    }

    private func setUpBinding() {
//        let input = CalculatorViewModel.Input(buttonTitle: board.buttonTitleView.rx.text.orEmpty.asDriver(),
//                inputLabel: Driver.just(screen.inputLabel?.text ?? ""),
//                historyLabel: Driver.just(screen.historyLabel?.text ?? ""))
        let input = CalculatorViewModel.Input(buttonTitle: board.nameSubject.asDriver(onErrorJustReturn: "----eer"))

        let output = viewModel.transform(input: input)
        output.currentTitle.drive(screen.inputLabel!.rx.text).disposed(by: disposeBag)
        output.historyTitle.drive(screen.historyLabel!.rx.text).disposed(by: disposeBag)

    }

    private lazy var board: Board = {
        return Board()
    }()

    private lazy var screen: Screen = {
        return Screen()
    }()


}
