import UIKit

class LoginViewController: UIViewController {
    
    

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBAction func loginTapped(_ sender: UIButton) {
        let username = self.emailTextField.text!
        let password = self.passwordTextField.text!
        // create alert controller about blank fields
        
        UdacityAPI.login(username: username, password: password) { (success, eroor) in

            if success {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "completeLogin", sender: nil)
                }
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
}
