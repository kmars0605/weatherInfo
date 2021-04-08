import Foundation
import Combine
import Alamofire

class WeatherModel {
    var onecall: OneCall?
    @Published var detail: [DailyWeatherDetail] = []
    let decorder = JSONDecoder()
    var requestCancellable: Cancellable?
    var subscriptions = Set<AnyCancellable>()
    @Published var error = false
}

extension WeatherModel {

    func saveOnecall(onecall: [OneCall]) {
        let data = onecall.map { try! JSONEncoder().encode($0) }
        UserDefaults.standard.set(data as [Any], forKey: "oneCall")
    }

    func readOnecall() -> [OneCall]? {
        guard let items = UserDefaults.standard.array(forKey: "oneCall") as? [Data] else { return [OneCall]() }
        let decodedItems = items.map { try! JSONDecoder().decode(OneCall.self, from: $0) }
        return decodedItems
    }

    func saveDetail(detail: [DailyWeatherDetail]) {
        let data = detail.map { try! JSONEncoder().encode($0) }
        UserDefaults.standard.set(data as [Any], forKey: "detail")
        self.detail.removeAll()
    }

    func readDetail() -> [DailyWeatherDetail]? {
        guard let items = UserDefaults.standard.array(forKey: "detail") as? [Data] else { return [DailyWeatherDetail]() }
        let decodedItems = items.map { try! JSONDecoder().decode(DailyWeatherDetail.self, from: $0) }
        return decodedItems
    }
    //URLSessionでの実装
    func request(latitude: Double, longitude: Double) {
        let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=metric&APPID=12de4b711b7224a6556ea9e11f9a03ee")!
        requestCancellable = URLSession.shared.dataTaskPublisher(for: URLRequest(url: url))
            .map({(data, res) in return data})
            .decode(type: OneCall.self, decoder: decorder)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("通信成功")
                case .failure:
                    print("通信失敗")
                    self.error = true
                }
            }, receiveValue: { [self] onecall in
                self.onecall = onecall
                self.detail = onecall.daily.map{DailyWeatherDetail(daily: $0)}
                //OneCallのデータを保存
                self.saveOnecall(onecall: [onecall])
                //通信した時間の1時間後をunixで保存
                UserDefaults.standard.set(self.onecall!.hourly[1].dt, forKey: "upper")
            })
        UserDefaults.standard.set(true, forKey: "reVisit")
    }
    //Alamofireでの実装
    func requestAF(latitude: Double, longitude: Double) {
        let url = "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=metric&APPID=12de4b711b7224a6556ea9e11f9a03ee"
        requestCancellable = AF.request(url).publishDecodable(type: OneCall.self, decoder: decorder)
            .value()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    print("通信成功")
                case .failure:
                    print("通信失敗")
                    self.error = true
                }
            }, receiveValue: { [self] onecall in
                self.onecall = onecall
                self.detail = onecall.daily.map{DailyWeatherDetail(daily: $0)}
                //OneCallのデータを保存
                self.saveOnecall(onecall: [onecall])
                //通信した時間の1時間後をunixで保存
                UserDefaults.standard.set(self.onecall!.hourly[1].dt, forKey: "upper")
                self.detail.removeAll()
            })
        UserDefaults.standard.set(true, forKey: "reVisit")
    }

    //気象庁とopenWeatherMapの両者の通信を束ねる時に使用
    func requestAPIandAgency(localCode: Int, latitude: Double, longitude: Double) {
        let urlOfAgency = URL(string: "https://www.jma.go.jp/bosai/forecast/data/forecast/\(localCode).json")!
        let agencyPublisher = URLSession.shared.dataTaskPublisher(for: URLRequest(url: urlOfAgency))
            .map({(data, res) in return data})
            .decode(type: [Agency].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()

        let urlOfAPI = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=metric&APPID=12de4b711b7224a6556ea9e11f9a03ee")!
        let apiPublisher = URLSession.shared.dataTaskPublisher(for: URLRequest(url: urlOfAPI))
            .map({(data, res) in return data})
            .decode(type: [Agency].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()

         Publishers.Zip(agencyPublisher, apiPublisher)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: {completion in
                    switch completion {
                    case .finished:
                        print("通信成功")
                    case .failure:
                        print("通信失敗")
                    }},
                receiveValue: { agency, onecall in
                    //2つの通信結果を用いた処理
                }
            )
            .store(in: &subscriptions)
    }
}
