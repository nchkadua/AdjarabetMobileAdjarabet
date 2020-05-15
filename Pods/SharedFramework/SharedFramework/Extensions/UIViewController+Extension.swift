
extension UIViewController {
    public func to<T: UIViewController>(_ type: T.Type) -> T? {
        return self as? T
    }
    
    public func add(child: UIViewController) {
        addChild(child)
        view.addSubview(child.view)
        child.didMove(toParent: self)
    }
    
    public func remove() {
        guard parent != nil else {return}
        
        willMove(toParent: nil)
        removeFromParent()
        view.removeFromSuperview()
    }
    
    public func showAlert(title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    public func wrap<T: UINavigationController>(in navigationController: T.Type) -> T {
        return T(rootViewController: self)
    }
}
