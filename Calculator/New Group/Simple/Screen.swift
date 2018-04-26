//
//  Screen.swift
//  Calculator
//
//  Created by heyongjian on 2017/12/17.
//  Copyright © 2017年 heyongjian. All rights reserved.
//

import UIKit

class Screen: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    var inputLabel: UILabel?
    var historyLabel: UILabel?
    var inputString = ""
    var historyString = ""
    let figureArray: Array<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "."]
    let funcArray = ["+", "-", "*", "/", "%", "^"]

    init() {
        inputLabel = UILabel()
        historyLabel = UILabel()
        super.init(frame: CGRect.zero)
        setupView()
    }

    func setupView() {
        inputLabel?.textAlignment = .right
        historyLabel?.textAlignment = .right
        inputLabel?.font = UIFont.systemFont(ofSize: 34)
        historyLabel?.font = UIFont.systemFont(ofSize: 30)
        inputLabel?.textColor = UIColor.orange
        historyLabel?.textColor = UIColor.black
        inputLabel?.adjustsFontSizeToFitWidth = true
        inputLabel?.minimumScaleFactor = 0.5
        historyLabel?.adjustsFontSizeToFitWidth = true
        historyLabel?.minimumScaleFactor = 0.5
        inputLabel?.lineBreakMode = .byTruncatingHead
        historyLabel?.lineBreakMode = .byTruncatingHead
        inputLabel?.numberOfLines = 0
        historyLabel?.numberOfLines = 0
        self.addSubview(inputLabel!)
        self.addSubview(historyLabel!)

        inputLabel?.snp.makeConstraints({ (makeer) in
            makeer.left.equalTo(10)
            makeer.right.equalTo(-10)
            makeer.bottom.equalTo(-10)
            makeer.height.equalTo(inputLabel!.superview!.snp.height).multipliedBy(0.5).offset(-10)
        })

        historyLabel?.snp.makeConstraints({ (makeer) in
            makeer.left.equalTo(10)
            makeer.right.equalTo(-10)
            makeer.top.equalTo(10)
            makeer.height.equalTo(inputLabel!.superview!.snp.height).multipliedBy(0.5).offset(-10)
        })

    }

    func inputContent(content: String) {
        if !figureArray.contains(content.last!) && !funcArray.contains(content) {
            return;
        }
        if inputString.count > 0 {
            if figureArray.contains(inputString.last!) {
                inputString.append(content)
                inputLabel?.text = inputString
            } else {
                if figureArray.contains(content.last!) {
                    inputString.append(content)
                    inputLabel?.text = inputString
                }
            }
        } else {
            if figureArray.contains(content.last!) {
                inputString.append(content)
                inputLabel?.text = inputString
            }
        }
    }

    func refreshHistory() {
        historyString = inputString
        historyLabel?.text = historyString
    }

    func clearContent() -> Void {
        inputString = ""
    }

    func deleteInput() -> Void {
        if inputString.count > 0 {
            inputString.remove(at: inputString.index(before: inputString.endIndex))
            inputLabel?.text = inputString
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("<#T##message: String##String#>")
    }


}
