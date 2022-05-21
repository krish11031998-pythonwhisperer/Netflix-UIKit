//
//  MovieModel.swift
//  Netflix
//
//  Created by Krishna Venkatramani on 17/05/2022.
//

import Foundation


// MARK: - Movie Data
struct MovieData: Codable {
    let adult: Bool?
    let backdropPath: String?
    let genreIDS: [Int]?
    let id: Int?
    let originalLanguage: String?
    let originalTitle, overview: String?
    let popularity: Double?
    let posterPath, releaseDate, title,name,original_name: String?
    let video: Bool?
    let voteAverage: Double?
    let voteCount: Int?

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video,name,original_name
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}


struct MovieResponse: Codable {
    let page: Int?
    let results: [MovieData]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
    
    static func parseMovieListFromData(data:Data,completion:@escaping (Result<[MovieData],DataError>) -> Void){
        do{
            let response = try JSONDecoder().decode(MovieResponse.self, from: data)
            if let movies = response.results{
                completion(.success(movies))
            }else{
                completion(.failure(.dataMissing))
            }
        }catch{
            completion(.failure(.noData))
        }
    }
    
}


// MARK: - MovieDetail
struct MovieDetail:Codable{
    var adult:Bool?
    var backdrop_path:String?
    var belongs_to_collection:MovieCollection?
    var budget:Int?
    var genres:[MovieGenre]?
    var homepage:String?
    var id:Int?
    var imdb_id,original_language,title,original_title,overview:String?
    var popularity: Double?
    var poster_path, releaseDate,tagline,status: String?
    var revenue,runtime: Int?
    var video: Bool?
    var vote_average: Double?
    var vote_count: Int?
    var production_companies:[MovieProductionCompany]?
    
}


struct MovieProductionCompany:Codable{
    var id:Int?
    var logo_path:String?
    var name:String?
    var origin_country:String?
}

struct MovieCollection:Codable{
    var id:Int?
    var name:String?
    var poster_path:String?
    var backdrop_path:String?
}


struct MovieGenre:Codable{
    var id:Int?
    var name:String?
}


