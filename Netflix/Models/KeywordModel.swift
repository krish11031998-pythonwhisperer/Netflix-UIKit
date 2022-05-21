//
//  KeywordModel.swift
//  Netflix
//
//  Created by Krishna Venkatramani on 19/05/2022.
//

import Foundation

struct KeywordData:Codable{
    var name:String?
    var id:Int?
}

struct KeywordResponse:Codable{
    var page:Int?
    var results:[KeywordData]?
    var total_pages:Int?
    var total_results:Int?
    
    
    static func parseKeywordFromResponse(result:Result<Data,Error>, completion:@escaping ((Result<[KeywordData],DataError>) -> Void)){
        switch result{
        case .success(let data):
            do{
                let response = try JSONDecoder().decode(KeywordResponse.self, from: data)
                if let keywords = response.results{
                    completion(.success(keywords))
                }else{
                    completion(.failure(.dataMissing))
                }
            }catch{
                completion(.failure(.dataParse))
            }
        case .failure(let err):
            print("(Error) err : ",err.localizedDescription)
            completion(.failure(.noData))
        }
    }
}
