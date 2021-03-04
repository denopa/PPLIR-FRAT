//
//  Disclaimer.swift
//  PPLIR-FRAT
//
//  Created by Patrick de Nonneville on 01/03/2021.
//

import Foundation
import SwiftUI

struct DisclaimerView : View {
    
    @AppStorage("firstTime") var firstTime: Bool = true
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    Image("55")
                    Text("Flight Risk Assesment Tool").font(Font.headline)
                }
                Text("Disclaimer").font(Font.largeTitle)
            }
            Spacer()
            ScrollView(.vertical, showsIndicators: true) {
                VStack {
                    Text("This application is provided to you as a training tool to help you consider some of the risks inherent in General Aviation flying. It doesn't in any way, shape or form relieve you of any responsibility linked to the planning and conduct of a potential flight.").font(Font.footnote)
                    Text("")
                    Text("In no event shall PPL/IR Europe, its officers and members, or the creators and developers of this application, be liable for any damage whatsoever, including special, indirect, consequential or incidental damages, including lost profit, arising out of or connected with any of the material or the use, reliance upon or performance of any material contained in this tool.").font(Font.footnote)
                    Text("")
                    Text("There is no warranty, representation, or condition of any kind; and any warranty, express or implied is excluded and disclaimed, including the warranty of fitness for a particular purpose.").font(Font.footnote)
                    Text("")
                    Text("The Pilot In Command is solely responsible for the safe, proper and legal operation of his/her aircraft.").font(Font.footnote)
                    Text("")
                    Spacer()
                    Button("Accept", action: toContent)
                        
                }
            }
            .padding()
            
        }
    }
    
    func toContent() {
        firstTime = false
        if let window = UIApplication.shared.windows.first {
                window.rootViewController = UIHostingController(rootView: ContentView())
                window.makeKeyAndVisible()
            }
    }
    
}



struct DisclaimerView_Previews: PreviewProvider {
    static var previews: some View {
        DisclaimerView().environment(\.colorScheme, .light)
    }
}
