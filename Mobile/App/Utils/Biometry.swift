import LocalAuthentication

final public class Biometry {
    public typealias SuccessComplition = () -> Void
    public typealias ErrorComplition = (Error?) -> Void

    public static let shared = Biometry()
    public weak var dataSourse: AppBiometryDataSourse!
    private var context = LAContext()

    private init() { }

    public var isAvailable: Bool {
        return biometryType != .none
    }

    public var biometryType: LABiometryType {
        var error: NSError?

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            return LABiometryType.none
        }

        return context.biometryType
    }

    public func authenticate(successComplition: @escaping SuccessComplition, errorComplition: @escaping ErrorComplition) {
        var error: NSError?
        let reasonString = "Easy login"

        guard context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) else {
            errorComplition(error)
            return
        }

        context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reasonString, reply: { success, evalPolicyError in
            DispatchQueue.main.async {
                if success {
                    successComplition()
                } else {
                    errorComplition(evalPolicyError)
                }
            }

            self.context = LAContext()
        })
    }

    public var image: UIImage? {
        switch biometryType {
        case .faceID: return #imageLiteral(resourceName: "face")
        case .touchID: return #imageLiteral(resourceName: "touch")
        case .none: return nil
        @unknown default: return nil
        }
    }
}
