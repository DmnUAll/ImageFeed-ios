import UIKit

final class SplashViewController: UIViewController {
    private enum AppFlows: String {
        case auth = "AuthFlow"
        case main = "MainFlow"
    }
    private let profileService = ProfileService.shared
    private let tokenStorage = OAuth2TokenStorage()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let token = tokenStorage.token else {
            proceedToFlow(withID: .auth)
            return
        }
        fetchProfile(token: token)
    }

    private func proceedToFlow(withID flowID: AppFlows) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        switch flowID {
        case .main:
            guard let nextVC = storyBoard.instantiateViewController(
                withIdentifier: flowID.rawValue) as? UITabBarController else { return }
            UIApplication.shared.windows.first?.rootViewController = nextVC
        case .auth:
            guard let nextVC = storyBoard.instantiateViewController(
                withIdentifier: flowID.rawValue) as? UINavigationController else { return }
            UIApplication.shared.windows.first?.rootViewController = nextVC
        }
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }

    private func fetchProfile(token: String) {
        UIBlockingProgressHUD.show()
        profileService.fetchProfile(tokenStorage.token ?? "") { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                do {
                    let data = try result.get()
                    let username = data.username
                    ProfileImageService.shared.fetchProfileImageURL(token: token, username: username) { _ in }
                    self.proceedToFlow(withID: .main)
                } catch {
                    let errorAlert = UIAlertController()
                        .createSimpleAlert(withTitle: "Что-то пошло не так(",
                                           message: "Не удалось войти в систему",
                                           andButtonTitle: "Ок")
                    self.present(errorAlert, animated: true)
                }
                UIBlockingProgressHUD.dismiss()
            }
        }
    }
}
