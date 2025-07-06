//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Andrey Sopov on 09.03.2025.
//
import UIKit

protocol ImagesListCellDelegate: AnyObject {
    func imageListCellDidTapLike(_ cell: ImagesListCell)
}

final class ImagesListCell: UITableViewCell {
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    
    static let reuseIdentifier = "ImagesListCell"
    
    @IBAction func TabLikeButton(_ sender: Any) {
        delegate?.imageListCellDidTapLike(self)
    }
    
    
    weak var delegate: ImagesListCellDelegate?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        cellImage.kf.cancelDownloadTask()
    }
    
    @IBAction private func likeButtonClicked() {
        delegate?.imageListCellDidTapLike(self)
    }
    
    func setIsLiked(_ isLiked: Bool) {
        let likeImage = isLiked ? UIImage(named: "Active") : UIImage(named: "No Active")
        likeButton.setImage(likeImage, for: .normal)
    }
    
    
}
