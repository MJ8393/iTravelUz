//
//  CommentsSmallTableViewCell.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 25/10/23.
//

import UIKit

let smallColors = [UIColor(hex: "CE5A67"), UIColor(hex: "6C5F5B"), UIColor(hex: "9A4444"), UIColor(hex: "3085C3"), UIColor(hex: "004225"), UIColor(hex: "E55604"), UIColor(hex: "0F2C59"), UIColor(hex: "57375D")]

class CommentsSmallTableViewCell: UITableViewCell {
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var avatarView: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 15
        view.backgroundColor = smallColors.randomElement()
        return view
    }()
    
    lazy var mainLabel: UILabel = {
        let label = UILabel()
        label.text = String(randomUppercaseLetter())
        label.font = .systemFont(ofSize: 14, weight: .medium)
        label.textColor = .white
        return label
    }()
    
    lazy var commentsLabel: UILabel = {
        let label = UILabel()
        label.text = "nnjjnnknjnjnjnkkjnnjknkjnjknkjnjkjnkkjnnjkknjnkjnjknkjkjnnkjnkjnjknkjnkjnjknjknjknjknjknjknjknjknjknkjnkjnjknkj"
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .label
        label.numberOfLines = 0
        label.lineBreakMode = .byWordWrapping
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initViews() {
        contentView.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(avatarView)
        avatarView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(5)
//            make.bottom.lessThanOrEqualToSuperview().offset(-5)
            make.height.width.equalTo(30)
        }
        
        avatarView.addSubview(mainLabel)
        mainLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        subView.addSubview(commentsLabel)
        commentsLabel.snp.makeConstraints { make in
            make.left.equalTo(avatarView.snp.right).offset(20)
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(avatarView)
//            make.bottom.equalTo(avatarView.snp.bottom).offset(5)
//            make.bottom.greaterThanOrEqualToSuperview().offset(-5)
        }

        print(commentsLabel.numberOfVisibleLines)
    }
 
    func setCommend(_ text: String) {
        commentsLabel.text = text
        let numberOfLines = commentsLabel.numberOfVisibleLines
        if numberOfLines > 2 {
            commentsLabel.snp.makeConstraints { make in
                make.bottom.equalToSuperview().offset(-5)
            }
        } else {
            commentsLabel.snp.makeConstraints { make in
                make.bottom.equalTo(avatarView.snp.bottom).offset(5)
            }
        }
    }
    
    func randomUppercaseLetter() -> Character {
        let letters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
        let randomIndex = Int(arc4random_uniform(UInt32(letters.count)))
        let randomLetter = letters[letters.index(letters.startIndex, offsetBy: randomIndex)]
        return randomLetter
    }
}

extension UILabel {
    var numberOfVisibleLines: Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        let textHeight = sizeThatFits(maxSize).height
        let lineHeight = font.lineHeight
        return Int(ceil(textHeight / lineHeight))
    }
}
