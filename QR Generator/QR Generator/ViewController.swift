//
//  ViewController.swift
//  QR Generator
//
//  Created by İremsu  Baş  on 3.07.2024.
//


//TODO: add an export QR thing

import UIKit
import CoreImage.CIFilterBuiltins

class ViewController: UIViewController, UITextFieldDelegate {

    private let viewModel = ViewModel()
    private let colors: [UIColor] = [.white, .yellow, .green, .blue, .red, .black]
    private var selectedColor: UIColor = .white

    private lazy var imageView: UIImageView = {
       
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 220),
            view.heightAnchor.constraint(equalToConstant: 220),
        ])
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
    
    private let colorPicker: UIButton = {
            let button = UIButton(type: .system)
            button.setTitle("Pick Color", for: .normal)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
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

        view.addSubview(label)
        view.addSubview(textField)
        view.addSubview(colorPicker)
        view.addSubview(generateButton)
        view.addSubview(imageView)
        view.addSubview(collectionView)

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

            generateButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            generateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            imageView.topAnchor.constraint(equalTo: generateButton.bottomAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),

            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 20),
            collectionView.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

 /*   @objc private func generateQRCode(ciImage: CIImage?) {
        guard let text = textField.text, !text.isEmpty else {
            print("Text field is empty")
            return
        }
        
        let swiftLeeOrangeColor = UIColor(red:0.93, green:0.31, blue:0.23, alpha:1.00)
        let qrURLImage = URL(string: "https://www.google.com")?.qrImage(using: swiftLeeOrangeColor)
        
        /*let context = CIContext()
            if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
                let uiImage = UIImage(cgImage: cgImage)
                
                // Create a UIImageView with the UIImage
                let qrView = UIImageView(image: uiImage)*/
                
                
       
        
        if let image = viewModel.createQRCode(from: text) {
            let targetColor = UIColor.white // Replace red color
            let newColor = UIColor.blue // With blue color
            imageView.image = image
        } else {
            print("Failed to generate QR code.")
        }
    }
}*/
    
    @objc private func openColorPicker() {
            let colorPickerVC = UIColorPickerViewController()
            colorPickerVC.delegate = self
            present(colorPickerVC, animated: true, completion: nil)
        }
    
    @objc private func generateQRCode() {
        guard let urlString = textField.text else {
            print("Invalid URL")
            return
        }
        
        if let qrImage = viewModel.createQRCode(from: urlString, color: selectedColor) {
            imageView.image = qrImage
        } else {
            print("Failed to generate QR code")
        }
    }
}

extension ViewController: UIColorPickerViewControllerDelegate {
    func colorPickerViewControllerDidFinish(_ viewController: UIColorPickerViewController) {
        selectedColor = viewController.selectedColor
    }
    
    func colorPickerViewController(_ viewController: UIColorPickerViewController, didSelect color: UIColor, continuously: Bool) {
        selectedColor = color
    }
}

extension ViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return colors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ColorCell", for: indexPath)
        cell.backgroundColor = colors[indexPath.item]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedColor = colors[indexPath.item]
        generateQRCode()
    }
}

class CollectionViewLayout {
    func createCompositionaLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 50, height: 50)
        layout.minimumLineSpacing = 10
        return layout
    }
}


