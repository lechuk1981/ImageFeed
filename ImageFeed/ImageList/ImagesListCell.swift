//
//  ImagesListCell.swift
//  ImageFeed
//
//  Created by Andrey Sopov on 09.03.2025.
//
import UIKit

final class ImagesListCell: UITableViewCell {
    
    @IBOutlet var cellImage: UIImageView!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var dateLabel: UILabel!
    
    static let reuseIdentifier = "ImagesListCell"

}
