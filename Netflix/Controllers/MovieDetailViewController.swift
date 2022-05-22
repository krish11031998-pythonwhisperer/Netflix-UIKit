//
//  MovieDetailViewController.swift
//  Netflix
//
//  Created by Krishna Venkatramani on 19/05/2022.
//

import UIKit

class MovieDetailViewController: UIViewController {

    public var movie:MovieData? = nil
    private var movieDetail:MovieDetail? = nil
    
    public var handlePopController:(() -> Void)? = nil
    
    // MARK: - ScrollView
    private let scrollView:UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.backgroundColor = .black
        return scrollView
    }()
    
    // MARK: - MovieTitle
    
    private let titleView:UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 35, weight: .semibold)
        label.numberOfLines = Int.max
        return label
    }()
    

    private let headerGenreStack:UIStackView = {
        let stack = UIStackView()
        stack.spacing = 5
        stack.axis = .vertical
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    
    private lazy var genreLabels:[UIView] = {
        guard let genres = self.movieDetail?.genres else {
            return []
        }
        var genreLabels:[UIView] = []
        for count in 0..<genres.count{
            let genre = genres[count]
            
            if count != 0{
                let dot = UIView()
                dot.backgroundColor = .red
                dot.translatesAutoresizingMaskIntoConstraints = false
                dot.widthAnchor.constraint(equalToConstant: 10).isActive = true
                dot.heightAnchor.constraint(equalToConstant: 10).isActive = true
                dot.layer.cornerRadius = 5
                genreLabels.append(dot)
            }

            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            label.font = .systemFont(ofSize: 11, weight: .medium)
            label.textColor = .white
            label.textAlignment = .center
            label.text = genre.name ?? "GenreNameX"
            genreLabels.append(label)
        }
        return genreLabels
    }()
    
    private lazy var genreStack:UIStackView = {
        let stack = UIStackView(arrangedSubviews: self.genreLabels)
        stack.axis = .horizontal
        stack.spacing = 5
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        return stack
    }()
    
    func updateMovieTitle(){
        if let safeTitle = self.movieDetail?.title{
            self.titleView.text  = safeTitle
        }
    }
    
    // MARK: - MovieInfo
    private let movieInfo:UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 13, weight: .medium)
        label.numberOfLines = Int.max
        return label
    }()
    
    private func updateMovieInfo(){
        if let safeInfo = self.movieDetail?.overview{
            self.movieInfo.text  = safeInfo
        }
    }
    
    // MARK: - MovieMetric
    
    private lazy var metricHeader:UILabel = {
        return self.sectionHeaderBuilder(title: "Metrics")
    }()
    
    private let metricStack:UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.distribution = .fillEqually
        return stack
    }()
    
    private let voteCountMetric:UIView = {
        return HeaderBodyView()
    }()
    
    private let voteAvgMetric:UIView = {
        return HeaderBodyView()
    }()
    
    private let popularityMetric:UIView = {
        return HeaderBodyView()
    }()
    
    private func updateMovieMetricView(){
        if let popularity = self.movieDetail?.popularity{
            if let safePopularity = self.popularityMetric as? HeaderBodyView{
                safePopularity.updateUI(header: "Popularity", body: "\(popularity)")
            }
        }
        
        if let voteAvg = self.movieDetail?.vote_average{
            if let safeVoteAvg = self.voteAvgMetric as? HeaderBodyView{
                safeVoteAvg.updateUI(header: "Vote Average", body: "\(voteAvg)")
            }
        }
        
        if let voteCount = self.movieDetail?.vote_count{
            if let safeVoteCount = self.voteCountMetric as? HeaderBodyView{
                safeVoteCount.updateUI(header: "Vote Count", body: "\(voteCount)")
            }
        }
    }
    
    // MARK: - CloseButton
    private let closeButton:UIButton = {
        let button = UIButton()
        if let img = UIImage(systemName: "xmark",withConfiguration: UIImage.SymbolConfiguration(pointSize: 15)){
            button.translatesAutoresizingMaskIntoConstraints = false
            button.setImage(img, for: .normal)
            button.tintColor = .white
            button.imageView?.contentMode = .scaleAspectFill
            button.backgroundColor = .black
            button.imageView?.clipsToBounds = true
        }
        
        button.backgroundColor = UIColor.black
        button.tintColor = .white
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 0.35
        
        return button
        
    }()
    
    @objc func handleClose(){
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Movie Images
    private let posterImage:UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = .init(named: "placeHolder")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 0.85
        imageView.layer.cornerRadius = 8
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    
    private let backdropPosterView:UIImageView =  {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = .init(named: "placeHolder")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.cgColor
        ]
        imageView.layer.addSublayer(gradientLayer)
        return imageView
    }()
    
    private func updateMovieImages(){
        if let backdropImage = self.movieDetail?.backdrop_path{
            TMDBAPI.shared.loadImage(posterPath: backdropImage) { [weak self] result in
                switch result{
                case .success(let image):
                    DispatchQueue.main.async {
                        self?.backdropPosterView.image = image
                    }
                case .failure(let err):
                    print("(Error) err :",err)
                }
            
            }
        }
        
        if let posterImage = self.movieDetail?.poster_path{
            TMDBAPI.shared.loadImage(posterPath: posterImage) { [weak self] result in
                switch result{
                case .success(let image):
                    DispatchQueue.main.async {
                        self?.posterImage.image = image
                    }
                case .failure(let err):
                    print("(DEBUG) err : ",err)
                }
                
            }
        }
    }
    
    // MARK: - ProducersSection
    private var producerSection:UICollectionView = {
        let collectionLayout = UICollectionViewFlowLayout()
        collectionLayout.itemSize = .init(width:150,height:150)
        collectionLayout.scrollDirection = .horizontal
        collectionLayout.minimumInteritemSpacing = 5
        let collection = UICollectionView(frame: .zero,collectionViewLayout: collectionLayout)
        collection.register( ProducerInfoView.self, forCellWithReuseIdentifier: ProducerInfoView.identifier)
        collection.showsHorizontalScrollIndicator = false
        collection.translatesAutoresizingMaskIntoConstraints = false
        return collection
    }()
    
    
    private lazy var producersTitle:UILabel = {
        return self.sectionHeaderBuilder(title: "Producer")
    }()
    
    // MARK: - CastSection
    
    private lazy var castSectionTitle:UILabel = {
        return self.sectionHeaderBuilder(title: "Cast")
    }()
    
    private lazy var castCollection:MovieCastCollectionView = {
        let collectionView = MovieCastCollectionView()
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    // MARK: - viewDidLoadSection
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.isHidden = true
                
        
        //ScrollView
        self.view.addSubview(self.scrollView)
        
        //Close Button
        self.closeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.handleClose)))
        self.backdropPosterView.addSubview(self.closeButton)
        
        //TitleView
        self.scrollView.addSubview(self.titleView)
        self.scrollView.addSubview(self.genreStack)
        
        //BackDropView
        self.scrollView.addSubview(self.backdropPosterView)
        
        //PosterView
        self.scrollView.addSubview(self.posterImage)
        
        //MovieInfoView
        self.scrollView.addSubview(self.movieInfo)
        
        //VoteCountMetric
        self.metricStack.addArrangedSubview(self.voteCountMetric)
        self.metricStack.addArrangedSubview(self.voteAvgMetric)
        self.metricStack.addArrangedSubview(self.popularityMetric)
        
        //MetricStack
        self.scrollView.addSubview(self.metricHeader)
        self.scrollView.addSubview(self.metricStack)
        
        //Producer
        self.scrollView.addSubview(self.producersTitle)
        
        self.producerSection.delegate = self
        self.producerSection.dataSource = self
        self.scrollView.addSubview(self.producerSection)
        
        
        //Cast
        self.scrollView.addSubview(self.castSectionTitle)
        self.scrollView.addSubview(self.castCollection)
    
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.scrollView.frame = self.view.bounds
        self.scrollView.contentSize = .init(width: self.view.bounds.width, height: self.view.bounds.height * 2)
        self.setupLayout()
    }
    
    func setupLayout(){

        
        //backButton
        self.closeButton.trailingAnchor.constraint(equalTo: self.backdropPosterView.trailingAnchor, constant: -10).isActive = true
        self.closeButton.topAnchor.constraint(equalTo: self.backdropPosterView.topAnchor, constant: 10).isActive = true
        self.closeButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        self.closeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        self.closeButton.layer.cornerRadius = self.closeButton.frame.width * 0.5
        
        
        //backdropimage
        self.backdropPosterView.topAnchor.constraint(equalTo: self.scrollView.topAnchor).isActive = true
        self.backdropPosterView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor).isActive = true
        self.backdropPosterView.widthAnchor.constraint(equalToConstant: self.view.bounds.width).isActive = true
        self.backdropPosterView.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.35).isActive = true
        
        //posterImage
        self.posterImage.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor,constant: 10).isActive = true
        self.posterImage.centerYAnchor.constraint(equalTo: self.backdropPosterView.bottomAnchor).isActive = true
        self.posterImage.widthAnchor.constraint(equalToConstant: self.view.bounds.width * 0.35).isActive = true
        self.posterImage.heightAnchor.constraint(equalToConstant: self.view.bounds.height * 0.2).isActive = true
        
        //titleView
        self.titleView.topAnchor.constraint(equalTo: self.posterImage.bottomAnchor, constant: 15).isActive = true
        self.titleView.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor, constant: 10).isActive = true
        self.titleView.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 20).isActive = true
        
        
        //movieInfoView
        self.movieInfo.topAnchor.constraint(equalTo: self.titleView.bottomAnchor,constant: 50).isActive = true
        self.movieInfo.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor,constant: 10).isActive = true
        self.movieInfo.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 20).isActive = true
        
        
        //MetricStack
        self.metricHeader.topAnchor.constraint(equalTo: self.movieInfo.bottomAnchor,constant: 20).isActive = true
        self.metricHeader.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor,constant: 10).isActive = true
        self.metricHeader.widthAnchor.constraint(equalToConstant: self.metricHeader.intrinsicContentSize.width + 5).isActive = true
        self.metricHeader.heightAnchor.constraint(equalToConstant: self.metricHeader.intrinsicContentSize.height).isActive = true
        
        self.metricStack.topAnchor.constraint(equalTo: self.metricHeader.bottomAnchor,constant: 10).isActive = true
        self.metricStack.leadingAnchor.constraint(equalTo: self.view.leadingAnchor,constant: 10).isActive = true
        self.metricStack.trailingAnchor.constraint(equalTo: self.view.trailingAnchor,constant: -10).isActive = true
        self.metricStack.topAnchor.constraint(equalTo: self.metricHeader.bottomAnchor,constant: 15).isActive = true
        
        //ProducerCollection
        self.producersTitle.topAnchor.constraint(equalTo: self.metricStack.bottomAnchor,constant: 20).isActive = true
        self.producersTitle.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor,constant: 10).isActive = true
        self.producersTitle.widthAnchor.constraint(equalToConstant: self.producersTitle.intrinsicContentSize.width + 5).isActive = true
        self.producersTitle.heightAnchor.constraint(equalToConstant: self.producersTitle.intrinsicContentSize.height).isActive = true
        
        self.producerSection.topAnchor.constraint(equalTo: self.producersTitle.bottomAnchor,constant: 10).isActive = true
        self.producerSection.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 10).isActive = true
        self.producerSection.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 20).isActive = true
        self.producerSection.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        //genreStack
