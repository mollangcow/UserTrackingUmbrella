//
//  ConnectButtonView.swift
//  UserTrakingUmbrella
//
//  Created by mollangcow on 11/6/25.
//

import SwiftUI

struct ControlPanelView: View {
    
    // JoystickView로부터 받아올 웹소켓 매니저
    @ObservedObject var webSocketManager: WebSocketManager
    
    @Binding var isStart: Bool
    
    var body: some View {
        VStack {
            // 상단 모니터링 패널 (웹소켓 상태와 텔레메트리 표시)
            RoundedRectangle(cornerRadius: 22)
                .frame(height: 200)
                .foregroundStyle(Color.secondary.opacity(0.2))
                .overlay(
                    VStack {
                        // 연결 상태 텍스트
                        Text(webSocketManager.isConnected ? "연결됨" : "연결 끊김")
                            .font(.headline)
                            .foregroundColor(webSocketManager.isConnected ? .green : .red)
                            .padding(.top)
                        
                        Spacer()
                        
                        // 텔레메트리 데이터 표시
                        ScrollView {
                            Text(webSocketManager.telemetryData)
                                .font(.caption)
                                .padding(.horizontal)
                        }
                        
                        Spacer()
                    }
                )
            
            // Stop/Start 토글
            Toggle(isOn: $isStart) {
                Text(isStart ? "시동 중" : "시동 꺼짐")
                    .foregroundStyle(webSocketManager.isConnected ? Color.primary : Color.secondary.opacity(0.5))
            }
            .frame(height: 52)
            .padding(.horizontal, 24)
            .background(Color.secondary.opacity(0.2))
            .mask(RoundedRectangle(cornerRadius: 34))
            .disabled(!webSocketManager.isConnected)
            
            // 연결/해제 버튼 (기존 Find Device 버튼)
            Button(action: {
                // 웹소켓 연결 상태에 따라 동작 변경
                if webSocketManager.isConnected {
                    webSocketManager.disconnect()
                } else {
                    webSocketManager.connect()
                }
            }) {
                RoundedRectangle(cornerRadius: 26)
                    // webSocketManager.isConnected 상태에 따라 색상 변경
                    .fill(webSocketManager.isConnected ? Color.red : Color.green)
                    .frame(maxWidth: .infinity, maxHeight: 52)
                    .overlay(
                        // webSocketManager.isConnected 상태에 따라 텍스트 변경
                        Text(webSocketManager.isConnected ? "연결 해제" : "장치 연결")
                            .font(Font.system(size: 18, weight: .bold))
                            .foregroundStyle(Color.white)
                    )
            }
        }
        .padding(.all, 12)
        .background(Color.secondary.opacity(0.2))
        .mask(RoundedRectangle(cornerRadius: 34))
    }
}
