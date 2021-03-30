import Foundation

class WeatherModel {
    var onecall: OneCall?
    var detail: [DailyWeatherDetail] = []
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
}
