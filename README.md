<img src="https://github.com/user-attachments/assets/5980a742-36ca-4bc1-80e4-5f77c8a6fd4a" alt="form_view_screenshot" height="300">

# FormView

FormView is a flexible, keyboard-aware and scrollable container similar to a vertical `UIStackView`

## Key Features

1. **Row Alignment Options**: Easily configure row alignments, including leading, trailing, center, and fill.
2. **Multiple Views in a Row**: Add multiple views to a single row, allowing for complex layouts where multiple views are horizontally arranged within one row.
3. **Section Support**: FormView supports organizing items into distinct sections.
4. **Automatic Keyboard Handling**: FormView automatically adjusts its `contentInset` based on keyboard visibility.
5. **Dynamic Height Adjustment**: FormView dynamically adjusts its height to fit its content and allows scrolling if the content exceeds the available space.
6. **Customizable Backgrounds**: Supports applying custom background views to both the entire FormView and individual sections.
7. **Flexible Item Spacing**: Customize the spacing between items using three different approaches:
   - Set a global `itemSpacing` for the entire FormView.
   - Insert custom spacers using the `FormSpacer`.
   - Adjust item-specific spacing using the `settingCustomSpacingAfter` method on individual form items.

## Usage

FormView provides a simple and flexible API to create organized and well-aligned forms.

### Example

<img src="https://github.com/user-attachments/assets/15b11c1b-bbd8-45bc-b1a2-7572a11d1535" alt="simulator_screenshot_60B125DB-0A0B-4B6E-9DBF-307E7A7360D" height="500">

```swift
formView.populate {
    FormRow(imageView, height: 80)
        .settingCustomSpacingAfter(20)
    
    FormRow(titleLabel, alignment: .center)
        .settingCustomSpacingAfter(20)
    
    FormRow(detailLabel)
        .settingCustomSpacingAfter(40)
    
    FormSection(backgroundView: FieldBackgroundView(), contentInset: .init(top: 20, left: 20, bottom: 20, right: 20), itemSpacing: 15) {
        FormRow(idTextField)
        
        FormSeparator()
        
        FormRow(pswTextField)
    }
    .settingCustomSpacingAfter(10)
    
    FormRow {
        signUpButton

        UIView()

        forgotPswButton
    }

    FormSpacer(50)
    
    FormRow(loginButton, insets: .init(top: 0, left: 20, bottom: 0, right: 20))
}
```
