import UIKit

class TabBarController: UITabBarController {
    let homeViewController = HomeViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if UserDefaults.standard.object(forKey: "latest") == nil {
            let settingPlaceViewController = self.storyboard?.instantiateViewController(withIdentifier: "SettingPlace")
            self.present(settingPlaceViewController!, animated: true, completion: nil)
        }
    }
}
