//
//  ViewController.swift
//  ios-session-download-demo
//
//  Created by Eiji Kushida on 2016/12/28.
//  Copyright © 2016年 Eiji Kushida. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let urlString = "https://developer.apple.com/jp/documentation/MobileHIG.pdf"

    @IBOutlet weak var pregress: UIProgressView!

    override func viewDidLoad() {
        super.viewDidLoad()

        let manager = DownloadUtil(delegate: self)
        manager.start(urlString: urlString)
    }
}

//MARK:- ProgressDelegate
extension ViewController: ProgressDelegate {

    func updatePerProgress(per: Float) {
        print("\(Int(per * 100))%ダウンロード")
        pregress.setProgress(per, animated: true)
    }
}
