//
//  ViewController.swift
//  networkapp
//
//  Created by Boris on 12.01.2021.
//

import UIKit

class UsersViewController: UIViewController {
  // MARK: IBOutlets
  @IBOutlet var indicator: UIActivityIndicatorView!
  @IBOutlet var collectionView: UICollectionView!

  // MARK: Public properies
  var users: [User] = []   {
    didSet {
      collectionView?.reloadData()
    }
  }
  
  // MARK: Private properties
  private let itemsPerRow: CGFloat = 4

  private let sectionInsets = UIEdgeInsets(top: 2.0,
                                           left: 2.0,
                                           bottom: 2.0,
                                           right: 2.0)

  // MARK: Lifecycles
  override func viewDidLoad() {
    super.viewDidLoad()
    
    indicator.startAnimating()
    
    configureCollectionView()
    loadUsers()
  }
  
  // MARK: Nagivation
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    guard segue.identifier == "showUser" else { return }
    guard let destiantion = segue.destination as? UserViewController else { return }
    destiantion.user = sender as? User
  }
  
  // MARK: Private methods
  private func loadUsers() {
    NetworkManager.shared.getUsers() { [weak self] result in
     switch result {
       case .failure(let error):
        DispatchQueue.main.async {
          self?.failedAlert(message: error.rawValue)
          self?.hideIndicator()
        }
        break
       case .success(let response):
        DispatchQueue.main.async {
          self?.users = response
          self?.hideIndicator()
        }
        break
       }
    }
  }

  private func configureCollectionView() {
    collectionView.delegate = self
    collectionView.dataSource = self
  }

  private func hideIndicator() {
    indicator.stopAnimating()
    indicator.isHidden = true
  }

  private func failedAlert(message: String) {
    let alert = UIAlertController(title: "Failed",
                                  message: message,
                                  preferredStyle: .alert)
    
    let okAction = UIAlertAction(title: "OK", style: .default) { [weak self] _ in
      self?.loadUsers()
    }

    alert.addAction(okAction)
    present(alert, animated: true)
  }
}

// MARK: Extentions
// MARK: UICollectionViewDelegate
extension UsersViewController: UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    performSegue(withIdentifier: "showUser", sender: users[indexPath.row])
  }
}

// MARK: UICollectionViewDataSource
extension UsersViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return users.count
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "userCell", for: indexPath as IndexPath) as! UserCollectionViewCell
    cell.set(url: users[indexPath.row].imageUrl)

    return cell
  }
}

// MARK: UICollectionViewDelegateFlowLayout
extension UsersViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
    let availableWidth = view.frame.width - paddingSpace
    let widthPerItem = availableWidth / itemsPerRow
    
    return CGSize(width: widthPerItem, height: widthPerItem)
  }

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      insetForSectionAt section: Int) -> UIEdgeInsets {
    return sectionInsets
  }

  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return sectionInsets.left
  }
}
