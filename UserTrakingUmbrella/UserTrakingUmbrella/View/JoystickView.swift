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
    @State private var isHoverMode: Bool = false
    
    // 3. 전송 타이머
    let timer = Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()

    var body: some View {
        HStack(alignment: .bottom) {
            // 좌측 스틱
            JoystickButtonView(location: $leftJoystickLocation, label: "Throttle&Yaw")
                .padding(.leading, 20)
                                  
            // 컨트롤 패널 (웹소켓 매니저 전달)
            ControlPanelView(webSocketManager: webSocketManager, isStart: $isArmed, isHovering: $isHoverMode)
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
            let throttle = mapJoystickValue(leftJoystickLocation.x, reversed: false)
            let yaw = mapJoystickValue(leftJoystickLocation.y)
            let pitch = mapJoystickValue(rightJoystickLocation.y, reversed: true)
            let roll = mapJoystickValue(rightJoystickLocation.x, reversed: false)
            
            let aux1 = isArmed ? 2000 : 1000
            let aux2 = isHoverMode ? 2000 : 1000

            webSocketManager.sendControlData(
                roll: Int(roll),
                pitch: Int(pitch),
                yaw: Int(yaw),
                throttle: Int(throttle),
                aux1: aux1,
                aux2: aux2
            )
        }
    }
    
    private func mapJoystickValue(_ value: CGFloat, reversed: Bool = true) -> CGFloat {
        // 설정 상수
        let joystickMax: CGFloat = 80.0  // 조이스틱 최대 반경
        let deadZone: CGFloat = 20.0     // 데드존 범위 (-20 ~ 20)
        
        let rcCenter: CGFloat = 1500.0   // RC 중립값
        let rcRange: CGFloat = 500.0     // 변동 폭 (1500 ± 500)
        let rcMin: CGFloat = 1000.0
        let rcMax: CGFloat = 2000.0
        
        // 1. 데드존 체크
        // 입력값의 절대값이 데드존(20)보다 작으면 중립값(1500) 반환
        if abs(value) <= deadZone {
            return rcCenter
        }
        
        // 2. 유효 입력값 계산 (데드존을 뺀 나머지 범위에서 선형 증가)
        // value가 21이면 -> effectiveValue는 1
        // value가 80이면 -> effectiveValue는 60
        var effectiveValue: CGFloat = 0.0
        
        if value > 0 {
            effectiveValue = value - deadZone
        } else {
            effectiveValue = value + deadZone // 음수이므로 더하면 0에 가까워짐
        }
        
        // 3. 정규화 비율 계산 (0.0 ~ 1.0)
        // 유효 범위는 (80 - 20) = 60
        let effectiveMax = joystickMax - deadZone
        var normalized = effectiveValue / effectiveMax
        
        // 4. 반전 처리
        if reversed {
            normalized = -normalized
        }
        
        // 5. 최종 RC 값 계산
        // 1500 + (비율 * 500)
        let rcValue = rcCenter + (normalized * rcRange)
        
        // 6. 안전장치 (Clamping)
        return max(rcMin, min(rcMax, rcValue))
    }
}


