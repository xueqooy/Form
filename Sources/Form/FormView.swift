//
//  FormView.swift
//
//  Created by xueqooy on 2024/9/10.
//

import UIKit
import SnapKit

/// Similar to the vertical StackView, it supports row alignment (leading, trailing, center and fill) and row height settings.
public class FormView: UIView {
    
    public enum ContentScrollingBehavior {
        case normal // Scrollable, the content offset will be adjusted according to the keyboard to make the content always visible.
        
        case limited // Under normal circumstances, it cannot be scrolled. The content height is less than or equal to the view height, but the content offset will be adjusted according to the keyboard to make the content always visible.
            
        case disabled // Non-scrollable, the content height is always equal to the view height.
    }

    public var backgroundView: UIView? {
        willSet {
            backgroundView?.removeFromSuperview()
        }
        didSet {
            maybeSetupBackgroundView()
        }
    }

    public var contentInset: UIEdgeInsets {
        didSet {
            container.layoutMargins = contentInset
            invalidateIntrinsicContentSize()
        }
    }
    
    @objc dynamic public var itemSpacing: CGFloat {
        didSet {
            container.spacing = itemSpacing
            invalidateIntrinsicContentSize()
        }
    }
    
    public var items: [FormItem] {
        container.arrangedSubviews.reduce(into: [FormItem]()) { partialResult, view in
            if let item = view.formItem {
                partialResult.append(item)
            }
        }
    }
        
    open override var bounds: CGRect {
        didSet {
            guard previousBoundWidth != bounds.width else { return }
            
            previousBoundWidth = bounds.width
            invalidateIntrinsicContentSize()
        }
    }
    
    public var contentScrollingBehavior: ContentScrollingBehavior {
        didSet {
            if oldValue == contentScrollingBehavior {
                return
            }
            
            if oldValue != .disabled {
                scrollingContainer.removeFromSuperview()
            }
            container.removeFromSuperview()
            
            setupContainer()
        }
    }
    
    public private(set) lazy var scrollingContainer: UIScrollView = FormScrollView()
            
    private let container: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
            
    private var previousBoundWidth: CGFloat?

    
    public init(contentScrollingBehavior: ContentScrollingBehavior = .normal, contentInset: UIEdgeInsets = .zero, itemSpacing: CGFloat = 0) {
        self.contentScrollingBehavior = contentScrollingBehavior
        self.contentInset = contentInset
        self.itemSpacing = itemSpacing
        
        super.init(frame: .zero)
        
        initialize()
        setupContainer()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func addItem(_ item: FormItem) {
        let loadedView = item.loadView()
        container.addArrangedSubview(loadedView)
        
        if let customSpacingAfter = item.customSpacingAfter {
            container.setCustomSpacing(customSpacingAfter, after: loadedView)
        }
        
        invalidateIntrinsicContentSize()
    }
    
    public func insertItem(_ item: FormItem, at index: Int) {
        let loadedView = item.loadView()
        container.insertArrangedSubview(loadedView, at: index)
        
        if let customSpacingAfter = item.customSpacingAfter {
            container.setCustomSpacing(customSpacingAfter, after: loadedView)
        }
        
        invalidateIntrinsicContentSize()
    }
    
    public func removeAllItems() {
        container.arrangedSubviews.forEach { $0.removeFromSuperview() }
        invalidateIntrinsicContentSize()
    }
    
    public override func invalidateIntrinsicContentSize() {
        super.invalidateIntrinsicContentSize()
        
        // Recursively invalidate content size of super form view
        if let superFormView = findSuperview(ofType: FormView.self) {
            superFormView.invalidateIntrinsicContentSize()
        }
    }
        
    public override var intrinsicContentSize: CGSize {
        // If the width is 0, the systemLayoutSizeFitting method will not work properly, so we need to use the compressed size
        if bounds.width == 0 {
            container.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        } else {
            container.systemLayoutSizeFitting(CGSize(width: bounds.width, height: 0), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
        }
    }

    
    // MARK: - Private
    
    private func initialize() {
        container.layoutMargins = contentInset
        container.spacing = itemSpacing        
    }
    
    private func setupContainer() {
        if contentScrollingBehavior != .disabled {
            addSubview(scrollingContainer)
            scrollingContainer.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            
            scrollingContainer.addSubview(container)
            container.snp.makeConstraints { make in
                make.top.bottom.left.equalToSuperview()
                make.width.equalToSuperview()
                if contentScrollingBehavior == .limited {
                    make.height.lessThanOrEqualToSuperview()
                }
            }
        } else {
            addSubview(container)
            container.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
        }
    }
    
    private func maybeSetupBackgroundView() {
        guard let backgroundView else { return }
        
        addSubview(backgroundView)
        sendSubviewToBack(backgroundView)
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }        
    }
}


// MARK: - DSL

extension FormView {
    
    public func populate(keepPreviousItems: Bool = false, @ArrayBuilder<FormItem> items: () -> [FormItem]) {
        if !keepPreviousItems {
            removeAllItems()
        }
        
        items()
            .forEach { addItem($0) }
    }
}
