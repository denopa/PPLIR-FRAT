//
//  ContentView.swift
//  Shared
//
//  Created by October on 21/02/2021.
//

import SwiftUI
import Sliders

struct ContentView: View {
    
    @State private var hoursInType: Double = 0
    @State private var recentHoursInType: Double = 0
    @State private var monthsSinceTraining: Double = 12
    @State private var IRRatedCopilot: Bool = false
    @State private var license = 0
    let licenses = ["PPL","Instructor","CPL","ATPL"]
    let licensePoints : [Double] = [0,-1,-1,-4]
    @State private var rating = 0
    let ratings = ["No IR", "IMCr", "IR"]
    let ratingPoints : [Double] = [0, -1, -2]
    
    var pilotPoints: Double {
        let inType = max(0,(5-hoursInType/100)).rounded(.up)
        let recent = max(0,(6-recentHoursInType/30)).rounded(.up)
        let training = min(6,(monthsSinceTraining/1.5)).rounded(.up) - 1
        let copilot : Double = IRRatedCopilot ? -5 : 0
        return inType + recent + training + copilot + licensePoints[license] + (licenses[license]=="ATPL" ? 0 : ratingPoints[rating])
    }
    
    var body: some View {
        
        TabView {
            Text("Hello, world!")
                .padding()
                .tabItem {
                            Image(systemName: "house")
                            Text("Home")
                }
            Form {
                Section() {
                    HStack {
                        Text("Pilot").font(.largeTitle)
                        Spacer()
                        Text("\(pilotPoints, specifier: "%.00f") points")
                    }
                }
                Section(header: Text("Experience")) {
                    //TextField("Hours in type", text: $hoursInType)
                    HStack {
                        Text("Hours in type")
                        Spacer()
                        Text("\(hoursInType, specifier: "%.00f")\(hoursInType==500 ? "+" : "")")
                    }
                    HSlider(value: $hoursInType, in: 0...500, step: 25, track:
                                LinearGradient(gradient: Gradient(colors: [.red, .orange, .green]), startPoint: .leading, endPoint: .trailing)
                            .frame(height: 3)
                            .cornerRadius(4)
                    )
                    HStack {
                        Text("Hours in this aircraft (last 90 days)")
                        Spacer()
                        Text("\(recentHoursInType, specifier: "%.00f")\(recentHoursInType==30 ? "+" : "")")
                    }
                    HSlider(value: $recentHoursInType, in: 0...30, step: 5, track:
                                LinearGradient(gradient: Gradient(colors: [.red, .orange, .green]), startPoint: .leading, endPoint: .trailing)
                            .frame(height: 3)
                            .cornerRadius(4)
                    )
                    HStack {
                        Text("Months since last training")
                        Spacer()
                        Text("\(monthsSinceTraining, specifier: "%.00f")\(monthsSinceTraining==12 ? "+" : "")")
                    }
                    HSlider(value: $monthsSinceTraining, in: 0...12, step: 1, track:
                                LinearGradient(gradient: Gradient(colors: [.green, .orange,.red]), startPoint: .leading, endPoint: .trailing)
                            .frame(height: 3)
                            .cornerRadius(4)
                    )
                    Toggle(isOn: $IRRatedCopilot) {
                        Text("Instructor or IR pilot in copilot's seat? ")
                    }
                }
                Section(header: Text("Licenses, Current and Proficient Ratings")) {
                    Picker(selection: $license, label:Text("License")) {
                        ForEach(0..<licenses.count) {
                            Text(self.licenses[$0])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    Picker(selection: $rating, label:Text("rating")) {
                        ForEach(0..<ratings.count) {
                            Text(self.ratings[$0])
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .padding()
            .tabItem {
                        Image(systemName: "person")
                Text("Pilot: \(pilotPoints, specifier: "%.00f")")
            }
            Text("Airplane")
                .padding()
                .tabItem {
                            Image(systemName: "paperplane")
                            Text("Airplane")
                }
            Text("Environment")
                .padding()
                .tabItem {
                            Image(systemName: "cloud.bolt")
                            Text("Environment")
                }
            Text("Pressure")
                .padding()
                .tabItem {
                            Image(systemName: "waveform.path.ecg")
                            Text("Pressure")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.colorScheme, .light)
    }
}
