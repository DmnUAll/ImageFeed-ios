//
//  ViewController.swift
//  ImageFeed
//
//  Created by Илья Валито on 21.11.2022.
//

import UIKit

class ImageListViewController: UIViewController {
    
    private var photosName = [String]()
    
    @IBOutlet private var tableView: UITableView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        photosName = Array(0..<20).map{ "\($0)" }
    }
    
    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        cell.addGradient()
        guard let contentImage = UIImage(named: photosName[indexPath.row]) else { return }
        cell.contentImageView.image = contentImage
        cell.dateLabel.text = Date().dateTimeString
        if indexPath.row % 2 != 0 {
            cell.likeButton.setImage(UIImage(named: "activeLike"), for: .normal)
        } else {
            cell.likeButton.setImage(UIImage(named: "inactiveLike"), for: .normal)
        }
    }
}

extension ImageListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photosName.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImagesListCell.reuseIdentifier, for: indexPath)
        
        guard let imageListCell = cell as? ImagesListCell else {
            return UITableViewCell()
        }
        
        configCell(for: imageListCell, with: indexPath)
        return imageListCell
    }
}

extension ImageListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) { }
}
