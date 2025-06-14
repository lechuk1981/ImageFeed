//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Andrey Sopov on 16.03.2025.
//

import UIKit
import Kingfisher

final class ProfileViewController: UIViewController {
    
    @IBOutlet var accountText: UILabel!
    @IBOutlet var accountLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var exitButton: UIButton!
    @IBOutlet var profileImage: UIImageView!
    
    private let profileService = ProfileService.shared
    private var profileImageServiceObserver: NSObjectProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUIElements()
        loadProfile()
        view.backgroundColor = .ypBlack
        
        profileImageServiceObserver = NotificationCenter.default
            .addObserver(
                forName: ProfileImageService.didChangeNotification,
                object: nil,
                queue: .main
            ) { [weak self] _ in
                guard let self = self else { return }
                updateAvatar()
            }
        updateAvatar()
        
    }
    
    func loadProfile() {
        guard let profile = profileService.profile  else {
            nameLabel.text = "Екатерина Новикова"
            accountLabel.text = "@ekaterina_nov"
            accountText.text = "Hello, world!"
            return
        }
        nameLabel.text = "\(profile.firstName ?? "") \(profile.lastName ?? "")"
        accountLabel.text = "@" + (profile.username)
        accountText.text = profile.bio
    }
    
    
    private func setUIElements() {
        configAvatarPhoto()
        configUserNameLabel()
        configNickNameLabel()
        configDescriptionLabel()
        configExitButton()
        
        
        [profileImage, nameLabel, accountLabel, accountText, exitButton].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview($0)
        }
        
        activateConstraints()
    }
    
    private func updateAvatar() {
        guard
            let profileImageURL = ProfileImageService.shared.avatarURL,
            let url = URL(string: profileImageURL)
        else { return }
        print("URL = \(url)")
        let cache = ImageCache.default
        cache.clearDiskCache()
        let processor = RoundCornerImageProcessor(cornerRadius: 42)
        
        self.profileImage.kf.setImage(with: url,
                                      placeholder: UIImage(named: "placeholder"),
                                      options: [.processor(processor), .transition(.fade(1))])
        
    }
    
    private func configAvatarPhoto() {
        
        if profileImage != nil { return }
        let photo = UIImage(named: "photo")
        let profileImage = UIImageView(image: photo)
        self.profileImage = profileImage
        
    }
    
    
    private func configUserNameLabel() {
        let nameLabel = UILabel()
        nameLabel.textColor = UIColor(named: "YP White")
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
        self.nameLabel = nameLabel
    }
    
    private func configNickNameLabel() {
        let accountLabel = UILabel()
        accountLabel.textColor = UIColor.init(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
        accountLabel.font = UIFont.systemFont(ofSize: 13)
        self.accountLabel = accountLabel
    }
    
    private func configDescriptionLabel() {
        let accountText = UILabel()
        accountText.textColor = UIColor(named: "YP White")
        accountText.font = UIFont.systemFont(ofSize: 13)
        self.accountText = accountText
    }
    
    private func configExitButton() {
        let exitButton = UIButton(type: .custom)
        exitButton.setImage(UIImage(named: "Exit"), for: .normal)
        self.exitButton = exitButton
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            profileImage.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            profileImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            profileImage.widthAnchor.constraint(equalToConstant: 70),
            profileImage.heightAnchor.constraint(equalToConstant: 70),
            nameLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            nameLabel.topAnchor.constraint(equalTo: profileImage.bottomAnchor, constant: 8),
            accountLabel.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            accountLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            accountText.leadingAnchor.constraint(equalTo: profileImage.leadingAnchor),
            accountText.topAnchor.constraint(equalTo: accountLabel.bottomAnchor, constant: 8),
            exitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            exitButton.centerYAnchor.constraint(equalTo: profileImage.centerYAnchor),
            exitButton.widthAnchor.constraint(equalToConstant: 44),
            exitButton.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}

extension ProfileViewController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
