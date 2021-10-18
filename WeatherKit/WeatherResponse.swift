//
//  WeatherResponse.swift
//  WeatherKit
//
//  Created by Nugroho Arief Widodo on 18/10/21.
//


import Foundation

// MARK: - WeatherResponse
struct WeatherResponse: Codable {
    let weather: [Weather]
}
// MARK: - Weather
struct Weather: Codable {
    let id: Int

    enum CodingKeys: String, CodingKey {
        case id
    }
    
    func weather() -> String {
        switch id {
        case 200...599:
            return "rain"
        case 600...699:
            return "snow"
        case 700...799:
            return "sun-cloud"
        case 800:
            return "sunny"
        case 801...:
            return "cloudy"
        default:
            return "sunny"
        }
    }
}



