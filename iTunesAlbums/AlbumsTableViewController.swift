//
//  AlbumsTableViewController.swift
//  iTunesAlbums
//
//  Created by Shiva Teja on 10/30/19.
//  Copyright © 2019 Verizon. All rights reserved.
//

import UIKit

class AlbumsTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    // MARK:- Properties -
    
    var albumsModel: AlbumsModel?
    var albumsTableView = UITableView()
    var indicatorView: UIView?
    
    // MARK:- View life cycle methods -
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getScreenData()
        setUpTableView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Refresh",
                                                            style: .plain,
                                                            target: self,
                                                            action: #selector(getScreenData))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        albumsTableView.isHidden = false
    }
    
    // MARK:- Fetch data and setup UI methods -
    
    @objc func getScreenData() {
        let url = String(format: kiTunesDataURL, 100)
        showIndicator()
        NetworkHandler.shared.makeWebServiceCall(url: url) { (response, error) in
            if let data = response {
                self.parseData(responseData: data, error: error)
            } else {
                self.showAlert(message: error?.localizedDescription)
                self.hideIndicator()
            }
        }
    }
    
    func parseData(responseData: [String: Any], error: Error?) {
        if let dataDictionary = responseData["feed"] as? [String: Any] {
            albumsModel =  AlbumsModel(with: dataDictionary)
            updateUI()
        } else {
            hideIndicator()
        }
    }
    
    func updateUI() {
        DispatchQueue.main.async {
            self.title = self.albumsModel?.title ?? ""
            guard let font = UIFont(name: "Gill Sans", size: 20) else { return }
            let attributes = [NSAttributedString.Key.font : font]
            self.navigationController?.navigationBar.titleTextAttributes = attributes
            self.albumsTableView.reloadData()
            self.hideIndicator()
        }
    }
    
    func setUpTableView() {
        self.albumsTableView.backgroundColor = .white
        self.albumsTableView.register(UITableViewCell.self, forCellReuseIdentifier: "AlbumTableViewCell")
        self.albumsTableView.delegate = self
        self.albumsTableView.dataSource = self
        self.view.addSubview(self.albumsTableView)
        
        self.albumsTableView.translatesAutoresizingMaskIntoConstraints = false
        let albumsTableViewConstraints:[NSLayoutConstraint] = [
            self.albumsTableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            self.albumsTableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            self.albumsTableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            self.albumsTableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -34)
        ]
        NSLayoutConstraint.activate(albumsTableViewConstraints)
        self.view.layoutIfNeeded()
    }
    
    // MARK: - Table view methods -

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albumsModel?.albums.count ?? 0
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        var cell = tableView.dequeueReusableCell(withIdentifier: "AlbumTableViewCell", for: indexPath)
        if cell.detailTextLabel == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "AlbumTableViewCell")
        }
        cell.imageView?.image = nil
        if let album = albumsModel?.albums[indexPath.row] {
            
            cell.textLabel?.text = album.name
            cell.textLabel?.font = UIFont(name: "Gill Sans", size: 18.0)
            cell.detailTextLabel?.text  = album.artistName
            cell.detailTextLabel?.font = UIFont(name: "Gill Sans", size: 15.0)
            cell.accessoryType = .disclosureIndicator
            cell.tag = indexPath.row
            if cell.imageView?.image == nil {
                if let urlString = album.thumbnailURL, let url = URL(string: urlString) {
                    if let data = try? Data(contentsOf: url) {
                        cell.imageView?.image = UIImage(data: data)
                    }
                }
            }
        }
        cell.layer.shouldRasterize = true
        cell.layer.rasterizationScale = UIScreen.main.scale
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let albumDetailVC = AlbumDetailViewController()
        albumDetailVC.album = albumsModel?.albums[indexPath.row]
        tableView.isHidden = true
        self.navigationController?.pushViewController(albumDetailVC, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    // MARK: - Indicator methods -
    
    func showIndicator() {
        
        let activityIndicatorView = UIView.init(frame: view.bounds)
        activityIndicatorView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let activityIndicator = UIActivityIndicatorView.init(style: .whiteLarge)
        activityIndicator.startAnimating()
        activityIndicator.center = activityIndicatorView.center
        
        DispatchQueue.main.async {
            activityIndicatorView.addSubview(activityIndicator)
            self.view.addSubview(activityIndicatorView)
        }
        indicatorView = activityIndicatorView
    }
    
    func hideIndicator() {
        DispatchQueue.main.async {
            self.indicatorView?.removeFromSuperview()
            self.indicatorView = nil
        }
    }
    
    func showAlert(message: String?) {
        if let errorMessage = message {
            let alertController = UIAlertController(title: "Something wrong", message:
                errorMessage+"\nPlease Try again", preferredStyle: .alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .default))
            self.present(alertController, animated: true, completion: nil)
        }
    }
}
