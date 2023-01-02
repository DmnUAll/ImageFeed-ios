import UIKit

final class AuthViewController: UIViewController {

    private let tokenStorage = OAuth2TokenStorage()
    private let profileService = ProfileService.shared
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

    private func fetchProfile(token: String) {
        profileService.fetchProfile(tokenStorage.token ?? "") { result in
            DispatchQueue.main.async {
                do {
                    let data = try result.get()
                    let username = data.username
                    ProfileImageService.shared.fetchProfileImageURL(token: token, username: username) { _ in }
                } catch let error {
                    print("Error: ", error)
                }
            }
        }
    }
}

extension AuthViewController: WebViewViewControllerDelegate {
    // swiftlint:disable identifier_name
    func webViewViewController(_ vc: WebViewViewController, didAuthenticateWithCode code: String) {
        UIBlockingProgressHUD.show()
        guard tokenStorage.token != nil else {
            OAuth2Service.shared.fetchAuthToken(code: code) { result in
                DispatchQueue.main.async { [weak self] in
                    guard let self = self else { return }
                    do {
                        let data = try result.get()
                        self.tokenStorage.token = data
                        self.fetchProfile(token: data)
                    } catch let error {
                        print("Error: ", error)
                    }
                    UIBlockingProgressHUD.dismiss()
                    self.proceedToMainFlow()
                }
            }
            return
        }
    }

    func webViewViewControllerDidCancel(_ vc: WebViewViewController) {
        vc.dismiss(animated: true)
    }
    // swiftlint:enable identifier_name
}
