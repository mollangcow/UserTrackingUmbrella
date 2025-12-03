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
    
    let maxRadius: CGFloat = 80
    let knobSize: CGFloat = 80
    
    let deadZone: CGFloat = 20.0
    

    @State private var knobOffset: CGPoint = .zero
    @State private var hasReachedEdge = false
    
    @State private var isXInsideDeadZone = true
    @State private var isYInsideDeadZone = true


    var fingerDrag: some Gesture {
        DragGesture()
            .onChanged { value in
                // value.translation: 드래그를 시작한 위치로부터의 x, y 이동 거리 (CGSize)
                let translation = value.translation
                // 피타고라스 정리를 사용해 중심으로부터의 거리 계산
                let distance = sqrt(pow(translation.width, 2) + pow(translation.height, 2))
                
                // 1. [변경] 데드존 햅틱 로직 (XY축 독립 판정)
                // X축 좌표가 데드존(-20 ~ 20) 내부에 있는지 확인
                let currentXInside = abs(translation.width) <= deadZone
                if currentXInside != isXInsideDeadZone {
                    isXInsideDeadZone = currentXInside
                }
                // Y축 좌표가 데드존(-20 ~ 20) 내부에 있는지 확인
                let currentYInside = abs(translation.height) <= deadZone
                if currentYInside != isYInsideDeadZone {
                    isYInsideDeadZone = currentYInside
                }
                
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
                
                // 상태 초기화 (중앙으로 돌아오므로 Inside = true)
                self.isXInsideDeadZone = true
                self.isYInsideDeadZone = true
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
                    .fill(Color.secondary.opacity(0.2))
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
                    .sensoryFeedback(.impact(weight: .light, intensity: 0.4), trigger: knobOffset)
                    .sensoryFeedback(.impact(weight: .heavy, intensity: 1.5), trigger: hasReachedEdge)
                    .sensoryFeedback(.impact(weight: .medium), trigger: isXInsideDeadZone)
                    .sensoryFeedback(.impact(weight: .medium), trigger: isYInsideDeadZone)
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

