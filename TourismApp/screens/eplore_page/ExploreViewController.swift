//
//  ExploreViewController.swift
//  TourismApp
//
//  Created by Mekhriddin Jumaev on 09/09/23.
//

import UIKit
import AVKit

let descriptionString = "Blessed Bukhara- the center of Islamic culture and ancient history of Uzbekistan. Over the course of two thousand years of history, this city has witnessed great historical events and brutal bloody battles. One of these battles took place in 1511-1512 between the troops of Timurid Babur and the Uzbek Khan Sheibanikhan. In November 1512, near Gijduvan, the Uzbek army prevailed over the united army of Muhammad Babur. The ruler of Bukhara was appointed the winner of the Battle of Gijduvan Ubaydullah Khan, the nephew of Muhammad Sheibani Khan, a connoisseur of the Koran, a talented poet and patron of scientists.\n\nIt was under Ubaydullah Khan that the real flourishing of Bukhara took place, the city acquired its own unique architectural style. In 1514, the Kalon Cathedral mosque, built under Karakhanid Arslan Khan (1102-1130), one of the largest in Transoxiana, was restored until 1404, when the construction of the Bibi-Khanim mosque in Samarkand, built by Temur's grandson Ulugbek, was completed. By order of Ubaydullah Khan, the facade of the mosque was decorated with a grandiose peshtak and a new mihrab was installed.\n\nNot far from the Bibi-Khanim Mosque in 1530, the construction of the Miri Arab madrasah was started, which surpassed the size of the Ulughbek madrasah in Samarkand. The new madrasah was named after an Arab scholar, a native of Yemen, Amir Abdullah al-Yamani, a disciple of the influential Naqshbandi Sheikh Khoja Ahrar and spiritual mentor of Ubaydullah Khan.\n\nToday, Miri Arab Madrasah is part of the Poi-Kalon architectural ensemble, which includes the Kalon Mosque and minaret and the Emir Alimkhan Madrasah. The main facade of the madrasah looks at the Kalon minaret. The entrance to the madrasah is decorated with a majestic and ornate peshtak with a deep niche, massive guldasata towers are located on the edges of the facade.\n\nIf you enter through the main entrance on the right, you can see the marble tomb of Sheikh Abdullah al-Yamani and the supposed burial place of Ubaydullah Khan himself. The premises are guarded by two domes lined with a blue slab.\n\nIn the courtyard there are study rooms – hujras, and summer classrooms are made in the form of aivans with small portals.\n\nMiri Arab Madrasah has always been considered the center of Islamic spiritual education, prominent spiritual figures and muftis studied within its walls. The activity of the madrasah was suspended in 1920, when the Bukhara Emirate was captured by the Bolsheviks. After the Second World War, the Soviet government changed its attitude to religion and gradually began to open religious institutions.\n\nIn 1943, the Kurultai of Muslim ulema in Tashkent established the Spiritual Administration of Muslims of Central Asia and Kazakhstan, whose chairman was appointed Sheikh Eshon Babakhan ibn Abdulmazhidkhan. It was through the efforts of the sheikh in 1945 that the Miri Arab madrasah was restored and received the status of an educational institution.\n\nGraduates of the Miri Arab Madrasah at various times were famous spiritual and political leaders, muftis and even heads of some states.\n\nAmong the most famous: Chief Mufti of Uzbekistan and Chairman of the Board of Muslims of Uzbekistan Usmankhan Alimov, Chairman of the Council of Muftis of Russia Ravil Gaynutdin, Mufti of Azerbaijan Allahshukur Pashazade, Mufti of Kazakhstan Ratbek Nysanbayuly, President of the Chechen Republic Ahmad Kadyrov, Supreme Mufti of Russia Tajuddin Talgat Safich, Chairman of the Spiritual Board of Muslims of Central Asia and Kazakhstan Sheikh Muhammad Sadik Muhammad Yusuf."

class ExploreViewController: UIViewController {
    
    lazy var subView: UIView = {
        let view = UIView()
        return view
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView(frame: .zero, style: .grouped)
        tableView.backgroundColor = UIColor.clear
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ExploreContentTableCell.self, forCellReuseIdentifier: String.init(describing: ExploreContentTableCell.self))
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        return tableView
    }()
    
    let synthesizer = AVSpeechSynthesizer()

    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        SpeechService.shared.speak(text: descriptionString) {
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        initViews()
        
        let header = StretchyTableHeaderView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 240))
        header.imageView.image = UIImage(named: "Registan")!
        tableView.tableHeaderView = header
    }
    
    private func initViews() {
        view.backgroundColor = UIColor.white
        view.addSubview(subView)
        subView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        subView.addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

}

extension ExploreViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String.init(describing: ExploreContentTableCell.self), for: indexPath) as? ExploreContentTableCell else { return UITableViewCell() }
        cell.setData("Miri Arab madrasasi - islom ta'limoti markazi", descriptionString)
        cell.backgroundColor = .clear
        cell.selectionStyle = .none
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let header = tableView.tableHeaderView as? StretchyTableHeaderView else { return }
        header.scrollViewDidScroll(scrollView: tableView)
    }
}
