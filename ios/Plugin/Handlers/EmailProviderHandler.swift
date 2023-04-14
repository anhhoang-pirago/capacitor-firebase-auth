import Foundation
import Capacitor
import FirebaseAuth

class EmailProviderHandler: NSObject, ProviderHandler {


    var plugin: CapacitorFirebaseAuth? = nil
    var mEmail: String? = nil
    var mPassword: String? = nil


    func initialize(plugin: CapacitorFirebaseAuth) {
        print("Initializing Email Provider Handler")
        self.plugin = plugin
    }

    func signIn(call: CAPPluginCall) {
        guard let data = call.getObject("data") else {
            call.reject("The auth data is required")
            return
        }

        guard let email = data["email"] as? String else {
            call.reject("The email is required")
            return
        }

        guard let password = data["password"] as? String else {
            call.reject("The password is required")
            return
        }

        self.mEmail = email
        self.mPassword = password

        Auth.auth().signIn(withEmail: String(email), password: String(password)) { (result, error) in
            call.reject(error)
            // let authError = error as NSError?
            // if authError != nil {
            //     call.reject("Email Sign In failure: \(String(describing: error))")
            // } else {
            //     let user = Auth.auth().currentUser
            //         user?.multiFactor.getSessionWithCompletion({ (session, error) in
            //             PhoneAuthProvider.provider().verifyPhoneNumber(String(number), uiDelegate: nil, multiFactorSession: session) { (verificationID, error) in
            //                 if let error = error {
            //                     if let errCode = AuthErrorCode(rawValue: error._code) {
            //                         switch errCode {
            //                         case AuthErrorCode.quotaExceeded:
            //                             call.reject("Quota exceeded.")
            //                         case AuthErrorCode.invalidPhoneNumber:
            //                             call.reject("Invalid phone number.")
            //                         case AuthErrorCode.captchaCheckFailed:
            //                             call.reject("Captcha Check Failed")
            //                         case AuthErrorCode.missingPhoneNumber:
            //                             call.reject("Missing phone number.")
            //                         default:
            //                             call.reject("PhoneAuth Sign In failure: \(String(describing: error))")
            //                         }

            //                         return
            //                     }
            //                 }

            //                 self.mVerificationId = verificationID

            //                 guard let verificationID = verificationID else {
            //                     call.reject("There is no verificationID after .verifyPhoneNumber!")
            //                     return
            //                 }

            //                 // notify event On Cond Sent.
            //                 self.plugin?.notifyListeners("cfaSignInPhoneOnCodeSent", data: ["verificationId" : verificationID ])

            //                 // return success call.
            //                 call.success([
            //                     "callbackId": call.callbackId,
            //                     "verificationId":verificationID
            //                 ]);

            //             }
            //         })
            // }

        }
    }

    func signOut() {
        // do nothing
    }

    func isAuthenticated() -> Bool {
        return false
    }

    func fillResult(credential: AuthCredential?, data: PluginResultData) -> PluginResultData {

        var jsResult: PluginResultData = [:]
        data.forEach { (key, value) in
            jsResult[key] = value
        }

        jsResult["phone"] = self.mPhoneNumber
        jsResult["verificationId"] = self.mVerificationId
        jsResult["verificationCode"] = self.mVerificationCode

        return jsResult

    }
}
