//
//  DownloadUtil.swift
//  ios-session-download-demo
//
//  Created by Eiji Kushida on 2016/12/28.
//  Copyright © 2016年 Eiji Kushida. All rights reserved.
//

import UIKit

protocol ProgressDelegate {
    func updatePerProgress(per: Float)
}

final class DownloadUtil: NSObject {

    private var session: URLSession?
    fileprivate var delegate: ProgressDelegate?

    func setup(delegate: ProgressDelegate?) {

        //タイムアウトなし
//        let config = URLSessionConfiguration.default

        //タイムアウトあり
        let config = URLSessionConfiguration.background(withIdentifier: "backgroundTask")
        config.timeoutIntervalForRequest = 60
        config.timeoutIntervalForResource = TimeInterval(60 * 60 * 24 * 7)

        session = Foundation.URLSession(configuration: config,
                                            delegate: self,
                                            delegateQueue: OperationQueue.main)
        self.delegate = delegate
    }

    func start(urlString: String) {

        if let url = URL(string: urlString) {

            let request = URLRequest(url: url)
            let task = session!.downloadTask(with: request)
            task.resume()
        } else {
            fatalError("URLが不正")
        }
    }
}

extension DownloadUtil: URLSessionDownloadDelegate {

    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didFinishDownloadingTo location: URL) {

        //TODO: ダウンロードしたデータを取り出す.
        FileUtil().saveData(location: location)
    }

    func urlSession(_ session: URLSession,
                    downloadTask: URLSessionDownloadTask,
                    didWriteData bytesWritten: Int64,
                    totalBytesWritten: Int64,
                    totalBytesExpectedToWrite: Int64) {

        DispatchQueue.main.async (execute: { [weak self] in

            let per = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
            self?.delegate?.updatePerProgress(per: per)
        })
    }

    func urlSession(_ session: URLSession,
                    task: URLSessionTask,
                    didCompleteWithError error: Error?) {

        if let error = error {
            print("ダウンロードが失敗しました")
            print(error.localizedDescription)
        } else {
            print("ダウンロードが完了しました")
        }
    }
}
