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
            ScrollView(.vertical, showsIndicators: true) {
                VStack {
                    Text("At 1:51 p.m. on Jan. 6, a right-wing radio host named Michael D. Brown wrote on Twitter that rioters had breached the United States Capitol — and immediately speculated about who was really to blame. “Antifa or BLM or other insurgents could be doing it disguised as Trump supporters,” Mr. Brown wrote, using shorthand for Black Lives Matter. “Come on, man, have you never heard of psyops?”Only 13,000 people follow Mr. Brown on Twitter, but his tweet caught the attention of another conservative pundit: Todd Herman, who was guest-hosting Rush Limbaugh’s national radio program. Minutes later, he repeated Mr. Brown’s baseless claim to Mr. Limbaugh’s throngs of listeners: “It’s probably not Trump supporters who would do that. Antifa, BLM, that’s what they do. Right?” What happened over the next 12 hours illustrated the speed and the scale of a right-wing disinformation machine primed to seize on a lie that served its political interests and quickly spread it as truth to a receptive audience. The weekslong fiction about a stolen election that President Donald J. Trump pushed to his millions of supporters had set the stage for a new and equally false iteration: that left-wing agitators were responsible for the attack on the Capitol. In fact, the rioters breaking into the citadel of American democracy that day were acolytes of Mr. Trump, intent on stopping Congress from certifying his electoral defeat. Subsequent arrests and investigations have found no evidence that people who identify with antifa, a loose collective of antifascist activists, were involved in the insurrection.But even as Americans watched live images of rioters wearing MAGA hats and carrying Trump flags breach the Capitol — egged on only minutes earlier by a president who falsely denounced a rigged election and exhorted his followers to fight for justice — history was being rewritten in real time.Nearly two months after the attack, the claim that antifa was involved has been repeatedly debunked by federal authorities, but it has hardened into gospel among hard-line Trump supporters, by voters and sanctified by elected officials in the party. More than half of Trump voters in a Suffolk University/USA Today poll said that the riot was “mostly an antifa-inspired attack.” At Senate hearings last week focused on the security breakdown at the Capitol, Senator Ron Johnson, a Wisconsin Republican, repeated the falsehood that “fake Trump protesters” fomented the violence.")
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
