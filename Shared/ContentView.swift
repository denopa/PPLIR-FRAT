//
//  ContentView.swift
//  Shared
//
//  Created by Patrick de Nonneville on 21/02/2021.
//
import Foundation
import SwiftUI
import Sliders


struct ContentView: View {

//    Pilot tab
    @AppStorage("hoursInType") var hoursInType: Double = 0
    @AppStorage("recentHoursInType") var recentHoursInType: Double = 0
    @AppStorage("monthsSinceTraining") var monthsSinceTraining: Double = 12
    @AppStorage("IRRatedCopilot") var IRRatedCopilot: Bool = false
    @AppStorage("license") var license: Int = 0
    let licenses = ["PPL","Instructor","CPL","ATPL"]
    let licensePoints : [Double] = [0,-1,-1,-4]
    @AppStorage("rating") var rating = 0
    let ratings = ["No IR", "IMCr", "IR"]
    let ratingPoints : [Double] = [0, -1, -2]
    
    var pilotPoints: Double {
        let inType = max(0,(5-hoursInType/100)).rounded(.up)
        let recent = max(0,(6-recentHoursInType/5)).rounded(.up)
        let training = min(6,(monthsSinceTraining/1.5)).rounded(.up) - 1
        let copilot : Double = IRRatedCopilot ? -5 : 0
        return inType + recent + training + copilot + licensePoints[license] + (licenses[license]=="ATPL" ? 0 : ratingPoints[rating])
    }
    
    var pilotColor: Color {
        if pilotPoints < 15 {
            return Color.green
        }
        else if pilotPoints < 25 {
            return Color.orange
        }
        else {
            return Color.red
        }
    }
    
