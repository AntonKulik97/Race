import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var startGameButton: UIButton!
    @IBOutlet weak var scoreButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var carFontView: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.startGameButton.buttonRadius()
        self.scoreButton.buttonRadius()
        self.settingsButton.buttonRadius()
        self.startGameButton.dropShadow(color: .black, offSet: CGSize(width: 5, height: 5), scale: false, cornerRadius: startGameButton.layer.cornerRadius )
        self.scoreButton.dropShadow(color: .black, offSet: CGSize(width: 5, height: 5), scale: false, cornerRadius: scoreButton.layer.cornerRadius )
        self.settingsButton.dropShadow(color: .black, offSet: CGSize(width: 5, height: 5), scale: false, cornerRadius: settingsButton.layer.cornerRadius )
        addParallaxToView(view: carFontView, magnitude: 30)
    }
    
    @IBAction func startGameButtonPressed(_ sender: UIButton) {
        guard let gameController = self.storyboard?.instantiateViewController(withIdentifier: "GameViewController") as? GameViewController else {return}
        self.navigationController?.pushViewController(gameController, animated: true)
    }
    
    @IBAction func scoreButtonPressed(_ sender: UIButton) {
        guard let tabelController = self.storyboard?.instantiateViewController(withIdentifier: "TabelViewController") as? TabelViewController else {return}
        self.navigationController?.pushViewController(tabelController, animated: true)
    }
    
    
    @IBAction func settingsButtonPressed(_ sender: UIButton) {
        guard let settingsController = self.storyboard?.instantiateViewController(withIdentifier: "SettingsViewController") as? SettingsViewController else {return}
        self.navigationController?.pushViewController(settingsController, animated: true)
    }
    
    func addParallaxToView(view: UIView, magnitude: Float) {
        let horizontal = UIInterpolatingMotionEffect(keyPath: "center.x", type: .tiltAlongHorizontalAxis)
        horizontal.minimumRelativeValue = -magnitude
        horizontal.maximumRelativeValue = magnitude

        let vertical = UIInterpolatingMotionEffect(keyPath: "center.y", type: .tiltAlongVerticalAxis)
        vertical.minimumRelativeValue = -magnitude
        vertical.maximumRelativeValue = magnitude

        let group = UIMotionEffectGroup()
        group.motionEffects = [horizontal, vertical]
        view.addMotionEffect(group)
    }
}

extension UIView{
    func viewStyle(radius: CGFloat = 20, opacity: CGFloat = 0.8) {
        self.layer.cornerRadius = radius
        self.backgroundColor = .black
        self.layer.opacity = Float(opacity)
    }
    
    func buttonRadius(radius: CGFloat = 20, opacity: Float = 0.8){
        self.layer.cornerRadius = radius
        self.layer.opacity = opacity
    }
    
    func dropShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale:Bool = true, cornerRadius:CGFloat = 20 ){
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
}




