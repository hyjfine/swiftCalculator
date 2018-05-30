//
//  TableViewNavigator.swift
//  Calculator
//
//  Created by heyongjian on 2018/5/30.
//  Copyright © 2018年 heyongjian. All rights reserved.
//

import Foundation
import UIKit

protocol NewsLatestNavigatorProtocol {
    func goTest()
}

class NewsLatestNavigator: NewsLatestNavigatorProtocol {
    private let navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func goTest() {
        let navigator = CalculatorNavigator(navigationController: navigationController)
        let vc = CalculatorViewController()
        vc.viewModel = CalculatorViewModel(screen: Screen(), navigator: navigator)
        navigationController?.pushViewController(vc, animated: true)
    }

}
