//
// Created by heyongjian on 2018/4/24.
// Copyright (c) 2018 heyongjian. All rights reserved.
//

import Foundation
import UIKit

protocol CalculatorNavigatorProtocol {
    func toZhihu()
}

class CalculatorNavigator: CalculatorNavigatorProtocol {
    private let navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }

    func toZhihu() {
        let navigator = TableViewNavigator(navigationController: navigationController)
        let vc = TableViewController()
        vc.viewModel = TableViewModel(navigator: navigator)
        navigationController?.pushViewController(vc, animated: true)
    }
}
