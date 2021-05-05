import UIKit
class TagView: UIView {
    var tagModel = TagModel()
    @IBOutlet weak var tagTableView: UITableView!

    public func setView() {
        let nib = UINib(nibName: "TagTableViewCell", bundle: nil)
        tagTableView.register(nib, forCellReuseIdentifier: "Cell")
        tagTableView.delegate = self
        tagTableView.dataSource = self
    }
}

extension TagView: UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tagModel.sectionTitle.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return tagModel.arrayData1.count
        }
        else if section == 1 {
            return tagModel.arrayData2.count
        }
        else if section == 2 {
            return tagModel.arrayData3.count
        }
        else if section == 3 {
            return tagModel.arrayData4.count
        }
        else if section == 4 {
            return tagModel.arrayData5.count
        }
        else if section == 5 {
            return tagModel.arrayData6.count
        }
        else if section == 6 {
            return tagModel.arrayData7.count
        }
        else{
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TagTableViewCell
        if indexPath.section == 0{
            cell.newJISLabel.text = tagModel.arrayData1[indexPath.row]["title"]
            cell.descLabel.text = tagModel.arrayData1[indexPath.row]["content"]
            cell.JISLabel.text = tagModel.arrayData1[indexPath.row]["JIS"]
        }else if indexPath.section == 1{
            cell.newJISLabel.text = tagModel.arrayData2[indexPath.row]["title"]
            cell.descLabel.text = tagModel.arrayData2[indexPath.row]["content"]
            cell.JISLabel.text = tagModel.arrayData2[indexPath.row]["JIS"]
        }else if indexPath.section == 2{
            cell.newJISLabel.text = tagModel.arrayData3[indexPath.row]["title"]
            cell.descLabel.text = tagModel.arrayData3[indexPath.row]["content"]
            cell.JISLabel.text = tagModel.arrayData3[indexPath.row]["JIS"]
        }else if indexPath.section == 3{
            cell.newJISLabel.text = tagModel.arrayData4[indexPath.row]["title"]
            cell.descLabel.text = tagModel.arrayData4[indexPath.row]["content"]
            cell.JISLabel.text = tagModel.arrayData4[indexPath.row]["JIS"]
        }else if indexPath.section == 4{
            cell.newJISLabel.text = tagModel.arrayData5[indexPath.row]["title"]
            cell.descLabel.text = tagModel.arrayData5[indexPath.row]["content"]
            cell.JISLabel.text = tagModel.arrayData5[indexPath.row]["JIS"]
        }else if indexPath.section == 5{
            cell.newJISLabel.text = tagModel.arrayData6[indexPath.row]["title"]
            cell.descLabel.text = tagModel.arrayData6[indexPath.row]["content"]
            cell.JISLabel.text = tagModel.arrayData6[indexPath.row]["JIS"]
        }else if indexPath.section == 6{
            cell.newJISLabel.text = tagModel.arrayData7[indexPath.row]["title"]
            cell.descLabel.text = tagModel.arrayData7[indexPath.row]["content"]
            cell.JISLabel.text = tagModel.arrayData7[indexPath.row]["JIS"]
        }
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tagModel.sectionTitle[section]
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        view.tintColor = UIColor.lightGray
    }
}
