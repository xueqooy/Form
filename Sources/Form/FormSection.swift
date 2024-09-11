//
//  FormSection.swift
//  Form
//
//  Created by xueqooy on 2024/1/11.
//

import UIKit
import Combine

/// A container for `FormItem`,  can set its background, content insets, and item spacing, etc
/// By default, `FormSection` automatically refreshes its isHidden property based on the isHidden property of its items. If all items are hidden, the FormSection will also be hidden.
/// Conversely, if any item is visible, the `FormSection` will also be visible.
public class FormSection: FormItem {
   
    public var items: [FormItem] = [] {
        didSet {
            if !isPopulating {
                loadedSectionView?.populate {
                    items
                }
            }
            
            // Listen to the hidden attribute of items and hide the FormSection when all items are hidden
            itemObservationCancellables.removeAll()
            
            checkItems()
            
            items.forEach { item in
                item.hiddenChangedEvent
                    .sink { [weak self] _ in
                        guard let self = self else { return }
                        
                        self.checkItems()
                    }
                    .store(in: &itemObservationCancellables)
            }
        }
    }
    
    public var backgroundView: UIView? {
        didSet {
            loadedSectionView?.backgroundView = backgroundView
        }
    }
    
    public var contentInset: UIEdgeInsets {
        didSet {
            loadedSectionView?.contentInset = contentInset
        }
    }
    
    public var itemSpacing: CGFloat {
        didSet {
            loadedSectionView?.itemSpacing = itemSpacing
        }
    }
    
    public var automaticallyUpdatesVisibility: Bool {
        didSet {
            guard oldValue != automaticallyUpdatesVisibility else {
                return
            }
            
            checkItems()
        }
    }
    
    private var loadedSectionView: FormSectionView? {
        loadedView as? FormSectionView
    }
    
    private var isPopulating: Bool = false
    
    private var itemObservationCancellables = Set<AnyCancellable>()
        
    public init(
        items: [FormItem],
        backgroundView: UIView? = nil,
        contentInset: UIEdgeInsets = .zero,
        itemSpacing: CGFloat = 0,
        automaticallyUpdatesVisibility: Bool = true
    ) {
        self.backgroundView = backgroundView
        self.contentInset = contentInset
        self.itemSpacing = itemSpacing
        self.automaticallyUpdatesVisibility = automaticallyUpdatesVisibility
        
        super.init()
        
        defer {
            self.items = items
        }
    }
    
    public convenience init(
        backgroundView: UIView? = nil,
        contentInset: UIEdgeInsets = .zero,
        itemSpacing: CGFloat = 0,
        automaticallyUpdatesVisibility: Bool = true,
        @ArrayBuilder<FormItem> items: () -> [FormItem]) {
        
        self.init(items: items(), backgroundView: backgroundView, contentInset: contentInset, itemSpacing: itemSpacing, automaticallyUpdatesVisibility: automaticallyUpdatesVisibility)
    }
    
    public func populate(keepPreviousItems: Bool = false, @ArrayBuilder<FormItem> items: () -> [FormItem]) {
        isPopulating = true
        defer {
            isPopulating = false
        }
        
        let items = items()
                
        loadedSectionView?.populate(keepPreviousItems: keepPreviousItems) {
            items
        }
        
        if keepPreviousItems {
            self.items.append(contentsOf: items)
        } else {
            self.items = items
        }
        
        
    }
    
    public override func createView() -> UIView {
        let sectionView = FormSectionView(backgroundView: backgroundView, contentInset: contentInset, itemSpacing: itemSpacing)
        
        if !items.isEmpty {
            sectionView.populate {
                items
            }
        }
        
        return sectionView
    }
    
    private func checkItems() {
        loadedSectionView?.invalidateIntrinsicContentSize()
        
        guard automaticallyUpdatesVisibility else {
            // Ignore checking the hidden attribute of items if automaticallyUpdatesVisibility is disabled
            return
        }
        
        var existsVisibleItems = false
        
        for item in items {
            if !item.isHidden {
                existsVisibleItems = true
                break
            }
        }
        
        isHidden = !existsVisibleItems
    }
}


class FormSectionView: FormView {
    
    init(backgroundView: UIView?, contentInset: UIEdgeInsets, itemSpacing: CGFloat) {
        super.init(contentScrollingBehavior: .disabled)
            
        defer {            
            self.backgroundView = backgroundView
            self.contentInset = contentInset
            self.itemSpacing = itemSpacing
        }
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
