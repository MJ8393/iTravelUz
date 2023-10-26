//
//  InfoContentVC.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 25/10/23.
//

import UIKit

protocol FPContentVCDelegate: AnyObject {
    func didTapXButton()
    func didTapGoButton()
    func didTapShareButton(_: UIButton)
    func didTapLikeButton()
}

class InfoContentVC: UIViewController {
    
    weak var delegate: FPContentVCDelegate?
    var images: [Gallery] = []
    var gallery: [Gallery] = []
    let thisWidth = CGFloat(UIScreen.main.bounds.width)
    
    lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 25, weight: .bold)
        label.textColor = UIColor(named: "view_all_colorSet")
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15)
        label.textColor = UIColor(named: "view_all_colorSet")
        return label
    }()
    
    private let goButton: UIButton = {
        let goButton = UIButton()
        goButton.translatesAutoresizingMaskIntoConstraints = false
        goButton.backgroundColor = .secondarySystemBackground
        goButton.titleLabel?.lineBreakMode = .byWordWrapping
        goButton.setTitleColor(.systemBlue, for: .normal)
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
    
    private let likeButton: UIButton = {
        let likeButton = UIButton()
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.backgroundColor = .secondarySystemBackground
        let image = UIImage(systemName: "heart")
        likeButton.setImage(image, for: .normal)
        likeButton.layer.cornerRadius = 8
        likeButton.addTarget(self, action: #selector(likeButtonPressed), for: .touchUpInside)
        return likeButton
    }()
    
    private let xButton: UIButton = {
        let xButton = UIButton()
        xButton.translatesAutoresizingMaskIntoConstraints = false
        xButton.backgroundColor = .clear
        if let image = UIImage(systemName: "xmark.circle.fill") {
            let imageSize = CGSize(width: 24, height: 24) // Adjust the width and height as needed
            let resizedImage = image.withRenderingMode(.alwaysTemplate)
            let renderer = UIGraphicsImageRenderer(size: imageSize)
            let renderedImage = renderer.image { _ in
                resizedImage.draw(in: CGRect(origin: .zero, size: imageSize))
            }
            xButton.setImage(renderedImage, for: .normal)
        }
        //        xButton.setImage(image, for: .normal)
        xButton.tintColor = .chatGrayColor
        xButton.imageView?.tintColor = .chatGrayColor
        xButton.addTarget(self, action: #selector(xButtonPressed), for: .touchUpInside)
        return xButton
    }()
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: thisWidth, height: 260)
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: thisWidth, height: 260), collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(HeaderImagesCollectionViewCell.self, forCellWithReuseIdentifier: HeaderImagesCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        addSubviews()
        applyConstraints()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        cityLabel.sizeToFit()
        cityLabel.frame = CGRect(x: 20, y: 15, width: cityLabel.frame.size.width, height: cityLabel.frame.size.height)
    }
    
    @objc func goButtonPressed() {
        delegate?.didTapGoButton()
    }
    
    @objc func shareButtonPressed(_ sender: UIButton) {
        delegate?.didTapShareButton(sender)
    }
    
    @objc func likeButtonPressed() {
        delegate?.didTapLikeButton()
    }
    
    @objc func xButtonPressed() {
        delegate?.didTapXButton()
    }
    
    
    
    private func addSubviews() {
        let properties = [cityLabel, descriptionLabel, goButton, shareButton, likeButton, xButton, collectionView]
        for property in properties {
            view.addSubview(property)
        }
    }
    
    func applyConstraints() {
        
        let descriptionLabelConstraints = [
            descriptionLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 5),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ]
        
        let goButtonConstrains = [
            goButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40),
            goButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            goButton.heightAnchor.constraint(equalToConstant: 42),
            goButton.widthAnchor.constraint(equalToConstant: 120)
        ]
        
        let shareButtonConstraints = [
            shareButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40),
            shareButton.leadingAnchor.constraint(equalTo: goButton.trailingAnchor, constant: 7),
            shareButton.heightAnchor.constraint(equalToConstant: 40),
            shareButton.widthAnchor.constraint(equalToConstant: 50)
        ]
        
        let saveButtonConstraints = [
            likeButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 40),
            likeButton.leadingAnchor.constraint(equalTo: shareButton.trailingAnchor, constant: 7),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            likeButton.widthAnchor.constraint(equalToConstant: 50)
        ]
        
        let xButtonConstraints = [
            xButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            xButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            xButton.heightAnchor.constraint(equalToConstant: 30),
            xButton.widthAnchor.constraint(equalToConstant: 30)
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
    
}

extension InfoContentVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return gallery.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeaderImagesCollectionViewCell.identifier, for: indexPath) as? HeaderImagesCollectionViewCell else { return UICollectionViewCell() }
        
        cell.setImage(with: gallery[indexPath.row].url)
        cell.clipsToBounds = true
        cell.backgroundColor = .clear
        return cell
    }
}
