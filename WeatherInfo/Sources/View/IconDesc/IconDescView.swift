import UIKit

class IconDescView: UIView {
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var iconTableView: UITableView!
    private var iconModel: IconModel!

    func inject(iconModel: IconModel) {
        self.iconModel = iconModel
    }
    
    public func setView() {
        let nib = UINib(nibName: "IconDescTableViewCell", bundle: nil)
        iconTableView.register(nib, forCellReuseIdentifier: "Cell")
        cancelButton.frame = CGRect(origin: .zero, size: CGSize(width: 44, height: 44))
        iconTableView.delegate = self
        iconTableView.dataSource = self
    }
}

extension IconDescView {
    @IBAction func cancelButton(_ sender: Any) {
        NotificationCenter.default.post(name: .closeIcon, object: nil)
    }
}

extension IconDescView: UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return iconModel.sectionTitle.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return iconModel.arrayData1.count
        }
        else if section == 1 {
            return iconModel.arrayData2.count
        }
        else{
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! IconDescTableViewCell
        if indexPath.section == 0{
            cell.iconImage.image = UIImage(named: String(iconModel.arrayData1[indexPath.row]["title"]!))
            cell.descLabel.text = iconModel.arrayData1[indexPath.row]["content"]
        }else if indexPath.section == 1{
            cell.iconImage.image = UIImage(named: String(iconModel.arrayData2[indexPath.row]["title"]!))
            cell.descLabel.text = iconModel.arrayData2[indexPath.row]["content"]
        }
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return iconModel.sectionTitle[section]
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.lightGray
    }
}
