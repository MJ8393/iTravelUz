//
//  InfoWindowVC.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 18/09/23.
//

import UIKit

protocol InfoWindowVCDelegate: AnyObject {
    func didTapXButton()
    func didTapShareButton(_: UIButton)
    func didTapGoButton()
}

class InfoWindowVC: UIViewController {

    weak var delegate: InfoWindowVCDelegate?
    var images: [GalleryModel]?
    var cityLabelText: String?
    var cityName: String?
    let vc = ViewController()
    
    lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.text = cityLabelText
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.textColor = .black
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = cityName
        label.font = .systemFont(ofSize: 15)
        label.textColor = .black
        return label
    }()
    
    private let goButton: UIButton = {
        let goButton = UIButton()
        goButton.translatesAutoresizingMaskIntoConstraints = false
        goButton.backgroundColor = .systemBlue
        goButton.titleLabel?.lineBreakMode = .byWordWrapping
        goButton.setTitleColor(.white, for: .normal)
        goButton.setTitle("Open\nGoogle Maps", for: .normal)
        goButton.titleLabel?.textAlignment = .center
        goButton.layer.cornerRadius = 8
        goButton.addTarget(self, action: #selector(goButtonPressed), for: .touchUpInside)
        return goButton
    }()
    
    private let shareButton: UIButton = {
        let shareButton = UIButton()
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.backgroundColor = .secondarySystemBackground
        let image = UIImage(systemName: "square.and.arrow.up")
        shareButton.setImage(image, for: .normal)
        shareButton.layer.cornerRadius = 8
        shareButton.addTarget(self, action: #selector(shareButtonPressed(_:)), for: .touchUpInside)
        return shareButton
    }()
    
    private let saveButton: UIButton = {
        let saveButton = UIButton()
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.backgroundColor = .secondarySystemBackground
        let image = UIImage(systemName: "heart")
        saveButton.setImage(image, for: .normal)
        saveButton.layer.cornerRadius = 8
        return saveButton
    }()
    
    private let xButton: UIButton = {
        let xButton = UIButton()
        xButton.translatesAutoresizingMaskIntoConstraints = false
        xButton.backgroundColor = .secondarySystemBackground
        xButton.setTitleColor(.secondarySystemBackground, for: .normal)
        let image = UIImage(systemName: "xmark")
        xButton.setImage(image, for: .normal)
        xButton.tintColor = .black
        xButton.layer.cornerRadius = 14
        xButton.addTarget(self, action: #selector(xButtonPressed), for: .touchUpInside)
        return xButton
    }()
    
    private let collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: 220, height: 260)
        flowLayout.scrollDirection = .horizontal
        flowLayout.minimumInteritemSpacing = 10
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: ImageCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let properties = [cityLabel, descriptionLabel, goButton, shareButton, saveButton, xButton, collectionView]
        for property in properties {
            view.addSubview(property)
        }
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        applyConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        cityLabel.sizeToFit()
        cityLabel.frame = CGRect(x: 15, y: 15, width: cityLabel.frame.size.width, height: cityLabel.frame.size.height)
    }
    
    func applyConstraints() {
        
        let descriptionLabelConstraints = [
            descriptionLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 4),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15)
        ]
        
        let goButtonConstrains = [
            goButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 15),
            goButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            goButton.heightAnchor.constraint(equalToConstant: 42),
            goButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        let shareButtonConstraints = [
            shareButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 15),
            shareButton.leadingAnchor.constraint(equalTo: goButton.trailingAnchor, constant: 7),
            shareButton.heightAnchor.constraint(equalToConstant: 40),
            shareButton.widthAnchor.constraint(equalToConstant: 50)
        ]
        
        let saveButtonConstraints = [
            saveButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 15),
            saveButton.leadingAnchor.constraint(equalTo: shareButton.trailingAnchor, constant: 7),
            saveButton.heightAnchor.constraint(equalToConstant: 40),
            saveButton.widthAnchor.constraint(equalToConstant: 50)
        ]
        
        let xButtonConstraints = [
            xButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 13),
            xButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -13),
            xButton.heightAnchor.constraint(equalToConstant: 28),
            xButton.widthAnchor.constraint(equalToConstant: 28)
        ]
        
        let collectionViewConstraints = [
            collectionView.topAnchor.constraint(equalTo: goButton.bottomAnchor, constant: 30),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            collectionView.heightAnchor.constraint(equalToConstant: 250)
        ]
        
        let constraints = [descriptionLabelConstraints, goButtonConstrains, shareButtonConstraints, saveButtonConstraints, xButtonConstraints, collectionViewConstraints]
        for constraint in constraints { NSLayoutConstraint.activate(constraint) }
    }
    
    @objc func xButtonPressed() {
        delegate?.didTapXButton()
    }
    
    @objc func shareButtonPressed(_ sender: UIButton) {
        delegate?.didTapShareButton(sender)
    }
    
    @objc func goButtonPressed() {
        delegate?.didTapGoButton()
    }
}


extension InfoWindowVC: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let count = images?.count else { return 0 }
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.identifier, for: indexPath) as? ImageCollectionViewCell else { return UICollectionViewCell() }
        if let url = images?[indexPath.row].url {
            cell.setImage(url: url)
        }
        cell.clipsToBounds = true
        cell.backgroundColor = .clear
        return cell
    }
}
