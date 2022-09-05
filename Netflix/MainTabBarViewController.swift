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
        view.backgroundColor = .systemYellow
        let navViews = [self.InitializeTabViewController(tab:.home),
        InitializeTabViewController(tab: .search),
		InitializeTabViewController(tab: .upcoming)].compactMap{ $0 }
        setViewControllers(navViews, animated: true)
        tabBar.tintColor = .label
        tabBar.layer.cornerRadius = 10;
        tabBar.layer.backgroundColor = .init(red: 255, green: 255, blue: 255, alpha: 0.5)
    }
    
    func InitializeTabViewController(tab:TabBarModel) -> UINavigationController? {
        var vc:UIViewController? = nil
        switch(tab){
            case .home:
                vc = HomeViewController()
            case .search:
                vc = SearchViewController()
            case .upcoming:
                vc = UpcomingViewController()
			default:
				break
        }
	
		guard let validVC = vc else { return nil }
		
        let navView = UINavigationController(rootViewController: validVC)
        navView.tabBarItem = .init(title: tab.TabBarItemStyling.title, image: .init(systemName: tab.TabBarItemStyling.icon), tag: 1)
        return navView
        
    }


}

