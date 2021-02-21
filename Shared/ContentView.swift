//
//  ContentView.swift
//  Shared
//
//  Created by October on 21/02/2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Text("Hello, world!")
                .padding()
                .tabItem {
                            Image(systemName: "house")
                            Text("Home")
                }
            Text("Pilot")
                .padding()
                .tabItem {
                            Image(systemName: "person")
                            Text("Pilot")
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
                            Image(systemName: "scalemass")
                            Text("Pressure")
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            
    }
}
