import Alamofire
import UIKit

class LoginView: UIViewController {
    @IBOutlet private var loginText: UITextField!
    @IBOutlet private var passwordText: UITextField!
    private let loginURL = "http://localhost:8080/dc/auth/signin"
    @IBAction func loginButtonPressed(_ sender: UIButton) {
        let parameters: [String: Any] = [
            "userName": loginText.text ?? "",
            "password": passwordText.text ?? ""
        ]
        AF.request(loginURL, method: .post, parameters: parameters, encoding: JSONEncoding.default).responseJSON { response in
            guard let data = response.data else {
                return
            }
            var auth: Auth?
            let decoder = JSONDecoder()
            do {
                auth = try decoder.decode(Auth.self, from: data)
                let appDelegate = UIApplication.shared.delegate as! AppDelegate
                appDelegate.token = auth?.token
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: true)
                }
            }
            catch {
                print("JSON String: \(String(describing: String(data: data, encoding: .utf8)))")
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: "Wrong credentials", message: "Your credentials are incorrect. Please check your username and password", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.present(alert, animated: true, completion: nil)
                }
            }
            
        }.resume()
    }
    
    override func viewDidLoad() {
    }
}
