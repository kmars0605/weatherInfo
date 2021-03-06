import UIKit
import MapKit
import PKHUD

class SettingPlaceView: UIView {
    private var searchCompleter = MKLocalSearchCompleter()
    public var address = "地名"
    private var bool = false
    
    @IBOutlet weak var cancelIcon: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!

    func setView(bool: Bool, string: String) {
        tableView.delegate = self
        tableView.dataSource = self
        searchCompleter.delegate = self
        textField.delegate = self
        cancelButton.isHidden = bool
        cancelIcon.isHidden = bool
        cancelButton.isEnabled = !bool
        if bool {
            self.textField.placeholder = string
        } else {
            textField.placeholder = string
        }
    }
}

extension SettingPlaceView {
    @IBAction func cancelButton(_ sender: Any) {
        NotificationCenter.default.post(name: .closePlace, object: nil)
    }
    @IBAction func textField(_ sender: Any) {
        searchCompleter.queryFragment = textField.text!
    }
}

extension SettingPlaceView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchCompleter.results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let completion = searchCompleter.results[indexPath.row]
        cell.textLabel?.text = completion.title
        cell.detailTextLabel?.text = completion.subtitle
        HUD.hide()
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        address = searchCompleter.results[indexPath.row].title
        CLGeocoder().geocodeAddressString(address) { placemarks, error in
            guard (placemarks?.first?.location?.coordinate.latitude) != nil else {
                //位置情報なし
                HUD.show(.labeledError(title: L10n.LocationErrorView.Title.text, subtitle: L10n.LocationErrorView.Message.text))
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { HUD.hide() }
                return
            }
            NotificationCenter.default.post(name: .saveAddress, object: nil)
            NotificationCenter.default.post(name: .netWorkCheckCancel, object: nil)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

extension SettingPlaceView: MKLocalSearchCompleterDelegate{
    //検索成功
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        tableView.reloadData()
    }
    // 検索失敗
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        HUD.show(.labeledError(title: L10n.SearchErrorView.Title.text, subtitle: nil))
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { HUD.hide() }
    }

    func netWorkError() {
        DispatchQueue.main.async {
            HUD.hide()
            HUD.show(.labeledError(title: L10n.NetWorkErrorView.Title.text, subtitle: L10n.NetWorkErrorView.Message.text))}
    }

    func netWorkSuccess() {
        DispatchQueue.main.async {
            HUD.hide()
        }
    }
}

extension SettingPlaceView: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        HUD.show(.progress)
        textField.resignFirstResponder()
        return true
    }
}
