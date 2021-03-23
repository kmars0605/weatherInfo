import UIKit
import CoreLocation
import MapKit

class SettingPlaceViewController: UIViewController,UITableViewDelegate, UITableViewDataSource,MKLocalSearchCompleterDelegate,UITextFieldDelegate {

    @IBOutlet weak var cancelIcon: UIImageView!
    @IBOutlet weak var cancelButton: UIButton!
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    let homeViewController = HomeViewController()
    @IBOutlet private weak var textField: UITextField!
    @IBOutlet private weak var tableView: UITableView!
    @IBAction private func textFieldEditingChanged(_ sender: Any) {
        searchCompleter.queryFragment = textField.text!
    }
    private var searchCompleter = MKLocalSearchCompleter()
    var address = "地名"

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        searchCompleter.delegate = self
        textField.delegate = self
    }

    override func viewWillAppear(_ animated: Bool) {

        if let _ = homeViewController.userDefaults.object(forKey: "latest") {
            self.cancelButton.isHidden = false
            self.cancelIcon.isHidden = false
            self.cancelButton.isEnabled = true
            self.textField.placeholder = "位置情報を入力"
        } else {
            self.cancelButton.isHidden = true
            self.cancelIcon.isHidden = true
            self.cancelButton.isEnabled = false
            self.textField.placeholder = "位置情報を登録してください"
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchCompleter.results.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let completion = searchCompleter.results[indexPath.row]
        cell.textLabel?.text = completion.title
        cell.detailTextLabel?.text = completion.subtitle
        return cell
    }

    // 正常に検索結果が更新されたとき
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        tableView.reloadData()
    }

    // 検索が失敗したとき
    func completer(_ completer: MKLocalSearchCompleter, didFailWithError error: Error) {
        print("エラー")
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.address = "\(searchCompleter.results[indexPath.row].title)"

        homeViewController.userDefaults.set(self.address, forKey:"latest")
        homeViewController.userDefaults.synchronize()
        // セルの選択を解除
        tableView.deselectRow(at: indexPath, animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
            // キーボードを閉じる
            textField.resignFirstResponder()
            return true
        }
}
