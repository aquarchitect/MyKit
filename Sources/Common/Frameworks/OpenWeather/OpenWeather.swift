/*
 * OpenWeather.swift
 * MyKit
 *
 * Created by Hai Nguyen.
 * Copyright (c) 2015 Hai Nguyen.
 */

import CoreLocation

public final class OpenWeather {

    public typealias Callback = Result<[String: AnyObject]>.Callback

    public enum Format: String {

        case celsius = "metric"
        case fahrenheit = "imperial"
    }

    fileprivate enum Method: String {

        case currentWeather = "/weather?"
        case dailyForecast = "/forecast/daily?"
    }

    fileprivate indirect enum Component {

        case apiKey(String)
        case language(String)
        case units(Format)
        case returnedDays(Int)
        case cityName(String)
        case cityID(Int)
        case locationCoordinate(CLLocationCoordinate2D)
        case compound([Component])
    }

    // MARK: Property

    public let apiKey: String
    public let version: Double
    public let language: String
    public let format: Format

    private let baseURL = "http://api.openweathermap.org/data/"

    // MARK: Initialization

    public init(apiKey: String, version: Double = 2.5, language: String = "en", format: Format = .celsius) {
        self.apiKey = apiKey
        self.version = version
        self.language = language
        self.format = format
    }

    // MARK: Support Method

    fileprivate func fetch(method: Method, components comps: Component...) -> Promise<[String: AnyObject]> {
        let baseComps: [Component] = [.apiKey(apiKey),
                                      .language(language),
                                      .units(format)]
        let fullURL = baseURL + String(version) + (method + Component.compound(baseComps + comps))

        return URL(string: fullURL).map(URLSession.shared.dataTask as (URL) -> Promise<[String: AnyObject]>) ?? Promise { $0(.fullfill([:])) }
    }
}

public extension OpenWeather {

    // MARK: Current Weather Network Calls

    func fetchcurrentWeatherOf(city name: String) -> Promise<[String: AnyObject]> {
        return fetch(method: .currentWeather, components: .cityName(name))
    }

    func fetchcurrentWeatherOf(city id: Int) -> Promise<[String: AnyObject]> {
        return fetch(method: .currentWeather, components: .cityID(id))
    }

    func fetchcurrentWeatherAt(location coord: CLLocationCoordinate2D) -> Promise<[String: AnyObject]> {
        return fetch(method: .currentWeather, components: .locationCoordinate(coord))
    }

    // MARK: Daily Forecast Network Calls

    func fetchdailyForecastOf(city name: String, numberOfDays count: Int) -> Promise<[String: AnyObject]> {
        return fetch(method: .dailyForecast, components: .cityName(name), .returnedDays(count))
    }

    func fetchdailyForecastOf(city id: Int, numberOfDays count: Int) -> Promise<[String: AnyObject]> {
        return fetch(method: .dailyForecast, components: .cityID(id), .returnedDays(count))
    }

    func fetchdailyForecastAt(location coord: CLLocationCoordinate2D, numberOfDays count: Int) -> Promise<[String: AnyObject]> {
        return fetch(method: .dailyForecast, components: .locationCoordinate(coord), .returnedDays(count))
    }
}

private func + (lhs: OpenWeather.Method, rhs: OpenWeather.Component) -> String {
    return lhs.rawValue + rhs.query
}

private extension OpenWeather.Component {

    var query: String {
        switch self {
        case .apiKey(let key): return "APPID=\(key)"
        case .language(let language): return "lang=\(language)"
        case .units(let format): return "units=\(format.rawValue)"
        case .returnedDays(let count): return "cnt=\(count)"
        case .cityName(let name): return "q=\(name)"
        case .cityID(let id): return "id=\(id)"
        case .locationCoordinate(let coord): return "lat=\(coord.latitude)&lon=\(coord.longitude)"
        case .compound(let comps): return comps.map { $0.query }.joined(separator: "&")
        }
    }
}
