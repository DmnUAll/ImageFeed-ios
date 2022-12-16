import UIKit

final class SplashViewController: UIViewController {

    private enum AppFlows: String {
        case auth = "AuthFlow"
        case main = "MainFlow"
    }

    private let tokenStorage = OAuth2TokenStorage()

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        sleep(1)

        guard tokenStorage.token != nil else {
            proceedToFlow(withID: .auth)
            return
        }
        proceedToFlow(withID: .main)
    }

    private func proceedToFlow(withID flowID: AppFlows) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        var nextVC: UIViewController
        // swiftlint:disable force_cast
        switch flowID {
        case .main:
            nextVC = storyBoard.instantiateViewController(withIdentifier: flowID.rawValue) as! UITabBarController
        case .auth:
            nextVC = storyBoard.instantiateViewController(withIdentifier: flowID.rawValue) as! UINavigationController
        }
        // swiftlint:enable force_cast
        UIApplication.shared.windows.first?.rootViewController = nextVC
        UIApplication.shared.windows.first?.makeKeyAndVisible()
    }
}
