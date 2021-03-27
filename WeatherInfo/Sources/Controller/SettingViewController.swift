import UIKit
import SafariServices

class SettingViewController: UIViewController{
    @IBOutlet var settingView: SettingView!

    override func viewDidLoad() {
        super.viewDidLoad()
        settingView.setView()
        NotificationCenter.default.addObserver(self, selector: #selector(toSettingPlace), name: .toSettingPlace, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(toSafari), name: .toSafari, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(toIconDesc), name: .toIconDesc, object: nil)
    }

    func setSettingViewController() {
        NotificationCenter.default.addObserver(self, selector: #selector(toSettingPlace), name: .toSettingPlace, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(toSafari), name: .toSafari, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(toIconDesc), name: .toIconDesc, object: nil)
    }

    @objc func toSettingPlace() {
        let settingPlaceViewController = self.storyboard?.instantiateViewController(withIdentifier: "SettingPlace")
        self.present(settingPlaceViewController!, animated: true, completion: nil)
        let UINavigationController = tabBarController?.viewControllers?[0]
        tabBarController?.selectedViewController = UINavigationController
    }

    @objc func toSafari() {
        let url = URL(string:L10n.SafariURL.text)
        if let url = url{
            let vc = SFSafariViewController(url: url)
            present(vc, animated: true, completion: nil)
        }
    }

    @objc func toIconDesc() {
        let settingPlaceViewController = self.storyboard?.instantiateViewController(withIdentifier: "IconDesc")
        self.present(settingPlaceViewController!, animated: true, completion: nil)
    }
}
