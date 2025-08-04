//
//  TabBarController.swift
//  Tracker
//
//  Created by Ульта on 26.07.2025.
//

import UIKit

class TabBarController: UITabBarController {
    
    private let topBorderView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        
        setupTabBar()
        setupTopBorder()
    }
    
    private func setupTopBorder() {
        topBorderView.translatesAutoresizingMaskIntoConstraints = false
        topBorderView.backgroundColor = UIColor(named: "Gray")
        view.addSubview(topBorderView)
        
        NSLayoutConstraint.activate([
            topBorderView.bottomAnchor.constraint(equalTo: tabBar.topAnchor, constant: -4),
            topBorderView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            topBorderView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            topBorderView.heightAnchor.constraint(equalToConstant: 1)
        ])
    }
    
    private func setupTabBar() {
        // Создаем экран трекеров (главный экран)
        let trackersViewController = TrackersViewController()
        trackersViewController.tabBarItem = UITabBarItem(
            title: "Трекеры",
            image: UIImage(systemName: "record.circle"),
            selectedImage: UIImage(systemName: "record.circle.fill")
        )
        
        // Создаем экран статистики (пока пустой)
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.tabBarItem = UITabBarItem(
            title: "Статистика",
            image: UIImage(named: "TabBarStat"),
            selectedImage: UIImage(named: "TabBarStat")
        )
        
        // Настраиваем TabBar
        viewControllers = [
            trackersViewController,
            statisticsViewController
        ]
        
        // Настраиваем внешний вид TabBar
        tabBar.tintColor = UIColor(named: "Blue")
        tabBar.unselectedItemTintColor = UIColor(named: "Gray")
    }
}

// MARK: - Placeholder View Controllers

class StatisticsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.systemBackground
        title = "Статистика"
    }
}
