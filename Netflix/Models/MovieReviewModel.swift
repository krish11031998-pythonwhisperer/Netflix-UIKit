//
//  MovirReviewModel.swift
//  Netflix
//
//  Created by Krishna Venkatramani on 23/05/2022.
//

import Foundation

struct MovieReviewResponse:Codable{
    var id:Int?
    var page:Int?
    var results:[MovieReviewModel]?
    
    
    static func parseMovieReviewsFromData(data:Data,completion:@escaping ((Result<[MovieReviewModel],DataError>) -> Void)){
        let decoder = JSONDecoder()
        do{
            let response = try decoder.decode(MovieReviewResponse.self, from: data)
            if let reviews = response.results{
                completion(.success(reviews))
            }else{
                completion(.failure(.dataMissing))
            }
        }catch{
            completion(.failure(.dataParse))
        }
    }
}


struct MovieReviewModel:Codable{
    var author:String?
    var author_details:MovieReviewAuthorModel?
    var content:String?
    var created_at:String?
    var id:String?
    var updated_at:String?
    var url:String?
}

struct MovieReviewAuthorModel:Codable{
    var name:String?
    var username:String?
    var avatar_path:String?
    var rating:Int?
}
