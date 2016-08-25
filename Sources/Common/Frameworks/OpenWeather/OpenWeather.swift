/*
 * OpenWeather.swift
 * MyKit
 *
 * Copyright (c) 2015 Hai Nguyen
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

import CoreLocation

public final class OpenWeather {

    public typealias Callback = Result<[String: AnyObject]>.Callback

    public enum Format: String {

        case Celsius = "metric"
        case Fahrenheit = "imperial"
    }

    private enum Method: String {

        case CurrentWeather = "/weather?"
        case DailyForecast = "/forecast/daily?"
    }

    private indirect enum Component {

        case APIKey(String)
        case Language(String)
        case Units(Format)
        case ReturnedDays(Int)
        case CityName(String)
        case CityID(Int)
        case LocationCoordinate(CLLocationCoordinate2D)
        case Compound([Component])
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

    private func fetch(method: Method, components comps: Component...) -> Promise<[String: AnyObject]> {
        let baseComps: [Component] = [.APIKey(apiKey), .Language(language), .Units(format)]
        let fullURL = baseURL + String(version) + (method + Component.Compound(baseComps + comps))

        return NSURL(string: fullURL)?.andThen(NSURLSession.sharedSession().data) ?? Promise { $0(.Fullfill([:])) }
    }
}

public extension OpenWeather {

    // MARK: Current Weather Network Calls

    func fetchCurrentWeatherOf(city name: String) -> Promise<[String: AnyObject]> {
        return fetch(.CurrentWeather, components: .CityName(name))
    }

    func fetchCurrentWeatherOf(city id: Int) -> Promise<[String: AnyObject]> {
        return fetch(.CurrentWeather, components: .CityID(id))
    }

    func fetchCurrentWeatherAt(location coord: CLLocationCoordinate2D) -> Promise<[String: AnyObject]> {
        return fetch(.CurrentWeather, components: .LocationCoordinate(coord))
    }

    // MARK: Daily Forecast Network Calls

    func fetchDailyForecastOf(city name: String, numberOfDays count: Int) -> Promise<[String: AnyObject]> {
        return fetch(.DailyForecast, components: .CityName(name), .ReturnedDays(count))
    }

    func fetchDailyForecastOf(city id: Int, numberOfDays count: Int) -> Promise<[String: AnyObject]> {
        return fetch(.DailyForecast, components: .CityID(id), .ReturnedDays(count))
    }

    func fetchDailyForecastAt(location coord: CLLocationCoordinate2D, numberOfDays count: Int) -> Promise<[String: AnyObject]> {
        return fetch(.DailyForecast, components: .LocationCoordinate(coord), .ReturnedDays(count))
    }
}

private func + (lhs: OpenWeather.Method, rhs: OpenWeather.Component) -> String {
    return lhs.rawValue + rhs.query
}

private extension OpenWeather.Component {

    var query: String {
        switch self {
        case .APIKey(let key): return "APPID=\(key)"
        case .Language(let language): return "lang=\(language)"
        case .Units(let format): return "units=\(format.rawValue)"
        case .ReturnedDays(let count): return "cnt=\(count)"
        case .CityName(let name): return "q=\(name)"
        case .CityID(let id): return "id=\(id)"
        case .LocationCoordinate(let coord): return "lat=\(coord.latitude)&lon=\(coord.longitude)"
        case .Compound(let comps): return comps.map { $0.query }.joinWithSeparator("&")
        }
    }
}