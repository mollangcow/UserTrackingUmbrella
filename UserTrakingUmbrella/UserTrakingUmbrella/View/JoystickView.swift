//
//  JoystickContentView.swift
//  UserTrakingUmbrella
//
//  Created by mollangcow on 11/5/25.
//

import SwiftUI

struct JoystickView: View {
    @State private var leftJoystickLocation: CGPoint = .zero
    @State private var rightJoystickLocation: CGPoint = .zero

    var body: some View {
        HStack {
            JoystickButtonView(location: $leftJoystickLocation, label: "Throttle&Yaw")
                .padding(.leading, 40)
            
            Spacer()
            
            VStack {                
                ConnectButtonView()
                    .padding(.bottom, 20)
                
                StartStopButtonView()
            }
            
            Spacer()
            
            JoystickButtonView(location: $rightJoystickLocation, label: "Pitch&Roll")
                .padding(.trailing, 40)
        }
        .onAppear {
            self.leftJoystickLocation = CGPoint(x: 150, y: 150)
            self.rightJoystickLocation = CGPoint(x: 150, y: 150)
        }
    }
}
