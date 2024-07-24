//
//  ViewModel.swift
//  QR Generator
//
//  Created by İremsu  Baş  on 4.07.2024.

//TODO: Turi create araştır, iki tane ML model yarat

import UIKit
import CoreImage.CIFilterBuiltins

protocol ViewModelProtocol {
    func generatingQRCode(string: String)
    func setViewController(viewController: UIViewController)
    func getColors() -> [UIColor]
}

final class ViewModel: NSObject, ColorSelectionListable, ViewModelProtocol {
    
    var viewModel: ViewModelProtocol?
    
    let colors: [UIColor] = [.magenta, .red, .orange, .yellow, .green, .cyan, .blue, .black, .white]
    
    var QRGeneration: QRGeneratable?
    
    var selectedBackgroundColor: UIColor = .white
    var selectedColor: UIColor = .black
    var prevIndexPathBackground: IndexPath?
    var prevIndexPathQR: IndexPath?
    weak var viewController: ViewController?
    
    init(qrGeneration: QRGeneratable) {
        self.QRGeneration = qrGeneration
    }

    func setViewController(viewController: UIViewController) {
        self.viewController = (viewController as! ViewController)
    }
    
    func getColors() -> [UIColor] {
        return colors
    }
    
    func generatingQRCode(string: String) {
        switch QRGeneration?.createQrCode(from: string, backgroundColor: selectedBackgroundColor, color: selectedColor) {
            case .success(let image):
                viewController?.showQRCode(image: image)
            case .error(let errorMessage):
                viewController?.showToast(message: errorMessage)
            
        case .none:
            break
        }
    }
    
    func didSelectItem(collectionView: UICollectionView, indexPath: IndexPath) {
        if collectionView == viewController?.collectionViewBackground{
            selectedBackgroundColor = colors[indexPath.item]
            if let prevIndexPathBackground = prevIndexPathBackground, prevIndexPathBackground != indexPath {
                let prevCell = collectionView.cellForItem(at: prevIndexPathBackground)
                prevCell?.layer.borderColor = UIColor.black.cgColor
                prevCell?.layer.borderWidth = 2
                prevCell?.transform = CGAffineTransform.identity
            }
            prevIndexPathBackground = indexPath
        }
        else{
            selectedColor = colors[indexPath.item]
            if let prevIndexPathQR = prevIndexPathQR, prevIndexPathQR != indexPath {
                let prevCell = collectionView.cellForItem(at: prevIndexPathQR)
                prevCell?.layer.borderColor = UIColor.black.cgColor
                prevCell?.layer.borderWidth = 2
                prevCell?.transform = CGAffineTransform.identity
            }
            prevIndexPathQR = indexPath
            
        }

        
        viewController?.generateQRCode()

    }

    
    
   

        
}


    


    
