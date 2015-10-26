//
//  OpenWeather.swift
//  MyKit
//
//  Created by Hai Nguyen on 10/21/15.
//
//

infix operator & {}

private func & (lhs: String, rhs: String) -> String {
    return "\(lhs)&\(rhs)"
}

public class OpenWeather {

    public enum TemperatureFormat: String {

        case Celsius = "metric"
        case Fahrenheit = "imperial"
    }

    public let apiKey: String
    public let version: Double
    public let language: String
    public let format: TemperatureFormat

    private let baseURL = "http://api.openweathermap.org/data/"

    public init(apiKey: String, version: Double = 2.5, language: String = "en", format: TemperatureFormat = .Celsius) {
        self.apiKey = apiKey
        self.version = version
        self.language = language
        self.format = format
    }

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

    private func retrieveData(method: String, completion: NSDictionary? -> Void)  {
        let apiKey = "APPID=\(self.apiKey)"
        let language = "lang=\(self.language)"
        let units = "units=\(format.rawValue)"

        let string = [apiKey, language, units].reduce(baseURL + String(version) + method, combine: &)
        guard let url = NSURL(string: string) else { return }

        NSURLSession.sharedSession().dataTaskWithURL(url) { optinalData, _, _ in
            var dictionary: NSDictionary?

            if let data = optinalData {
                let json = try? NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers)
                dictionary = json as? NSDictionary
            }
            
            completion(dictionary)
        }.resume()
    }
}