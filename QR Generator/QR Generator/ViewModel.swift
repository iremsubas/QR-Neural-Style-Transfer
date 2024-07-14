//
//  ViewModel.swift
//  QR Generator
//
//  Created by İremsu  Baş  on 4.07.2024.



import UIKit
import CoreImage.CIFilterBuiltins

class ViewModel:NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    
    let colors: [UIColor] = [.yellow, .green, .cyan, .blue, .red, .magenta, .white]
    
    var selectedBackgroundColor: UIColor = .white
    var prevIndexPath: IndexPath?
    weak var viewController: ViewController?
    
    func generateQrCode(from string: String) {
            switch QRGeneration.shared.createQrCode(from: string, backgroundColor: selectedBackgroundColor) {
            case .success(let image):
                viewController?.showQrCode(image: image)
            case .error(let errorMessage):
                viewController?.showToast(message: errorMessage)
            }
        }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath)
        cell.layer.cornerRadius = 8
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 2
        cell.backgroundColor = colors[indexPath.item]
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        selectedBackgroundColor = colors[indexPath.item]

        if let prevIndexPath = prevIndexPath, prevIndexPath != indexPath {
            let prevCell = collectionView.cellForItem(at: prevIndexPath)
            prevCell?.layer.borderColor = UIColor.black.cgColor
            prevCell?.layer.borderWidth = 2
            prevCell?.transform = CGAffineTransform.identity
        }
        viewController?.generateQrCode()
        
        prevIndexPath = indexPath
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    

        
    }


    


    
