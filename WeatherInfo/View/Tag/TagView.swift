import UIKit
class TagView: UIView {
    var tagData: Tag?
    @IBOutlet weak var tagTableView: UITableView!
    public func setView(tag: Tag) {
        self.tagData = tag
        let nib = UINib(nibName: "TagTableViewCell", bundle: nil)
        tagTableView.register(nib, forCellReuseIdentifier: "Cell")
        tagTableView.delegate = self
        tagTableView.dataSource = self
    }
}

extension TagView: UITableViewDataSource,UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return tagData!.sectionTitle.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return tagData!.arrayData1.count
        }
        else if section == 1 {
            return tagData!.arrayData2.count
        }
        else if section == 2 {
            return tagData!.arrayData3.count
        }
        else if section == 3 {
            return tagData!.arrayData4.count
        }
        else if section == 4 {
            return tagData!.arrayData5.count
        }
        else if section == 5 {
            return tagData!.arrayData6.count
        }
        else if section == 6 {
            return tagData!.arrayData7.count
        }
        else{
            return 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! TagTableViewCell
        if indexPath.section == 0{
            cell.newJISLabel.text = tagData!.arrayData1[indexPath.row]["title"]
            cell.descLabel.text = tagData!.arrayData1[indexPath.row]["content"]
            cell.JISLabel.text = tagData!.arrayData1[indexPath.row]["JIS"]

        }else if indexPath.section == 1{
            cell.newJISLabel.text = tagData!.arrayData2[indexPath.row]["title"]
            cell.descLabel.text = tagData!.arrayData2[indexPath.row]["content"]
            cell.JISLabel.text = tagData!.arrayData2[indexPath.row]["JIS"]
        }else if indexPath.section == 2{
            cell.newJISLabel.text = tagData!.arrayData3[indexPath.row]["title"]
            cell.descLabel.text = tagData!.arrayData3[indexPath.row]["content"]
            cell.JISLabel.text = tagData!.arrayData3[indexPath.row]["JIS"]
        }else if indexPath.section == 3{
            cell.newJISLabel.text = tagData!.arrayData4[indexPath.row]["title"]
            cell.descLabel.text = tagData!.arrayData4[indexPath.row]["content"]
            cell.JISLabel.text = tagData!.arrayData4[indexPath.row]["JIS"]
        }else if indexPath.section == 4{
            cell.newJISLabel.text = tagData!.arrayData5[indexPath.row]["title"]
            cell.descLabel.text = tagData!.arrayData5[indexPath.row]["content"]
            cell.JISLabel.text = tagData!.arrayData5[indexPath.row]["JIS"]
        }else if indexPath.section == 5{
            cell.newJISLabel.text = tagData!.arrayData6[indexPath.row]["title"]
            cell.descLabel.text = tagData!.arrayData6[indexPath.row]["content"]
            cell.JISLabel.text = tagData!.arrayData6[indexPath.row]["JIS"]
        }else if indexPath.section == 6{
            cell.newJISLabel.text = tagData!.arrayData7[indexPath.row]["title"]
            cell.descLabel.text = tagData!.arrayData7[indexPath.row]["content"]
            cell.JISLabel.text = tagData!.arrayData7[indexPath.row]["JIS"]
        }
        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return tagData!.sectionTitle[section]
    }

    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        // 背景色を変更する
        view.tintColor = UIColor.lightGray
    }
}
