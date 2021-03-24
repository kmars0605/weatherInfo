import Foundation
import PKHUD
import Combine
import Alamofire

class WeatherModel {
    let decorder = JSONDecoder()
    var requestCancellable: Cancellable?
    var onecall: OneCall?
    var detail: [DailyWeatherDetail] = []

    deinit {
        requestCancellable?.cancel()
    }
    //URLSessionでの実装
    func request(latitude: Double, longitude: Double, address: String) {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=metric&APPID=12de4b711b7224a6556ea9e11f9a03ee")!
        HUD.show(.progress)
        requestCancellable = URLSession.shared.dataTaskPublisher(for: URLRequest(url: url))
            .map({(data, res) in
                return data
            })
            .decode(type: OneCall.self, decoder: decorder)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("通信成功")
                case .failure(let error):
                    print("エラー:\(error)")
                    HUD.flash(.labeledError(title: "通信に失敗しました。", subtitle: nil))
                }
            }, receiveValue: { [self] onecall in
                self.onecall = onecall
                for i in onecall.daily {
                    detail.append(DailyWeatherDetail(daily: i))
                }
                //OneCallのデータを保存
                saveOnecall(items: [onecall])
                saveDetail(items: detail)
                detail.removeAll()
                //通信した時間の1時間後をunixで保存
                UserDefaults.standard.set(self.onecall!.hourly[1].dt, forKey: "upper")
            })
        UserDefaults.standard.set(true, forKey: "reVisit")
    }
    //Alamofireでの実装
    func requestAF(latitude: Double, longitude: Double, address: String) {
        var detail: [DailyWeatherDetail] = []
        let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=metric&APPID=12de4b711b7224a6556ea9e11f9a03ee"
        HUD.show(.progress)
        requestCancellable = AF.request(url).publishDecodable(type: OneCall.self, decoder: decorder)
            .value()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("通信成功")
                case .failure(let error):
                    print("エラー:\(error)")
                    HUD.flash(.labeledError(title: "通信に失敗しました。", subtitle: nil))
                }
            }, receiveValue: { [self] onecall in
                self.onecall = onecall
                for i in onecall.daily {
                    detail.append(DailyWeatherDetail(daily: i))
                }
//                homeView.onecall = onecall
//                homeView.setView(address: address, onecall: self.onecall!, detail: detail)
                HUD.hide()
                //OneCallのデータを保存
                saveOnecall(items: [onecall])
                saveDetail(items: detail)
                detail.removeAll()
                //通信した時間の1時間後をunixで保存
                UserDefaults.standard.set(self.onecall!.hourly[1].dt, forKey: "upper")
            })
        UserDefaults.standard.set(true, forKey: "reVisit")
    }

    func saveOnecall(items: [OneCall]) {
        let data = items.map { try! JSONEncoder().encode($0) }
        UserDefaults.standard.set(data as [Any], forKey: "oneCall")
    }

    func readOnecall() -> [OneCall]? {
        guard let items = UserDefaults.standard.array(forKey: "oneCall") as? [Data] else { return [OneCall]() }
        let decodedItems = items.map { try! JSONDecoder().decode(OneCall.self, from: $0) }
        return decodedItems
    }

    func saveDetail(items: [DailyWeatherDetail]) {
        let data = items.map { try! JSONEncoder().encode($0) }
        UserDefaults.standard.set(data as [Any], forKey: "detail")
    }

    func readDetail() -> [DailyWeatherDetail]? {
        guard let items = UserDefaults.standard.array(forKey: "detail") as? [Data] else { return [DailyWeatherDetail]() }
        let decodedItems = items.map { try! JSONDecoder().decode(DailyWeatherDetail.self, from: $0) }
        return decodedItems
    }
}
