//
//  TMDB.swift
//  Netflix
//
//  Created by Krishna Venkatramani on 17/05/2022.
//

import Foundation
import UIKit

enum TMDBEndpoints:String{
    case trending = "/trending/movie/day"
    case popular = "/movie/popular"
    case topRated = "/movie/top_rated"
    case upcoming = "/movie/upcoming"
    case popularTV = "/tv/popular"
    case discoverMovies = "/discover/movie"
    case searchKeyword = "/search/keyword"
    case moviesForKeyword = "/keyword/keyword_id/movies"
    case movieDetail = "/movie/movie_id"
    case movieCast = "/movie/movie_id/credits"
    case movieVideos = "/movie/movie_id/videos"
    case movieReviews = "/movie/movie_id/reviews"
}

class TMDBAPI:DataParser{
    
    private struct Constant{
        static let APIKey = "de9f7b77079a0a63c506c9582ec4dc3e"
        static let baseAPIURL = "https://api.themoviedb.org"
    }
    
    var endpoint:TMDBEndpoints
    var params:[String:Any]
    
    init(endpoint:TMDBEndpoints = .popular,params:[String:Any] = [:]){
        self.endpoint = endpoint
        self.params = params
    }
    
    
    static var shared = TMDBAPI()
    
    func URLBuilder(endpoint:String? = nil,params:[String:String]? = nil) -> URL?{
        var urlComponents = URLComponents(string: Constant.baseAPIURL)
        urlComponents?.path = "/3" + (endpoint ?? self.endpoint.rawValue ?? "")
        urlComponents?.queryItems = [URLQueryItem(name: "api_key", value: Constant.APIKey)]
        if !(params ?? self.params).isEmpty{
            urlComponents?.queryItems?.append(contentsOf: (params ?? self.params).map({URLQueryItem(name: $0, value: $1 as? String)}))
        }
        return urlComponents?.url
    }
    
    func parseData(dataResult: Result<Data,Error>) {
        print("(DEBUG) Default Parser")
    }
    
    func dataFetchExecutor(url:URL,completion:((Result<Data,Error>) -> Void)? = nil){
        if let cacheDataForURL = DataCache.shared[url]{
            print("(DEBUG) Loading From Cache : \(url)")
            if let safeCompletion = completion{
                safeCompletion(.success(cacheDataForURL))
            }else{
                self.parseData(dataResult: .success(cacheDataForURL))
            }
        }else{
            print("(DEBUG) Fetching New Data : \(url)")
            let session = URLSession.shared.dataTask(with: url) { data, response, error in
                if let safeResponse = response as? HTTPURLResponse,safeResponse.statusCode > 400 && safeResponse.statusCode < 500{
                    print("(Error) bad error  : ",safeResponse.statusCode)
                    return
                }
                guard let safeData = data else {
                    if let error = error {
                        print("(Error) There was an error : ",error.localizedDescription)
                        completion?(.failure(error))
                    }
                    return
                }
                
                DataCache.shared[url] = safeData
                
                if let safeCompletion = completion{
                    safeCompletion(.success(safeData))
                }else{
                    self.parseData(dataResult: .success(safeData))
                }
            }
            
            session.resume()

        }
    }
    
    // MARK: - Fetch Movies
    
    func fetchMovieData(endpoint:TMDBEndpoints?=nil,endpointValue:String?=nil,params:[String:String] = [:],completion: @escaping ((Result<[MovieData],DataError>) -> Void)){
        guard let safeURL = self.URLBuilder(endpoint: endpoint?.rawValue ?? endpointValue, params: params) else {
            print("(Error) Empty URL!")
            completion(.failure(.invalidURL))
            return
        }
        self.dataFetchExecutor(url: safeURL) {result in
            switch result{
            case .success(let data):
                MovieResponse.parseMovieListFromData(data: data,completion: completion)
            case .failure(let error):
                completion(.failure(.noData))
            }
        }
    }
    
    func fetchTrendingMovies(params:[String:String] = [:],completion: @escaping ((Result<[MovieData],DataError>) -> Void)){
        self.fetchMovieData(endpoint: .trending,params: params, completion: completion)
    }
    
