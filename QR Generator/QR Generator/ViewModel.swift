//
//  ViewModel.swift
//  QR Generator
//
//  Created by İremsu  Baş  on 4.07.2024.



import UIKit
import CoreImage.CIFilterBuiltins

class ViewModel:NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout  {
    
    let colors: [UIColor] = [.magenta, .red, .orange, .yellow, .green, .cyan, .blue, .black, .white]
    
    var selectedBackgroundColor: UIColor = .white
    var selectedColor: UIColor = .black
    var prevIndexPathBackground: IndexPath?
    var prevIndexPathQR: IndexPath?
    weak var viewController: ViewController?
    
    func generateQrCode(from string: String) {
        switch QRGeneration.shared.createQrCode(from: string, backgroundColor: selectedBackgroundColor, color: selectedColor) {
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
        
        if collectionView == viewController?.collectionViewBackground{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "BackgroundColorCell", for: indexPath)
            cell.layer.cornerRadius = 8
            cell.layer.borderColor = UIColor.black.cgColor
            cell.layer.borderWidth = 2
            cell.backgroundColor = colors[indexPath.item]
            return cell
        }
        else{
            let cell2 = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath)
            cell2.layer.cornerRadius = 8
            cell2.layer.borderColor = UIColor.black.cgColor
            cell2.layer.borderWidth = 2
            cell2.backgroundColor = colors[indexPath.item]
            return cell2
            
        }
        
        
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
       
            
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        
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

        
        viewController?.generateQrCode()
        
        
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    

        
    }


    


    
