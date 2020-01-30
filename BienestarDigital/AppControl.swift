import UIKit
import Alamofire

class AppControl: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    var maxTime : Int = 0
    
    //Outlets
    @IBOutlet weak var photoApp: UIImageView!
    @IBOutlet weak var appSelector: UIPickerView!
    @IBOutlet weak var timeSlider: UISlider!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var initialHour: UIDatePicker!
    @IBOutlet weak var finalHour: UIDatePicker!
    
    //Actions
    @IBAction func saveRestrictionButton(_ sender: Any) {
        
    }
    
    @IBAction func setMaxTimeSlider(_ sender: UISlider) {
        maxTime = Int(sender.value)
        timeLabel.text = String(maxTime) + "h"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getInitialRestrictionHour()
        getFinalRestrictionHour()
    }
    
    //Functions
    
    let apps = ["Whatsapp", "Instagram", "Twitter", "Youtube", "Snapchat", "Spotify"]
    
    //Número de columnas
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //Número de filas
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return apps.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return apps[row]
    }
    
    /*func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
     var appSelected = apps[row]
     }*/
    
    public func getApplicationToRestrict(){
        
    }
    
    public func getInitialRestrictionHour(){
        let date = initialHour.date
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour
        let minute = components.minute
        print ("La hora inicial de restricción es: ", hour as Any, minute as Any)
    }
    
    public func getFinalRestrictionHour(){
        let date = initialHour.date
        let components = Calendar.current.dateComponents([.hour, .minute], from: date)
        let hour = components.hour
        let minute = components.minute
        print ("La hora final de restricción es: ", hour as Any, minute as Any)
    }
}
