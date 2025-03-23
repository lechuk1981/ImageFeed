//
//  ProfileViewController.swift
//  ImageFeed
//
//  Created by Andrey Sopov on 16.03.2025.
//

import UIKit

final class ProfileViewController: UIViewController {
    
    @IBOutlet var accountText: UILabel!
    @IBOutlet var accountLabel: UILabel!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var exitButton: UIButton!
    @IBOutlet var profileImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUIElements()
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
    
    private func configAvatarPhoto() {
        let photo = UIImage(named: "photo")
        let profileImage = UIImageView(image: photo)
        self.profileImage = profileImage
    }
    
    private func configUserNameLabel() {
        let nameLabel = UILabel()
        nameLabel.text = "Екатерина Новикова"
        nameLabel.textColor = UIColor(named: "YP White")
        nameLabel.font = UIFont.systemFont(ofSize: 23, weight: .semibold)
        self.nameLabel = nameLabel
    }
    
    private func configNickNameLabel() {
        let accountLabel = UILabel()
        accountLabel.text = "@ekaterina_nov"
        accountLabel.textColor = UIColor.init(red: 174/255, green: 175/255, blue: 180/255, alpha: 1)
        accountLabel.font = UIFont.systemFont(ofSize: 13)
        self.accountLabel = accountLabel
    }
    
    private func configDescriptionLabel() {
        let accountText = UILabel()
        accountText.text = "Hello, world!"
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

