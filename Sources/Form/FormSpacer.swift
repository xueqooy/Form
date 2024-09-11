//
//  FormSpacer.swift
//  Form
//
//  Created by xueqooy on 2023/3/4.
//

import UIKit

public class FormSpacer: FormItem {
    
    public var spacing: CGFloat {
        didSet {
            (loadedView as? FormSpacerView)?.spacing = spacing
        }
    }
    
    public var huggingPriority: UILayoutPriority {
        didSet {
            (loadedView as? FormSpacerView)?.huggingPriority = huggingPriority
        }
    }
    
    public var compressionResistancePriority: UILayoutPriority {
        didSet {
            (loadedView as? FormSpacerView)?.compressionResistancePriority = compressionResistancePriority
        }
    }
        
    public init(_ spacing: CGFloat = 0, huggingPriority: UILayoutPriority = .dragThatCannotResizeScene, compressionResistancePriority: UILayoutPriority = .dragThatCannotResizeScene) {
        self.spacing = spacing
        self.huggingPriority = huggingPriority
        self.compressionResistancePriority = compressionResistancePriority
        
        super.init()
    }

    public static func flexible() -> FormSpacer {
        FormSpacer(.greatestFiniteMagnitude, compressionResistancePriority: .fittingSizeLevel)
    }
    
    public override func createView() -> UIView {
        FormSpacerView(spacing, huggingPriority: huggingPriority, compressionResistancePriority: compressionResistancePriority)
    }
}


class FormSpacerView: UIView {
    
    var spacing: CGFloat = 0 {
        didSet {
            guard spacing != oldValue else {
                return
            }
            
            invalidateIntrinsicContentSize()
        }
    }
    
    var huggingPriority: UILayoutPriority {
        set {
            setContentHuggingPriority(newValue, for: .vertical)
        }
        get {
            contentHuggingPriority(for: .vertical)
        }
    }
    
    
    var compressionResistancePriority: UILayoutPriority {
        set {
            setContentCompressionResistancePriority(newValue, for: .vertical)
        }
        get {
            contentHuggingPriority(for: .vertical)
        }
    }
    
    init(_ spacing: CGFloat, huggingPriority: UILayoutPriority, compressionResistancePriority: UILayoutPriority) {
        self.spacing = spacing
        
        super.init(frame: .zero)
        
        self.compressionResistancePriority = compressionResistancePriority
        self.huggingPriority = huggingPriority
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: UIView.noIntrinsicMetric, height: spacing)
    }
}
