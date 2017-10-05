// 
// OpenWeather.swift
// MyKit
// 
// Created by Hai Nguyen.
// Copyright (c) 2015 Hai Nguyen.
// 

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

    fileprivate enum Component {

        case apiKey(String)
        case language(String)
        case units(Format)
        case returnedDays(Int)
        case cityName(String)
        case cityID(Int)
        case locationCoordinate(CLLocationCoordinate2D)

        indirect case compound([Component])
    }

    // MARK: Property

    public let apiKey: String
    public let version: Double
    public let language: String
    public let format: Format

    private let basePath = "http://api.openweathermap.org/data/"

    // MARK: Initialization

    /// OpenWeather manages networking requests.
    ///
    /// - parameter version:  default value - 2.5
    /// - parameter language: default value - en
    /// - parameter format:   default format - celsius
    ///
    /// - warning: make sure to register your api key in the Info-Framework.plist
    public init(version: Double = 2.5, language: String = "en", format: Format = .celsius) {
        self.apiKey = Bundle.main
            .infoDictionary?["OpenWeatherAPIKey"] as? String
            ?? ""
        self.version = version
        self.language = language
        self.format = format
    }

    // MARK: Support Method

#if true
    fileprivate func fetch(_ method: Method, with components: Component...) -> Promise<(Data, URLResponse)> {
        let baseComponents: [Component] = [
            .apiKey(apiKey),
            .language(language),
            .units(format)
        ] + components

        return URL(string: "\(basePath)\(version)\(method + .compound(baseComponents))")
            .map(URLSession.shared.dataTask(with:))
            ?? Promise(MyKit.Error.harmless)
    }
#else
    fileprivate func fetch(_ method: Method, with components: Component...) -> Observable<(Data, URLResponse)> {
        let baseComponents: [Component] = [
            .apiKey(apiKey),
            .language(language),
            .units(format)
        ] + components

        return URL(string: "\(basePath)\(version)\(method + .compound(baseComponents))")
            .map(URLSession.shared.dataTask(with:))
            ?? Observable()
    }
#endif
}

public extension OpenWeather {

    // MARK: Current Weather Network Calls

#if true
    func fetchCurrentWeather(ofCity name: String) -> Promise<(Data, URLResponse)> {
        return fetch(.currentWeather, with: .cityName(name))
    }
#else
    func fetchCurrentWeather(ofCity name: String) -> Observable<(Data, URLResponse)> {
        return fetch(.currentWeather, with: .cityName(name))
    }
#endif

#if true
    func fetchCurrentWeather(ofCity id: Int) -> Promise<(Data, URLResponse)> {
        return fetch(.currentWeather, with: .cityID(id))
    }
#else
    func fetchCurrentWeather(ofCity id: Int) -> Observable<(Data, URLResponse)> {
        return fetch(.currentWeather, with: .cityID(id))
    }
#endif

#if true
    func fetchCurrentWeather(atLocation coord: CLLocationCoordinate2D) -> Promise<(Data, URLResponse)> {
        return fetch(.currentWeather, with: .locationCoordinate(coord))
    }
#else
    func fetchCurrentWeather(atLocation coord: CLLocationCoordinate2D) -> Observable<(Data, URLResponse)> {
        return fetch(.currentWeather, with: .locationCoordinate(coord))
    }
#endif

    // MARK: Daily Forecast Network Calls

#if true
    func fetchDailyForecast(ofCity name: String, numberOfDays count: Int) -> Promise<(Data, URLResponse)> {
        return fetch(.dailyForecast, with: .cityName(name), .returnedDays(count))
    }
#else
    func fetchDailyForecast(ofCity name: String, numberOfDays count: Int) -> Observable<(Data, URLResponse)> {
        return fetch(.dailyForecast, with: .cityName(name), .returnedDays(count))
    }
#endif

#if true
    func fetchDailyForecast(ofCity id: Int, numberOfDays count: Int) -> Promise<(Data, URLResponse)> {
        return fetch(.dailyForecast, with: .cityID(id), .returnedDays(count))
    }
#else
    func fetchDailyForecast(ofCity id: Int, numberOfDays count: Int) -> Observable<(Data, URLResponse)> {
        return fetch(.dailyForecast, with: .cityID(id), .returnedDays(count))
    }
#endif

#if true
    func fetchDailyForecast(atLocation coord: CLLocationCoordinate2D, numberOfDays count: Int) -> Promise<(Data, URLResponse)> {
        return fetch(.dailyForecast, with: .locationCoordinate(coord), .returnedDays(count))
    }
#else
    func fetchDailyForecast(atLocation coord: CLLocationCoordinate2D, numberOfDays count: Int) -> Observable<(Data, URLResponse)> {
        return fetch(.dailyForecast, with: .locationCoordinate(coord), .returnedDays(count))
    }
#endif
}

fileprivate func + (lhs: OpenWeather.Method, rhs: OpenWeather.Component) -> String {
    return lhs.rawValue + rhs.query
}

extension OpenWeather.Component {

    var query: String {
        switch self {
        case let .apiKey(key):
            return "APPID=\(key)"
        case let .language(language):
            return "lang=\(language)"
        case let .units(format):
            return "units=\(format.rawValue)"
        case let .returnedDays(count):
            return "cnt=\(count)"
        case let .cityName(name):
            return "q=\(name)"
        case let .cityID(id):
            return "id=\(id)"
        case let .locationCoordinate(coord):
            return "lat=\(coord.latitude)&lon=\(coord.longitude)"
        case let .compound(components):
            return components
                .map({ $0.query })
                .joined(separator: "&")
        }
    }
}
