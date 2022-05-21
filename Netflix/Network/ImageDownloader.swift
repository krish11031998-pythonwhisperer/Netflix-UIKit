//
//  ImageDownloader.swift
//  Netflix
//
//  Created by Krishna Venkatramani on 17/05/2022.
//

import Foundation
import UIKit

enum ImageDownloaderError: String,Error{
    case invalidURL = "Invalid URL Provided"
    case responseStatusFailed = "Response Status Code suggests failed data fetch"
    case dataNotFetched = "Data not fetched"
}

protocol ImageDictCache{
    subscript(_ url:URL) -> UIImage? { get set }
}

public struct ImageCache:ImageDictCache{
    private let cache:NSCache<NSURL, UIImage> = {
        let cache = NSCache<NSURL,UIImage>()
        cache.countLimit = 500;
        cache.totalCostLimit = 1024 * 1024 * 500
        return cache
    }()
    static var cache = ImageCache()
    public subscript(url: URL) -> UIImage? {
        get{
            var res : UIImage? = nil
            if let url = url as? NSURL{
                res = self.cache.object(forKey: url)
            }
            return res
        }
        set{
            guard let img = newValue, let url = url as? NSURL else {return}
            self.cache.setObject(img, forKey: url)
        }
    }
}


class ImageDownloader{
    
    static var shared = ImageDownloader()

    func fetchImage(urlStr:String,completion:@escaping ((Result<UIImage,ImageDownloaderError>) -> Void)){
        guard let safeURL = URL(string: urlStr) else{
            completion(.failure(.invalidURL))
            print("(Error) the url is not valid: Damaged => ")
            return
        }
        
        if let image = ImageCache.cache[safeURL]{
            completion(.success(image))
        }else{
            URLSession.shared.dataTask(with: safeURL) { data , response, err in
                if let safeResponse = response as? HTTPURLResponse,safeResponse.statusCode >= 400 && safeResponse.statusCode < 500{
                    print("(Error) the response was not fetched status : ",safeResponse.statusCode)
                    completion(.failure(.responseStatusFailed))
                    return
                }
                
                guard let safeData = data,let image = UIImage(data: safeData) else {
                    if let safeError = err{
                        completion(.failure(.dataNotFetched))
                        print("(Error) Error while fetching : ",safeError.localizedDescription)
                    }
                    return
                }
                
                ImageCache.cache[safeURL] = image
                
                completion(.success(image))
                
                
                
            }.resume()
        }
    }
    
}

