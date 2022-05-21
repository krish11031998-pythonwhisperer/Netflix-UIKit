//
//  HomeViewController.swift
//  Netflix
//
//  Created by Krishna Venkatramani on 09/05/2022.
//

import UIKit

class HomeViewController: UIViewController {

    
    var sectionTitles:[String] = ["Trending Movies","Trending TV","Popular","Upcoming Movies","Top Rated"]
    var sectionMovies = [String:[MovieData]]()
    
    private let homeFeedTable:UITableView = {
        let table = UITableView(frame: .zero,style: .grouped)
        table.register(CollectionTableViewCell.self, forCellReuseIdentifier: CollectionTableViewCell.identifier)
        table.showsVerticalScrollIndicator = false
        return table
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.homeFeedTable)
        self.configNavbar()
        self.homeFeedTable.tableHeaderView = HeroHeaderVIew(frame: .init(x: 0, y: 0, width: self.view.bounds.width, height: self.view.bounds.height * 0.65))
        self.homeFeedTable.delegate = self
        self.homeFeedTable.dataSource = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.homeFeedTable.frame = self.view.bounds
    }
    
    private func configNavbar(){
        guard var image = UIImage(named: "netflixLogo") else {return}
        image = image.withRenderingMode(.alwaysOriginal)
        let imageTabBarItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        navigationItem.leftBarButtonItem = imageTabBarItem
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: .init(systemName: "person"), style: .done, target: self, action: nil),
            UIBarButtonItem(image: .init(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    func handleMovieSelection( _ movie:MovieData){
        let movieDetailVC = MovieDetailViewController()
        movieDetailVC.updateView(movie)
        self.navigationController?.pushViewController(movieDetailVC, animated: true)
    }

}


extension HomeViewController:UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionTitles.count
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: CollectionTableViewCell.identifier, for: indexPath) as? CollectionTableViewCell{
            switch indexPath.section{
            case SectionType.TrendingMovies.rawValue:
                TMDBAPI.shared.fetchTrendingMovies(completion: cell.innerViewBuilderwithResult(result:))
            case SectionType.TredningTV.rawValue:
                TMDBAPI.shared.fetchPopularTV(completion: cell.innerViewBuilderwithResult(result:))
            case SectionType.TopRated.rawValue:
                TMDBAPI.shared.fetchTopRatedMovies(completion: cell.innerViewBuilderwithResult(result:))
            case SectionType.Upcoming.rawValue:
                TMDBAPI.shared.fetchUpcomingMovies(completion: cell.innerViewBuilderwithResult(result:))
            case SectionType.Popular.rawValue:
                TMDBAPI.shared.fetchPopularMovies(completion: cell.innerViewBuilderwithResult(result:))
            default:
                print("Invalid section")
            }
            cell.handleMovieSelection = self.handleMovieSelection(_:)
            return cell
        } else{
            return UITableViewCell()
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * 0.225
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section >= 0 && section < self.sectionTitles.count{
            return self.sectionTitles[section]
        }else{
            return nil
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .boldSystemFont(ofSize: 20)
        header.textLabel?.textColor = .white
        header.textLabel?.text = header.textLabel?.text?.capitalized
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = self.view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        self.navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0,-offset))

    }
}
