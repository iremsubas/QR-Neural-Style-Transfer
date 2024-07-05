//
//  ViewModel.swift
//  QR Generator
//
//  Created by İremsu  Baş  on 4.07.2024.
//

import UIKit
import CoreImage.CIFilterBuiltins

class ViewModel {

    func createQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        let filter = CIFilter.qrCodeGenerator()
        filter.setValue(data, forKey: "inputMessage")

        if let outputImage = filter.outputImage {
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let scaledImage = outputImage.transformed(by: transform)
            return UIImage(ciImage: scaledImage)
        } else {
            print("Failed to create output image.")
        }

        return nil
    }
}
