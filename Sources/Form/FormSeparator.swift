//
//  FormSeparator.swift
//
//  Created by xueqooy on 2023/3/6.
//

import UIKit

public class FormSeparator: FormItem {
    
    public var leadingPadding: CGFloat {
        didSet {
            (loadedView as? FormSeparatorView)?.leadingPadding = leadingPadding
        }
    }
    
    public var trailingPadding: CGFloat {
        didSet {
            (loadedView as? FormSeparatorView)?.trailingPadding = trailingPadding
        }
    }
    
    public var color: UIColor? {
        didSet {
            (loadedView as? FormSeparatorView)?.color = color
        }
    }
    
    public var thickness: CGFloat {
        didSet {
            (loadedView as? FormSeparatorView)?.thickness = thickness
        }
    }
    
    public init(color: UIColor? = .separator, thickness: CGFloat = 1, leadingPadding: CGFloat = 0, trailingPadding: CGFloat = 0) {
        self.color = color
        self.thickness = thickness
        self.leadingPadding = leadingPadding
        self.trailingPadding = trailingPadding
        
        super.init()
    }
    
    public override func createView() -> UIView {
        FormSeparatorView(color: color, thickness: thickness, leadingPadding: leadingPadding, trailingPadding: trailingPadding)
    }
}


class FormSeparatorView: UIView {
    
    var leadingPadding: CGFloat = 0 {
        didSet {
            guard oldValue != leadingPadding else {
                return
            }
            
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    var trailingPadding: CGFloat = 0 {
        didSet {
            guard oldValue != trailingPadding else {
                return
            }
            
            setNeedsLayout()
            layoutIfNeeded()
        }
    }
    
    var color: UIColor? {
        set {
            lineView.backgroundColor = newValue
        }
        get {
            lineView.backgroundColor
        }
    }
    
    var thickness: CGFloat {
        didSet {
            guard oldValue != thickness else {
                return
            }
            
            updateLineView()
        }
    }

    private var lineView = UIView()


    init(color: UIColor?, thickness: CGFloat, leadingPadding: CGFloat, trailingPadding: CGFloat) {
        self.thickness = thickness
        self.leadingPadding = leadingPadding
        self.trailingPadding = trailingPadding
        
        super.init(frame: .zero)
        
        addSubview(lineView)
        
        self.color = color
        
        updateLineView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func updateLineView() {
        frame.size.height = thickness
        autoresizingMask = .flexibleWidth
        
        isAccessibilityElement = false
        isUserInteractionEnabled = false
        
        setContentCompressionResistancePriority(.required, for: .vertical)
        setContentHuggingPriority(.required, for: .vertical)
        
        invalidateIntrinsicContentSize()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
            
        lineView.frame = bounds.inset(by: UIEdgeInsets(top: 0, left: leadingPadding, bottom: 0, right: trailingPadding))
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: frame.height)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        CGSize(width: size.width, height: frame.height)
    }
}
