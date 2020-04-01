public class AppNavigationController: UINavigationController, UIGestureRecognizerDelegate, UINavigationControllerDelegate {
    public override func viewDidLoad() {
        super.viewDidLoad()

        interactivePopGestureRecognizer?.delegate = self
        delegate = self
//        let color = DesignSystem.Color.mrktBlack
//        navigationBar.titleTextAttributes = [
//            NSAttributedString.Key.foregroundColor: color,
//            NSAttributedString.Key.font: AppFont.helveticaBold.with(size: 16)]
//        navigationBar.tintColor = color

        removeDefaultSettings()
    }

    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        viewControllers.count > 1
    }

    private func removeDefaultSettings() {
//        navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationBar.shadowImage = UIImage()
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = .white
        view.backgroundColor = .clear
    }

    public override var childForStatusBarStyle: UIViewController? { topViewController }

    public override var childForStatusBarHidden: UIViewController? { topViewController }
}

public extension UIViewController {
    func wrapInNav() -> UINavigationController {
        UINavigationController(rootViewController: self)
    }
}
