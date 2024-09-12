//
//  FormRow.swift
//
//  Created by xueqooy on 2023/3/4.
//

import UIKit

/// `FormRow` serves as a container for single or multiple views. It is responsible for adding these views to the `FormView` and can be configured with alignment, height, and other properties.
public class FormRow: FormItem {
    
    public struct Constants {
        public static let defaultAlignment: Alignment = .fill
        public static let defaultSpacing: CGFloat = 0
        public static let defaultDistribution: Distribution = .fill
        public static let defaultVerticalAlignment: VerticalAlignment = .fill
    }
    
    public enum Alignment: Equatable {
        case fill, leading, center, trailing
    }
    
    public enum VerticalAlignment {
        case fill, top, center, bottom
    }
    
    public enum Distribution : Int {
        case fill, fillEqually, fillProportionally, equalSpacing, equalCentering
    }
    
    private enum Style {
        case singleView(UIView, insets: UIEdgeInsets?)
        case multipleViews([UIView], spacing: CGFloat, distribution: Distribution, verticalAlignment: VerticalAlignment, insets: UIEdgeInsets?)
    }
    
    private let style: Style
    
    public var height: CGFloat? {
        didSet {
            (loadedView as? FormRowView)?.height = height
        }
    }
    
    public var alignment: Alignment {
        didSet {
            (loadedView as? FormRowView)?.alignment = alignment
        }
    }
    
    public init(_ view: UIView, height: CGFloat? = nil, alignment: Alignment = Constants.defaultAlignment, insets: UIEdgeInsets? = nil) {
        self.style = .singleView(view, insets: insets)
        self.height = height
        self.alignment = alignment
        
        super.init()
    }
    
    public init(_ views: [UIView], spacing: CGFloat = Constants.defaultSpacing, height: CGFloat? = nil, distribution: Distribution = Constants.defaultDistribution, verticalAlignment: VerticalAlignment = Constants.defaultVerticalAlignment, alignment: Alignment = Constants.defaultAlignment, insets: UIEdgeInsets? = nil) {
        self.style = .multipleViews(views, spacing: spacing, distribution: distribution, verticalAlignment: verticalAlignment, insets: insets)
        self.height = height
        self.alignment = alignment
        
        super.init()
    }
    
    /// DSL initializer for multiple views
    public convenience init(spacing: CGFloat = Constants.defaultSpacing, height: CGFloat? = nil, distribution: Distribution = Constants.defaultDistribution, verticalAlignment: VerticalAlignment = Constants.defaultVerticalAlignment, alignment: Alignment = Constants.defaultAlignment, insets: UIEdgeInsets = .zero, @ArrayBuilder<UIView> views: () -> [UIView]) {
        self.init(views(), spacing: spacing, height: height, distribution: distribution, verticalAlignment: verticalAlignment, alignment: alignment, insets: insets)
    }
    
    /// Get a certain view that force casting to the type
    /// - warning: Do not use it if you don't clear about the view type
    public func view<T: UIView>(of _: T.Type, at index: Int = 0) -> T {
        switch style {
        case .singleView(let view, _):
            return view as! T
        case .multipleViews(let views, _, _, _, _):
            return views[index] as! T
        }
    }
    
    public override func createView() -> UIView {
        switch style {
        case .singleView(let view, let insets):
            if let insets {
                let wrapperView = UIView()
                wrapperView.addSubview(view)
                view.snp.makeConstraints { make in
                    make.edges.equalTo(insets)
                }
                
                return FormRowView(wrapperView, height: height, alignment: alignment)
                
            } else {
                return FormRowView(view, height: height, alignment: alignment)
            }
            
        case .multipleViews(let views, let spacing, let distribution, let verticalAlignment, let insets):
            let stackAlignemnt: UIStackView.Alignment = {
                switch verticalAlignment {
                case .fill:
                    return .fill
                case .top:
                    return .top
                case .center:
                    return .center
                case .bottom:
                    return .bottom
                }
            }()
            let stackDistribution = UIStackView.Distribution(rawValue: distribution.rawValue)!
            
            let hStack = UIStackView(arrangedSubviews: views)
            hStack.distribution = stackDistribution
            hStack.alignment = stackAlignemnt
            hStack.spacing = spacing
            
            if let insets {
                hStack.layoutMargins = insets
                hStack.isLayoutMarginsRelativeArrangement = true
            }
            
            return FormRowView(hStack, height: height, alignment: alignment)
        }
       
    }
}


class FormRowView: UIView {
    
    weak var view: UIView?
    
    var height: CGFloat? {
        didSet {
            if height == oldValue {
                return
            }
            
           updateViewConstrants()
        }
    }
    
    var alignment: FormRow.Alignment {
        didSet {
            if alignment == oldValue {
                return
            }
            
           updateViewConstrants()
        }
    }
    
    init(_ view: UIView, height: CGFloat?, alignment: FormRow.Alignment) {
        self.height = height
        self.alignment = alignment
        
        super.init(frame: .zero)
        
        self.view = view
        
        addSubview(view)
        updateViewConstrants()
    }
    
    private func updateViewConstrants() {
        guard let view = view else {
            return
        }
        view.snp.remakeConstraints { make in
            if let height = height {
                make.height.equalTo(height)
            }
            make.top.bottom.equalToSuperview()
            switch alignment {
            case .fill:
                make.leading.trailing.equalToSuperview()
                
            case .leading:
                make.width.lessThanOrEqualToSuperview()
                make.leading.equalToSuperview()
                
            case .center:
                make.width.lessThanOrEqualToSuperview()
                make.centerX.equalToSuperview()
                
            case .trailing:
                make.width.lessThanOrEqualToSuperview()
                make.trailing.equalToSuperview()
            }
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
