//
//  UserResponse.swift
//  networkapp
//
//  Created by Boris on 12.01.2021.
//

import Foundation

struct UserResponse: Decodable {
  let results: [UserResponseResult]
}

struct UserResponseResult: Decodable {
  let name: UserResponseResultName
  let location: Location
  let email: String
  let phone: String
  let picture: PictureResponse
}

struct UserResponseResultName: Decodable {
  let first: String
  let last: String
}

struct PictureResponse: Decodable {
  let medium: String
  let large: String
}
