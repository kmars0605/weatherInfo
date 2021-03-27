import UIKit

class IconDescViewController: UIViewController {
    @IBOutlet var iconDescView: IconDescView!

    override func viewDidLoad() {
        super.viewDidLoad()
        iconDescView.setView()
        NotificationCenter.default.addObserver(self, selector: #selector(closeIcon), name: .closeIcon, object: nil)
    }
    
    @objc func closeIcon() {
        self.dismiss(animated: true, completion: nil)
    }
}
