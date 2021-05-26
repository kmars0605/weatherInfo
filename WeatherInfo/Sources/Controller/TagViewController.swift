import UIKit

class TagViewController: UIViewController{
    @IBOutlet private var tagView: TagView!
    private let tagModel = TagModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        tagView.inject(tagModel: tagModel)
        tagView.setView()
    }
}
