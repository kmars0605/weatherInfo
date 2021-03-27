import UIKit

class IconDescTableViewCell: UITableViewCell {
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var iconImage: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
