import Foundation
import Combine
import Alamofire

class WeatherModel {
    @Published public var detail: [DailyWeatherDetail] = []
    @Published public var error = false
    public var onecall: OneCall?
    public var requestCancellable: Cancellable?
    public var subscriptions = Set<AnyCancellable>()

    enum Key {
        case onecall
        case detail

        var name: String {
            switch self {
            case .onecall:
                return "oneCall"
            case .detail:
                return "detail"
            }
        }
    }
}

extension WeatherModel {
    func saveData<T: Codable>(of weatherData: [T], to key: Key) {
        let data = weatherData.map{ try! JSONEncoder().encode($0)}
        UserDefaults.standard.set(data as [Any], forKey: key.name)
    }

    func loadData(of key: Key) {
        guard let items = UserDefaults.standard.array(forKey: key.name) as? [Data] else { return }
        switch key {
        case .onecall:
            let decodedItems = items.map { try! JSONDecoder().decode(OneCall.self, from: $0) }
            self.onecall = decodedItems[0]
        case .detail:
            let decodedItems = items.map { try! JSONDecoder().decode(DailyWeatherDetail.self, from: $0) }
            self.detail = decodedItems
        }
    }

    func resetData(of key: Key) {
        UserDefaults.standard.set(nil, forKey: key.name)
    }
    
    //URLSessionでの実装
    func request(latitude: Double, longitude: Double) {
        let decorder = JSONDecoder()
        let url = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=metric&APPID=12de4b711b7224a6556ea9e11f9a03ee")!
        requestCancellable = URLSession.shared.dataTaskPublisher(for: URLRequest(url: url))
            .map({(data,response) in
                    if let response = response as? HTTPURLResponse {
                        if response.statusCode != 200 {
                            print("通信失敗:\(response.statusCode)")
                            self.error = true
                        } else { print("通信成功") }
                    } else {
                        print("通信失敗")
                        self.error = true
                    }
                    return data})
            .decode(type: OneCall.self, decoder: decorder)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    //通信・デコード成功
                    print("成功")
                case .failure:
                    //通信orデコード失敗
                    print("失敗")
                    self.error = true
                }
            }, receiveValue: { [self] onecall in
                self.onecall = onecall
                self.detail = onecall.daily.map{DailyWeatherDetail(daily: $0)}
                //OneCallのデータを保存
                saveData(of: [onecall], to: Key.onecall)
            })
    }
    //Alamofireでの実装
    func requestAF(latitude: Double, longitude: Double) {
        let decorder = JSONDecoder()
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
                saveData(of: [onecall], to: Key.onecall)
                //通信した時間の1時間後をunixで保存
                self.detail.removeAll()
            })
    }

    //気象庁とopenWeatherMapの両者の通信を束ねる時に使用
    func requestAPIandAgency(localCode: Int, latitude: Double, longitude: Double) {
        let urlOfAgency = URL(string: "https://www.jma.go.jp/bosai/forecast/data/forecast/\(localCode).json")!
        let agencyPublisher = URLSession.shared.dataTaskPublisher(for: URLRequest(url: urlOfAgency))
            .map({(data, res) in return data})
            .decode(type: [AgencyModel].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()

        let urlOfAPI = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=metric&APPID=12de4b711b7224a6556ea9e11f9a03ee")!
        let apiPublisher = URLSession.shared.dataTaskPublisher(for: URLRequest(url: urlOfAPI))
            .map({(data, res) in return data})
            .decode(type: [AgencyModel].self, decoder: JSONDecoder())
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
