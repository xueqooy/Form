//
//  File.swift
//  
//  Created by xueqooy on 2024/9/11.
//

import UIKit
import Combine

class FormScrollView: UIScrollView {
    
    private var keyboardSubscription: AnyCancellable?
        
    private var originalBottomContentInset: CGFloat?
    
    init() {
        super.init(frame: .zero)
        
        contentInsetAdjustmentBehavior = .never

        let center = NotificationCenter.default
        
        keyboardSubscription = center.publisher(for: UIApplication.keyboardWillChangeFrameNotification)
            .merge(with: center.publisher(for: UIApplication.keyboardDidChangeFrameNotification))
            .sink { [weak self] in
                guard let self else { return }
                
                self.keyboardFrameChanged($0)
            }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func keyboardFrameChanged(_ notification: Notification) {
        guard let container = superview, var keyboardFrame = notification.userInfo?[UIApplication.keyboardFrameEndUserInfoKey] as? CGRect else { return }
        
        keyboardFrame = container.convert(keyboardFrame, from: nil)
                
        if originalBottomContentInset == nil {
            originalBottomContentInset = contentInset.bottom
        }
        
        let isFloatingKeyboard = keyboardFrame.width < window?.bounds.width ?? 0
        
        let intersectionHeight: CGFloat = if isFloatingKeyboard {
            0
        } else {
            bounds.intersection(keyboardFrame).height
        }

        let bottomInset = max(originalBottomContentInset!, intersectionHeight + originalBottomContentInset!)
        
        if contentInset.bottom != bottomInset {
            contentInset.bottom = bottomInset
        }
    }
    
    
}
