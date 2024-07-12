//
//  ViewController.swift
//  QR Generator
//
//  Created by İremsu  Baş  on 3.07.2024.
//


//TODO: add an export QR thing
//TODO: bir tane daha collection view ekle qr code'un içindeki rengi değiştir, sonradan da ml model için collection view

import UIKit
import CoreImage.CIFilterBuiltins

class ViewController: UIViewController, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    //TODO: aşağıdaki data source'ları viewmodel'a taşı
    
    private let viewModel = ViewModel()
    
    private let colors: [UIColor] = [.yellow, .green, .cyan, .blue, .red, .magenta, .white]
    
    private var selectedBackgroundColor: UIColor = .white
    
    private var prevIndexPath:IndexPath? = nil
    
    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 220),
            view.heightAnchor.constraint(equalToConstant: 220),
        ])
        view.layer.shadowColor = UIColor.gray.cgColor
        view.layer.shadowOpacity = 1
        view.layer.shadowOffset = .zero
        view.layer.shadowRadius = 7
        
        return view
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 25))
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "QR Neural Style Generator"
        return label
    }()
    
    private lazy var textField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.borderStyle = .roundedRect
        field.placeholder = "Enter text for QR Code"
        field.translatesAutoresizingMaskIntoConstraints = false
        field.delegate = self
        return field
    }()
    
    private lazy var generateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Generate QR Code", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(generateQRCode), for: .touchUpInside)
        return button
    }()
    
    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout:
                                                CollectionViewLayout().createCompositionaLayout())
        
        collectionView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ColorCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 7)
        setupViews()
    }
    
    private func setupViews() {
        view.addSubview(label)
        view.addSubview(textField)
        view.addSubview(generateButton)
        view.addSubview(collectionView)
        view.addSubview(imageView)
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            label.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.8),
            label.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
            
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
            
            generateButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 50),
            generateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            imageView.topAnchor.constraint(equalTo: generateButton.bottomAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -200),
            collectionView.heightAnchor.constraint(equalToConstant: 150),
            
        ])
    }
    
    @objc private func generateQRCode() {
        guard let urlString = textField.text else {
            print("Invalid URL")
            return
        }
        
        if let qrImage = viewModel.createQRCode(from: urlString, backgroundColor: selectedBackgroundColor) {
            imageView.image = qrImage
        } else {
            print("Failed to generate QR code")
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
        selectedBackgroundColor = colors[indexPath.item]
        
        
        if prevIndexPath != nil && prevIndexPath! != indexPath {
            let cell = collectionView.cellForItem(at: prevIndexPath!)
            
            
            cell?.layer.borderColor = UIColor.black.cgColor
            cell?.layer.borderWidth = 2
            cell?.transform = CGAffineTransform.identity
            
        }
        
        let cell = collectionView.cellForItem(at: indexPath)
        
        cell?.transform = CGAffineTransform(scaleX: 1.15, y: 1.15)
        
        
        generateQRCode()
        
        
        prevIndexPath = indexPath
    }
    
}
    



class CollectionViewLayout {
    func createCompositionaLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumLineSpacing = 20
        return layout
    }
}
