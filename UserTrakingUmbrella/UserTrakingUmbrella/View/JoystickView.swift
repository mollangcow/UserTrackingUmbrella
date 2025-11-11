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
        HStack(alignment: .bottom) {
            JoystickButtonView(location: $leftJoystickLocation, label: "Throttle&Yaw")
                .padding(.leading, 20)
                        
            ControlPanelView()
                .padding(.horizontal, 60)
                        
            JoystickButtonView(location: $rightJoystickLocation, label: "Pitch&Roll")
                .padding(.trailing, 20)
        }
        .onAppear {
            self.leftJoystickLocation = CGPoint(x: 0, y: 0)
            self.rightJoystickLocation = CGPoint(x: 0, y: 0)
        }
    }
}
