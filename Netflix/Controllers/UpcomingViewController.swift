//
//  UpcomingViewController.swift
//  Netflix
//
//  Created by Krishna Venkatramani on 09/05/2022.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    private var upcomingTableView:UITableView = {
       let tableView = UITableView()
        tableView.register(MoviePreviewCard.self, forCellReuseIdentifier: MoviePreviewCard.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.showsVerticalScrollIndicator = false
        return tableView
    }()
    
    private var upcomingMovies = [MovieData]()
    
    
    private var sections = ["For You","New Suggestions"]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationItem.largeTitleDisplayMode = .always
        self.title = "Upcoming"
        self.view.addSubview(self.upcomingTableView)
        self.upcomingTableView.dataSource = self
        self.upcomingTableView.delegate = self
        self.fetchUpcomingMovies()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.upcomingTableView.frame = self.view.bounds.insetBy(dx: 10, dy: 10)
    }
        
    private func fetchUpcomingMovies(){
        TMDBAPI.shared.fetchUpcomingMovies {[weak self] result in
            switch result{
                case .success(let movies):
                print("(DEBUG) succesfully got movies : ",movies.isEmpty)
                    self?.upcomingMovies = movies
                    DispatchQueue.main.async {
                        self?.upcomingTableView.reloadData()
                    }
                    
                case .failure(let error):
                    print("(Error) : ",error.localizedDescription)
            }
        }
    }

}

extension UpcomingViewController:UITableViewDelegate,UITableViewDataSource{
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.upcomingMovies.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MoviePreviewCard.identifier, for: indexPath) as? MoviePreviewCard else {
            return UITableViewCell()
        }
        if !self.upcomingMovies.isEmpty{
            cell.subviews.forEach({
                if $0.accessibilityIdentifier == "loadingView"{
                    $0.removeFromSuperview()
                }
            })
            cell.updateView(self.upcomingMovies[indexPath.section])
        }else{
            let textView = UITextView()
            textView.accessibilityIdentifier = "loadingView"
            textView.translatesAutoresizingMaskIntoConstraints = false
            textView.frame = .init(x: cell.bounds.minX + 10, y: cell.bounds.minY + 10, width: 100, height: 100)
            textView.backgroundColor = .clear
            textView.text = "Loading"
            textView.textColor = .white
            textView.font = .boldSystemFont(ofSize: 15)
            cell.addSubview(textView)
            cell.backgroundColor = .clear
        }
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * 0.4
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let clearView = UIView()
        clearView.backgroundColor = .clear
        return clearView
    }
    
}
