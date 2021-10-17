//
//  Extensions.swift
//  WeatherKit
//
//  Created by Nugroho Arief Widodo on 12/10/21.
//

import SwiftUI

extension Color {
    init(rgb: UInt) {
        self.init(red: Double((rgb & 0xFF0000) >> 16) / 255.0, green: Double((rgb & 0x00FF00) >> 8) / 255.0, blue: Double(rgb & 0x0000FF) / 255.0)
    }
}

extension UserDefaults {
    
    static let group = UserDefaults(suiteName: "group.com.nugroho.tech.WeatherKit")!
    
    func save(image: UIImage?, name: String) {
        guard let data = image?.jpegData(compressionQuality: 0.5), let encoded = try? PropertyListEncoder().encode(data) else { return }
        self.set(encoded, forKey: name)
    }

    func loadImage(name: String) -> UIImage? {
         guard let data = self.data(forKey: name) else { return nil}
        guard let decoded = try? PropertyListDecoder().decode(Data.self, from: data), let image = UIImage(data: decoded) else {return nil}
        return image
    }
}
