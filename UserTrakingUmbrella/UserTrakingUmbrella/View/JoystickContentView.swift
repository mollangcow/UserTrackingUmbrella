//
//  JoystickContentView.swift
//  UserTrakingUmbrella
//
//  Created by mollangcow on 11/5/25.
//

import SwiftUI

struct JoystickContentView: View {
    @State private var leftJoystickLocation: CGPoint = .zero
    @State private var rightJoystickLocation: CGPoint = .zero

    var body: some View {
        HStack {
            JoystickView(location: $leftJoystickLocation, label: "Throttle&Yaw")
                .padding(.leading, 40)
            
            Spacer()
            
            JoystickView(location: $rightJoystickLocation, label: "Pitch&Roll")
                .padding(.trailing, 40)
        }
        .onAppear {
            self.leftJoystickLocation = CGPoint(x: 150, y: 150)
            self.rightJoystickLocation = CGPoint(x: 150, y: 150)
        }
    }
}
