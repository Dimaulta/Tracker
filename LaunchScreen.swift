//
//  LaunchScreen.swift
//  Tracker
//
//  Created by Ульта on 26.07.2025.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    
    private let backgroundView = UIView()
    private let logoImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            let tabBarController = TabBarController()
            tabBarController.modalPresentationStyle = .fullScreen
            self.present(tabBarController, animated: true)
        }
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "Blue")
        
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.backgroundColor = UIColor(named: "Blue")
        view.addSubview(backgroundView)
        
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "LaunchLogo")
        logoImageView.contentMode = .scaleAspectFit
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 91),
            logoImageView.heightAnchor.constraint(equalToConstant: 91)
        ])
    }
}
