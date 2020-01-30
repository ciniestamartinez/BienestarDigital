import UIKit
import Alamofire

//Variables
var Token = ""

class Login: UIViewController {
    
    //Outlets
    @IBOutlet weak var dataUser: UITextField!
    @IBOutlet weak var passwordUser: UITextField!
    @IBOutlet weak var showProgress: UIActivityIndicatorView!
    @IBOutlet weak var loginButton: UIButton!
    
    //Actions
    @IBAction func loginButton(_ sender: Any) {
        loginUser()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Functions
    func loginUser() {
        //Ruta de end-point
        let url = "http://localhost:8888/BienestarDigital/public/index.php/api/login"
        
        //Datos que se mandan a la API
        let json = ["email": dataUser.text, "password": passwordUser.text]
        
        //Mostrar error de falta de campos
        if dataUser.text!.isEmpty || passwordUser.text!.isEmpty{
            mostrarAlerta(title: "Faltan datos", message: "Rellena todos los campos para poder loguearte")
        }
        
        //Mostrar progreso de la petición
        showProgress.isHidden = false
        loginButton.isHidden = true
        
        //Realizar petición
        Alamofire.request(url, method: .post, parameters: json as Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            print(response)
            
        //Comprobar estado de la petición
            self.showProgress.isHidden = true
            self.loginButton.isHidden = false
            let estadoRespuesta = response.response?.statusCode
            if estadoRespuesta == 200{
                let json = response.result.value as! [String:AnyObject]
                Token = json ["token"] as! String
                
                self.mostrarAlerta(title: "¡Bienvenido!", message: "")
                //self.performSegue(withIdentifier: "hola", sender: nil)
            }
            if estadoRespuesta == 401{
                self.mostrarAlerta(title: "Error", message: "Email o contraseña incorrectos")
            }
        }
    }
    
    func mostrarAlerta(title: String, message: String){
        let alerta = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OK = UIAlertAction(title: "OK", style: .cancel, handler: {(action) in})
        alerta.addAction(OK)
        present(alerta, animated: true, completion: nil)
    }
}

