//
//  XDTouchesGestureRecognizer.swift
//  XDXCLife
//
//  Created by SongOY on 2021/4/19.
//

import Foundation
import UIKit
import UIKit.UIGestureRecognizerSubclass

class XDTouchesGestureRecognizer: UIGestureRecognizer {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        state = UIGestureRecognizer.State.began
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent) {
        state = UIGestureRecognizer.State.changed
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        state = UIGestureRecognizer.State.ended
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        state = UIGestureRecognizer.State.ended
    }
    
    override func reset() {
        state = UIGestureRecognizer.State.possible
    }
}
