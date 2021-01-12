//
//  UserViewController.swift
//  networkapp
//
//  Created by Boris on 12.01.2021.
//

import UIKit

class UserViewController: UIViewController {
  // MARK: IBOutlets
  @IBOutlet var avatarImageView: UIImageView!
  @IBOutlet var fullnameLabel: UILabel!
  @IBOutlet var tableView: UITableView!
  
  // MARK: Public properties
  var user: User?

  // MARK: Private properties
  let countTableRows = 5

  var contactInformation: [String: String] = [:]
  
  // MARK: Lifecycles
  override func viewDidLoad() {
    super.viewDidLoad()
    configure()
  }
  
  // MARK: Private methods
  private func configure() {
    guard let user = user else { return }
    
    contactInformation = [
      "Email": user.email,
      "Phone": user.phone,
      "City": user.location.city,
      "Country": user.location.country,
      "State": user.location.state,
    ]
    
    tableView.dataSource = self

    avatarImageView.image = UIImage(named: "default")
    fullnameLabel.text = user.fullName

    NetworkManager.shared.downloadImage(from: user.largeImageUrl) { [weak self] image in
      guard let self = self else { return }
      DispatchQueue.main.async { self.avatarImageView.image = image }
    }
  }
}

// MARK: Extentions
// MARK: UICollectionViewDelegate
extension UserViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return contactInformation.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "contactsCell")!
    
    cell.textLabel?.text = Array(contactInformation.keys)[indexPath.row]
    cell.detailTextLabel?.text = Array(contactInformation.values)[indexPath.row]

    return cell
  }
}
