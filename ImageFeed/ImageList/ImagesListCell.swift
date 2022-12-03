import UIKit

final class ImagesListCell: UITableViewCell {

    static let reuseIdentifier = "ImagesListCell"

    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var blurView: UIView!

    override func awakeFromNib() {
       super.awakeFromNib()
       addGradient()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 0, bottom: 8, right: 0))
    }

    func addGradient() {
        let gradient = CAGradientLayer()
        gradient.frame = blurView.bounds
        gradient.colors = [UIColor.ypGradientWhite.cgColor, UIColor.ypGradientBlack.cgColor]
        blurView.layer.insertSublayer(gradient, at: 0)
    }
}
