//
// Created by heyongjian on 2018/4/24.
// Copyright (c) 2018 heyongjian. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


class CalculatorViewModel: ViewModelType {
    private let screen: Screen
    private let figureArray: Array<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."]
    private let funcArray = ["+", "-", "*", "/", "%", "^"]
    private let navigator: CalculatorNavigatorProtocol?
    private var disposeBag = DisposeBag()
    private var isNew = false

    init(screen: Screen, navigator: CalculatorNavigatorProtocol? = nil) {
        self.screen = screen
        self.navigator = navigator
    }

    func transform(input: Input) -> Output {

        let currentTitle = input.buttonTitle.map { [weak self] buttonTitle -> String in
            var inputLabel = self?.screen.inputLabel?.text ?? ""
            if buttonTitle == "AC" || buttonTitle == "Del" || buttonTitle == "=" {

                print("------currentTitle: ", buttonTitle, " ", inputLabel)
                switch buttonTitle {
                case "AC":
                    return ""
                case "Del":
                    return self?.deleteInput(inputLabel: inputLabel) ?? ""
                case "=":
                    self?.isNew = true
                    let result = self?.calculatorEquation(equation: inputLabel) ?? 0
                    return self?.inputContent(content: String(result), inputLabel: "") ?? ""
                default:
                    return inputLabel
                }
            } else {
                if self?.isNew ?? false {
                    inputLabel = ""
                    self?.isNew = false
                }
                return self?.inputContent(content: buttonTitle, inputLabel: inputLabel) ?? ""
            }
        }

        let _ = currentTitle.asObservable().bind { [weak self] e in
            if (String(e) == "123") {
                print("-----test 1234")
                self?.navigator?.toZhihu()
                print("-----test 12345")

            }
        }.disposed(by: disposeBag)

        let historyTitle = input.buttonTitle.map { [weak self] buttonTitle -> String in
            let inputLabel = self?.screen.inputLabel?.text ?? ""
            let historyLabel = self?.screen.historyLabel?.text ?? ""
            if buttonTitle == "AC" || buttonTitle == "Del" || buttonTitle == "=" {
                print("------historyTitle: ", buttonTitle, " ", inputLabel)
                switch buttonTitle {
                case "AC":
                    return ""
                case "Del":
                    return historyLabel
                case "=":
                    return inputLabel
                default:
                    return inputLabel
                }
            } else {
                return historyLabel
            }
        }

        return Output(currentTitle: currentTitle, historyTitle: historyTitle)
    }

    func deleteInput(inputLabel: String) -> String {
        if inputLabel.count > 0 {
            var temp = inputLabel
            temp.remove(at: temp.index(before: temp.endIndex))
            return temp
        } else {
            return ""
        }
    }

    func inputContent(content: String, inputLabel: String) -> String {

        if content.isEmpty {
            return "";
        }
        if !figureArray.contains(content.last!) && !funcArray.contains(content) {
            return "";
        }
        if inputLabel.count > 0 {
            if figureArray.contains(inputLabel.last!) {
                return inputLabel + content
            } else {
                if figureArray.contains(content.last!) {
                    return inputLabel + content
                }
            }
        } else {
            if figureArray.contains(content.last!) {
                return inputLabel + content
            }
        }

        return inputLabel
    }

    func calculatorEquation(equation: String) -> Double {
        let funcArrayThis: CharacterSet = ["+", "-", "*", "/", "^", "%"]
        let elementArray = equation.components(separatedBy: funcArrayThis)
        var tip = 0
        var result: Double = Double(elementArray[0])!
        for char in equation {
            switch char {
            case "+":
                tip += 1
                if elementArray.count > tip {
                    result += Double(elementArray[tip])!
                }
            case "-":
                tip += 1
                if elementArray.count > tip {
                    result -= Double(elementArray[tip])!
                }
            case "*":
                tip += 1
                if elementArray.count > tip {
                    result *= Double(elementArray[tip])!
                }
            case "/":
                tip += 1
                if elementArray.count > tip {
                    result /= Double(elementArray[tip])!
                }
            case "%":
                tip += 1
                if elementArray.count > tip {
                    result += Double(Int(result) % Int(elementArray[tip])!)
                }
            case "^":
                tip += 1
                if elementArray.count > tip {
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

}


extension CalculatorViewModel {
    struct Input {
        let buttonTitle: Driver<String>
    }

    struct Output {
        let currentTitle: Driver<String>
        let historyTitle: Driver<String>
    }
}
