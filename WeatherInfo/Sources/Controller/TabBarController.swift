import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let userModel = UserModel()
        for item in (self.tabBar.items)! {
            item.imageInsets = UIEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)
        }
        if  userModel.loadAddress() == nil {
            let settingPlaceViewController = self.storyboard?.instantiateViewController(withIdentifier: "SettingPlace")
            self.present(settingPlaceViewController!, animated: true, completion: nil)
        }
    }
}
