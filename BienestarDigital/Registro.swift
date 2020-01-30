import UIKit
import Alamofire

class Registro: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Outlets
    @IBOutlet weak var photoUser: UIImageView!
    @IBOutlet weak var nameUser: UITextField!
    @IBOutlet weak var surnameUser: UITextField!
    @IBOutlet weak var idUser: UITextField!
    @IBOutlet weak var emailUser: UITextField!
    @IBOutlet weak var passwordUser: UITextField!
    @IBOutlet weak var confirmPassword: UITextField!
    @IBOutlet weak var showProgress: UIActivityIndicatorView!
    @IBOutlet weak var registerButton: UIButton!
    
    //Actions
    @IBAction func uploadPhotoButton(_ sender: Any) {
        uploadPhoto()
    }
    
    @IBAction func registerButton(_ sender: UIButton) {
        registerUser()
    }
    
    //Functions
    func registerUser() {
        //Ruta de end-point
        let url = URL(string: "http://localhost:8888/BienestarDigital/public/index.php/api/users")
        
        //Datos que se mandan a la API
        let json = ["name": nameUser.text, "surname": surnameUser.text, "username": idUser.text, "email": emailUser.text, "password": passwordUser.text]
        
        //Mostrar error de falta de campos
        if nameUser.text!.isEmpty || surnameUser.text!.isEmpty || idUser.text!.isEmpty || emailUser.text!.isEmpty || passwordUser.text!.isEmpty || confirmPassword.text!.isEmpty{
            mostrarAlerta(title: "Faltan datos", message: "Rellena todos los campos para poder registrarte")
            return
        }
        
        //Comprobar email
        var correctEmail = false
        if (emailUser.text?.contains("@"))! && (emailUser.text?.contains("."))!{
            correctEmail = true
            print("Formato de email correcto")
        }
        
        //Mostrar error de email
        if correctEmail == false{
            mostrarAlerta(title: "Formato de email incorrecto", message: "El email escrito no es válido")
            print("Formato de email incorrecto")
        }
        
        //Comprobar contraseña bien escrita
        var correctWrittenPassword = false
        if passwordUser.text == confirmPassword.text{
            correctWrittenPassword = true
            print("Contraseña correcta")
        }
        
        //Mostrar error de contraseña
        if correctWrittenPassword == false{
            mostrarAlerta(title: "Contraseña incorrecta", message: "Las dos contraseñas son distintas")
            print("Contraseña incorrecta")
        }
        
        //Comprobar longitud de contraseña
        let longitudContraseña = passwordUser.text?.count
        var goodPasswordLength = true
        if longitudContraseña! < 5{
            mostrarAlerta(title: "Contraseña demasiado corta", message: "La contraseña debe tener al menos 5 carácteres")
            goodPasswordLength = false
            return
        }
        if longitudContraseña! > 15{
            mostrarAlerta(title: "Contraseña demasiado larga", message: "La contraseña debe tener menos de 15 carácteres")
            goodPasswordLength = false
            return
        }
        
        //Comprobar si la contraseña tiene al menos un número
        var numberFound = false
        for numbers in 0...9{
            numberFound = true
            break //Si encuentra un número sale del bucle
            }
        if numberFound == false{
            mostrarAlerta(title: "Contraseña inválida", message: "La contraseña debe tener al menos un número")
            return
        }
        
        //Comprobar si la contraseña tiene al menos una letra mayúscula
        var capitalLetterFound = false
        for capitalLetters in "ABCDEFGHIJKLMNÑOPQRSTUVWXYZ"{
            capitalLetterFound = true
            break
        }
        if capitalLetterFound == false{
            mostrarAlerta(title: "Contraseña inválida", message: "La contraseña debe tener al menos una letra mayúscula")
            return
        }
        
        //Comprobar todos los requerimientos para que la contraseña sea correcta
        let correctPassword = correctWrittenPassword && goodPasswordLength && numberFound && capitalLetterFound
        
        //Mostrar progreso de la petición
        showProgress.isHidden = false
        registerButton.isHidden = true
        
        //Realizar petición
        if correctEmail && correctPassword{
            Alamofire.request(url!, method: .post, parameters: json as Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
                print(response)
                
                self.showProgress.isHidden = true
                self.registerButton.isHidden = false
                let estadoRespuesta = response.response?.statusCode
                if estadoRespuesta == 200{
                    self.mostrarAlerta(title: "¡Bienvenido!", message: "Usuario registrado correctamente")
                    //self.performSegue(withIdentifier: "vistaPrincipal", sender: nil)
                }
                
                if estadoRespuesta == 401{
                    self.mostrarAlerta(title: "Usuario ya registrado", message: "Este email o nombre de usuario ya está registrado en la aplicación")
                }
            }
        }
    }
    
    func mostrarAlerta(title: String, message: String){
        let alerta = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let OK = UIAlertAction(title: "OK", style: .cancel, handler: {(action) in})
        alerta.addAction(OK)
        present(alerta, animated: true, completion: nil)
    }
    
    func uploadPhoto(){
        
    }
    
}
