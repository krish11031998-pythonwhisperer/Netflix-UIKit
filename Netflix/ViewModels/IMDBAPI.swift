//
//  IMDBAPI.swift
//  Netflix
//
//  Created by Krishna Venkatramani on 21/05/2022.
//

import Foundation

enum IMDBEndpoints:String{
    case trailer = "Trailer"
    case fullCast = "FullCast"
}

class IMDBAPI{

    class Constants{
        static let baseURL = "https://imdb-api.com/API"
        static let apiKey = "k_xwxzyh48"
    }
    
    init(){}
    
    
    static var shared = IMDBAPI()
    
    
    func URLBuilder(endpoint:String,params:[String] = []) -> URL?{
        var urlComponents = URLComponents(string: Constants.baseURL)
        urlComponents?.path =  "/\(endpoint)" + params.reduce("", {$0 + "/" + $1})
        return urlComponents?.url
    }
    
    
    func fetchIMDBData(endpoint:IMDBEndpoints,params:[String],completion: @escaping ((Result<Data,DataError>) -> Void)){
        guard let safeURL = self.URLBuilder(endpoint: endpoint.rawValue, params: params) else {
            completion(.failure(.invalidURL))
            return
        }
        let dataTask = URLSession.shared.dataTask(with: safeURL) { data, response, err in
            if let resp = response as? HTTPURLResponse, resp.statusCode >= 400 && resp.statusCode < 500{
                completion(.failure(.responseStatusInvalid))
                return
            }
            
            
            guard let safeData = data else {
                if let safeErr = err{
                    print("(Error) err : ",safeErr.localizedDescription)
                }
                completion(.failure(.noData))
                return
            }
            
            DataCache.shared[safeURL] = safeData
            
            completion(.success(safeData))
        }
        
        dataTask.resume()
    }
    
    
    func fetchCastForMovie(movieID:String){
        self.fetchIMDBData(endpoint: .fullCast, params: [movieID]) { result in
            switch result{
            case .success(let data):
                break
            case .failure(let err):
                print("(Error) err : ",err.localizedDescription)
            }
        }
    }
    

}
