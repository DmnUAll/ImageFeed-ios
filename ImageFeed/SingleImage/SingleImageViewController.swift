import UIKit

final class SingleImageViewController: UIViewController {

    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet weak var imageView: UIImageView!

    var image: UIImage! {
        didSet {
            guard isViewLoaded else { return }
            imageView.image = image
            rescaleAndCenterImageInScrollView(image: image)
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        imageView.image = image
        rescaleAndCenterImageInScrollView(image: image)
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 1.25
    }

    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        let visibleRectSize = view.bounds.size
        let imageSize = image.size
        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()
        let newContentSize = scrollView.contentSize
        let xPosition = (newContentSize.width - visibleRectSize.width) / 2
        let yPosition = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: xPosition, y: yPosition), animated: false)
    }

    @IBAction private func didTapBackButton() {
            dismiss(animated: true, completion: nil)
        }
    @IBAction func didTapShareButton() {
        let activityViewController = UIActivityViewController(activityItems: [image ?? UIImage()],
                                                              applicationActivities: nil)
        activityViewController.overrideUserInterfaceStyle = .dark
        self.present(activityViewController, animated: true, completion: nil)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
