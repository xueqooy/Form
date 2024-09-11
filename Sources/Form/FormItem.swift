//
//  FormItem.swift
//  Form
//
//  Created by xueqooy on 2023/3/5.
//

import UIKit
import Combine

/// Abstract class
open class FormItem {
        
    @Published
    open var customSpacingAfter: CGFloat? {
        didSet {
            guard oldValue != customSpacingAfter else {
                return
            }
            
            guard let loadedView = loadedView, let stackView = loadedView.superview as? UIStackView else {
                return
            }
            
            if let customSpacingAfter = customSpacingAfter {
                stackView.setCustomSpacing(customSpacingAfter, after: loadedView)
            } else {
                stackView.setCustomSpacing(UIStackView.spacingUseDefault, after: loadedView)
            }
        }
    }
     
    @Published
    open var isHidden: Bool = false {
        didSet {
            guard oldValue != isHidden else {
                return
            }
                        
            loadedView?.isHidden = isHidden
            loadedView?.findSuperview(ofType: FormView.self)?.invalidateIntrinsicContentSize()
            
            hiddenChangedEvent.send(isHidden)
        }
    }
    
    open func createView() -> UIView {
        preconditionFailure("Subclass should override this method")
    }

    public func removeFromForm() {
        guard let loadedView else { return }
        
        let superFormView = loadedView.findSuperview(ofType: FormView.self)
        
        loadedView.removeFromSuperview()
        
        superFormView?.invalidateIntrinsicContentSize()
    }
    
    @discardableResult
    public func settingCustomSpacingAfter(_ customSpacingAfter: CGFloat?) -> Self {
        self.customSpacingAfter = customSpacingAfter
        return self
    }
    
    @discardableResult
    public func settingHidden(_ hidden: Bool) -> Self {
        self.isHidden = hidden
        return self
    }
    
        
    // MARK: Internal
    
    let hiddenChangedEvent = PassthroughSubject<Bool, Never>()
    
    weak var loadedView: UIView?
    
    func loadView() -> UIView  {
        loadedView?.removeFromSuperview()
        loadedView?.formItem = nil
        
        let view = createView()
        view.formItem = self
        view.isHidden = isHidden
        
        loadedView = view
        
        return view
    }
    
    
    // MARK: Private
    
    private var customSpacingBinding: AnyCancellable?
    
    private var hiddenBinding: AnyCancellable?
}


// MARK: - Binding

extension FormItem {
    
    @discardableResult
    func bindingCustomSpacingAfter<T>(to publisher: some Publisher<T, Never>, transform: @escaping (T) -> CGFloat) -> Self {
        customSpacingBinding =
        publisher
            .map(transform)
            .sink { [weak self] spacing in
                self?.customSpacingAfter = spacing
            }
        
        return self
    }
    
    @discardableResult
    func bindingCustomSpacingAfter(to publisher: some Publisher<CGFloat, Never>) -> Self {
        bindingCustomSpacingAfter(to: publisher) { $0 }
    }
    
    @discardableResult
    func bindingHidden<T>(to publisher: some Publisher<T, Never>, transform: @escaping (T) -> Bool) -> Self {
        hiddenBinding =
        publisher
            .map(transform)
            .sink { [weak self] isHidden in
                self?.isHidden = isHidden
            }
        
        return self
    }
    
    @discardableResult
    func bindingHidden(to publisher: some Publisher<Bool, Never>, toggled: Bool = false) -> Self {
        bindingHidden(to: publisher) {
            toggled ? !$0 : $0
        }
    }
}


// MARK: - UIView+FormItem

extension UIView {
    
    var formItem: FormItem? {
        get {
            objc_getAssociatedObject(self, UnsafeRawPointer(Unmanaged.passUnretained(self).toOpaque())) as? FormItem
        }
        set {
            objc_setAssociatedObject(self, UnsafeRawPointer(Unmanaged.passUnretained(self).toOpaque()), newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

