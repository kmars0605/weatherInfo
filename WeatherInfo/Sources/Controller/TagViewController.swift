import UIKit

class TagViewController: UIViewController{
    @IBOutlet var tagView: TagView!
    let tagModel = TagModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        tagView.inject(tagModel: tagModel)
        tagView.setView()
    }
}
