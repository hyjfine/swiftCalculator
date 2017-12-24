//
//  SimplePresenter.swift
//  Calculator
//
//  Created by heyongjian on 2017/12/22.
//  Copyright © 2017年 heyongjian. All rights reserved.
//

import Foundation

class SimplePresenter:SimplePresenterProtocol{
    
    var view:SimpleViewProtocol?
    //    let calculator = CalculatorEngine()
    let funcArray:CharacterSet = ["+","-","*","/","^","%"]
    
    func calculatEquation(equation:String) -> Double {
        let elementArray = equation.components(separatedBy: funcArray)
        var tip = 0
        var result:Double = Double(elementArray[0])!
        for char in equation {
            switch char {
            case "+":
                tip += 1
                if elementArray.count>tip {
                    result+=Double(elementArray[tip])!
                }
            case "-":
                tip += 1
                if elementArray.count>tip {
                    result-=Double(elementArray[tip])!
                }
            case "*":
                tip += 1
                if elementArray.count>tip {
                    result*=Double(elementArray[tip])!
                }
            case "/":
                tip += 1
                if elementArray.count>tip {
                    result/=Double(elementArray[tip])!
                }
            case "%":
                tip += 1
                if elementArray.count>tip {
                    result+=Double(Int(result)%Int(elementArray[tip])!)
                }
            case "^":
                tip += 1
                if elementArray.count>tip {
                    let tmp = result
                    for _ in 1..<Int(elementArray[tip])! {
                        result *= tmp
                    }
                }
                
            default:
                break
            }
        }
        return result
    }
    
    func setView(view: SimpleViewProtocol) {
        self.view = view
    }
    
    func boardButtonClick(content:String) {
        if content == "AC" || content == "Del" || content == "="{
            switch content {
            case "AC":
                view?.actionAc()
            case "Del":
                view?.actionDel()
            case "=":
                let result = calculatEquation(equation: (view?.getInputString())!)
                view?.actionEqua(result:String(result))
            default:
                view?.actionAc()
            }
        }else{
            view?.actionNum(content: content)
        }
    }
    
}

