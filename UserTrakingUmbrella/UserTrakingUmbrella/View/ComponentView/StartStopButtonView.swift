//
//  StartStopButtonView.swift
//  UserTrakingUmbrella
//
//  Created by mollangcow on 11/6/25.
//

import SwiftUI

struct StartStopButtonView: View {
    @State private var isStart: Bool = true
    
    var body: some View {
        VStack {
            Toggle("", isOn: $isStart)
                .labelsHidden()
            
            Text("Start/Stop")

        }
    }
}
