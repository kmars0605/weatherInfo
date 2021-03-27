import UIKit

class TagTableViewCell: UITableViewCell {
    @IBOutlet weak var JISLabel: UILabel!
    @IBOutlet weak var newJISLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
