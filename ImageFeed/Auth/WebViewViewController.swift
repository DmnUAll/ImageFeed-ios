import UIKit
import WebKit

protocol WebViewViewControllerDelegate: AnyObject {
    // swiftlint:disable identifier_name
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String)
    func webViewViewControllerDidCancel(_ vc: WebViewViewController)
    // swiftlint:enable identifier_name
}

final class WebViewViewController: UIViewController {

    @IBOutlet private var webView: WKWebView!
    @IBOutlet private var progressView: UIProgressView!

    weak var delegate: WebViewViewControllerDelegate?
    private var estimatedProgressObservation: NSKeyValueObservation?

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackBarButton()
        webView.navigationDelegate = self
        beginObserving()
        loadPage()
    }

    @objc private func didTapBackButton() {
        delegate?.webViewViewControllerDidCancel(self)
        navigationController?.popToRootViewController(animated: true)
    }

    private func beginObserving() {
        estimatedProgressObservation = webView.observe(
            \.estimatedProgress,
             options: [],
             changeHandler: { [weak self] _, _ in
                 guard let self = self else { return }
                 self.updateProgress()
             })
    }

    private func loadPage() {
        var urlComponents = URLComponents(string: unsplashAuthorizeURLString)!
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: accessKey),
            URLQueryItem(name: "redirect_uri", value: redirectURI),
            URLQueryItem(name: "response_type", value: "code"),
            URLQueryItem(name: "scope", value: accessScope)
        ]
        let url = urlComponents.url!
        let request = URLRequest(url: url)
        webView.load(request)
    }

    private func updateProgress() {
        progressView.progress = Float(webView.estimatedProgress)
        progressView.isHidden = fabs(webView.estimatedProgress - 1.0) <= 0.0001
    }

    private func code(from navigationAction: WKNavigationAction) -> String? {
        if
            let url = navigationAction.request.url,
            let urlComponents = URLComponents(string: url.absoluteString),
            urlComponents.path == "/oauth/authorize/native",
            let items = urlComponents.queryItems,
            let codeItem = items.first(where: { $0.name == "code" }) {
            return codeItem.value
        } else {
            return nil
        }
    }

    private func configureBackBarButton() {
        let backButtonView = UIView(frame: CGRect(x: 0, y: 0, width: 64, height: 44))
        let imageView = UIImageView(image: .ypBackBarButtonImage)
        imageView.frame = CGRect(x: 12, y: 16, width: 8.97, height: 15.59)
        imageView.image = imageView.image!.withRenderingMode(.alwaysTemplate)
        imageView.tintColor = .ypBlack
        backButtonView.addSubview(imageView)
        backButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didTapBackButton)))
        let barButton = UIBarButtonItem(customView: backButtonView)
        navigationItem.leftBarButtonItem = barButton
    }
}

extension WebViewViewController: WKNavigationDelegate {

    func webView(
        _ webView: WKWebView,
        decidePolicyFor navigationAction: WKNavigationAction,
        decisionHandler: @escaping (WKNavigationActionPolicy) -> Void
    ) {
        if let code = code(from: navigationAction) {
            delegate?.webViewViewController(self, didAuthenticateWithCode: code)
            decisionHandler(.cancel)
        } else {
            decisionHandler(.allow)
        }
    }
}
