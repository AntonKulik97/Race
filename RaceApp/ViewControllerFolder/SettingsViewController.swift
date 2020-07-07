
import UIKit

class SettingsViewController: UIViewController {
    
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet weak var raceNameLabel: UILabel!
    @IBOutlet weak var leftButtonRaceView: UIButton!
    @IBOutlet weak var rightButtonRaceView: UIButton!
    @IBOutlet weak var raceCarImage: UIImageView!
    @IBOutlet weak var leftButtonPoliceView: UIButton!
    @IBOutlet weak var rightButtonPoliceView: UIButton!
    @IBOutlet weak var policeCarImage: UIImageView!
    @IBOutlet weak var nameOfRacer: UITextField!
    var countCar :Int = 0
    var countPolice :Int = 0
    var countElementsOfCarArray :Int = 0
    var countElementsOfPoliceArray :Int = 0
    var settings: Settings?
    var carImageArray = ["car","car2", "car3","car4","car5","car6","car7"]
    var policeImageArray = ["police_car","police_car2","police_car3"]
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.countElementsOfCarArray = carImageArray.count
        self.countElementsOfPoliceArray = policeImageArray.count
        
        if self.settings != nil{
            self.settings = SettingsManager.shared.getSettings()
        } else{
            self.settings = SettingsManager.shared.defaultSettings
            
        }
        
        guard let carImg = settings?.car else {return}
        raceCarImage.image = UIImage(named: carImg)
        guard let policeImg = settings?.police else {return}
        policeCarImage.image = UIImage(named: policeImg)
  
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if self.settings != nil{
            SettingsManager.shared.setSettings()
        }
    }
    
    @IBAction private func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
        self.settings?.name = nameOfRacer.text
    }
    
    
    @IBAction func leftButtonRaceViewPressed(_ sender: UIButton) {
        if countCar == 0 {
            countCar = countElementsOfCarArray
            self.raceCarImage.image = UIImage(named: carImageArray[countCar - 1])
            settings?.car = carImageArray[countCar - 1]
        }else if countCar > 0{
            countCar -= 1
            raceCarImage.image = UIImage(named: carImageArray[countCar])
            settings?.car = carImageArray[countCar]
        }
    }
    
    @IBAction func rightButtonRaceViewPressed(_ sender: UIButton) {
        if countCar >= countElementsOfCarArray - 1 {
            countCar = 0
            self.raceCarImage.image = UIImage(named: carImageArray[countCar])
            settings?.car = carImageArray[countCar]
        } else {
            countCar += 1
            self.raceCarImage.image = UIImage(named: carImageArray[countCar])
            settings?.car = carImageArray[countCar]
        }
    }
    
    @IBAction func leftButtonPoliceViewPressed(_ sender: UIButton) {
        if countPolice == 0 {
            countPolice = countElementsOfPoliceArray - 1
            self.policeCarImage.image = UIImage(named: policeImageArray[countPolice])
            settings?.police = policeImageArray[countPolice]
        }else if countPolice > 0{
            countPolice -= 1
            policeCarImage.image = UIImage(named: policeImageArray[countPolice])
            settings?.police = policeImageArray[countPolice]
        }
    }
    
    @IBAction func rightButtonPoliceViewPressed(_ sender: UIButton) {
        if countPolice == countElementsOfPoliceArray - 1 {
            countPolice = 0
            self.policeCarImage.image =  UIImage(named: policeImageArray[countPolice])
            settings?.police = policeImageArray[countPolice]
        } else {
            countPolice += 1
            self.policeCarImage.image = UIImage(named: policeImageArray[countPolice])
            settings?.police = policeImageArray[countPolice]
        }
    }
    
}
