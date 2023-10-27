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
    let thisWidth = CGFloat(UIScreen.main.bounds.width - 40.0)
    var cityGallery: [String] = []
    var isCity = false
    
    lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 23, weight: .bold)
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
        goButton.setTitle("open_google_map".translate(), for: .normal)
        goButton.titleLabel?.textAlignment = .center
        goButton.layer.cornerRadius = 8
        goButton.setTitleColor(UIColor.mainColor, for: .normal)
        goButton.addTarget(self, action: #selector(goButtonPressed), for: .touchUpInside)
        return goButton
    }()
    
    private let shareButton: UIButton = {
        let shareButton = UIButton()
        shareButton.translatesAutoresizingMaskIntoConstraints = false
        shareButton.backgroundColor = .secondarySystemBackground
        let image = UIImage(systemName: "square.and.arrow.up")
        shareButton.setImage(image, for: .normal)
        shareButton.tintColor = .mainColor
        shareButton.layer.cornerRadius = 8
        shareButton.addTarget(self, action: #selector(shareButtonPressed(_:)), for: .touchUpInside)
        return shareButton
    }()
    
    lazy var likeButton: UIButton = {
        let likeButton = UIButton()
        likeButton.translatesAutoresizingMaskIntoConstraints = false
        likeButton.backgroundColor = .secondarySystemBackground
        let image = UIImage(systemName: "heart")
        likeButton.setImage(image, for: .normal)
        likeButton.layer.cornerRadius = 8
        likeButton.tintColor = .mainColor
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
            xButton.setImage(renderedImage.withTintColor(.label), for: .normal)
//            xButton.setTi
        }
        //        xButton.setImage(image, for: .normal)
        xButton.tintColor = .systemBlue
        xButton.imageView?.tintColor = .systemBlue
        xButton.addTarget(self, action: #selector(xButtonPressed), for: .touchUpInside)
        return xButton
    }()
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.itemSize = CGSize(width: thisWidth, height: 250)
        flowLayout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: CGRect(x: 0, y: 0, width: thisWidth, height: 260), collectionViewLayout: flowLayout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = true
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(HeaderImagesCollectionViewCell.self, forCellWithReuseIdentifier: HeaderImagesCollectionViewCell.identifier)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.isPagingEnabled = true
        collectionView.layer.cornerRadius = 15
        collectionView.clipsToBounds = true
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
        cityLabel.frame = CGRect(x: 20, y: 15, width: UIScreen.main.bounds.width - 60, height: cityLabel.frame.size.height)
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
            descriptionLabel.topAnchor.constraint(equalTo: cityLabel.bottomAnchor, constant: 7),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ]
        
        let likeButtonConstraints = [
            likeButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            likeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            likeButton.heightAnchor.constraint(equalToConstant: 40),
            likeButton.widthAnchor.constraint(equalToConstant: 50)
        ]
        
        let shareButtonConstraints = [
            shareButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            shareButton.trailingAnchor.constraint(equalTo: likeButton.leadingAnchor, constant: -7),
            shareButton.heightAnchor.constraint(equalToConstant: 40),
            shareButton.widthAnchor.constraint(equalToConstant: 50)
        ]

        let goButtonConstrains = [
            goButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 20),
            goButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            goButton.heightAnchor.constraint(equalToConstant: 42),
//            goButton.widthAnchor.constraint(equalToConstant: 150)
            goButton.trailingAnchor.constraint(equalTo: shareButton.leadingAnchor, constant: -7),

        ]
        
        let xButtonConstraints = [
            xButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 10),
            xButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -10),
            xButton.heightAnchor.constraint(equalToConstant: 30),
            xButton.widthAnchor.constraint(equalToConstant: 30)
        ]
        
        let collectionViewConstraints = [
            collectionView.topAnchor.constraint(equalTo: goButton.bottomAnchor, constant: 30),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.heightAnchor.constraint(equalToConstant: 250)
        ]
        
        let constraints = [descriptionLabelConstraints, shareButtonConstraints, likeButtonConstraints, goButtonConstrains, xButtonConstraints, collectionViewConstraints]
        for constraint in constraints { NSLayoutConstraint.activate(constraint) }
    }
    
}

extension InfoContentVC: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if isCity {
            return cityGallery.count
        }
        return gallery.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HeaderImagesCollectionViewCell.identifier, for: indexPath) as? HeaderImagesCollectionViewCell else { return UICollectionViewCell() }
        if isCity {
            if  cityGallery.count == 0 {
                cell.setImage(with: "destination_653a701b0ba11ced210daa73_5-0-0-0-0-1583403867-0-0-0-0-1583403914.jpg")
            } else {
                cell.setImage(with: cityGallery[indexPath.section])
            }
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 15
            cell.backgroundColor = .clear
        } else {
            cell.setImage(with: gallery[indexPath.section].url ?? "destination_653a701b0ba11ced210daa73_5-0-0-0-0-1583403867-0-0-0-0-1583403914.jpg")
            cell.clipsToBounds = true
            cell.layer.cornerRadius = 15
            cell.backgroundColor = .clear
        }
        return cell
    }
}
