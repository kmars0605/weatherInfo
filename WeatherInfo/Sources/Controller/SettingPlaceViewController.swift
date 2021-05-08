import UIKit
import Network
import PKHUD

class SettingPlaceViewController: UIViewController {
    @IBOutlet var settingPlaceView: SettingPlaceView!
    let userModel = UserModel()
    let monitor = NWPathMonitor()

    override func viewWillAppear(_ animated: Bool) {
        var bool = false
        var string = ""
        NotificationCenter.default.addObserver(self, selector: #selector(saveAddress), name: .saveAddress, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(closePlace), name: .closePlace, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(netWorkCheckCancel), name: .netWorkCheckCancel, object: nil)
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

    @objc func saveAddress() {
        userModel.saveAddress(address: settingPlaceView.address)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func closePlace() {
        netWorkCheckCancel()
        self.dismiss(animated: true, completion: nil)
    }

    @objc func netWorkCheckCancel() {
        monitor.cancel()
    }

    func netWorkCheck() {
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
