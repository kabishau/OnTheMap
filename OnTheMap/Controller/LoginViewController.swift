import UIKit

class LoginViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBAction func loginTapped(_ sender: UIButton) {
        
        setLoggingIn(true)
        
        let username = self.emailTextField.text!
        let password = self.passwordTextField.text!
        // create alert controller about blank fields
        
        UdacityAPI.login(username: username, password: password) { (success, error) in
            
            self.setLoggingIn(false)
            if success {
                self.performSegue(withIdentifier: "completeLogin", sender: nil)
            } else {
                self.showLoginFailure(message: error?.localizedDescription ?? "Unknown Error")
            }
        }
    }
    
    @IBAction func signUpTapped(_ sender: UIButton) {
        UIApplication.shared.open(URL(string: "https://auth.udacity.com/sign-up")!, options: [:], completionHandler: nil)    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        emailTextField.text = ""
        passwordTextField.text = ""
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func setLoggingIn(_ loggingIn: Bool) {
        if loggingIn {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        emailTextField.isEnabled = !loggingIn
        passwordTextField.isEnabled = !loggingIn
        loginButton.isEnabled = !loggingIn
    }
    
    func showLoginFailure(message: String) {
        let alertController = UIAlertController(title: "Login Failed", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        //show(alertController, sender: nil)
        present(alertController, animated: true, completion: nil)
    }
}
