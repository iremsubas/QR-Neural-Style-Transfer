//
//  ViewController.swift
//  QR Generator
//
//  Created by İremsu  Baş  on 3.07.2024.
//
import UIKit
import CoreImage.CIFilterBuiltins

class ViewController: UIViewController {

    private lazy var imageView: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: 150),
            view.heightAnchor.constraint(equalToConstant: 150),
        ])
        return view
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let image = createQRCode(from: "hafize")
        if let image = image {
            imageView.image = image
        } else {
            print("Failed to generate QR code.")
        }
        view.addSubview(imageView)
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ])
    }

    
}
