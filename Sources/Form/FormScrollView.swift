//
//  FormScrollView.swift
//
//  Created by xueqooy on 2024/9/11.
//

import Combine
import UIKit

class FormScrollView: UIScrollView {
    #if os(iOS)
    private var keyboardSubscription: AnyCancellable?
    private var originalBottomContentInset: CGFloat?
    #endif

    init() {
        super.init(frame: .zero)
        contentInsetAdjustmentBehavior = .never

        #if os(iOS)
        let center = NotificationCenter.default
        keyboardSubscription = center.publisher(for: UIApplication.keyboardWillChangeFrameNotification)
            .merge(with: center.publisher(for: UIApplication.keyboardDidChangeFrameNotification))
            .sink { [weak self] in
                guard let self else { return }

                self.keyboardFrameChanged($0)
            }
        #endif
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    #if os(iOS)
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
    #endif
}
