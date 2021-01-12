//
//  UserCollectionViewCell.swift
//  networkapp
//
//  Created by Boris on 12.01.2021.
//

import UIKit

class UserCollectionViewCell: UICollectionViewCell {
  @IBOutlet var avatarView: UIImageView!
  
  public func set(url: String) {
    avatarView.image = UIImage(named: "default")

    NetworkManager.shared.downloadImage(from: url) { [weak self] image in
      guard let self = self else { return }
      DispatchQueue.main.async { self.avatarView.image = image }
    }
 }
}
