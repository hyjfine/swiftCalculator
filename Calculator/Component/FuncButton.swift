//
//  FuncButton.swift
//  Calculator
//
//  Created by heyongjian on 2017/12/17.
//  Copyright © 2017年 heyongjian. All rights reserved.
//

import UIKit

class FuncButton: UIButton {
    let highlightColor = UIColor(red: 219 / 255.0, green: 219 / 255.0, blue: 219 / 255.0, alpha: 1)

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

    init() {
        super.init(frame: CGRect.zero)
        self.layer.borderWidth = 0.5
        self.layer.borderColor = highlightColor.cgColor
        self.setTitleColor(UIColor.orange, for: UIControlState.normal)
        self.titleLabel?.font = UIFont.systemFont(ofSize: 25)
        self.setTitleColor(UIColor.black, for: UIControlState.highlighted)

        self.setBackgroundImage(UIImage(color: highlightColor), for: .highlighted)

    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension UIImage {

    public convenience init(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
        let rect = CGRect(origin: CGPoint.zero, size: size)
        UIGraphicsBeginImageContextWithOptions(size, true, 0)
        color.setFill()
        UIRectFill(rect)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        self.init(cgImage: (image?.cgImage!)!)
    }
}
