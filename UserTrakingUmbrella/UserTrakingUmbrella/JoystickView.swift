//
//  JoystickView.swift
//  UserTrakingUmbrella
//
//  Created by mollangcow on 11/5/25.
//

import SwiftUI

struct JoystickView: View {
    @Binding var location: CGPoint
    let label: String

    @State private var innerCircleLocation: CGPoint = .zero
    @State private var fingerLocation: CGPoint? = nil
    @State private var startLocation: CGPoint? = nil

    var fingerDrag: some Gesture {
        DragGesture()
            .onChanged { value in
                self.fingerLocation = value.location
                let distance = self.fingerLocation!.distance(to: self.startLocation!)
                if distance > 100 {
                    let angle = self.fingerLocation!.angle(to: self.startLocation!)
                    let newX = self.startLocation!.x + 100 * cos(angle)
                    let newY = self.startLocation!.y + 100 * sin(angle)
                    self.innerCircleLocation = CGPoint(x: newX, y: newY)
                } else {
                    self.innerCircleLocation = self.fingerLocation!
                }
                self.location = self.innerCircleLocation
            }
            .onEnded { value in
                self.innerCircleLocation = self.startLocation!
                self.location = self.innerCircleLocation
                self.fingerLocation = nil
            }
    }

    var body: some View {
        ZStack {
            Text(label)
                .font(.largeTitle)
                .position(x: startLocation?.x ?? 0, y: (startLocation?.y ?? 0) - 150)
            Circle()
                .stroke(Color.primary, lineWidth: 2)
                .frame(width: 200, height: 200)
                .position(startLocation ?? .zero)

            Circle()
                .fill(Color.orange)
                .frame(width: 100, height: 100)
                .position(innerCircleLocation)
                .gesture(fingerDrag)
        }
        .onAppear {
            self.startLocation = self.location
            self.innerCircleLocation = self.location
        }
    }
}

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(self.x - point.x, 2) + pow(self.y - point.y, 2))
    }

    func angle(to point: CGPoint) -> CGFloat {
        return atan2(self.y - point.y, self.x - point.x)
    }
}
