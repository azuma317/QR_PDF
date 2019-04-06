//
//  ViewController.swift
//  QR_PDF
//
//  Created by Azuma on 2019/04/06.
//  Copyright © 2019 Azuma. All rights reserved.
//

import UIKit
import PDFKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func qrAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "QRコードを生成", message: "何枚のQRコードを生成しますか？", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.keyboardType = .numberPad
        }
        let done = UIAlertAction(title: "生成する", style: .default) { (_) in
            guard let textField = alert.textFields?.first else { return }
            guard let count = Int(textField.text!) else { return }
            self.createPDF(count: count)
        }
        let cancel = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        alert.addAction(done)
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
    }
    
    // PDFを生成する関数
    private func createPDF(count: Int) {
        guard let path = Bundle.main.path(forResource: "Sample", ofType: "pdf") else { return }
        guard let document = PDFDocument(url: URL(fileURLWithPath: path)) else { return }
        for i in 1...count {
            let random = randomString(length: 12)
            // 文字列をデータ化
            let randomData = random.data(using: .utf8)!
            // QRコード生成のためのFilter
            let qr = CIFilter(name: "CIQRCodeGenerator", parameters: ["inputMessage": randomData, "inputCorrectionLevel": "M"])!
            let sizeTransform = CGAffineTransform(scaleX: 10, y: 10)
            let qrImage = qr.outputImage!.transformed(by: sizeTransform)
            // QRコードの画像を生成
            let image = UIImage(ciImage: qrImage)
            // QRコードの画像をPDF化
            guard let page = PDFPage(image: image) else { return }
            // PDFにQRコードを挿入
            document.insert(page, at: i)
        }
        guard let data = document.dataRepresentation() else { return }
        let activityItem = ["QRCode", data] as [Any]
        let activityVC = UIActivityViewController(activityItems: activityItem, applicationActivities: nil)
        present(activityVC, animated: true, completion: nil)
    }
    
    // ランダムな文字列を生成する関数
    private func randomString(length: Int) -> String {
        let letters: String = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        let len = UInt32(letters.count)
        var random: String = ""
        
        for _ in 0..<length {
            let rand = arc4random_uniform(len)
            random += String(letters[letters.index(letters.startIndex, offsetBy: Int(rand))])
        }
        return random
    }
    
}

