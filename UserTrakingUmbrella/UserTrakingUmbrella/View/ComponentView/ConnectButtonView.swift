//
//  ConnectButtonView.swift
//  UserTrakingUmbrella
//
//  Created by mollangcow on 11/6/25.
//

import SwiftUI

struct ConnectButtonView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Button(action: {
                    //action
                }) {
                    Circle()
                        .fill(Color.primary)
                        .frame(width: 64, height: 64)
                }
                
                Text("Connect")
            }
        }
    }
}
