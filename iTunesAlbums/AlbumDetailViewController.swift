//
//  AlbumDetailViewController.swift
//  iTunesAlbums
//
//  Created by Shiva Teja on 10/31/19.
//  Copyright © 2019 Verizon. All rights reserved.
//

import UIKit

class AlbumDetailViewController: UIViewController {

    // MARK:- Properties -

    var imageView = UIImageView()
    var nameLabel = UILabel()
    var artistLabel = UILabel()
    var genreLabel = UILabel()
    var releaseDateLabel = UILabel()
    var copyrightLabel = UILabel()
    var iTunesButton = UIButton()
    var album: Album?
    
    // MARK:- View life cycle method -

    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()        
    }
    
    // MARK:- setup UI methods -

    /**
     setUp method
     
     - important: This method sets up the image, labels and button
     - returns: none
     - parameter none
     */
    func setUp() {
        
        setUpUI()
        if let urlString = album?.thumbnailURL, let url = URL(string: urlString) {
            DispatchQueue.main.async {
                if let data = try? Data(contentsOf: url) {
                    self.imageView.image = UIImage(data: data)
                }
            }
        }
        
        nameLabel.text = album?.name
        nameLabel.font = UIFont(name: kGillSansFont, size: 25.0)
        artistLabel.text = album?.artistName
        artistLabel.font = UIFont(name: kGillSansFont, size: 18.0)
        genreLabel.text = album?.genres[0].name
        genreLabel.font = UIFont(name: kGillSansFont, size: 18.0)
        
        if let releaseDate = album?.releaseDate {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy'-'MM'-'dd"
            guard let date = dateFormatter.date(from: releaseDate) else { return }
            dateFormatter.dateFormat = "dd' 'MMM' 'yyyy"
            releaseDateLabel.text = dateFormatter.string(from: date)
            releaseDateLabel.font = UIFont(name: kGillSansFont, size: 18.0)
        }
        copyrightLabel.text = album?.copyRight
        copyrightLabel.font = UIFont(name: kGillSansFont, size: 15.0)
        iTunesButton.setTitle(kITunesButtonTitle, for: .normal)
        iTunesButton.titleLabel?.font = UIFont(name: kGillSansFont, size: 18.0)
        iTunesButton.titleLabel?.textColor = .white
        iTunesButton.addTarget(self, action: #selector(iTunesButtonTapped), for: .touchUpInside)
    }
    
    /**
     setUpUI method
     
     - important: This method sets up the frame and constraints for image, labels and button
     - returns: none
     - parameter none
     */
    func setUpUI() {
        
        // ImageView constraint setup
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        let imageViewConstraints = [
        imageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 30),
        imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 50),
        imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -50),
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor)
            ]
        NSLayoutConstraint.activate(imageViewConstraints)
        view.layoutIfNeeded()
        
        // nameLabel constraint setup

        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 0
        view.addSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        let nameLabelConstraints = [
            nameLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 15),
            nameLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            nameLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            nameLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 80.0)
        ]
        NSLayoutConstraint.activate(nameLabelConstraints )
        view.layoutIfNeeded()
        
        // artistLabel constraint setup
        
        setConstraints(for: artistLabel, toLabel: nameLabel)
        
        // genreLabel constraint setup
        
        setConstraints(for: genreLabel, toLabel: artistLabel)
        
        // releaseDateLabel constraint setup
        
        setConstraints(for: releaseDateLabel, toLabel: genreLabel)
        
        // copyrightLabel constraint setup
        
        copyrightLabel.textAlignment = .center
        copyrightLabel.numberOfLines = 0
        view.addSubview(copyrightLabel)
        copyrightLabel.translatesAutoresizingMaskIntoConstraints = false
        let copyrightLabelConstraints = [
            copyrightLabel.topAnchor.constraint(equalTo: releaseDateLabel.bottomAnchor, constant: 15),
            copyrightLabel.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            copyrightLabel.trailingAnchor.constraint(equalTo: imageView.trailingAnchor),
            copyrightLabel.heightAnchor.constraint(lessThanOrEqualToConstant: 120.0)
        ]
        NSLayoutConstraint.activate(copyrightLabelConstraints )
        view.layoutIfNeeded()
        
        // iTunesButton constraint setup
        
        iTunesButton.backgroundColor = .black
        view.addSubview(iTunesButton)
        iTunesButton.translatesAutoresizingMaskIntoConstraints = false
        let iTunesButtonConstraints = [
            iTunesButton.topAnchor.constraint(equalTo: copyrightLabel.bottomAnchor, constant: 15),
            iTunesButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            iTunesButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            iTunesButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -20),
            iTunesButton.heightAnchor.constraint(equalToConstant: 50.0)
        ]
        NSLayoutConstraint.activate(iTunesButtonConstraints)
        view.layoutIfNeeded()
        iTunesButton.layer.cornerRadius = (iTunesButton.frame.height)/2
    }

    func setConstraints(for label: UILabel, toLabel: UILabel) {

        label.textAlignment = .center
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        let labelConstraints = [
            label.topAnchor.constraint(equalTo: toLabel.bottomAnchor, constant: 15),
            label.leadingAnchor.constraint(equalTo: imageView.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: imageView.trailingAnchor)
        ]
        NSLayoutConstraint.activate(labelConstraints)
        view.layoutIfNeeded()
    }
    
    // MARK:- Button action methods -
    
    /**
     iTunesButtonTapped method
     
     - important: This method is invoked when "View in Itunes" button is tapped
     - returns: none
     - parameter none
     */
    @objc func iTunesButtonTapped() {
        if var urlString = album?.url {
            
            if urlString.contains(kMusicDomain) {
                urlString = urlString.replacingOccurrences(of: kMusicDomain, with: kITunesDomain)
            }
            if let url = URL(string: urlString), UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                showAlert(message: kITunesUnavailabilityErrorMessage)
            }
        }
    }
    
    // MARK: - Alert method -
    
    /**
     showAlert method
     
     - important: This method shows the alert
     - returns: none
     - parameter message
     */
    func showAlert(message: String?) {
        if let errorMessage = message {
            let alertController = UIAlertController(title: kAlertTitle, message:
                errorMessage+kPleaseTryAgainMessage, preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: kDismiss, style: .default))
            self.present(alertController, animated: true, completion: nil)
        }
    }
    
}
