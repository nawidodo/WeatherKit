//
//  WeatherView.swift
//  WeatherKit
//
//  Created by Nugroho Arief Widodo on 13/10/21.
//

import SwiftUI
import WidgetKit

let widgetBG = "widgetBG"
let widgetLocation = "widgetLocation"
let widgetWeather = "widgetWeather"

struct WeatherView: View {
    @Binding var image: UIImage?
    @Binding var currentLocation: String?
    @Binding var weather: String?
    var body: some View {
        GeometryReader { geo in
            ZStack {
                Image(uiImage: self.image ?? UIImage())
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(maxWidth: geo.size.width, maxHeight: geo.size.height)
                    .onChange(of: image) { img in
                        UserDefaults.group.save(image: img, name: widgetBG)
                        WidgetCenter.shared.reloadAllTimelines()
                    }
                VStack {
                    Image(weather ?? "sunny")
                        .resizable()
                        .frame(width: 67, height: 67)
                    Text(currentLocation ?? "Tokyo, Japan")
                        .font(Font.system(.headline, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(image == nil ? Color(rgb: 0x333333) : Color.white)
                        .padding([.leading, .trailing], 16)
                        .onChange(of: currentLocation) { loc in
                            UserDefaults.group.setValue(loc, forKey: widgetLocation)
                            UserDefaults.group.setValue(weather, forKey: widgetWeather)
                            WidgetCenter.shared.reloadAllTimelines()
                        }
                    
                }
            }
            .background(Color.white)
            .cornerRadius(22)
        }
    }
}

struct WeatherView_Previews: PreviewProvider {
    
    @State static var image = UIImage(named: "bulbasaur")
    @State static var currentLocation: String? = "Semarang, Jawa Tengah, Indonesia"
    @State static var weather: String? = "rain"

    static var previews: some View {
        WeatherView(image: $image, currentLocation: $currentLocation, weather: $weather)
            .previewLayout(.fixed(width: 150, height: 150))
    }
}


func randomWeather() -> String {
    let w = ["sunny", "cloudy", "rain", "snow", "sun-cloud"]
    return w.randomElement()!
}

