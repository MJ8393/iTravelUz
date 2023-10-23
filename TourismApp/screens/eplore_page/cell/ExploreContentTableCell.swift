//
//  ExploreContentTableCell.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 09/09/23.
//


import UIKit

class ExploreContentTableCell: UITableViewCell {
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 22, weight: .semibold)
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.numberOfLines = 0
        return label
    }()
    
    lazy var playButton: UIButton = {
        let button = UIButton(type: .custom)
        button.backgroundColor = UIColor.mainColor
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        let playIconImage = UIImage(systemName: "play.fill")
        button.setImage(playIconImage, for: .normal)
        button.addTarget(self, action: #selector(playButtonTapped), for: .touchUpInside)
        button.tintColor = .white
        return button
    }()
    
    private var isSpeechPlaying = false
    private var isSpeechPaused = false
    
    private var currentlySpokenWordRange: NSRange?
    
    private var attributedTextWithHighlighting: NSMutableAttributedString?
    
    
    
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
        
        subView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
        
        subView.addSubview(playButton)
        playButton.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.right.equalToSuperview().offset(-20)
            make.width.height.equalTo(40)
        }
        
        subView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-20)
        }
    }
    
    func setData(_ title: String, _ description: String) {
        //        titleLabel.text = title
        //        descriptionLabel.text = description
        titleLabel.text = "Miri Arab madrasasi"
        descriptionLabel.text = "Muborak Buxoro islom madaniyati va O‘zbekistonning qadimiy tarixi markazidir. Ikki ming yillik tarix davomida bu shahar buyuk tarixiy voqealarga, ayovsiz qonli janglarga guvoh bo‘ldi. Ana shunday janglardan biri 1511-1512 yillarda temuriy Bobur qoʻshinlari bilan oʻzbek xoni Shayboniyxon oʻrtasida boʻlib oʻtgan. 1512-yil noyabrda Gʻijduvon yaqinida oʻzbek qoʻshinlari Muhammad Boburning birlashgan qoʻshinini magʻlub etadi. G‘ijduvon jangi g‘olibi Muhammad Shayboniyxonning jiyani, Qur’oni karim bilimdoni, iste’dodli shoir, olimlar homiysi Ubaydullaxon Buxoro hukmdori etib tayinlandi."
    }
    
    @objc func playButtonTapped() {
        
    }
}
