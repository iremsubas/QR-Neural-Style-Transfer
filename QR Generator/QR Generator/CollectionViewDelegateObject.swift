//
//  CollectionViewDelegateObject.swift
//  QR Generator
//
//  Created by İremsu  Baş  on 19.07.2024.
//

import Foundation
import UIKit

protocol ColorSelectionListable {
    func didSelectItem(collectionView: UICollectionView, indexPath: IndexPath)
}


final class CollectionViewDelegateObject: NSObject, UICollectionViewDelegate {
    
    var colorSelection: ColorSelectionListable
    
    init(_ colorSelection:ColorSelectionListable) {
        self.colorSelection = colorSelection
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath)
        cell?.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        
        colorSelection.didSelectItem(collectionView: collectionView, indexPath: indexPath)
    }
    
    
    
}
