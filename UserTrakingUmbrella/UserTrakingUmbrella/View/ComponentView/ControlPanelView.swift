//
//  ConnectButtonView.swift
//  UserTrakingUmbrella
//
//  Created by mollangcow on 11/6/25.
//

import SwiftUI

struct ControlPanelView: View {
    @ObservedObject var webSocketManager: WebSocketManager
    
    @Binding var isStart: Bool
    @Binding var isHovering: Bool
    
    var body: some View {
        VStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 22)
                .foregroundStyle(Color.secondary.opacity(0.2))
                .overlay(
                    VStack {
                        Spacer()
                        
                        Text(webSocketManager.isConnected ? "CONNECTED" : "DISCONNECTED")
                            .font(.title3)
                            .fontWeight(.bold)
                            .foregroundColor(webSocketManager.isConnected ? .green : .red)
                       
                        Spacer()
                    }
                )
            
            // 1. 호버링 모드 토글
            Toggle(isOn: $isHovering) {
                VStack(alignment: .leading) {
                    Text(isHovering ? "호버링 ON" : "호버링 OFF")
                        .fontWeight(.bold)
                    Text("NAV POSHOLD")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .foregroundStyle(webSocketManager.isConnected ? Color.primary : Color.secondary.opacity(0.5))
            }
            .frame(height: 52)
            .padding(.horizontal, 24)
            .background(Color.secondary.opacity(0.2))
            .mask(RoundedRectangle(cornerRadius: 34))
            .disabled(!webSocketManager.isConnected) // 연결 안 되면 비활성화
           
            // 2. 시동 토글
            Toggle(isOn: $isStart) {
                VStack(alignment: .leading) {
                    Text(isStart ? "시동 ON" : "시동 OFF")
                        .fontWeight(.bold)
                    Text("ARMING")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .foregroundStyle(webSocketManager.isConnected ? Color.primary : Color.secondary.opacity(0.5))
            }
            .frame(height: 52)
            .padding(.horizontal, 24)
            .background(Color.secondary.opacity(0.2))
            .mask(RoundedRectangle(cornerRadius: 34))
            .disabled(!webSocketManager.isConnected)
            
            // 3. 연결/해제 버튼
            Button(action: {
                if webSocketManager.isConnected {
                    webSocketManager.disconnect()
                } else {
                    webSocketManager.connect()
                }
            }) {
                RoundedRectangle(cornerRadius: 26)
                    .fill(webSocketManager.isConnected ? Color.red : Color.green)
                    .frame(maxWidth: .infinity, maxHeight: 52)
                    .overlay(
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
