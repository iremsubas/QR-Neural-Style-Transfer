//
//  ViewController.swift
//  QR Generator
//
//  Created by İremsu  Baş  on 3.07.2024.
//


//TODO: add an export QR thing
//TODO: sonradan da ml model için collection view

import UIKit
import CoreImage.CIFilterBuiltins

/*protocol ViewControllerProtocol {
    func showQRCode(image: UIImage)
    func showToast(message: String)
    func generateQRCode()
}*/

final class ViewController: UIViewController, UITextFieldDelegate, ViewModelProtocol {
    
    
    
    var collectionViewDataSource: UICollectionViewDataSource?
    
    var collectionViewDelegate: UICollectionViewDelegate?
    
    var viewModel:ViewModelProtocol?
    
    
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
    
    private lazy var error: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 300, height: 25))
        label.font = UIFont.boldSystemFont(ofSize: 20.0)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
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
    
    
     lazy var collectionViewBackground: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout:
                                                CollectionViewLayout().createCompositionaLayout())
        
        collectionView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "BackgroundColorCell")
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    lazy var collectionViewQR: UICollectionView = {
       let collectionView = UICollectionView(frame: .zero, collectionViewLayout:
                                               CollectionViewLayout().createCompositionaLayout())
       
       collectionView.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
       collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "ColorCell")
       collectionView.translatesAutoresizingMaskIntoConstraints = false
       collectionView.backgroundColor = .clear
       return collectionView
   }()
    
    func setViewController(viewController: UIViewController) {
        viewModel?.setViewController(viewController: self)
    }


    
    func getColors() -> [UIColor] {
        guard let colors = viewModel?.getColors() else {
                    return []
                }
                return colors
    }
    
    
    
    private func setCollectionViews() {
        
        guard let viewModel = viewModel else {
                print("viewModel is nil")
                return
            }

        
        collectionViewDataSource = CollectionViewDataSourceObject(.init(color: getColors(), identifiers: [collectionViewBackground: "BackgroundColorCell", collectionViewQR: "ColorCell"]))
        collectionViewDelegate = CollectionViewDelegateObject(viewModel as! ColorSelectionListable)
        
        collectionViewBackground.dataSource = collectionViewDataSource
        collectionViewBackground.delegate = collectionViewDelegate
        
        collectionViewQR.dataSource = collectionViewDataSource
        collectionViewQR.delegate = collectionViewDelegate
    }
 

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        viewModel?.setViewController(viewController: self)
        collectionViewQR.contentInset = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 7)
        collectionViewBackground.contentInset = UIEdgeInsets(top: 0, left: 7, bottom: 0, right: 7)
        
        setCollectionViews()
        setupViews()
    }
    
   
    
    private func setupViews() {
        view.addSubview(label)
        view.addSubview(textField)
        view.addSubview(generateButton)
        view.addSubview(collectionViewQR)
        view.addSubview(collectionViewBackground)
        view.addSubview(imageView)
        setupConstraints()
    }
    
    
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            label.widthAnchor.constraint(lessThanOrEqualTo: view.widthAnchor, multiplier: 0.8),
            label.heightAnchor.constraint(greaterThanOrEqualToConstant: 20),
            
            textField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 80),
            textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 80),
            textField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -80),
            
            generateButton.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 20),
            generateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            imageView.topAnchor.constraint(equalTo: generateButton.bottomAnchor, constant: 60),
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            collectionViewQR.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionViewQR.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionViewQR.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -300),
            collectionViewQR.heightAnchor.constraint(equalToConstant: 150),
            
            collectionViewBackground.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionViewBackground.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionViewBackground.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -160),
            collectionViewBackground.heightAnchor.constraint(equalToConstant: 150),
            
        ])
    }
    
    
    @objc func generateQRCode() {
        guard let text = textField.text, !text.isEmpty else {
            showToast(message: "Please enter text to generate QR Code.")
            return
        }
        generatingQRCode(string: text)
    }
    
    func generatingQRCode(string: String) {
        viewModel?.generatingQRCode(string: string)
    }
    
    func showQRCode(image: UIImage) {
        imageView.image = image
    }

    func showToast(message: String) {
        error.text = message
        view.addSubview(error)
        NSLayoutConstraint.activate([
            error.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            error.topAnchor.constraint(equalTo: generateButton.bottomAnchor, constant: 10),
        ])
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.error.removeFromSuperview()
        }
    }
    
    
    
    
}
    


class CollectionViewLayout {
    func createCompositionaLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.itemSize = CGSize(width: 90, height: 90)
        layout.minimumLineSpacing = 20
        return layout
    }
}
