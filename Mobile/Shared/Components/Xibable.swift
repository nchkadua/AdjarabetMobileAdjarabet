protocol Xibable: class {
    var mainView: UIView { get set }
    func setupUI()
}

extension Xibable where Self: UIView {
    func nibSetup() {
        backgroundColor = .clear

        mainView = loadViewFromNib()
        mainView.backgroundColor = .clear
        mainView.frame = bounds
        mainView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        mainView.translatesAutoresizingMaskIntoConstraints = true

        addSubview(mainView)

        setupUI()
    }

    // swiftlint:disable force_cast
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: String(describing: type(of: self)), bundle: bundle)
        let nibView = nib.instantiate(withOwner: self, options: nil).first as! UIView

        return nibView
    }
}
