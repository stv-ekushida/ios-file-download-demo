//
//  FileUtil.swift
//  ios-session-download-demo
//
//  Created by Eiji Kushida on 2016/12/28.
//  Copyright © 2016年 Eiji Kushida. All rights reserved.
//

import UIKit

final class FileUtil {

    func saveData(location: URL) {

        let data = NSData(contentsOf: location)
        if let data = data {

            do{
                let fileExtension = location.pathExtension
                let filePath = getSaveDirectory() + getIdFromDateTime() + "." + fileExtension

                print(filePath)

                try data.write(toFile: filePath, options: .atomic)
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }


    // 現在時刻からユニークな文字列を得る
    private func getIdFromDateTime() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd-HH-mm-ss"
        return dateFormatter.string(from: Date())
    }

    // 保存するディレクトリのパス
    private func getSaveDirectory() -> String {

        let fileManager = Foundation.FileManager.default

        // ライブラリディレクトリのルートパスを取得して、それにフォルダ名を追加
        let path = NSSearchPathForDirectoriesInDomains(
            Foundation.FileManager.SearchPathDirectory.libraryDirectory,
            Foundation.FileManager.SearchPathDomainMask.userDomainMask,
                                                       true).first! + "/DownloadFiles/"

        // ディレクトリがない場合は作る
        if !fileManager.fileExists(atPath: path) {
            createDir(path: path)
        }

        return path
    }

    // ディレクトリを作成
    private func createDir(path: String) {
        do {
            let fileManager = Foundation.FileManager.default
            try fileManager.createDirectory(atPath: path,
                                            withIntermediateDirectories: true,
                                            attributes: nil)
        } catch let error as NSError {
            print("createDir: \(error)")
        }
    }
}
