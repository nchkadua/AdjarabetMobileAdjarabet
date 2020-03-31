public protocol Loading {
    func showLoading()
    func hideLoading()
}

public class LoadingButton: AppShadowButton, Loading {
    struct ButtonState {
        var state: UIControl.State
        var title: String?
        var image: UIImage?
    }

    fileprivate var buttonStates: [ButtonState] = []
    public lazy var activityIndicator: UIActivityIndicatorView = {
        let a = UIActivityIndicatorView()
        a.translatesAutoresizingMaskIntoConstraints = false
        a.hidesWhenStopped = true
        a.stopAnimating()
        a.color = UIColor.systemBlue
        self.addSubview(a)
        return a
    }()

    public var isLoading: Bool = false {
        didSet {
            if isLoading == oldValue {return}

            if isLoading {
                activityIndicator.startAnimating()
                var buttonStates: [ButtonState] = []
                for state in [UIControl.State.normal] {
                    let buttonState = ButtonState(state: state, title: title(for: state), image: image(for: state))
                    buttonStates.append(buttonState)
                    setTitle("", for: state)
                    setImage(UIImage(), for: state)
                }
                self.buttonStates = buttonStates
            } else {
                activityIndicator.stopAnimating()
                for buttonState in buttonStates {
                    setTitle(buttonState.title, for: buttonState.state)
                    setImage(buttonState.image, for: buttonState.state)
                }
                buttonStates.removeAll(keepingCapacity: true)
            }
        }
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        sharedInitialization()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInitialization()
    }

    public func showLoading() {
        isLoading = true
    }

    public func hideLoading() {
        isLoading = false
    }

    fileprivate func sharedInitialization() {
        activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor, constant: 0).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 0).isActive = true

        isLoading = false
    }
}
