//
//  SingleImageViewController.swift
//  ImageFeed
//
//  Created by Andrey Sopov on 16.03.2025.
//

import UIKit

final class SingleImageViewController: UIViewController {
    var image: UIImage?{
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
        }
    }
    
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet var scrollView: UIScrollView!
    @IBAction func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
    }
}
