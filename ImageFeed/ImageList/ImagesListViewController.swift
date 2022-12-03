//
//  ViewController.swift
//  ImageFeed
//
//  Created by Илья Валито on 21.11.2022.
//

import UIKit

final class ImagesListViewController: UIViewController {

    private let showSingleImageSegueIdentifier = "ShowSingleImage"
    private var photoNames = [String]()

    @IBOutlet private var tableView: UITableView!

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        photoNames = Array(0..<20).map { "\($0)" }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            // swiftlint:disable force_cast
            let viewController = segue.destination as! SingleImageViewController
            let indexPath = sender as! IndexPath
            // swiftlint:enable force_cast
            let image = UIImage(named: photoNames[indexPath.row])
            viewController.image = image
        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

    func configCell(for cell: ImagesListCell, with indexPath: IndexPath) {
        guard let contentImage = UIImage(named: photoNames[indexPath.row]) else { return }
        cell.contentImageView.image = contentImage
        cell.dateLabel.text = Date().dateTimeString
        if indexPath.row % 2 != 0 {
            cell.likeButton.setImage(UIImage(named: "activeLike"), for: .normal)
        } else {
            cell.likeButton.setImage(UIImage(named: "inactiveLike"), for: .normal)
        }
    }
}

extension ImagesListViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoNames.count
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

extension ImagesListViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }
}
