//
//  TabItemModel.swift
//  Netflix
//
//  Created by Krishna Venkatramani on 09/05/2022.
//

import Foundation

enum TabBarModel{
    case home
    case search
    case upcoming
    case downloads
}

extension TabBarModel{
    var TabBarItemStyling:(title:String,icon:String){
        switch(self){
        case .home:
            return (title:"Home",icon:"house")
        case .search:
            return (title:"Search",icon:"magnifyingglass")
        case .downloads:
            return (title:"Downloads",icon:"arrow.down")
        case .upcoming:
            return (title:"Upcoming",icon:"play.circle")
        }
    }
}
