//
//  OpenWeather.swift
//  MyKit
//
//  Created by Hai Nguyen on 10/21/15.
//
//

infix operator & { associativity left }

private func & (lhs: String, rhs: String) -> String {
    return "\(lhs)&\(rhs)"
}

public final class OpenWeather {

    public enum Format: String {

        case Celsius = "metric"
        case Fahrenheit = "imperial"
    }

    // MARK: Property

    public let apiKey: String
    public let version: Double
    public let language: String
    public let format: Format

    private let baseURL = "http://api.openweathermap.org/data/"

    // MARK: Initialization

    public init(apiKey: String, version: Double = 2.5, language: String = "en", format: Format = .Celsius) {
        self.apiKey = apiKey
        self.version = version
        self.language = language
        self.format = format
    }

    // MARK: Support Method

    private func componentForReturnedDays(count: Int) -> String {
        return "cnt=\(count)"
    }

    private func componentForCityName(name: String) -> String {
        return "q=\(name)"
    }

    private func componentForCityID(id: Int) -> String {
        return "id=\(id)"
    }

    private func componentForCoordinate(coordinate: CLLocationCoordinate2D) -> String {
        return "lat=\(coordinate.latitude)&lon=\(coordinate.longitude)"
    }

    private func retrieveData(method: String, completion: NSDictionary? -> Void)  {
        let apiKey = "APPID=\(self.apiKey)"
        let language = "lang=\(self.language)"
        let units = "units=\(format.rawValue)"

        NSURL(string: [apiKey, language, units].reduce(baseURL + String(version) + method, combine: &))?.then {
            NSURLSession.sharedSession().dataTaskWithURL($0) { data, _, _ in
                data?.then {
                    (try? NSJSONSerialization.JSONObjectWithData($0, options: .MutableContainers)) as? NSDictionary
                    }?.then { completion($0) }
            }
        }.resume()
    }

    // MARK: Network Call

    public func currentWeather(cityName: String, completion: NSDictionary? -> Void) {
        retrieveData("/weather?" + componentForCityName(cityName), completion: completion)
    }

    public func currentWeather(cityID: Int, completion: NSDictionary? -> Void) {
        retrieveData("/weather?" + componentForCityID(cityID), completion: completion)
    }

    public func currentWeather(coordinate: CLLocationCoordinate2D, completion: NSDictionary? -> Void) {
        retrieveData("/weather?" + componentForCoordinate(coordinate), completion: completion)
    }

    public func dailyForecast(cityName: String, numberOfDays: Int, completion: NSDictionary? -> Void) {
        let components = componentForCityName(cityName) & componentForReturnedDays(numberOfDays)
        retrieveData("/forecast/daily?" + components, completion: completion)
    }

    public func dailyForecast(cityID: Int, numberOfDays: Int, completion: NSDictionary? -> Void) {
        let components = componentForCityID(cityID) & componentForReturnedDays(numberOfDays)
        retrieveData("/forecast/daily?" + components, completion: completion)
    }

    public func dailyForecast(coordinate: CLLocationCoordinate2D, numberOfDays: Int, completion: NSDictionary? -> Void) {
        let components = componentForCoordinate(coordinate) & componentForReturnedDays(numberOfDays)
        retrieveData("/forecast/daily?" + components, completion: completion)
    }
}