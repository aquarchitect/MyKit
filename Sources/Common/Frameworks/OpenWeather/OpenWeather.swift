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

    /// OpenWeather manages networking requests.
    ///
    /// - parameter version:  default value - 2.5
    /// - parameter language: default value - en
    /// - parameter format:   default format - celsius
    ///
    /// - warning: make sure to register your api key in the Info.plist
    public init(version: Double = 2.5, language: String = "en", format: Format = .celsius) {
        self.apiKey = Bundle.main.infoDictionary?["OpenWeatherAPIKey"] as? String ?? ""
        self.version = version
        self.language = language
        self.format = format
    }

    // MARK: Support Method

    fileprivate func fetchData(using method: Method, components comps: Component...) -> Promise<(Data, URLResponse)> {
        let baseComps: [Component] = [.apiKey(apiKey),
                                      .language(language),
                                      .units(format)]
        let fullURL = baseURL + String(version) + (method + Component.compound(baseComps + comps))

        return URL(string: fullURL).map(URLSession.shared.dataTask as (URL) -> Promise<(Data, URLResponse)>)
            ?? Promise.lift { throw PromiseError.empty }
    }
}

public extension OpenWeather {

    // MARK: Current Weather Network Calls

    func fetchCurrentWeather(ofCity name: String) -> Promise<(Data, URLResponse)> {
        return fetchData(using: .currentWeather, components: .cityName(name))
    }

    func fetchCurrentWeather(ofCity id: Int) -> Promise<(Data, URLResponse)> {
        return fetchData(using: .currentWeather, components: .cityID(id))
    }

    func fetchCurrentWeather(atLocation coord: CLLocationCoordinate2D) -> Promise<(Data, URLResponse)> {
        return fetchData(using: .currentWeather, components: .locationCoordinate(coord))
    }

    // MARK: Daily Forecast Network Calls

    func fetchDailyForecast(ofCity name: String, numberOfDays count: Int) -> Promise<(Data, URLResponse)> {
        return fetchData(using: .dailyForecast, components: .cityName(name), .returnedDays(count))
    }

    func fetchDailyForecast(ofCity id: Int, numberOfDays count: Int) -> Promise<(Data, URLResponse)> {
        return fetchData(using: .dailyForecast, components: .cityID(id), .returnedDays(count))
    }

    func fetchDailyForecast(atLocation coord: CLLocationCoordinate2D, numberOfDays count: Int) -> Promise<(Data, URLResponse)> {
        return fetchData(using: .dailyForecast, components: .locationCoordinate(coord), .returnedDays(count))
    }
}

fileprivate func + (lhs: OpenWeather.Method, rhs: OpenWeather.Component) -> String {
    return lhs.rawValue + rhs.query
}

extension OpenWeather.Component {

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
