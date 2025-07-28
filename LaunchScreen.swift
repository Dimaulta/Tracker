//
//  LaunchScreen.swift
//  Tracker
//
//  Created by Ульта on 26.07.2025.
//

import UIKit

class LaunchScreenViewController: UIViewController {
    
    private let logoImageView = UIImageView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        // Переход к TabBarController через 2 секунды
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            self.showMainInterface()
        }
    }
    
    private func showMainInterface() {
        let tabBarController = TabBarController()
        tabBarController.modalPresentationStyle = .fullScreen
        tabBarController.modalTransitionStyle = .crossDissolve
        present(tabBarController, animated: true)
    }
    
    private func setupUI() {
        // Настройка основного фона
        view.backgroundColor = UIColor(named: "Blue")
        
        // Настройка логотипа
        setupLogo()
    }
    
    private func setupLogo() {
        logoImageView.translatesAutoresizingMaskIntoConstraints = false
        logoImageView.image = UIImage(named: "LaunchLogo")
        logoImageView.contentMode = .scaleAspectFit
        view.addSubview(logoImageView)
        
        NSLayoutConstraint.activate([
            logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            logoImageView.widthAnchor.constraint(equalToConstant: 91),
            logoImageView.heightAnchor.constraint(equalToConstant: 91)
        ])
    }
}
