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
    
    // 조이스틱의 최대 반경 (외부 원의 반경)
    let maxRadius: CGFloat = 100
    // 내부 원(손잡이)의 크기
    let knobSize: CGFloat = 100
    
    // 내부 원(손잡이)의 현재 오프셋(이동) 상태
    @State private var knobOffset: CGPoint = .zero

    var fingerDrag: some Gesture {
        DragGesture()
            .onChanged { value in
                // value.translation: 드래그를 시작한 위치로부터의 x, y 이동 거리 (CGSize)
                let translation = value.translation
                
                // 피타고라스 정리를 사용해 중심으로부터의 거리 계산
                let distance = sqrt(pow(translation.width, 2) + pow(translation.height, 2))
                
                // 만약 거리가 maxRadius(최대 반경)를 초과하면
                if distance > maxRadius {
                    // 비율을 사용해 x, y 값을 최대 반경 내에 머무르도록 제한
                    let newX = translation.width * (maxRadius / distance)
                    let newY = translation.height * (maxRadius / distance)
                    self.knobOffset = CGPoint(x: newX, y: newY)
                } else {
                    // 최대 반경 내에 있다면, 현재 이동한 만큼만 오프셋 설정
                    self.knobOffset = CGPoint(x: translation.width, y: translation.height)
                }
                
                // 부모 뷰에 현재 오프셋 값을 전달
                self.location = self.knobOffset
            }
            .onEnded { value in
                // 터치가 끝나면 오프셋을 0으로 리셋 (중앙으로 복귀)
                self.knobOffset = .zero
                self.location = .zero
            }
    }

    var body: some View {
        VStack {
            Text(label)
                .font(.largeTitle)
                .bold()
            
            // ZStack이 조이스틱 컴포넌트의 기준이 됩니다.
            ZStack {
                // 1. 외부 원 (조이스틱 배경)
                Circle()
                    .stroke(Color.primary, lineWidth: 2)
                    .frame(width: maxRadius * 2, height: maxRadius * 2)
                
                // 2. 내부 원 (손잡이)
                Circle()
                    .fill(Color.orange)
                    .frame(width: knobSize, height: knobSize)
                    // .position() 대신 .offset()을 사용
                    // knobOffset 값에 따라 중앙에서부터 이동합니다.
                    .offset(x: knobOffset.x, y: knobOffset.y)
                    .gesture(fingerDrag) // 제스처는 손잡이에 적용
            }
            // ZStack 자체의 프레임을 고정해 레이아웃을 안정시킵니다.
            .frame(width: maxRadius * 2, height: maxRadius * 2)
        }
        .onAppear {
            // 뷰가 나타날 때 오프셋과 바인딩 값을 .zero로 초기화
            self.knobOffset = .zero
            self.location = .zero
        }
    }
}
