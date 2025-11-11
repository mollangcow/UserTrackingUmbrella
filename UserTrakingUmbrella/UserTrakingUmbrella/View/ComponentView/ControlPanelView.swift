//
//  ConnectButtonView.swift
//  UserTrakingUmbrella
//
//  Created by mollangcow on 11/6/25.
//

import SwiftUI

struct ControlPanelView: View {
    @State private var isStart: Bool = false
    @State private var isConnect: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                
                RoundedRectangle(cornerRadius: 22)
                    .frame(height: 200)
                    .foregroundStyle(Color.secondary.opacity(0.1))
                    .overlay(
                        Text("Not Found...")
                    )
                
                Toggle(isOn: $isStart) {
                    Text("Stop/Start")
                        .foregroundStyle(isConnect ? Color.primary : Color.secondary.opacity(0.5))
                }
                .frame(height: 52)
                .padding(.horizontal, 24)
                .background(Color.secondary.opacity(0.1))
                .mask(RoundedRectangle(cornerRadius: 34))
                .disabled(!isConnect)
                
                Button(action: {
                    //action
                }) {
                    RoundedRectangle(cornerRadius: 26)
                        .fill(Color.green)
                        .frame(maxWidth: .infinity, maxHeight: 52)
                        .overlay(
                            Text("Find Device")
                                .font(Font.system(size: 18, weight: .bold))
                                .foregroundStyle(Color.white)
                        )
                }
            }
            .padding(.all, 12)
            .background(Color.secondary.opacity(0.1))
            .mask(RoundedRectangle(cornerRadius: 34))
        }
    }
}

