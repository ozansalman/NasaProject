//
//  ViewController.swift
//  Nasa
//
//  Created by Ozan Salman on 18.07.2022.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var tabsView: TabsView!
    var currentIndex: Int = 0
    var pageController: UIPageViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        setupPageViewController()
        //tabsView.frame = CGRect(x: 0, y: 70, width: view.frame.size.width, height: 60)
        self.tabsView.collectionView.selectItem(at: IndexPath(item: 0, section: 0), animated: true, scrollPosition: .centeredVertically)
        fatalError("Crash was triggered")
    }
    
    func setupTabs() {
        tabsView.tabs = [
            Tab(icon: UIImage(named: ""), title: "Curiosity"),
            Tab(icon: UIImage(named: ""), title: "Opportunity"),
            Tab(icon: UIImage(named: ""), title: "Spirit")
        ]
        tabsView.tabMode = .fixed
        tabsView.titleColor = .black
        tabsView.iconColor = .white
        tabsView.indicatorColor = UIColor.red
        tabsView.titleFont = UIFont.systemFont(ofSize: 14, weight: .regular)
        tabsView.backgroundColor = UIColor.green
        tabsView.delegate = self
    }
    
    func setupPageViewController() {
        self.pageController = storyboard?.instantiateViewController(withIdentifier: "TabsPageViewController") as! TabsPageViewController
        self.addChild(self.pageController)
        self.view.addSubview(self.pageController.view)
        pageController.delegate = self
        pageController.dataSource = self
        pageController.setViewControllers([showViewController(0)!], direction: .forward, animated: true, completion: nil)
        self.pageController.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.pageController.view.topAnchor.constraint(equalTo: self.tabsView.bottomAnchor),
            self.pageController.view.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.pageController.view.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.pageController.view.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        self.pageController.didMove(toParent: self)
    }

    func showViewController(_ index: Int) -> UIViewController? {
        if (self.tabsView.tabs.count == 0) || (index >= self.tabsView.tabs.count) {
            return nil
        }
        currentIndex = index
        if index == 0 {
            let contentVC = storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
            contentVC.pageIndex = index
            return contentVC
        } else if index == 1 {
            let contentVC = storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
            contentVC.pageIndex = index
            return contentVC
        } else if index == 2 {
            let contentVC = storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
            contentVC.pageIndex = index
            return contentVC
        } else {
            let contentVC = storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as! ResultViewController
            contentVC.pageIndex = index
            return contentVC
        }
    }
}

extension ViewController: TabsDelegate {
    func tabsViewDidSelectItemAt(position: Int) {
        if position != currentIndex {
            if position > currentIndex {
                self.pageController.setViewControllers([showViewController(position)!], direction: .forward, animated: true, completion: nil)
            } else {
                self.pageController.setViewControllers([showViewController(position)!], direction: .reverse, animated: true, completion: nil)
            }
            tabsView.collectionView.scrollToItem(at: IndexPath(item: position, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
}


extension ViewController: UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let vc = pageViewController.viewControllers?.first
        var index: Int
        index = getVCPageIndex(vc)
        if index == tabsView.tabs.count {
            return nil
        } else {
            index += 1
            return self.showViewController(index)
        }
    }
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let vc = pageViewController.viewControllers?.first
        var index: Int
        index = getVCPageIndex(vc)
        
        if index == 0 {
            return nil
        } else {
            index -= 1
            return self.showViewController(index)
        }
    }
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if finished {
            if completed {
                guard let vc = pageViewController.viewControllers?.first else { return }
                let index: Int
                index = getVCPageIndex(vc)
                tabsView.collectionView.selectItem(at: IndexPath(item: index, section: 0), animated: true, scrollPosition: .centeredVertically)
                tabsView.collectionView.scrollToItem(at: IndexPath(item: index, section: 0), at: .centeredHorizontally, animated: true)
            }
        }
    }
    func getVCPageIndex(_ viewController: UIViewController?) -> Int {
        switch viewController {
        case is ResultViewController:
            let vc = viewController as! ResultViewController
            return vc.pageIndex
        default:
            let vc = viewController as! ResultViewController
            return vc.pageIndex
        }
    }
}
