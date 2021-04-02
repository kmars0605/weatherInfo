import Foundation
import Combine

class WeatherModel {
    var onecall: OneCall?
    var detail: [DailyWeatherDetail] = []
    var subscriptions: Set<AnyCancellable> = []
}
extension WeatherModel {

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
    //気象庁とopenWeatherMapの両者の通信を束ねる時に使用
    func requestAPIandAgency(localCode: Int, latitude: Double, longitude: Double) {
        let urlOfAgency = URL(string: "https://www.jma.go.jp/bosai/forecast/data/forecast/\(localCode).json")!
        let agencyPublisher = URLSession.shared.dataTaskPublisher(for: URLRequest(url: urlOfAgency))
            .map(\.data)
            .decode(type: [Agency].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()

        let urlOfAPI = URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(latitude)&lon=\(longitude)&units=metric&APPID=12de4b711b7224a6556ea9e11f9a03ee")!
        let apiPublisher = URLSession.shared.dataTaskPublisher(for: URLRequest(url: urlOfAPI))
            .map(\.data)
            .decode(type: [Agency].self, decoder: JSONDecoder())
            .eraseToAnyPublisher()

        Publishers.Zip(agencyPublisher, apiPublisher)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: {completion in
                    switch completion {
                    case .finished:
                        print("通信成功")
                        break
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
