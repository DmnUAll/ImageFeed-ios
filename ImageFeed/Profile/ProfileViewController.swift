import UIKit

final class ProfileViewController: UIViewController {

    lazy var profileView: ProfileView = {
        let view = ProfileView()
        return view
    }()

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        profileView.delegate = self
        view.addSubview(profileView)
        setupConstraints()
    }

    private func setupConstraints() {
        let constraints = [
            profileView.topAnchor.constraint(equalTo: view.topAnchor),
            profileView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            profileView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            profileView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ]
        NSLayoutConstraint.activate(constraints)
    }
}

extension ProfileViewController: ProfileViewDelegate {
    func logOutButtonTapped() {
        print(#function)
    }
}
