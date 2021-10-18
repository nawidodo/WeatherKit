//
//  WeatherService.swift
//  WeatherKit
//
//  Created by Nugroho Arief Widodo on 17/10/21.
//

import Combine
import Foundation

class WeatherService {
    
    static let shared = WeatherService()
    private let url = "http://api.openweathermap.org/data/2.5/weather?lat={{lat}}&lon={{lon}}&appid=dbb2dd22ce8ddfc4498635ace6ea59dd"
    func getWeather(lat: Double, lon: Double) -> AnyPublisher<String?, Error> {
        var target = url.replacingOccurrences(of: "{{lat}}", with: "\(lat)")
        target = target.replacingOccurrences(of: "{{lon}}", with: "\(lon)")
        let targetURL = URL(string: target)!
        
        return URLSession
            .shared
            .dataTaskPublisher(for: targetURL)
            .map(\.data)
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .map { response in
                return response.weather.first?.weather()
            }
            .eraseToAnyPublisher()
    }
}
