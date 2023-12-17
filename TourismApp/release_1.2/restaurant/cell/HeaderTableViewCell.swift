//
//  HeaderTableViewCell.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 16/12/23.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {
    
    let width = UIScreen.main.bounds.width
    var imageURLs = [String]() {
        didSet {
            pageControl.numberOfPages = imageURLs.count
        }
    }
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.isScrollEnabled = true
        collectionView.isPagingEnabled = true
        collectionView.layer.cornerRadius = 0
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(HeaderCollectionViewCell.self, forCellWithReuseIdentifier: String.init(describing: HeaderCollectionViewCell.self))
        return collectionView
    }()
    
    lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = imageURLs.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .secondaryLabel
        pageControl.currentPageIndicatorTintColor = .systemBlue
        pageControl.hidesForSinglePage = true
        return pageControl
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()
    
    lazy var locationImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Group 7")!
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy var cityLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return label
    }()
    
    lazy var starImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "ant-design_star-filled")!
        return imageView
    }()
    
    lazy var ratingLabel: UILabel = {
        let label = UILabel()
        label.textColor = .label
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        label.text = "5.0"
        return label
    }()
    
    lazy var workHoursLabel: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.text = "working hours:".translate()
        return label
    }()
    
    lazy var workHoursTime: UILabel = {
        let label = UILabel()
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
        //pageControl.frame = CGRect(x: 0, y: 0, width: 40, height: 30)
    }
    
    func initViews() {
        contentView.addSubview(containerView)
        containerView.snp_makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        containerView.addSubview(collectionView)
        collectionView.snp_makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
            make.trailing.equalToSuperview()
            make.height.equalTo(200)
        }
        
        containerView.addSubview(pageControl)
        pageControl.snp_makeConstraints { make in
            make.centerX.equalTo(collectionView)
            make.bottom.equalTo(collectionView.snp.bottom).offset(-5)
        }
        
        containerView.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(15)
            make.leading.equalToSuperview().offset(20)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        containerView.addSubview(locationImageView)
        locationImageView.snp_makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().offset(15)
            make.height.width.equalTo(18)
        }
        
        containerView.addSubview(cityLabel)
        cityLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.left.equalToSuperview().offset(37)
            make.right.equalToSuperview().offset(-20)
        }
        
        containerView.addSubview(ratingLabel)
        ratingLabel.snp_makeConstraints { make in
            make.centerY.equalTo(cityLabel)
            make.trailing.equalToSuperview().offset(-20)
        }
        
        containerView.addSubview(starImageView)
        starImageView.snp.makeConstraints { make in
            make.right.equalTo(ratingLabel.snp.left).offset(-4)
            make.centerY.equalTo(ratingLabel)
            make.height.width.equalTo(18)
        }
        
        containerView.addSubview(workHoursLabel)
        workHoursLabel.snp_makeConstraints { make in
            make.top.equalTo(cityLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().offset(0)
        }
        
        containerView.addSubview(workHoursTime)
        workHoursTime.snp_makeConstraints { make in
            make.centerY.equalTo(workHoursLabel)
            make.leading.equalTo(workHoursLabel.snp.trailing).offset(5)
        }
    }
    
    func setData(_ id: String, _ name: String, _ city: String, _ workHours: String) {
        nameLabel.text = name
        cityLabel.text = city
        workHoursTime.text = workHours
    }
}

extension HeaderTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String.init(describing: HeaderCollectionViewCell.self), for: indexPath) as? HeaderCollectionViewCell else {return UICollectionViewCell()}
        cell.setImage(with: imageURLs[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: width, height: 200)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return imageURLs.count
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let currentPage = Int(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.currentPage = currentPage
    }
}
