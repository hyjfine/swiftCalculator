//
//  simpleContract.swift
//  Calculator
//
//  Created by heyongjian on 2017/12/22.
//  Copyright © 2017年 heyongjian. All rights reserved.
//

import Foundation

protocol SimpleViewProtocol {
    
    func actionAc() -> Void
    
    func actionDel() -> Void
    
    func actionEqua(result:String) -> Void
    
    func actionNum(content:String) -> Void
    
    func getInputString() -> String
    
}

protocol SimplePresenterProtocol {
    
    func calculatEquation(equation:String) -> Double
    
    func boardButtonClick(content:String) -> Void
    
    func setView(view:SimpleViewProtocol) -> Void
    
}