//        self.genreStack.leadingAnchor.constraint(equalTo:self.view.leadingAnchor,constant: 10).isActive = true
//        self.genreStack.widthAnchor.constraint(equalToConstant: self.genreLabels.compactMap({$0.intrinsicContentSize.width + 10}).reduce(0, {$0 + $1})).isActive = true
//        self.genreStack.heightAnchor.constraint(equalToConstant: self.genreLabels.first?.intrinsicContentSize.height ?? 100).isActive = true
//        self.genreStack.topAnchor.constraint(equalTo: self.titleView.bottomAnchor,constant: 10).isActive = true
        
        //castCollection
        self.castSectionTitle.topAnchor.constraint(equalTo: self.producerSection.bottomAnchor,constant: 20).isActive = true
        self.castSectionTitle.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor,constant: 10).isActive = true
        self.castSectionTitle.widthAnchor.constraint(equalToConstant: self.castSectionTitle.intrinsicContentSize.width + 5).isActive = true
        self.castSectionTitle.heightAnchor.constraint(equalToConstant: self.castSectionTitle.intrinsicContentSize.height).isActive = true
        
    
        self.castCollection.topAnchor.constraint(equalTo: self.castSectionTitle.bottomAnchor,constant: 10).isActive = true
        self.castCollection.leadingAnchor.constraint(equalTo: self.scrollView.leadingAnchor,constant: 10).isActive = true
        self.castCollection.widthAnchor.constraint(equalToConstant: self.view.bounds.width - 20).isActive = true
        self.castCollection.heightAnchor.constraint(equalToConstant: self.scrollView.bounds.height * 0.5).isActive = true
    }
    
    private func fetchMovieDetail(_ movie_id:String){
        TMDBAPI.shared.fetchMovieDetail(movie_id: movie_id) { [weak self] result in
            switch result{
            case .success(let movieDetail):
                self?.movieDetail = movieDetail
                self?.updateUIWithMovieDetail()
                self?.fetchMovieCast(movie_id: movie_id)
            case .failure(let err):
                print("(Err) err : ",err.localizedDescription)
            }
        }
    }
    
    func fetchMovieCast(movie_id:String){
        TMDBAPI.shared.fetchMovieCasts(movie_id: movie_id) { [weak self] result in
            switch result{
            case .success(let cast):
                if let actors = cast.cast{
                    self?.castCollection.updateCollectionWithMovieCastCrew(actors)
                }
            case .failure(let err):
                print("(Error) err : ",err.localizedDescription)
            }
        }
    }
    
    
    func updateUIWithMovieDetail(){
        DispatchQueue.main.async {
            
            //Update Movie Title
            self.updateMovieTitle()
            
            //Update Movie Info
            self.updateMovieInfo()
            
            //Update Movie Images
            self.updateMovieImages()
            
            //Update Movie Metrics
            self.updateMovieMetricView()
            
            //Update Movie Genre
            for label in self.genreLabels{
                self.genreStack.addArrangedSubview(label)
            }
            self.scrollView.addSubview(self.genreStack)
            self.genreStack.leadingAnchor.constraint(equalTo:self.view.leadingAnchor,constant: 10).isActive = true
            self.genreStack.widthAnchor.constraint(equalToConstant: self.genreLabels.compactMap({$0.intrinsicContentSize.width + 10}).reduce(0, {$0 + $1})).isActive = true
            self.genreStack.heightAnchor.constraint(equalToConstant: self.genreLabels.first?.intrinsicContentSize.height ?? 100).isActive = true
            self.genreStack.topAnchor.constraint(equalTo: self.titleView.bottomAnchor,constant: 10).isActive = true
            
            //Reload
            self.producerSection.reloadData()
        }
    }
    
    
    public func updateView(_ movie:MovieData){

        if let id = movie.id{
            self.fetchMovieDetail("\(id)")
        }
    }
    
    private func sectionHeaderBuilder(title:String,size:CGFloat = 22.5) -> UILabel{
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: size, weight: .semibold)
        label.text = title
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }

}


extension MovieDetailViewController:UICollectionViewDelegate,UICollectionViewDataSource{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.movieDetail?.production_companies?.count ?? 0
    }
 
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProducerInfoView.identifier, for: indexPath) as? ProducerInfoView else{
            return UICollectionViewCell()
        }
        if let producers = self.movieDetail?.production_companies,indexPath.row < producers.count{
            cell.updateView(producers[indexPath.row])
        }
        return cell
    }
    
}
