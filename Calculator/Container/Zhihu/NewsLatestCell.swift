//
//  NewsLatestCell.swift
//  Calculator
//
//  Created by heyongjian on 2018/5/19.
//  Copyright © 2018年 heyongjian. All rights reserved.
//

import Foundation
import UIKit

class NewsLatestCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        autoLayout()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupUI() {
        contentView.addSubview(title)
    }

    func autoLayout() {
        title.snp.makeConstraints { (make) in
            make.left.equalTo(16)
            make.centerY.equalToSuperview()
        }
    }

    private lazy var title: UILabel = {
        let label = UILabel()
        label.backgroundColor = .clear
        label.textAlignment = .right
        return label
    }()

    var data: String? = nil {
        didSet {
            title.text = data
        }
    }
}
