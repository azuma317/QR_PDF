# QR_PDF

QRコードを自動生成して、PDFとしてまとめるアプリ。

## 自動生成後のPDF
<img src="https://github.com/azuma317/QR_PDF/blob/master/image/1.png" width="300">

## プログラム

```swift:ViewController.swift
// PDFを生成する関数
    private func createPDF(count: Int) {
        guard let path = Bundle.main.path(forResource: "Sample", ofType: "pdf") else { return }
        guard let document = PDFDocument(url: URL(fileURLWithPath: path)) else { return }
        for i in 1...count {
            // randomStringは自作のランダムな文字列を生成する関数
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
```
