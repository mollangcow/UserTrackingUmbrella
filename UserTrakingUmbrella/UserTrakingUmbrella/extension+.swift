//
//  extension.swift
//  UserTrakingUmbrella
//
//  Created by mollangcow on 11/5/25.
//

import SwiftUI

extension CGPoint {
    func distance(to point: CGPoint) -> CGFloat {
        return sqrt(pow(self.x - point.x, 2) + pow(self.y - point.y, 2))
    }

    func angle(to point: CGPoint) -> CGFloat {
        return atan2(self.y - point.y, self.x - point.x)
    }
}
