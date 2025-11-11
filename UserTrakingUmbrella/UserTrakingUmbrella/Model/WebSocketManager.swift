//
//  WebSocketManager.swift
//  UserTrakingUmbrella
//
//  Created by mollangcow on 11/11/25.
//

import Foundation
import Combine

// iOS -> RPi로 보낼 RC 데이터 구조체
struct ControlData: Codable {
    var roll: Int
    var pitch: Int
    var yaw: Int
    var throttle: Int
    var aux1: Int
}

@MainActor
class WebSocketManager: NSObject, ObservableObject, URLSessionWebSocketDelegate {
    
    @Published var isConnected = false
    @Published var telemetryData: String = "---" // RPi -> iOS
    
    private var webSocketTask: URLSessionWebSocketTask?
    
    // RPi AP 모드의 기본 IP (10.42.0.1)와 포트(8765)
    private let serverURL = URL(string: "ws://10.42.0.1:8765")!
    
    func connect() {
        if isConnected { return }
        
        let session = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        webSocketTask = session.webSocketTask(with: serverURL)
        
        print("웹소켓 연결 시도...")
        webSocketTask?.resume()
        
        // 텔레메트리 수신 시작
        self.listen()
    }
    
    func disconnect() {
        print("웹소켓 연결 해제.")
        webSocketTask?.cancel(with: .goingAway, reason: nil)
        self.isConnected = false
    }
    
    // RPi로부터 텔레메트리 수신 대기
    private func listen() {
        webSocketTask?.receive { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .failure(let error):
                print("Receive 오류: \(error.localizedDescription)")
                DispatchQueue.main.async { self.isConnected = false }
                
            case .success(let message):
                switch message {
                case .string(let text):
                    // RPi가 보낸 텔레메트리(JSON)를 처리
                    DispatchQueue.main.async {
                        self.telemetryData = text
                    }
                case .data(let data):
                    print("수신된 바이너리 데이터: \(data)")
                @unknown default:
                    fatalError()
                }
                self.listen()
            }
        }
    }
    
    // RC 제어 데이터(JSON)를 RPi로 전송
    func sendControlData(roll: Int, pitch: Int, yaw: Int, throttle: Int, aux1: Int) {

        guard isConnected else { return }

        let controlData = ControlData(roll: roll, pitch: pitch, yaw: yaw, throttle: throttle, aux1: aux1)

        do {
            let jsonData = try JSONEncoder().encode(controlData)
            guard let jsonString = String(data: jsonData, encoding: .utf8) else {
                print(">>> JSON 문자열 변환 실패")
                return
            }

            webSocketTask?.send(.string(jsonString)) { error in
                if let error = error {
                    // 1. 에러가 발생하면 이걸 출력
                    print(">>> SEND FAILED: \(error.localizedDescription)")
                } else {
                    // 2. 성공하면 이걸 출력
                    print(">>> Send Succeeded (to RPi)")
                }
            }
        } catch {
            print(">>> JSON 인코딩 오류: \(error.localizedDescription)")
        }
    }
    
    // MARK: - URLSessionWebSocketDelegate
    
    // 연결 성공
    nonisolated func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didOpenWithProtocol protocol: String?) {
        print(">>> Delegate: Connection Opened!")
        
        DispatchQueue.main.async {
            print(">>> Delegate: Setting isConnected = true")
            
            self.isConnected = true
        }
    }
    
    // 연결 실패 또는 해제
    nonisolated func urlSession(_ session: URLSession, webSocketTask: URLSessionWebSocketTask, didCloseWith closeCode: URLSessionWebSocketTask.CloseCode, reason: Data?) {
        print("웹소켓 연결 해제.")
        DispatchQueue.main.async {
            self.isConnected = false
        }
    }
}

