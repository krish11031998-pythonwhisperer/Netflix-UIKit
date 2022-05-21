//
//  ErrorModel.swift
//  Netflix
//
//  Created by Krishna Venkatramani on 19/05/2022.
//

import Foundation

enum DataError:String,Error{
    case invalidURL = "The URL is empty/invalid and therefore no httpRequest commenced"
    case responseStatusInvalid = "The status Code for the response is not SUCCESS"
    case dataParse = "The Data to parse is in the incorrect format"
    case dataMissing = "The data you wish to parse is missing"
    case noData = "No Data"
}
