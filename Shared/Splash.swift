//
//  Splash.swift
//  PPLIR-FRAT
//
//  Created by Patrick de Nonneville on 01/03/2021.
//

import Foundation
import SwiftUI

struct SplashView : View {
    
    @State var isActive : Bool = false
    @AppStorage("firstTime") var firstTime: Bool = true
    
        var body: some View {
            VStack {
                if self.isActive && self.firstTime {
                    DisclaimerView()
                } else if self.isActive && !self.firstTime {
                    ContentView()
            } else {
                VStack {
                    Text("PPL/IR Europe").font(Font.headline)
                    Spacer()
                    Image("1024").resizable().scaledToFit()
                    Spacer()
                    Text("Flight Risk Assesment Tool").font(Font.headline)
                }
            }
        }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
    }
}


struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView().environment(\.colorScheme, .light)
    }
}
