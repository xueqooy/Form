//
//  FormView.swift
//
//  Created by xueqooy on 2024/9/10.
//

import UIKit

/// Similar to the vertical UIStackView, it supports row alignment (leading, trailing, center and fill) and row height settings.
public class FormView: UIView {
    public enum ContentScrollingBehavior {
        case normal // Scrollable, the content offset will be adjusted according to the keyboard to make the content always visible.

        case limited // Under normal circumstances, it cannot be scrolled. The content height is less than or equal to the view height, but the content offset will be adjusted according to the keyboard.

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
    
    @objc public dynamic var itemSpacing: CGFloat {
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

    override open var bounds: CGRect {
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

    public init(contentScrollingBehavior: ContentScrollingBehavior = .normal, contentInset: UIEdgeInsets = .init(), itemSpacing: CGFloat = 0) {
        self.contentScrollingBehavior = contentScrollingBehavior
        self.contentInset = contentInset
        self.itemSpacing = itemSpacing

        super.init(frame: .zero)

        initialize()
        setupContainer()
    }

    @available(*, unavailable)
    public required init?(coder _: NSCoder) {
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

    override public func invalidateIntrinsicContentSize() {
        super.invalidateIntrinsicContentSize()

        // Recursively invalidate content size of super form view
        if let superFormView = findSuperview(ofType: FormView.self) {
            superFormView.invalidateIntrinsicContentSize()
        }
    }

    override public var intrinsicContentSize: CGSize {
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
            scrollingContainer.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                scrollingContainer.topAnchor.constraint(equalTo: topAnchor),
                scrollingContainer.bottomAnchor.constraint(equalTo: bottomAnchor),
                scrollingContainer.leadingAnchor.constraint(equalTo: leadingAnchor),
                scrollingContainer.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
            
            scrollingContainer.addSubview(container)
            container.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate(
                Array {
                    container.topAnchor.constraint(equalTo: scrollingContainer.topAnchor)
                    container.bottomAnchor.constraint(equalTo: scrollingContainer.bottomAnchor)
                    container.leftAnchor.constraint(equalTo: scrollingContainer.leftAnchor)
                    container.widthAnchor.constraint(equalTo: scrollingContainer.widthAnchor)
                    
                    if contentScrollingBehavior == .limited {
                        container.heightAnchor.constraint(lessThanOrEqualTo: scrollingContainer.heightAnchor)
                    }
                }
            )
        } else {
            addSubview(container)
            container.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                container.topAnchor.constraint(equalTo: topAnchor),
                container.bottomAnchor.constraint(equalTo: bottomAnchor),
                container.leadingAnchor.constraint(equalTo: leadingAnchor),
                container.trailingAnchor.constraint(equalTo: trailingAnchor)
            ])
        }
    }

    private func maybeSetupBackgroundView() {
        guard let backgroundView else { return }

        addSubview(backgroundView)
        sendSubviewToBack(backgroundView)
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

// MARK: - DSL

public extension FormView {
    func populate(keepPreviousItems: Bool = false, @ArrayBuilder<FormItem> items: () -> [FormItem]) {
        if !keepPreviousItems {
            removeAllItems()
        }

        items()
            .forEach { addItem($0) }
    }
}
