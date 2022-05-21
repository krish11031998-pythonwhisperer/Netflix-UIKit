//
//  ViewController.swift
//  Netflix
//
//  Created by Krishna Venkatramani on 09/05/2022.
//

import UIKit

class MainTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemYellow
        let navViews = [self.InitializeTabViewController(tab:.home),
        self.InitializeTabViewController(tab: .downloads),
        self.InitializeTabViewController(tab: .search),
        self.InitializeTabViewController(tab: .upcoming)]
        self.setViewControllers(navViews, animated: true)
        self.tabBar.tintColor = .label
        self.tabBar.layer.cornerRadius = 10;
        self.tabBar.layer.backgroundColor = .init(red: 255, green: 255, blue: 255, alpha: 0.5)
    }
    
    func InitializeTabViewController(tab:TabBarModel) -> UINavigationController{
        var vc:UIViewController
        switch(tab){
            case .home:
                vc = HomeViewController()
            case .search:
                vc = SearchViewController()
            case .upcoming:
                vc = UpcomingViewController()
            case .downloads:
                vc = DownloadsViewController()
        }
        
        let navView = UINavigationController(rootViewController: vc)
        navView.tabBarItem = .init(title: tab.TabBarItemStyling.title, image: .init(systemName: tab.TabBarItemStyling.icon), tag: 1)
        return navView
        
    }


}

