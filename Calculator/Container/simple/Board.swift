//
//  Board.swift
//  Calculator
//
//  Created by heyongjian on 2017/12/17.
//  Copyright © 2017年 heyongjian. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift
import RxCocoa

class Board: UIView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    private var disposeBag = DisposeBag()
    var delegate: BoardButtonInputDelegate?

    let nameSubject = ReplaySubject<String>.create(bufferSize: 1)


    var dataArray = [
        "0", ".", "%", "="
        , "1", "2", "3", "+"
        , "4", "5", "6", "-"
        , "7", "8", "9", "*"
        , "AC", "Del", "^", "/"
    ]

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()

    }


    func setupUI() {


        var frontBtn: FuncButton!
        for index in 0..<20 {
            let btn = FuncButton()
            self.addSubview(btn)
            btn.snp.makeConstraints({ (maker) in
                if index % 4 == 0 {
                    maker.left.equalTo(0)
                } else {
                    maker.left.equalTo(frontBtn.snp.right)
                }

                if index / 4 == 0 {
                    maker.bottom.equalTo(0)
                } else if index % 4 == 0 {
                    maker.bottom.equalTo(frontBtn.snp.top)
                } else {
                    maker.bottom.equalTo(frontBtn.snp.bottom)
                }

                maker.width.equalTo(btn.superview!.snp.width).multipliedBy(0.25)
                maker.height.equalTo(btn.superview!.snp.height).multipliedBy(0.2)

            })
            btn.tag = index + 100
            btn.addTarget(self, action: #selector(btnClick(button:)), for: .touchUpInside)
            btn.setTitle(dataArray[index], for: UIControlState.normal)
            frontBtn = btn
        }

    }

    @objc func btnClick(button: FuncButton) {
        print(button.title(for: .normal) as Any)
        if delegate != nil {
            delegate?.boardButtonClick(content: button.currentTitle!)
        }


        nameSubject.onNext(button.currentTitle ?? "err")

        let animation = CATransition()
//        animation.delegate = self
        animation.duration = 0.5
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
//        animation.type = kCATransitionPush
        button.layer.add(animation, forKey: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }


}

protocol BoardButtonInputDelegate {
    func boardButtonClick(content: String)
}

