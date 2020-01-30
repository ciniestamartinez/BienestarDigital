import UIKit
import Alamofire

class PassReset: UIViewController {
    
    //Outlets
    @IBOutlet weak var goBack: UIButton!
    @IBOutlet weak var emailUser: UITextField!
    @IBOutlet weak var showProgress: UIActivityIndicatorView!
    @IBOutlet weak var sendAccessKeyButton: UIButton!
    
    //Actions
    @IBAction func sendPassToEmailButton(_ sender: Any) {
        sendNewPass()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Functions
    func sendNewPass() {
        //Ruta de end-point
        let url = URL(string: "http://localhost:8888/BienestarDigital/public/index.php/api/resetPassword")
        
        //Datos que se mandan a la API
        let json = ["email": emailUser.text]
        
        //Mostrar progreso de la petición
        showProgress.isHidden = false
        sendAccessKeyButton.isHidden = true
        
        //Realizar petición
        Alamofire.request(url!, method: .post, parameters: json as Parameters, encoding: JSONEncoding.default, headers: nil).responseJSON { (response) in
            print(response)
        
        //Comprobar estado de la petición
            self.showProgress.isHidden = true
            self.sendAccessKeyButton.isHidden = false
            let estadoRespuesta = response.response?.statusCode
            if estadoRespuesta == 200{
                self.mostrarAlerta(title: "Contraseña reestablecida", message: "Compruebe su correo electrónico para ver su nueva contraseña")
                self.goBack.isHidden = false
                //performSegue(withIdentifier: <#T##String#>, sender: <#T##Any?#>)
            }
            if estadoRespuesta == 401{
                self.mostrarAlerta(title: "Error", message: "El email no está registrado en la aplicación")
                self.goBack.isHidden = false
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
