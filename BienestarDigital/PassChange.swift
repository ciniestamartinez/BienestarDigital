import UIKit
import Alamofire

class PassChange: UIViewController {
    
    //Outlets
    @IBOutlet weak var newPassword: UITextField!
    @IBOutlet weak var repeatNewPassword: UITextField!
    @IBOutlet weak var showProgress: UIActivityIndicatorView!
    @IBOutlet weak var saveChangesButton: UIButton!
    
    //Actions
    @IBAction func saveNewPasswordButton(_ sender: Any) {
        changePassword()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Functions
    public func changePassword(){
        //Ruta de end-point
        let url = "http://localhost:8888/BienestarDigital/public/index.php/api/changePassword"
        
        //Comprobar contraseña bien escrita
        var correctWrittenNewPassword = false
        if newPassword.text == repeatNewPassword.text{
            correctWrittenNewPassword = true
        }
        if correctWrittenNewPassword == false{
            mostrarAlerta(title: "Contraseña incorrecta", message: "Las dos contraseñas son distintas")
        }
        
        //Comprobar longitud de contraseña
        let newPasswordLength = newPassword.text?.count
        var goodNewPasswordLength = true
        if newPasswordLength! < 5{
            mostrarAlerta(title: "Contraseña demasiado corta", message: "La contraseña debe tener al menos 5 carácteres")
            goodNewPasswordLength = false
            return
        }
        if newPasswordLength! > 15{
            mostrarAlerta(title: "Contraseña demasiado larga", message: "La contraseña debe tener menos de 15 carácteres")
            goodNewPasswordLength = false
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
        
        //Comprobar que la nueva contraseña sea diferente a la anterior
        var differentNewPassword = false
        if newPassword.text == repeatNewPassword.text{
            var differentNewPassword = true
        }
        if newPassword.text != repeatNewPassword.text{
            mostrarAlerta(title: "Error", message: "La contraseña que quieres cambiar es la misma que la anterior")
        }
        
        //Comprobar todos los requerimientos para que la nueva contraseña sea correcta y poder mandarla al servidor para cambiarla
        var checkedNewPassword = ""
        if correctWrittenNewPassword && goodNewPasswordLength && numberFound && capitalLetterFound && differentNewPassword{
            checkedNewPassword = newPassword.text!
        }
            
        //Datos que se mandan a la API
        let json = ["password": checkedNewPassword]
        
        //Mostrar progreso de la petición
        showProgress.isHidden = false
        saveChangesButton.isHidden = true
        
        //Realizar petición
        Alamofire.request(url, method: .post, parameters: json as Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            print(response)
            
        //Comprobar estado de la petición
            self.showProgress.isHidden = true
            self.saveChangesButton.isHidden = false
            
            let estadoRespuesta = response.response?.statusCode
            if estadoRespuesta == 200{
                self.mostrarAlerta(title: "Contraseña cambiada", message: "Se ha cambiado correctamente su contraseña")
                //performSegue(withIdentifier: <#T##String#>, sender: <#T##Any?#>)
            }
            if estadoRespuesta == 401{
                self.mostrarAlerta(title: "Error", message: "La contraseña es la misma que la anterior")
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
