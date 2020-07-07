import UIKit

class TabelViewController: UIViewController {

    @IBOutlet private weak var backButton: UIButton!
    @IBOutlet weak var scoreTableView: UITableView!
    var massiv: [Int] = [1,2,3,4,5]
    override func viewDidLoad() {
        super.viewDidLoad()

       
    }
    
    @IBAction private func backButtonPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}
extension TabelViewController: UITableViewDataSource,UITableViewDelegate{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.massiv.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as? CustomTableViewCell  else {
            return UITableViewCell()
        }
        cell.positionLabel.text = String(massiv[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           tableView.deselectRow(at: indexPath, animated: true)
       }
    
}
