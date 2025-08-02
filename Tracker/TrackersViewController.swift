//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Ульта on 26.07.2025.
//

import UIKit

class TrackersViewController: UIViewController {
    
    // MARK: - UI Elements
    private let titleLabel = UILabel()
    private let addButton = UIButton(type: .system)
    private let searchContainerView = UIView()
    private let searchTextField = UITextField()
    private let searchIconView = UIImageView()
    private let dateButton = UIButton(type: .system)
    private let emptyStateImageView = UIImageView()
    private let emptyStateLabel = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(named: "WhiteDay")
        setupNavigationBar()
        setupAddButton()
        setupDateButton()
        setupTitle()
        setupSearchBar()
        setupEmptyState()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func setupTitle() {
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.text = "Трекеры"
        titleLabel.font = UIFont(name: "SFPro-Bold", size: 34) ?? UIFont.boldSystemFont(ofSize: 34)
        titleLabel.textColor = UIColor(named: "BlackDay")
        view.addSubview(titleLabel)
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 88),
            titleLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleLabel.widthAnchor.constraint(equalToConstant: 254),
            titleLabel.heightAnchor.constraint(equalToConstant: 41)
        ])
    }
    
    private func setupAddButton() {
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setImage(UIImage(named: "Add tracker"), for: .normal)
        addButton.tintColor = UIColor.black
        addButton.backgroundColor = UIColor.clear
        addButton.alpha = 1.0
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        view.addSubview(addButton)
        NSLayoutConstraint.activate([
            addButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 45),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 6),
            addButton.widthAnchor.constraint(equalToConstant: 42),
            addButton.heightAnchor.constraint(equalToConstant: 42)
        ])
    }
    
    private func setupDateButton() {
        dateButton.translatesAutoresizingMaskIntoConstraints = false
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        let currentDate = Date()
        let dateString = dateFormatter.string(from: currentDate)
        dateButton.setTitleColor(UIColor(named: "BlackDay"), for: .normal)
        dateButton.titleLabel?.font = UIFont(name: "SFPro-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .regular)
        dateButton.titleLabel?.textAlignment = .right
        
        // Настройка line-height как в макете (22px)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 22.0 / 17.0 // 22px / 17px = 1.294
        let attributedString = NSAttributedString(
            string: dateString,
            attributes: [
                .paragraphStyle: paragraphStyle,
                .font: dateButton.titleLabel?.font ?? UIFont.systemFont(ofSize: 17),
                .foregroundColor: UIColor(named: "BlackDay") ?? UIColor.black
            ]
        )
        dateButton.setAttributedTitle(attributedString, for: .normal)
        dateButton.backgroundColor = UIColor(named: "LightGray")
        dateButton.layer.cornerRadius = 8
        dateButton.alpha = 1.0
        dateButton.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        dateButton.addTarget(self, action: #selector(dateButtonTapped), for: .touchUpInside)
        view.addSubview(dateButton)
        
        NSLayoutConstraint.activate([
            dateButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 49),
            dateButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            dateButton.widthAnchor.constraint(equalToConstant: 88),
            dateButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    private func setupSearchBar() {
        // Настройка контейнера
        searchContainerView.translatesAutoresizingMaskIntoConstraints = false
        searchContainerView.backgroundColor = UIColor(named: "LightGray")
        searchContainerView.layer.cornerRadius = 10
        searchContainerView.clipsToBounds = true
        view.addSubview(searchContainerView)
        
        // Настройка иконки лупы
        searchIconView.translatesAutoresizingMaskIntoConstraints = false
        searchIconView.image = UIImage(systemName: "magnifyingglass")
        searchIconView.tintColor = UIColor(named: "Gray")
        searchContainerView.addSubview(searchIconView)
        
        // Настройка текстового поля
        searchTextField.translatesAutoresizingMaskIntoConstraints = false
        searchTextField.placeholder = "Поиск"
        searchTextField.backgroundColor = .clear
        searchTextField.borderStyle = .none
        searchTextField.font = UIFont(name: "SFPro-Regular", size: 17) ?? UIFont.systemFont(ofSize: 17, weight: .regular)
        searchTextField.textColor = UIColor(named: "Gray")
        searchContainerView.addSubview(searchTextField)
        
        NSLayoutConstraint.activate([
            // Контейнер
            searchContainerView.topAnchor.constraint(equalTo: view.topAnchor, constant: 136),
            searchContainerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            searchContainerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            searchContainerView.heightAnchor.constraint(equalToConstant: 36),
            
            // Иконка лупы
            searchIconView.topAnchor.constraint(equalTo: searchContainerView.topAnchor, constant: 10),
            searchIconView.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor, constant: 8),
            searchIconView.widthAnchor.constraint(equalToConstant: 15.63),
            searchIconView.heightAnchor.constraint(equalToConstant: 15.78),
            
            // Текстовое поле
            searchTextField.topAnchor.constraint(equalTo: searchContainerView.topAnchor, constant: 7),
            searchTextField.leadingAnchor.constraint(equalTo: searchContainerView.leadingAnchor, constant: 30),
            searchTextField.trailingAnchor.constraint(equalTo: searchContainerView.trailingAnchor, constant: -8),
            searchTextField.bottomAnchor.constraint(equalTo: searchContainerView.bottomAnchor, constant: -7)
        ])
    }
    
    private func setupEmptyState() {
        emptyStateImageView.translatesAutoresizingMaskIntoConstraints = false
        emptyStateImageView.image = UIImage(named: "Dizzy")
        emptyStateImageView.contentMode = .scaleAspectFit
        emptyStateImageView.alpha = 1.0
        view.addSubview(emptyStateImageView)
        emptyStateLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyStateLabel.text = "Что будем отслеживать?"
        emptyStateLabel.font = UIFont.systemFont(ofSize: 12)
        emptyStateLabel.textColor = UIColor(named: "BlackDay")
        emptyStateLabel.textAlignment = .center
        view.addSubview(emptyStateLabel)
        NSLayoutConstraint.activate([
            emptyStateImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyStateImageView.widthAnchor.constraint(equalToConstant: 80),
            emptyStateImageView.heightAnchor.constraint(equalToConstant: 80),
            emptyStateLabel.topAnchor.constraint(equalTo: emptyStateImageView.bottomAnchor, constant: 8),
            emptyStateLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emptyStateLabel.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 16),
            emptyStateLabel.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -16)
        ])
    }
    
    // MARK: - Actions
    
    @objc private func addButtonTapped() {
        let createHabitViewController = CreateHabitViewController()
        createHabitViewController.modalPresentationStyle = .fullScreen
        present(createHabitViewController, animated: true)
    }
    
    @objc private func dateButtonTapped() {
        // Пока что ничего не происходит - реализацию логики выполним в следующих уроках
        print("Date button tapped")
    }
} 