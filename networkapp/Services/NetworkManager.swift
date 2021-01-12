//
//  NetworkManager.swift
//  networkapp
//
//  Created by Boris on 12.01.2021.
//

import Foundation
import UIKit

enum NetworkManagerError: String, Error {
  case somethingWentWrong = "Sorry, something went wrong"
  case unauthorized = "Invalid authorization, please check api key"
  case tooManyRequests = "Too many requests. Please try again later"
}

class NetworkManager {
  static let shared = NetworkManager()
  
  private let apiUrl = "https://randomuser.me/api"
  
  public let cache = NSCache<NSString, UIImage>()
  
  private init() {}
  
  // MARK: - Public methods
  func getUsers(countUsers: Int = 500, completed: @escaping (Result<[User], NetworkManagerError>) -> Void) {
    let endpoint = apiUrl + "/?results=\(countUsers)"

    guard let url = URL(string: endpoint) else {
      completed(.failure(.somethingWentWrong))
      return
    }
    
    URLSession.shared.dataTask(with: url) { data, response, error in
       if let _ = error {
         completed(.failure(.somethingWentWrong))
       }
       
       guard let response = response as? HTTPURLResponse else {
         completed(.failure(.somethingWentWrong))
         return
       }
       
       if response.statusCode == 401 {
         completed(.failure(.unauthorized))
         return
       }
       
       if response.statusCode == 429 {
         completed(.failure(.tooManyRequests))
         return
       }
       
       guard let data = data else {
         completed(.failure(.somethingWentWrong))
         return
       }
       
      do {
        let userResponse = try JSONDecoder().decode(UserResponse.self, from: data)
        completed(.success(self.mapUserResponse(response: userResponse)))
      } catch let error {
        print("DEBUG: \(error.localizedDescription))")
        completed(.failure(.somethingWentWrong))
      }
    }.resume()
  }

  func downloadImage(from urlString: String, competed: @escaping(UIImage?) -> Void) {
    let cacheKey = NSString(string: urlString)
    
    if let image = cache.object(forKey: cacheKey) {
      competed(image)
      return
    }
    
    guard let url = URL(string: urlString) else {
      competed(nil)
      return
    }
    
    URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
      guard let self = self,
        error == nil,
        let response = response as? HTTPURLResponse, response.statusCode == 200,
        let data = data,
        let image = UIImage(data: data)
      else {
        competed(nil)
        return
      }
        
      self.cache.setObject(image, forKey: cacheKey)
        
      competed(image)
    }.resume()
  }
}

// MARK: - Extentions
// MARK: - Mappers
extension NetworkManager {
  private func mapUserResponse(response: UserResponse) -> [User] {
    return response.results.map { result in
      User(
        fullName: "\(result.name.first) \(result.name.last)",
        email: result.email,
        phone: result.phone,
        location: result.location,
        imageUrl: result.picture.medium,
        largeImageUrl: result.picture.large
      )
    }
  }
}
