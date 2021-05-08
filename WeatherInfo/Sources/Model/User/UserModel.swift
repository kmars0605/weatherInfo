import Foundation

class UserModel {
    func saveAddress(address: String) {
        UserDefaults.standard.set(address, forKey:"address")
        UserDefaults.standard.synchronize()
    }

    func loadAddress() -> String? {
        return UserDefaults.standard.object(forKey: "address") as? String
    }

    func saveTime(dt: Int) {
        UserDefaults.standard.set(dt, forKey: "time")
        UserDefaults.standard.synchronize()
    }

    func loadTime() -> Int? {
        return UserDefaults.standard.object(forKey: "time") as? Int 
    }

    func resetUserInfo() {
        UserDefaults.standard.set(nil, forKey: "address")
        UserDefaults.standard.set(nil, forKey: "time")
        UserDefaults.standard.synchronize()
    }
}
