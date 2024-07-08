//
//  ViewModel.swift
//  QR Generator
//
//  Created by İremsu  Baş  on 4.07.2024.
//
import UIKit
import CoreImage.CIFilterBuiltins

class ViewModel {
    func createQRCode(from string: String, backgroundColor: UIColor) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        let filter = CIFilter.qrCodeGenerator()
        filter.setValue(data, forKey: "inputMessage")
        
        if let outputImage = filter.outputImage {
            let transform = CGAffineTransform(scaleX: 10, y: 10)
            let scaledImage = outputImage.transformed(by: transform)
            
            if let finalImage = scaledImage.tinted(using: .black)?.withBackground(using: backgroundColor) {
                return UIImage(ciImage: finalImage)
            } else {
                print("Failed to apply background color.")
            }
        } else {
            print("Failed to create output image.")
        }
        return nil
    }
}

extension CIImage {
    var transparent: CIImage? {
        return inverted?.blackTransparent
    }

    var inverted: CIImage? {
        guard let invertedColorFilter = CIFilter(name: "CIColorInvert") else { return nil }
        invertedColorFilter.setValue(self, forKey: "inputImage")
        return invertedColorFilter.outputImage
    }

    var blackTransparent: CIImage? {
        guard let blackTransparentFilter = CIFilter(name: "CIMaskToAlpha") else { return nil }
        blackTransparentFilter.setValue(self, forKey: "inputImage")
        return blackTransparentFilter.outputImage
    }

    func tinted(using color: UIColor) -> CIImage? {
        guard
            let transparentQRImage = transparent,
            let filter = CIFilter(name: "CIMultiplyCompositing"),
            let colorFilter = CIFilter(name: "CIConstantColorGenerator") else { return nil }

        let ciColor = CIColor(color: color)
        colorFilter.setValue(ciColor, forKey: kCIInputColorKey)
        let colorImage = colorFilter.outputImage

        filter.setValue(colorImage, forKey: kCIInputImageKey)
        filter.setValue(transparentQRImage, forKey: kCIInputBackgroundImageKey)

        return filter.outputImage
    }

    func withBackground(using color: UIColor) -> CIImage? {
        guard let backgroundFilter = CIFilter(name: "CIConstantColorGenerator") else { return nil }

        let ciColor = CIColor(color: color)
        backgroundFilter.setValue(ciColor, forKey: kCIInputColorKey)
        let backgroundImage = backgroundFilter.outputImage?.cropped(to: extent)

        let filter = CIFilter(name: "CISourceOverCompositing")
        filter?.setValue(self, forKey: kCIInputImageKey)
        filter?.setValue(backgroundImage, forKey: kCIInputBackgroundImageKey)

        return filter?.outputImage
    }
}
