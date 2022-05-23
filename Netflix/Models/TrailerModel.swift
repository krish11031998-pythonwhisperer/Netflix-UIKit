//
//  TrailerModel.swift
//  Netflix
//
//  Created by Krishna Venkatramani on 21/05/2022.
//

import Foundation

struct MovieVideoResponse:Codable{
    var id:Int?
    var results:[MovieVideoModel]?
    
    
    static func parseMovieVideoFromData(data:Data,completion:@escaping ((Result<[MovieVideoModel],DataError>) -> Void)){
        let decoder = JSONDecoder()
        do{
            let resp = try decoder.decode(MovieVideoResponse.self, from: data)
            if let safeVideos = resp.results{
                completion(.success(safeVideos))
            }else{
                completion(.failure(.dataMissing))
            }
        }catch{
            print("(Error) err : ",error.localizedDescription)
            completion(.failure(.dataParse))
        }
    }
    
}

struct MovieVideoModel:Codable{
    var iso_639_1:String?
    var iso_3166_1:String?
    var name:String?
    var key:String?
    var site:String?
    var size:Int?
    var type:String?
    var official:Bool?
    var id:String?
}

//"iso_639_1": "en",
//"iso_3166_1": "US",
//"name": ""Here's To Many More Seasons" Official Clip",
//"key": "p8E02oEkVok",
//"site": "YouTube",
//"size": 1080,
//"type": "Clip",
//"official": true,
//"published_at": "2022-05-20T20:00:12.000Z",
//"id": "62887cb48d2f8d009ce44e16"
