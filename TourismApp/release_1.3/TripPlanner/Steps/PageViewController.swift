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
    
    @objc func nextButtonPressed() {
        updateProgressView(index: (currentPageIndex + 1) + 1)
        guard currentPageIndex < viewControllerList.count - 1 else {
            let vc = TripDetailsViewController()
            navigationController?.pushViewController(vc, animated: true)
            return
        }
        pageViewController.setViewControllers([viewControllerList[currentPageIndex + 1]], direction: .forward, animated: true)
        currentPageIndex += 1
        
    }
    
    @objc func backButtonPressed() {
        guard currentPageIndex > 0 else { return }
        updateProgressView(index: (currentPageIndex + 1))
        pageViewController.setViewControllers([viewControllerList[currentPageIndex]], direction: .forward, animated: true)
        currentPageIndex -= 1
    }
    
    private func initViews() {
        let backButton = UIBarButtonItem(title: "", style: .plain, target: self, action: #selector(backButtonPressed))
        backButton.tintColor = .mainColor
        navigationItem.backBarButtonItem = backButton
        
        let nextButton = UIBarButtonItem(title: "Next", style: .done, target: self, action: #selector(nextButtonPressed))
        nextButton.tintColor = .mainColor
        let attributes: [NSAttributedString.Key : Any] = [
            .font: UIFont.systemFont(ofSize: 20, weight: .medium)
        ]
        nextButton.setTitleTextAttributes(attributes, for: .normal)
        navigationItem.rightBarButtonItem = nextButton
        
        if let firstVC = viewControllerList.first {
            pageViewController.setViewControllers([firstVC], direction: .forward, animated: true)
        }
        
        self.addChild(pageViewController)
        self.view.insertSubview(pageViewController.view, at: 0)
        pageViewController.didMove(toParent: self)
        
        view.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(10)
        }
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
        guard let viewControllerIndex = viewControllerList.firstIndex(of: viewController) else { return nil }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < viewControllerList.count else { return nil }
        return viewControllerList[nextIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if completed, let currentViewController = pageViewController.viewControllers?.first,
           let currentIndex = viewControllerList.firstIndex(of: currentViewController) {
            currentPageIndex = currentIndex
            updateProgressView(index: currentPageIndex + 1)
        }
    }
}
