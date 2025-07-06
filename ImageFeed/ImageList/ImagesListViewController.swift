//
//  ViewController.swift
//  ImageFeed
//
//  Created by Andrey Sopov on 04.03.2025.
//

import UIKit
import Kingfisher

final class ImagesListViewController: UIViewController {
    
    
    @IBOutlet private var tableView: UITableView!
    
    private let photosName: [String] = Array(0..<20).map{ "\($0)" }
    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    
    private let imagesListService = ImagesListService()
    private var photos: [Photo] = []
    
    private lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        return formatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 200
        tableView.contentInset = UIEdgeInsets(top: 12, left: 0, bottom: 12, right: 0)
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(updateTableViewAnimated),
            name: ImagesListService.didChangeNotification,
            object: nil
        )
        
        imagesListService.fetchPhotosNextPage()
    }
    
    @objc private func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        
        if oldCount == newCount { return }
        
        tableView.performBatchUpdates {
            let newIndexPaths = (oldCount..<newCount).map { index in
                IndexPath(row: index, section: 0)
            }
            photos = imagesListService.photos
            tableView.insertRows(at: newIndexPaths, with: .automatic)
        } completion: { _ in }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }
            
            //            let image = UIImage(named: photosName[indexPath.row])
            //            viewController.image = image
            let photo = photos[indexPath.row]
            guard let imageURL = URL(string: photo.largeImageURL) else { return }
            
            viewController.imageURL = imageURL
            
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }
    
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
//        guard let image = UIImage(named: photosName[indexPath.row]) else {
//            return
//        }
//        cell.cellImage.image = image
//        cell.dateLabel.text = dateFormatter.string(from: Date())
//        
//        let isLiked = indexPath.row % 2 == 0
//        let likeImage = isLiked ? UIImage(named: "Active") : UIImage(named: "No Active")
//        cell.likeButton.setImage(likeImage, for: .normal)
        let photo = photos[indexPath.row]
             guard let imageURL = URL(string: photo.largeImageURL) else { return }
             
             cell.cellImage.backgroundColor = UIColor(named: "YP Gray")
             cell.cellImage.contentMode = .center
             cell.cellImage.kf.indicatorType = .activity
             
             cell.cellImage.kf.setImage(
                 with: imageURL,
                 placeholder: UIImage(named: "stub"),
                 options: [
                     .transition(.fade(0.2))
                 ]
             ) { [weak cell] result in
                 guard let cell = cell else { return }
                 switch result {
                 case .success:
                     cell.cellImage.contentMode = .scaleAspectFill
                 case .failure:
                     cell.cellImage.contentMode = .center
                 }
             }
             
             if let date = photo.createdAt {
                 cell.dateLabel.text = dateFormatter.string(from: date)
             } else {
                 cell.dateLabel.text = ""
             }
             
            let likeImage = photo.isLiked ? UIImage(named: "Active") : UIImage(named: "No Active")
            cell.likeButton.setImage(likeImage, for: .normal)
    }
    
    
}

extension ImagesListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let image = UIImage(named: photosName[indexPath.row]) else {
            return 0
        }
        
        let imageInsets = UIEdgeInsets(top: 4, left: 16, bottom: 4, right: 16)
        let imageViewWidth = tableView.bounds.width - imageInsets.left - imageInsets.right
        let imageWidth = image.size.width
        let scale = imageViewWidth / imageWidth
        let cellHeight = image.size.height * scale + imageInsets.top + imageInsets.bottom
        return cellHeight
    }
}

extension ImagesListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}
