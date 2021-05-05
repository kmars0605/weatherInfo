import UIKit
import Network
import PKHUD

class SettingPlaceViewController: UIViewController {
    @IBOutlet var settingPlaceView: SettingPlaceView!
    let userModel = UserModel()

    override func viewWillAppear(_ animated: Bool) {
        var bool = false
        var string = ""

        NotificationCenter.default.addObserver(self, selector: #selector(closePlace), name: .closePlace, object: nil)
        if let _ = userModel.loadAddress() {
            bool = false
            string = L10n.InputOfPlace.text
        } else {
            bool = true
            string = L10n.InitialInputOfPlace.text
        }
        settingPlaceView.setView(bool: bool, string: string)
    }

    override func viewDidAppear(_ animated: Bool) {
        netWorkCheck()
    }
    
    @objc func closePlace() {
        self.dismiss(animated: true, completion: nil)
    }

    func netWorkCheck() {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                //通信環境あり
                self.settingPlaceView.netWorkSuccess()
            } else {
                //通信環境なし
                self.settingPlaceView.netWorkError()
            }
        }
        let queue = DispatchQueue(label: "Monitor")
        monitor.start(queue: queue)
    }
}
