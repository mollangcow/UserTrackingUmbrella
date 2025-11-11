//
//  JoystickView.swift
//  UserTrakingUmbrella
//
//  Created by mollangcow on 11/5/25.
//

import SwiftUI

struct JoystickButtonView: View {
    @Binding var location: CGPoint

    let label: String
    
    // 외부 원 반경
    let maxRadius: CGFloat = 80
    // 내부 원 크기
    let knobSize: CGFloat = 80
    
    // 내부 원 현재 오프셋 이동 상태
    @State private var knobOffset: CGPoint = .zero
    @State private var hasReachedEdge = false

    var fingerDrag: some Gesture {
        DragGesture()
            .onChanged { value in
                // value.translation: 드래그를 시작한 위치로부터의 x, y 이동 거리 (CGSize)
                let translation = value.translation
                // 피타고라스 정리를 사용해 중심으로부터의 거리 계산
                let distance = sqrt(pow(translation.width, 2) + pow(translation.height, 2))
                
                // 만약 거리가 maxRadius(최대 반경)를 초과하면
                if distance > maxRadius {
                    if !hasReachedEdge {
                        self.hasReachedEdge = true
                    }
                    // 비율을 사용해 x, y 값을 최대 반경 내에 머무르도록 제한
                    let newX = translation.width * (maxRadius / distance)
                    let newY = translation.height * (maxRadius / distance)
                    self.knobOffset = CGPoint(x: newX, y: newY)
                } else {
                    if hasReachedEdge {
                        self.hasReachedEdge = false
                    }
                    // 최대 반경 내에 있다면, 현재 이동한 만큼만 오프셋 설정
                    self.knobOffset = CGPoint(x: translation.width, y: translation.height)
                }
                // 부모 뷰에 현재 오프셋 값을 전달
                self.location = self.knobOffset
            }
            .onEnded { value in
                // 터치가 끝나면 오프셋을 0으로 리셋
                self.knobOffset = .zero
                self.location = .zero
                self.hasReachedEdge = false
            }
    }

    var body: some View {
        VStack {
            Spacer()
            
            Text("(\(location.x, specifier: "%.2f"), \(location.y, specifier: "%.2f"))")
                .monospacedDigit()
            
            Text(label)
                .font(.body)
                .bold()
            
            Spacer()
            
            ZStack {
                // 외부 원
                Circle()
                    .fill(Color.secondary.opacity(0.1))
//                    .stroke(Color.secondary.opacity(0.3), lineWidth: 2)
                    .frame(width: maxRadius * 2, height: maxRadius * 2)
                    .overlay(
                        Image(systemName: "plus")
                            .font(.system(size: 22, weight: .light))
                            .foregroundStyle(Color.secondary)
                    )
                
                // 내부 원
                Circle()
                    .fill(Color.gray)
                    .frame(width: knobSize, height: knobSize)
                    // knobOffset 값에 따라 중앙에서부터 이동
                    .offset(x: knobOffset.x, y: knobOffset.y)
                    .gesture(fingerDrag)
                    .sensoryFeedback(.impact(weight: .light, intensity: 0.5), trigger: knobOffset)
                    .sensoryFeedback(.impact(weight: .heavy), trigger: hasReachedEdge)
            }
            .frame(width: maxRadius * 2, height: maxRadius * 2)
        }
        .onAppear {
            // 뷰가 나타날 때 오프셋과 바인딩 값을 .zero로 초기화
            self.knobOffset = .zero
            self.location = .zero
        }
        .padding(.bottom, 20)
    }
}
