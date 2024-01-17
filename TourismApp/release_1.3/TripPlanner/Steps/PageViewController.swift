//
//  PageViewController.swift
//  TourismApp
//
//  Created by Uyg'un Tursunov on 05/01/24.
//

import UIKit

class PageViewController: UIViewController {
    
    var width = UIScreen.main.bounds.width
    var currentPageIndex: Int = 0
    var didChoosePlace: Bool = false
    var didChooseBudget: Bool = false
    
    lazy var progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = .mainColor
        progressView.trackTintColor = .systemBackground
        progressView.progress = 1.0 / Float(viewControllerList.count)
        return progressView
    }()
    
    lazy var pageViewController: UIPageViewController = {
        let pc = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        pc.delegate = self
        pc.dataSource = self
        pc.isDoubleSided = true
        return pc
    }()
    
    lazy var continueBtn: Button = {
        let btn = Button(title: "Continue")
        btn.layer.cornerRadius = 15
        btn.addTarget(self, action: #selector(continueBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    lazy var viewControllerList: [UIViewController] = {
        return [
            SearchPlaceViewController(),
            DateViewController(),
            CompanionsViewController(),
            InterestsViewController(),
            BudgetViewController()
        ]
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initViews()
    }
    
    func updateProgressView(index: Int) {
        DispatchQueue.main.async {
            let progress = Float(index) / Float(self.viewControllerList.count)
            self.progressView.setProgress(progress, animated: true)
        }
    }
    
    @objc func continueBtnPressed() {
        if didChoosePlace {
            updateProgressView(index: (currentPageIndex + 1) + 1)
            guard currentPageIndex < viewControllerList.count - 1 else {
                if didChooseBudget {
                    let vc = TripDetailsViewController()
                    navigationController?.pushViewController(vc, animated: true)
                } else {
                    showAlert(title: "Error", message: "Please, choose based on your budget")
                }
                return
            }
            pageViewController.setViewControllers([viewControllerList[currentPageIndex + 1]], direction: .forward, animated: true)
            currentPageIndex += 1
        } else {
            showAlert(title: "Error", message: "Please, choose the place")
        }
        
    }
    
    @objc func backButtonPressed() {
        guard currentPageIndex > 0 else {
            dismiss(animated: true)
            return }
        updateProgressView(index: (currentPageIndex + 1) - 1)
        pageViewController.setViewControllers([viewControllerList[currentPageIndex - 1]], direction: .reverse, animated: true)
        currentPageIndex -= 1
    }
    
    @objc func xButtonPressed() {
        dismiss(animated: true)
    }
    
    @objc func didSelectCell(_ notification: Notification) {
        if let choosePlace = notification.userInfo?["didChoosePlace"] as? Bool {
            didChoosePlace = choosePlace
        }
    }
    
    @objc func didSelectBudget(_ notification: Notification) {
        if let chooseBudget = notification.userInfo?["didChooseBudget"] as? Bool {
            didChooseBudget = chooseBudget
        }
    }
    
    private func initViews() {
        view.backgroundColor = .systemBackground
        
        NotificationCenter.default.addObserver(self, selector: #selector(didSelectCell(_:)), name: .didSelectCell, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(didSelectBudget(_:)), name: .didSelectBudget, object: nil)
        
        let backImage = UIImage(systemName: "chevron.left")
        let backButton = UIBarButtonItem(image: backImage, style: .plain, target: self, action: #selector(backButtonPressed))
        backButton.tintColor = .label
        navigationItem.leftBarButtonItem = backButton
        
        let xImage = UIImage(systemName: "xmark")
        let nextButton = UIBarButtonItem(image: xImage, style: .done, target: self, action: #selector(xButtonPressed))
        nextButton.tintColor = .label
        navigationItem.rightBarButtonItem = nextButton
        
        if let firstVC = viewControllerList.first {
            pageViewController.setViewControllers([firstVC], direction: .forward, animated: true)
        }
        
        self.addChild(pageViewController)
        self.view.insertSubview(pageViewController.view, at: 0)
        pageViewController.didMove(toParent: self)
        
        pageViewController.view.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview().offset(-90)
        }
        
        view.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(10)
        }
        
        view.addSubview(continueBtn)
        continueBtn.snp.makeConstraints { make in
            make.bottom.equalToSuperview().offset(-40)
            make.leading.equalToSuperview().offset(25)
            make.trailing.equalToSuperview().offset(-25)
            make.height.equalTo(45)
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}

extension PageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = viewControllerList.firstIndex(of: viewController) else { return nil }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else { return nil }
        guard viewControllerList.count > previousIndex else { return nil }
        return viewControllerList[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if didChoosePlace {
            guard let viewControllerIndex = viewControllerList.firstIndex(of: viewController) else { return nil }
            let nextIndex = viewControllerIndex + 1
            guard nextIndex < viewControllerList.count else { return nil }
            return viewControllerList[nextIndex]
        } else {
            return nil
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = viewControllerList.firstIndex(of: currentViewController) {
            currentPageIndex = currentIndex
            updateProgressView(index: currentPageIndex + 1)
        }
    }
}
