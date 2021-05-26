import UIKit

class IconDescViewController: UIViewController {
    @IBOutlet private var iconDescView: IconDescView!
    private let iconModel = IconModel()
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
