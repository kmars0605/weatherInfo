import UIKit
import SafariServices

class SettingView: UIView {
    @IBOutlet var tableView: UITableView!
    private let array = ["地点登録","アイコン説明","お問い合わせ"]
    func setView() {
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension SettingView: UITableViewDataSource,UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        // セルに表示する値を設定する
        cell.textLabel!.text = array[indexPath.row]
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{
            NotificationCenter.default.post(name: .toSettingPlace, object: nil)
        } else if indexPath.row == 2{
            NotificationCenter.default.post(name: .toSafari, object: nil)
        } else if indexPath.row == 1{
            NotificationCenter.default.post(name: .toIconDesc, object: nil)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
