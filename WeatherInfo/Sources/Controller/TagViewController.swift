import UIKit

class TagViewController: UIViewController{
    
    @IBOutlet var tagView: TagView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tagView.setView()
    }
}
