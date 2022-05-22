//
//  CastModel.swift
//  Netflix
//
//  Created by Krishna Venkatramani on 21/05/2022.
//

import Foundation

struct CastModel:Codable{
    var id:Int?
    var cast:[Actor]?
    var crew:[Crew]?
}

// MARK: - Actor
struct Actor:Codable{
    var adult:Bool?
    var gender:Int?
    var id:Int?
    var known_for_department,name,original_name,profile_path:String?
    var popularity:Double?
    var cast_id:Int?
    var character:String?
    var credit_id:String?
    var order:Int?
}


extension CastModel {
    static func parseCastModelFromData(data:Data,completion:@escaping ((Result<CastModel,DataError>) -> Void)){
        let decoder = JSONDecoder()
        do{
            let cast = try decoder.decode(CastModel.self, from: data)
            completion(.success(cast))
        }catch{
            print("(Error) there was an error while parsing the castModel from Data : ",error.localizedDescription)
            completion(.failure(.dataParse))
        }
    }
}

typealias Crew = Actor
