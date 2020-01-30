import UIKit
import Alamofire
import UserNotifications

var passwordUser = ""
var hiddenPasswordUser = ""

class Profile: UIViewController {
    
    //Outlets
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var surname: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var email: UILabel!
    @IBOutlet weak var password: UILabel!
    @IBOutlet weak var showPasswordButton: UIButton!
    @IBOutlet weak var hidePasswordButton: UIButton!
    @IBOutlet weak var switchNotifications: UISwitch!
    @IBOutlet weak var switchMessages: UISwitch!
    
    //Actions
    @IBAction func hideButton(_ sender: Any) {
        showPassword()
        showPasswordButton.isHidden = false
        hidePasswordButton.isHidden = false
    }
    
    @IBAction func showPasswordButton(_ sender: Any) {
        self.password.text = passwordUser
        showPasswordButton.isHidden = true
        hidePasswordButton.isHidden = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getDataUser()
        allowNotifications()
    }

    //Functions
    public func getDataUser(){
        //Ruta de end-point
        let url = "http://localhost:8888/BienestarDigital/public/index.php/api/show"
        
        let header = ["Authorization" : Token]
        
        //Realizar petición
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            print(response.result.value as Any)
            
            let json = response.result.value as! [String:AnyObject] //Coger el objeto JSON y transformarlo a String
            
            for i in json{
                print(i) //Ver los campos que tengo en el JSON
            }
            
            let nameUser = json ["name"] as! String
            self.name.text = nameUser
            let surnameUser = json ["surname"] as! String
            self.surname.text = surnameUser
            let usernameUser = json ["username"] as! String
            self.username.text = usernameUser
            let emailUser = json ["email"] as! String
            self.email.text = emailUser
            passwordUser = json ["password"] as! String
            
            self.showPassword()
        }
    }
    
    public func showPassword(){
        var arrayHiddenPassword : [Character] = []
        for characters in passwordUser{
            arrayHiddenPassword.append("*")
            hiddenPasswordUser = String(arrayHiddenPassword)
            self.password.text = hiddenPasswordUser
        }
    }
    
    public func allowNotifications(){
        if switchNotifications.isOn{
           UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) {
                (autorizado, error) in
                if autorizado {
                    print("Permiso concedido")
                } else {
                    print("Permiso denegado")
                }
            }
        }
    }
}
