//
//  ViewController.swift
//  Calculator
//
//  Created by heyongjian on 2017/12/17.
//  Copyright © 2017年 heyongjian. All rights reserved.
//

import UIKit

class ViewController: UIViewController,BoardButtonInputDelegate {
    func boardButtonClick(content: String) {
        if content == "AC" || content == "Del" || content == "="{
            screen.refreshHistory()
        }else{
            screen.inputContent(content: content)
        }
    }
    

    let board = Board()
    let screen = Screen()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        let board = Board(frame: CGRect(x:0,y:0, width:200,height:300))
////        let board = Board()
//
//        self.view.addSubview(board)
        setUpView()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setUpView(){
        self.view.addSubview(board)
        board.delegate = self
        board.snp.makeConstraints{(maker) in
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.bottom.equalTo(0)
            maker.height.equalTo(board.superview!.snp.height).multipliedBy(2/3.0)
        }
        
        self.view.addSubview(screen)
        screen.snp.makeConstraints{(maker) in
            maker.left.equalTo(0)
            maker.right.equalTo(0)
            maker.top.equalTo(0)
            maker.bottom.equalTo(board.snp.top)

        }
    }


}

