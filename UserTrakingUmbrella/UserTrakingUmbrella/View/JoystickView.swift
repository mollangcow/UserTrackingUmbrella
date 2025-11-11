//
//  JoystickContentView.swift
//  UserTrakingUmbrella
//
//  Created by mollangcow on 11/5/25.
//

import SwiftUI
import Combine

struct JoystickView: View {
    
    @StateObject private var webSocketManager = WebSocketManager()
    
    @State private var leftJoystickLocation: CGPoint = .zero
    @State private var rightJoystickLocation: CGPoint = .zero
    
    @State private var isArmed: Bool = false
    
    // 3. 전송 타이머
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()

    var body: some View {
        HStack(alignment: .bottom) {
            // 좌측 스틱
            JoystickButtonView(location: $leftJoystickLocation, label: "Throttle&Yaw")
                .padding(.leading, 20)
                                  
            // 컨트롤 패널 (웹소켓 매니저 전달)
            ControlPanelView(webSocketManager: webSocketManager, isStart: $isArmed)
                .padding(.horizontal, 60)
                                  
            // 우측 스틱
            JoystickButtonView(location: $rightJoystickLocation, label: "Pitch&Roll")
                .padding(.trailing, 20)
        }
        .onAppear {
            self.leftJoystickLocation = CGPoint(x: 0, y: 0)
            self.rightJoystickLocation = CGPoint(x: 0, y: 0)
        }
        .onReceive(timer) { _ in

            // --- 1번 디버깅 PRINT 추가 ---
            print("Timer fired. IsConnected: \(webSocketManager.isConnected)")

            // webSocketManager.isConnected가 false이면 여기서 멈춤
            guard webSocketManager.isConnected else { return }

            // --- 2번 디버깅 PRINT 추가 ---
            print("Sending data...")

            // 조이스틱 값(-80~80)을 RC 값(1000~2000)으로 변환하여 전송
            let throttle = mapJoystickValue(leftJoystickLocation.y, reversed: true)
            let yaw = mapJoystickValue(leftJoystickLocation.x)
            let pitch = mapJoystickValue(rightJoystickLocation.y, reversed: true)
            let roll = mapJoystickValue(rightJoystickLocation.x)
            
            let aux1 = isArmed ? 2000 : 1000

            webSocketManager.sendControlData(
                roll: Int(roll),
                pitch: Int(pitch),
                yaw: Int(yaw),
                throttle: Int(throttle),
                aux1: aux1
            )
        }
    }
    
    /// 조이스틱 값(-80 ~ 80)을 RC 채널 값(1000 ~ 2000)으로 변환하는 헬퍼 함수
    private func mapJoystickValue(_ value: CGFloat, reversed: Bool = false) -> CGFloat {
        let joystickMin: CGFloat = -80.0
        let joystickMax: CGFloat = 80.0
        
        let rcMin: CGFloat = 1000.0
        let rcMax: CGFloat = 2000.0
        
        var normalized = (value - joystickMin) / (joystickMax - joystickMin)
        if reversed {
            normalized = 1.0 - normalized
        }
        let rcValue = (normalized * (rcMax - rcMin)) + rcMin
        return max(rcMin, min(rcMax, rcValue))
    }
}
