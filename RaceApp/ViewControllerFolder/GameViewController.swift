import UIKit
import CoreMotion

enum Direction{
    case left
    case right
}

class GameViewController: UIViewController {
    
    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet private weak var leftGrassView: UIView!
    @IBOutlet private weak var rightGrassView: UIView!
    @IBOutlet private weak var roadView: UIView!
    @IBOutlet private weak var roadStickView: UIView!
    @IBOutlet private weak var carOpacityView: UIView!
    @IBOutlet private weak var leftTreeImageView: UIImageView!
    @IBOutlet private weak var rightTreeImageView: UIImageView!
    @IBOutlet private weak var rightTreeUpConstraint: NSLayoutConstraint!
    @IBOutlet private weak var leftTreeUpConstraint: NSLayoutConstraint!
    @IBOutlet private weak var carImageView: UIImageView!
    
    var stickTimer = Timer()
    var leftTreeTimer = Timer()
    var rightTreeTimer = Timer()
    var policeTimer = Timer()
    var crashTimer = Timer()
    var accelerometrTimer = Timer()
    var settings: Settings?
    let carView = UIImageView()
    let policeCar = UIImageView()
    let timerIntervalStick = 0.4
    let animationDuration = 4.0
    let carMoveConstant = 130
    let viewOriginBeforeStart = CGFloat(300)
    let leftTreeTimeInt = 0.5
    let rightTreeTimeInt = 0.6
    let policeCarWidth = CGFloat(90)
    let policeCarHeight = CGFloat(120)
    var motionManager = CMMotionManager()
    let treesArray = [UIImage(named: "firstTree"),
                      UIImage(named: "secondTree"),
                      UIImage(named: "thirdTree"),
                      UIImage(named: "fourthTree"),
                      UIImage(named: "fifthTree"),
                      UIImage(named: "sixTree"),
                      UIImage(named: "sevenTree")]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.settings != nil {
            settings = SettingsManager.shared.getSettings()
        }else{
            settings = SettingsManager.shared.defaultSettings
        }
        self.turnByAccelerometr()
        self.policeEdding()
        self.stickAnimation()
        self.leftTreeAnimation()
        self.rightTreeAnimation()
        self.carEdding()
        self.leftTurn()
        self.rightTurn()
        
        
    }
    override func viewDidLayoutSubviews() {
        self.cross()
    }
    
    // MARK: - Анимация деревьев и дороги
    
    private func stickAnimation() {
        stickTimer = Timer.scheduledTimer(withTimeInterval: timerIntervalStick, repeats: true, block: { (_) in
            let stickView = UIView()
            stickView.frame.origin = self.roadStickView.frame.origin
            stickView.frame.origin.y = self.roadView.frame.origin.y - self.viewOriginBeforeStart
            stickView.frame.size = self.roadStickView.frame.size
            stickView.backgroundColor = self.roadStickView.backgroundColor
            self.roadView.addSubview(stickView)
            UIView.animate(withDuration: self.animationDuration) {
                stickView.frame.origin.y = self.roadView.frame.size.height + self.viewOriginBeforeStart
            }
        })
        stickTimer.fire()
        
    }
    
    private func leftTreeAnimation(){
        leftTreeTimer = Timer.scheduledTimer(withTimeInterval: leftTreeTimeInt, repeats: true, block: { (_) in
            let leftTree = UIImageView()
            leftTree.frame.origin = self.leftTreeImageView.frame.origin
            leftTree.frame.origin.y = self.leftGrassView.frame.origin.y - self.viewOriginBeforeStart
            leftTree.frame.size = self.leftTreeImageView.frame.size
            leftTree.image = self.treesArray.randomElement() as? UIImage
            leftTree.contentMode = .scaleToFill
            self.view.addSubview(leftTree)
            UIView.animate(withDuration: self.animationDuration) {
                leftTree.frame.origin.y = self.leftGrassView.frame.size.height + self.viewOriginBeforeStart
            }
        })
        leftTreeTimer.fire()
    }
    
    private func rightTreeAnimation(){
        rightTreeTimer = Timer.scheduledTimer(withTimeInterval: rightTreeTimeInt, repeats: true, block: { (_) in
            let rightTree = UIImageView()
            rightTree.frame.origin = self.rightTreeImageView.frame.origin
            rightTree.frame.origin.y = self.rightGrassView.frame.origin.y - self.viewOriginBeforeStart
            rightTree.frame.size = self.rightTreeImageView.frame.size
            rightTree.image = self.treesArray.randomElement() as? UIImage
            rightTree.contentMode = .scaleToFill
            self.rightGrassView.addSubview(rightTree)
            UIView.animate(withDuration: self.animationDuration) {
                rightTree.frame.origin.y = self.rightGrassView.frame.size.height + self.viewOriginBeforeStart
            }
        })
        rightTreeTimer.fire()
    }
    
    // MARK: - Добавление Авто и препятствий
    
    private func carEdding(){
        
        carView.frame = carImageView.frame
        guard let img = settings?.car else {return}
        carView.image = UIImage(named: img)
        carView.contentMode = .scaleAspectFill
        self.carOpacityView.addSubview(carView)
        
    }
    
    private func policeEdding(){
        
        let firstPoliceXpocition = self.carImageView.frame.origin.x
        let secondPoliceXpocition = self.carImageView.frame.origin.x - CGFloat(carMoveConstant)
        self.policeCar.frame.size = CGSize(width: self.policeCarWidth, height: self.policeCarHeight)
        guard let img = settings?.police else {return}
        self.policeCar.image = UIImage(named:img)
        self.policeCar.contentMode = .scaleAspectFit
        let positionInRoadArray: [CGFloat] = [firstPoliceXpocition, secondPoliceXpocition]
        
        policeTimer = Timer.scheduledTimer(withTimeInterval: 4, repeats: true, block: { (_) in
            
            self.policeCar.frame.origin.y = self.carOpacityView.frame.origin.y - self.viewOriginBeforeStart
            let randomXposition = positionInRoadArray.randomElement()
            self.policeCar.frame.origin.x = randomXposition!
            self.carOpacityView.addSubview(self.policeCar)
            
            UIView.animate(withDuration: self.animationDuration) {
                self.policeCar.frame.origin.y = self.carOpacityView.frame.size.height + self.viewOriginBeforeStart
            }
        })
    }
    
    private func cross(){
        guard let userName = settings?.name else {return}
        crashTimer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (_) in
            guard let police = self.policeCar.layer.presentation() else {return}
            if police.frame.intersects(self.carView.frame) {
                //                self.view.layer.removeAllAnimations()
                //                self.carView.layer.removeAllAnimations()
                self.showAlert(title: "Приехали!", message: "Предъявите документики, \(userName) !", prefferedStyle: .alert, firstButtonText: "Показать", firstButtonStyle: .cancel, firstButtonAction: { (_) in
                    self.navigationController?.popViewController(animated: true)
                }, secondButtonText: "Скрыться!", secondButtonStyle: .default, secondButtonAction: nil)
            }
        })
    }
    // MARK: - Наклонные повороты
