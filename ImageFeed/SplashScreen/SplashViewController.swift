import UIKit

final class SplashViewController: UIViewController {
    private enum AppFlows: String {
        case auth = "AuthFlow"
        case main = "MainFlow"
    }
    private let tokenStorage = OAuth2TokenStorage()
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard tokenStorage.token != nil else {
            proceedToFlow(withID: .auth)
            return
        }
        proceedToFlow(withID: .main)
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
}
