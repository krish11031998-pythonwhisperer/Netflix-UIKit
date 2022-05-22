//
//  TrailerModel.swift
//  Netflix
//
//  Created by Krishna Venkatramani on 21/05/2022.
//

import Foundation

struct TrailerModel:Codable{
    var imDbId,title,fullTitle,type,year,videoId,videoUrl,errorMessage:String?
}

struct TrailerVideoModel:Codable{
    var videoId,title,description,duration,uploadDate,image:String?
    var videos:Array<TrailerVideoDataModel>?
}

struct TrailerVideoDataModel:Codable{
    var quality,mimeType,url,videoExtension:String?
    
    enum CodingKeys:String,CodingKey{
        case videoExtension = "extension"
        case quality
        case mimeType
        case url
    }
}
