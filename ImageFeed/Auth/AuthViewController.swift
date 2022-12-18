import UIKit

final class AuthViewController: UIViewController {

    private let tokenStorage = OAuth2TokenStorage()
    private let webViewSegueIdentifier = "ShowWebView"

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == webViewSegueIdentifier else { return }
        guard let destinationVC = segue.destination as? WebViewViewController else { return }
        destinationVC.delegate = self
    }

    private func proceedToMainFlow() {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        guard let nextVC = storyBoard.instantiateViewController(
            withIdentifier: "MainFlow") as? UITabBarController else { return }
        UIApplication.shared.windows.first?.rootViewController = nextVC
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    // swiftlint:disable identifier_name
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        guard tokenStorage.token != nil else {
            OAuth2Service.shared.fetchAuthToken(code: code) { result in
                DispatchQueue.main.async {
                    do {
                        let data = try result.get()
                        self.tokenStorage.token = data
                    } catch let error {
                        print("Error: ", error)
                    }
                }
            }
            proceedToMainFlow()
            return
        }
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
    // swiftlint:enable identifier_name
}
