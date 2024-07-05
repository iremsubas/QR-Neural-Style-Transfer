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
        label.center = CGPoint(x: 200, y: 90)
        label.textAlignment = .center
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(label)
        view.addSubview(textField)
        view.addSubview(generateButton)
        view.addSubview(imageView)
        
        setupConstraints()
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            //label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            //label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            //label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
            
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
            
            generateButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            generateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            imageView.topAnchor.constraint(equalTo: generateButton.bottomAnchor, constant: 20),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
    }

    @objc private func generateQRCode() {
        guard let text = textField.text, !text.isEmpty else {
            print("Text field is empty")
            return
        }
        if let image = viewModel.createQRCode(from: text) {
            imageView.image = image
        } else {
            print("Failed to generate QR code.")
        }
    }
}
