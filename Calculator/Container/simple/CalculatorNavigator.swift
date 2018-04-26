//
// Created by heyongjian on 2018/4/24.
// Copyright (c) 2018 heyongjian. All rights reserved.
//

import Foundation
import UIKit

protocol CalculatorNavigatorProtocol {
    func toAbout()
}

class CalculatorNavigator: CalculatorNavigatorProtocol {
    private let storyBoard: UIStoryboard
    private let navigationController: UINavigationController

    init(navigationController: UINavigationController, storyBoard: UIStoryboard) {
        self.navigationController = navigationController
        self.storyBoard = storyBoard
    }

    func toAbout() {
//        let vc = storyBoard.instantiateViewController(withIdentifier: "viewController2")
//
////    let vc = ViewController()
//        vc.viewModel = CalculatorViewModel(navigator: self)
//        navigationController.pushViewController(vc, animated: true)
    }
}
