//
//  CollectionViewDataSourceObject.swift
//  QR Generator
//
//  Created by İremsu  Baş  on 19.07.2024.
//

import Foundation
import UIKit

struct DataSourceObject{
    var color: [UIColor]
    var identifiers: [UICollectionView:String]
}

final class CollectionViewDataSourceObject: NSObject, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var object: DataSourceObject
    
    init(_ object: DataSourceObject){
        self.object = object
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return object.color.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: object.identifiers[collectionView]!, for: indexPath)
        cell.layer.cornerRadius = 8
        cell.layer.borderColor = UIColor.black.cgColor
        cell.layer.borderWidth = 2
        cell.backgroundColor = object.color[indexPath.item]
        return cell
        
        
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 100)
    }
    
}
