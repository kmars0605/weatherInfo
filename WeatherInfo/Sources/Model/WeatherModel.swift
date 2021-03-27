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
}
extension WeatherModel {
    //URLSessionでの実装
    func request(latitude: Double, longitude: Double, address: String) {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=metric&APPID=12de4b711b7224a6556ea9e11f9a03ee")!
        requestCancellable = URLSession.shared.dataTaskPublisher(for: URLRequest(url: url))
            .map({(data, res) in
                return data
            })
            .decode(type: OneCall.self, decoder: decorder)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    //通信成功
                    break
                case .failure:
                    //通信失敗
                    HUD.show(.labeledError(title: L10n.SearchErrorView.Title.text, subtitle: nil))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) { HUD.hide() }
                }
            }, receiveValue: { [self] onecall in
                self.onecall = onecall
                detail = onecall.daily.map{DailyWeatherDetail(daily: $0)}
                //OneCallのデータを保存
                saveOnecall(items: [onecall])
                //通信した時間の1時間後をunixで保存
                UserDefaults.standard.set(self.onecall!.hourly[1].dt, forKey: "upper")
            })
        UserDefaults.standard.set(true, forKey: "reVisit")
    }
    //Alamofireでの実装
    func requestAF(latitude: Double, longitude: Double, address: String) {
        var detail: [DailyWeatherDetail] = []
        let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=metric&APPID=12de4b711b7224a6556ea9e11f9a03ee"
        requestCancellable = AF.request(url).publishDecodable(type: OneCall.self, decoder: decorder)
            .value()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    //通信成功
                    break
                case .failure:
                    //error
                    HUD.show(.labeledError(title: L10n.CommunicationErrorView.Title.text, subtitle: nil))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) { HUD.hide() }
                }
            }, receiveValue: { [self] onecall in
                self.onecall = onecall
                detail = onecall.daily.map{DailyWeatherDetail(daily: $0)}
                //OneCallのデータを保存
                saveOnecall(items: [onecall])
                saveDetail(items: detail)
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
