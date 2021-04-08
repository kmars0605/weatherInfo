import UIKit

class SettingPlaceViewController: UIViewController {
    @IBOutlet var settingPlaceView: SettingPlaceView!

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        var bool = false
        var string = ""
        NotificationCenter.default.addObserver(self, selector: #selector(closePlace), name: .closePlace, object: nil)
        if let _ = UserDefaults.standard.object(forKey: "latest") {
            bool = false
            string = L10n.InputOfPlace.text
        } else {
            bool = true
            string = L10n.InitialInputOfPlace.text
        }
        settingPlaceView.setView(bool: bool, string: string)
    }
    
    @objc func closePlace() {
        self.dismiss(animated: true, completion: nil)
    }
}
