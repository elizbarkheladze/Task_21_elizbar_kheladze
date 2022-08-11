//
//  ApiCall.swift
//  Task_21_elizbar_kheladze
//
//  Created by alta on 8/11/22.
//

import Foundation


final class ApiCall{
    static let shared = ApiCall()
    
    
    struct Constants {
        static let url = URL(string:
        "https://restcountries.com/v2/all"
        )
        static let searchString =  "https://restcountries.com/v2/all&q="
    }
    private init(){}
    
    public func getCountry(completion: @escaping (Result<[Country],Error>) -> Void) {
        guard let url = Constants.url else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            
            else if let data = data {
                
                do{
                    let result = try JSONDecoder().decode([Country].self, from: data)
                    
                    print("countries : \(result.count)")
                    completion(.success(result))
                }
                catch{
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
    
    public func searc(with query: String,completion: @escaping (Result<[Country],Error>) -> Void) {
        guard !query.trimmingCharacters(in: .whitespaces).isEmpty else {
            return
        }
        
        let urlString = Constants.searchString + query
        guard let url = URL(string: urlString) else {
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                completion(.failure(error))
            }
            
            else if let data = data {
                
                do{
                    let result = try JSONDecoder().decode([Country].self, from: data)
                    
                    print("countries : \(result.count)")
                    completion(.success(result))
                }
                catch{
                    completion(.failure(error))
                }
            }
        }
        task.resume()
    }
}


//model

struct Country : Codable {
    let name : String
    let population : Int
    let flags: Flag
}

struct Flag :Codable{
    let svg: String
    let png : String
}

