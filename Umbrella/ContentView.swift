//
//  ContentView.swift
//  Umbrella
//
//  Created by mollangcow on 8/6/25.
//

import SwiftUI

struct ContentView: View {
    @State private var leftJoystickLocation: CGPoint = .zero
    @State private var rightJoystickLocation: CGPoint = .zero

    var body: some View {
        HStack {
            VStack {
                Text("(\(leftJoystickLocation.x, specifier: "%.2f"), \(leftJoystickLocation.y, specifier: "%.2f"))")
                    .padding()
                JoystickView(location: $leftJoystickLocation, label: "Throttle&Yaw")
            }
            VStack {
                Text("(\(rightJoystickLocation.x, specifier: "%.2f"), \(rightJoystickLocation.y, specifier: "%.2f"))")
                    .padding()
                JoystickView(location: $rightJoystickLocation, label: "Pitch&Roll")
            }
        }
        .onAppear {
            self.leftJoystickLocation = CGPoint(x: 150, y: 150)
            self.rightJoystickLocation = CGPoint(x: 150, y: 150)
        }
    }
}