    fileprivate func pilotTab() -> some View {
        return Form {
            Section() {
                HStack(alignment: .lastTextBaseline) {
                    Text("Pilot").font(.largeTitle)
                    Spacer()
                    Text("\(pilotPoints, specifier: "%.00f") points").foregroundColor(pilotColor)
                }
            }
            Section(header: Text("Experience")) {
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
                    Text("Instructor or IR pilot in P2 seat? ")
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
    }
    
//    Airplane tab
    @AppStorage("FIKI") var FIKI : Bool = false
    @AppStorage("ME") var ME : Bool = false
    @AppStorage("turbine") var turbine : Bool = false
    @AppStorage("dlWeather") var dlWeather : Bool = false
    @AppStorage("radar") var radar : Bool = false
    @AppStorage("alternator") var alternator : Bool = false
    @AppStorage("AI") var AI : Bool = false
    @AppStorage("vaccum") var vaccum : Bool = false
    @AppStorage("GNSS") var GNSS : Bool = false
    @AppStorage("ap") var ap : Bool = false
    @AppStorage("inop") var inop : Bool = false
    @AppStorage("maintenance") var maintenance : Bool = false
    @AppStorage("nonUse") var nonUse : Bool = false
    @AppStorage("inspection") var inspection : Bool = false
    @AppStorage("avionics") var avionics : Bool = false
   
    var airplanePoints: Double {
        var points : Double = 0
        points = points + (ME ? -2:0) + (turbine ? -2:0) + (inop ? 3:0) + (avionics ? 3:0)
        if (enrouteWeather>1) || (airportWeather>1) {
            points = points + (!ap ? 7:0) + (maintenance ? 5:0) + (!GNSS ? 4:0)
            
        } else {
            points = points +  (!GNSS ? 2:0)
        }
        if maintenance {
            points = points + 5
        } else {
            points = points + (nonUse ? 2:0) + (inspection ? 2:0)
        }
        return points
    }
    
    var airplaneColor: Color {
        if airplanePoints < 15 {
            return Color.green
        }
        else if airplanePoints < 25 {
            return Color.orange
        }
        else {
            return Color.red
        }
    }
    
    fileprivate func airplaneTab() -> some View {
        return Form {
            Section() {
                HStack(alignment: .lastTextBaseline) {
                    Text("Airplane").font(.largeTitle)
                    Spacer()
                    Text("\(airplanePoints, specifier: "%.00f") points").foregroundColor(airplaneColor)
                }
            }
            Section(header: Text("Status")) {
                Toggle(isOn: $inop) {
                    Text("Any inop systems (but not making the flight illegal)")
                }
                Toggle(isOn: $avionics) {
                    Text("Avionics: <10h with new/unfamiliar (to plane or pilot)")
                }
                Toggle(isOn: $maintenance.animation()) {
                    Text("First flight after maintenance")
                }
                if !maintenance {
                    Toggle(isOn: $nonUse) {
                        Text("First flight after outside storage or 15 days non-use")
                    }
                    Toggle(isOn: $inspection) {
                        Text("More than 6 months since last inspection")
                    }
                }
            }
            Section(header: Text("Equipment")) {
                Toggle(isOn: $ap) {
                    Text("Serviceable Autopilot")
                }
                Toggle(isOn: $GNSS) {
                    Text("GNSS")
                }
                Toggle(isOn: $FIKI) {
                    Text("FIKI")
                }
                Toggle(isOn: $ME) {
                    Text("Multi Engine")
                }
                Toggle(isOn: $turbine) {
                    Text("Turbine")
                }
                Toggle(isOn: $dlWeather) {
                    Text("Downlink Weather")
                }
                Toggle(isOn: $radar) {
                    Text("Onboard Radar")
                }
                Toggle(isOn: $alternator) {
                    Text("Backup Alternator")
                }
                Toggle(isOn: $AI) {
                    Text("Backup Attitude Indicator")
                }
                Toggle(isOn: $vaccum) {
                    Text("Dual vaccum system")
                }
            }
        }
        .padding()
        .tabItem {
            Image(systemName: "paperplane")
            Text("Airplane \(airplanePoints, specifier: "%.00f")")
        }
    }
    
 //    Environment tab
    @AppStorage("enrouteWeather") var enrouteWeather : Int = 0
    let weather : [String] = ["VMC","MVMC","IMC", "LIMC"]
    @AppStorage("night") var night : Bool = false
    @AppStorage("terrain") var terrain : Bool = false
    @AppStorage("icing") var icing : Int = 0
    let icings : [String] = ["No Icing","Light", "Moderate","Severe"]
    @AppStorage("storms") var storms : Bool = false
    @AppStorage("embeddedCB") var embeddedCB : Bool = false
    @AppStorage("turbulence") var turbulence : Bool = false
    @AppStorage("alternateBrief") var alternateBrief : Bool = false
    @AppStorage("alternateWeather") var alternateWeather : Bool = false
    @AppStorage("fuelReserve") var fuelReserve : Bool = false
    @AppStorage("airportWeather") var airportWeather : Int = 0
    @AppStorage("approach") var approach : Int = 0
    let approachTypes = ["No IAP","Circling","2D","3D"]
    @AppStorage("wind") var wind : Bool = false
    @AppStorage("crosswind") var crosswind : Int = 0
    let crosswindTypes = ["Light Xwind", "Marginal Xwind", "Strong Xwind"]
    @AppStorage("winter") var winter : Bool = false
    @AppStorage("airportTerrain") var airportTerrain : Bool = false
    @AppStorage("runwayLength") var runwayLength : Bool = false
    @AppStorage("density") var density : Bool = false
    @AppStorage("MTOW") var MTOW : Bool = false
    @AppStorage("uncontrolled") var uncontrolled : Bool = false
    
    var envPoints: Double {
        var points : Double = 0
        //        enroute
        if enrouteWeather > 1 {
            points = 6 - (dlWeather ? 1:0) - (radar ? 1:0) - (alternator ? 1:0) - (AI ? 1:0) - (vaccum ? 1:0)
            points = points + ((rating<1) ? 100:0) //no go if no IR rating
        }
        if night {
            points = points + 5 - ((ME||turbine) ? 2:0) - ((!(ME||turbine)&&(alternator&&vaccum)) ? 1:0)
        }
        if terrain && !(ME||turbine) {
            points = points + 3
        }
        if icing == 3 {
            points = points + 100
        } else if icing == 2 {
            points = points + (FIKI ? 5:15)
        } else if icing == 1 {
            points = points + (FIKI ? 0:3)
        }
        if storms {
            points = points + 15 + (dlWeather ? -4:0) + (radar ? -4:0)
        } else if turbulence {
            points = points + 7
        } else if embeddedCB {
            points = points + 7
        }
        if embeddedCB && (enrouteWeather > 1) && !dlWeather && !radar {
            points = points + 100
        }
        //      alternate and fuel
        points = points + (alternateBrief ? 0:3) + (alternateWeather ? 5:0) + (fuelReserve ? 3:0)
        //        airport
        points = points + (((airportWeather>1) && (rating<1)) ? 100:0)//no go if no IR rating
        points = points + (((airportWeather==1) && (rating<1)) ? 3:0) + ((airportWeather==3) ? 3:0)
        if airportWeather == 1 {
            points = points + ((approach==0) ? 3:0) + ((approach==1) ? 2:0)
        } else if airportWeather == 2 {
            points = points + ((approach==0) ? 100:0) + ((approach==1) ? 5:0) + ((approach==2) ? 2:0)
        } else if airportWeather == 3 {
            points = points + ((approach==0) ? 100:0) + ((approach==1) ? 15:0) + ((approach==2) ? 5:0) + ((approach==3) ? 2:0)
        }
        points = points + (wind ? 3:0)
        points = points + ((crosswind==1) ? 1:0) + ((crosswind==2) ? 15:0)
        points = points + (runwayLength ? 3:0) + (winter ? 6:0) + (density ? 2:0) + (MTOW ? 2:0) + ((MTOW && ME) ? 1:0) + (uncontrolled ? 2:0)
        if airportTerrain {
            points = points + 2
            if night {
                points = points + 2
            } else if ((airportWeather>0) && (approach<2)) {
                points = points + 2
            }
        }
        return points
    }
    
    var envColor: Color {
        if envPoints < 15 {
            return Color.green
        }
        else if envPoints < 25 {
            return Color.orange
        }
        else {
            return Color.red
        }
    }
        
    fileprivate func envTab() -> some View {
        return Form {
            Section() {
                HStack(alignment: .lastTextBaseline) {
                    Text("Environment").font(.largeTitle)
                    Spacer()
                    Text("\(envPoints, specifier: "%.00f") points").foregroundColor(envColor)
                }
            }
            Section(header: Text("Enroute conditions")) {
                Toggle(isOn: $night) {
                    Text("Twilight or Night? ")
                }
                Toggle(isOn: $terrain) {
                    Text("Sea/Hostile terrain, out of glide? ")
                }
            }
            Section(header: Text("Enroute forecast")) {
                Picker("Weather Conditions", selection: $enrouteWeather) {
                    ForEach(0..<weather.count) {
                        Text(self.weather[$0])
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                Toggle(isOn: $storms) {
                    Text("TS, Heavy Rain more than ISOL/OCNL? ")
                }
                Toggle(isOn: $embeddedCB) {
                    Text("Embedded CBs? ")
                }
                Toggle(isOn: $turbulence) {
                    Text("Turbulence SIGMET? ")
                }
                Picker(selection: $icing, label:Text("Icing")) {
                    ForEach(0..<icings.count) {
                        Text(self.icings[$0])
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
            Section(header: Text("Alternate and Fuel")) {
                Toggle(isOn: $alternateBrief) {
                    Text("Alternate: briefed? ")
                }
                Toggle(isOn: $alternateWeather) {
                    Text("Marginal weather at alternate? ")
                }
                Toggle(isOn: $fuelReserve) {
                    Text("Less than 30 minutes reserve on top of legal fuel? ")
                }
            }
            Section(header: Text("Airport Forecast - worst of Departure, Arrival, Alternate")) {
                Picker("Weather Conditions", selection: $airportWeather) {
                    ForEach(0..<weather.count) {
                        Text(self.weather[$0])
                    }
                }.pickerStyle(SegmentedPickerStyle())
                Picker("Approach", selection: $approach) {
                    ForEach(0..<approachTypes.count) {
                        Text(self.approachTypes[$0])
                    }
                }.pickerStyle(SegmentedPickerStyle())
                Toggle(isOn: $wind) {
                    Text("Surface winds > 1/3 Approach Speed ?")
                }
                Picker("Crosswind", selection: $crosswind) {
                    ForEach(0..<crosswindTypes.count) {
                        Text(self.crosswindTypes[$0])
                    }
                }.pickerStyle(SegmentedPickerStyle())
                Toggle(isOn: $winter) {
                    Text("Winter Ops Snow, Ice, Contaminated runway?")
                }
            }
            Section(header: Text("Airport Conditions - worst of Departure, Arrival, Alternate")) {
                Toggle(isOn: $airportTerrain) {
                    Text("High Terrain?")
                }
                Toggle(isOn: $runwayLength) {
                    Text("Runway length marginal?")
                }
                Toggle(isOn: $density) {
                    Text("High Density Altitude?")
                }
                Toggle(isOn: $MTOW) {
                    Text("Near MTOW?")
                }
                Toggle(isOn: $uncontrolled) {
                    Text("Uncontrolled or unfamiliar airport?")
                }
            }
        }
        .padding()
        .tabItem {
            Image(systemName: "cloud.bolt")
            Text("Environment \(envPoints, specifier: "%.00f")")
        }
    }
    
//    Pressure
    @AppStorage("passengers") var passengers : Int = 0
    let passengersType = ["None", "Inexperienced", "Experienced"]
    @AppStorage("IMSAFE") var IMSAFE : Int = 0
    let fitForFlight = ["Yes", "Marginal", "No"]
    @AppStorage("pressureToComplete") var pressureToComplete : Int = 1
    let pressureType = ["None", "Low", "High", "Very High"]
    
    var pressurePoints: Double {
        var points : Double = 0
        if passengers == 1 {
            points = points + 5
        } else if passengers == 2 {
            points = points + 3
        }
        if IMSAFE == 1 {
            points = points + 5
        } else if IMSAFE == 2 {
            points = points + 100
        }
        if pressureToComplete == 0 {
            points = points - 1
        } else if pressureToComplete == 2 {
            points = points + 5
        } else if pressureToComplete == 3 {
            points = points + 100
        }
        return points
    }
    
    var pressureColor: Color {
        if pressurePoints < 15 {
            return Color.green
        }
        else if pressurePoints < 25 {
            return Color.orange
        }
        else {
            return Color.red
        }
    }
    
    
    fileprivate func pressureTab() -> some View {
        return Form {
            Section() {
                HStack(alignment: .lastTextBaseline) {
                    Text("Pressure").font(.largeTitle)
                    Spacer()
                    Text("\(pressurePoints, specifier: "%.00f") points").foregroundColor(pressureColor)
                }
            }
            Section(header: Text("Passengers")) {
                Picker("Passengers", selection: $passengers) {
                    ForEach(passengersType.indices) {
                        Text(passengersType[$0])
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
            Section(header: Text("IMSAFE")) {
                Picker("IMSAFE", selection: $IMSAFE) {
                    ForEach(fitForFlight.indices) {
                        Text(fitForFlight[$0])
                    }
                }.pickerStyle(SegmentedPickerStyle())
            }
            Section(header: Text("Pressure to complete flight")) {
                Picker("pressureToComplete", selection: $pressureToComplete) {
                    ForEach(pressureType.indices) {
                        Text(pressureType[$0])
                    }
                }.pickerStyle(SegmentedPickerStyle())
                Text("Consider peer, family or work pressure, and other elements like cost-sharing or pressure to return the aicraft")
            }
            
        }
        .padding()
        .tabItem {
            Image(systemName: "waveform.path.ecg")
            Text("Pressure \(pressurePoints, specifier: "%.00f")")
        }
    }
    
//    main view
    var totalPoints: Double {
        return pilotPoints + airplanePoints + envPoints + pressurePoints
    }
    
    var totalColor: Color {
        if totalPoints < 15 {
            return Color.green
        }
        else if totalPoints < 25 {
            return Color.orange
        }
        else {
            return Color.red
        }
    }
    
    var body: some View {
        
        TabView {
            Text("\(totalPoints, specifier: "%.00f")").foregroundColor(pilotColor).font(.largeTitle)
                .padding()
                .tabItem {
                            Image(systemName: "house")
                            Text("Total \(totalPoints, specifier: "%.00f")")
                }
            pilotTab()
            airplaneTab()
            envTab()
            pressureTab()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.colorScheme, .light)
    }
}