//    
//    private func turnByAccelerometr(){
//
//            accelerometrTimer = Timer.scheduledTimer(withTimeInterval: 1/60, repeats: true) { (_) in
//            guard let motion = self.motionManager.accelerometerData?.acceleration.x else {return}
//                self.carView.frame.origin.x = CGFloat(motion) * 10
//
//                self.view.layoutIfNeeded()
//                print(motion)
//        }
//        accelerometrTimer.fire()
//
//    }
//
    
    
    // MARK: - Свайпы
    
    private func leftTurn(){
        
        let recognizerSwipe = UISwipeGestureRecognizer(target: self, action: #selector(leftSwipeDetected(_:)))
        recognizerSwipe.direction = .left
        self.view.addGestureRecognizer(recognizerSwipe)
        
    }
    
    @IBAction private func leftSwipeDetected(_ sender: UISwipeGestureRecognizer){
        if canMove(direction: .left) {
            UIView.animate(withDuration: 0.3) {
                self.carView.frame.origin.x -= CGFloat(self.carMoveConstant)
            }
        }
    }
    
    
    private func rightTurn(){
        let recognizerSwipe = UISwipeGestureRecognizer(target: self, action: #selector(rightSwipeDetected(_:)))
        recognizerSwipe.direction = .right
        self.view.addGestureRecognizer(recognizerSwipe)
    }
    
    @IBAction private func rightSwipeDetected(_ sender: UISwipeGestureRecognizer){
        if canMove(direction: .right) {
            UIView.animate(withDuration: 0.3) {
                self.carView.frame.origin.x += CGFloat(self.carMoveConstant)
            }
        }
    }
    
    
    
    // MARK: - Проверка возможности перемещения авто
    
    private func canMove(direction: Direction)->Bool{
        
        switch direction {
        case .left:
            if carView.frame.origin.x  > roadView.frame.origin.x {
                return true
            }else{
                
                showAlert(title: "Easy,Easy!", message: "Be carefull with the LEFT road curb!", prefferedStyle: .alert, firstButtonText: "Continue", firstButtonStyle: .default, firstButtonAction: nil, secondButtonText: "Restart", secondButtonStyle: .cancel) { (_) in
                    self.navigationController?.popViewController(animated: true)
                }
                return false
            }
            
        case .right:
            if carView.frame.origin.x + carView.frame.size.width < roadView.frame.size.width - roadView.frame.origin.x{
                return true
            }else{
                showAlert(title: "Easy,Easy!", message: "Be carefull with the RIGHT road curb!", prefferedStyle: .alert, firstButtonText: "Continue", firstButtonStyle: .default, firstButtonAction: nil, secondButtonText: "Restart", secondButtonStyle: .cancel) { (_) in
                    self.navigationController?.popViewController(animated: true)
                }
                return false
            }
        }
    }
    
    @IBAction private func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
// MARK: - Extensions для алерта

extension UIViewController{
    
    func showAlert(title: String?,message: String?,prefferedStyle:UIAlertController.Style, firstButtonText: String?,firstButtonStyle: UIAlertAction.Style, firstButtonAction: ((UIAlertAction) -> Void)?,secondButtonText: String?,secondButtonStyle: UIAlertAction.Style, secondButtonAction: ((UIAlertAction) -> Void)?)  {
        let alertCntrl = UIAlertController(title: title, message: message, preferredStyle: prefferedStyle)
        let firstButton = UIAlertAction(title: firstButtonText, style:firstButtonStyle, handler: firstButtonAction)
        let secondButton = UIAlertAction(title: secondButtonText, style:secondButtonStyle, handler: secondButtonAction)
        alertCntrl.addAction(firstButton)
        alertCntrl.addAction(secondButton)
        self.present(alertCntrl,animated: true)
    }
    
    func showAlert(title: String?,message: String?,prefferedStyle:UIAlertController.Style, firstButtonText: String?,firstButtonStyle: UIAlertAction.Style, firstButtonAction: ((UIAlertAction) -> Void)?){
        
        let alertCntrl = UIAlertController(title: title, message: message, preferredStyle: prefferedStyle)
        let firstButton = UIAlertAction(title: firstButtonText, style:firstButtonStyle, handler: firstButtonAction)
        alertCntrl.addAction(firstButton)
        self.present(alertCntrl,animated: true)
    }
    func startDate() -> String {
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MMMM-yyyy HH:mm"
        let currentDate = dateFormatter.string(from: date)
        return currentDate
    }
}
