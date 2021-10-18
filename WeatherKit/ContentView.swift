//
//  ContentView.swift
//  WeatherKit
//
//  Created by Nugroho Arief Widodo on 10/10/21.
//

import SwiftUI
import Combine

struct ContentView: View {
    @State var isPresentedImageGallery = false
    @State var selectedIndex = 0
    @State var image: UIImage? = UserDefaults.group.loadImage(name: widgetBG)
    @StateObject var locationManager = LocationManager.shared
    @State var weather: String?
    @State var storage: Set<AnyCancellable> = []
        
    var body: some View {
        NavigationView {
            ZStack {
                TabView(selection: $selectedIndex) {
                    WeatherView(image: self.$image, currentLocation: $locationManager.address, weather: $weather)
                        .frame(width: 155, height: 155)
                }
                .tabViewStyle(PageTabViewStyle())
                .padding(.bottom, 230)
                .onAppear {
                    UIPageControl.appearance().currentPageIndicatorTintColor = .black
                        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
                }
                
                VStack {
                    Spacer()
                    Button {
                        isPresentedImageGallery = true
                    } label: {
                        HStack {
                            Image(systemName: "photo")
                                .resizable()
                                .frame(width: 17, height: 17, alignment: .center)
                            Text("Change Background")
                                .font(Font.system(size: 17))
                        }
                        .frame(minWidth: 0, maxWidth: .infinity, minHeight: 50, maxHeight: 50)
                    }
                    .background(Color(rgb: 0x55AB67))
                    .foregroundColor(Color.white)
                    .cornerRadius(8.0)
                    .padding([.leading, .trailing], 16)
                    .padding(.bottom, 150)
                }
            }
            .navigationBarTitle("Weather Widget", displayMode: .inline)
            .background(Color(rgb: 0xF1EFE5))
            .sheet(isPresented: $isPresentedImageGallery, content: {
                ImagePicker(sourceType: .photoLibrary, selectedImage: self.$image)
            })
            .onAppear {
                locationManager
                    .$lastLocation
                    .receive(on: DispatchQueue.main)
                    .sink { loc in
                        if let lat = loc?.coordinate.latitude, let lon = loc?.coordinate.longitude {
                            WeatherService
                                .shared
                                .getWeather(lat: lat, lon: lon)
                                .subscribe(on: DispatchQueue.main)
                                .sink { _ in
                                } receiveValue: { weather_ in
                                    self.weather = weather_
                                }
                                .store(in: &storage)
                        }
                    }.store(in: &storage)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
