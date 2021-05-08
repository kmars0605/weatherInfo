import UIKit

class IconDescViewController: UIViewController {
    @IBOutlet var iconDescView: IconDescView!
    let iconModel = IconModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        iconDescView.inject(iconModel: iconModel)
        iconDescView.setView()
        NotificationCenter.default.addObserver(self, selector: #selector(closeIcon), name: .closeIcon, object: nil)
    }
    
    @objc func closeIcon() {
        self.dismiss(animated: true, completion: nil)
    }
}