    func fetchPopularMovies(params:[String:String] = [:],completion: @escaping ((Result<[MovieData],DataError>) -> Void)){
        self.fetchMovieData(endpoint: .popular, params: params, completion: completion)
    }
    
    func fetchTopRatedMovies(params:[String:String] = [:],completion: @escaping ((Result<[MovieData],DataError>) -> Void)){
        self.fetchMovieData(endpoint: .topRated, params: params, completion: completion)
    }
    
    func fetchUpcomingMovies(params:[String:String] = [:],completion: @escaping ((Result<[MovieData],DataError>) -> Void)){
        self.fetchMovieData(endpoint: .upcoming, params: params, completion: completion)
    }
    
    func fetchPopularTV(params:[String:String] = [:],completion: @escaping ((Result<[MovieData],DataError>) -> Void)){
        self.fetchMovieData(endpoint: .popularTV, params: params, completion: completion)
    }
    
    func fetchDiscoverMovies(params:[String:String] = [:],completion :@escaping ((Result<[MovieData],DataError>) -> Void)){
        self.fetchMovieData(endpoint: .discoverMovies, params: params, completion: completion)
    }
    
    // MARK: - Fetch Search Keywords
    
    func fetchKeywords(query:String,page:Int = 1,completion: @escaping ((Result<[KeywordData],DataError>) -> Void)){
        let params:[String:String] = ["query":query,"page":"\(page)"]
        guard let safeURL = self.URLBuilder(endpoint: TMDBEndpoints.searchKeyword.rawValue, params: params) else {
            print("(Error) Empty URL!")
            completion(.failure(.invalidURL))
            return
        }
        self.dataFetchExecutor(url: safeURL) {result in
            KeywordResponse.parseKeywordFromResponse(result: result, completion: completion)
        }
    }
    
    // MARK: - Fetch Movies For Keyword
    func fetchMoviesForKeyword(keyword_id:String,completion:@escaping ((Result<[MovieData],DataError>) -> Void)){
        let urlPath = TMDBEndpoints.moviesForKeyword.rawValue.replacingOccurrences(of: "keyword_id", with: keyword_id)
        print("(DEBUG) urlPath : ",urlPath)
        self.fetchMovieData(endpointValue: urlPath, completion: completion)
    }
    
    
    // MARK: - Fetch Movie Detail
    func fetchMovieDetail(movie_id:String,completion:@escaping ((Result<MovieDetail,DataError>) -> Void)){
        let urlPath = TMDBEndpoints.movieDetail.rawValue.replacingOccurrences(of: "movie_id", with: movie_id)
        guard let url = self.URLBuilder(endpoint: urlPath) else {
            print("invalid URL")
            completion(.failure(.invalidURL))
            return
        }
        
        self.dataFetchExecutor(url: url) { result in
            switch result{
            case .success(let data):
                do{
                    let movieDetail = try JSONDecoder().decode(MovieDetail.self, from: data)
                    completion(.success(movieDetail))
                }catch{
                    completion(.failure(.dataParse))
                }
            case .failure(let err):
                print("(Error) err : ",err.localizedDescription)
                completion(.failure(.dataMissing))
            }
        }
    }
    
    // MARK: - Fetch Movie Cast
    func fetchMovieCasts(movie_id:String,completion:@escaping ((Result<CastModel,DataError>) -> Void)){
        let urlPath = TMDBEndpoints.movieCast.rawValue.replacingOccurrences(of: "movie_id", with: movie_id)
        guard let url = self.URLBuilder(endpoint: urlPath) else {
            completion(.failure(.invalidURL))
            return
        }
        
        self.dataFetchExecutor(url: url) { result in
            switch result{
            case .success(let data):
                CastModel.parseCastModelFromData(data: data,completion: completion)
            case .failure(let err):
                print("(Error) err : ",err.localizedDescription)
            }
        }
    }
    
    func loadImage(posterPath:String,completion:@escaping ((Result<UIImage,ImageDownloaderError>) -> Void)){
        ImageDownloader.shared.fetchImage(urlStr: "https://image.tmdb.org/t/p/w500\(posterPath)",completion: completion) 
    }
    
}
