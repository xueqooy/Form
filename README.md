<p align="center">
<img src="https://github.com/user-attachments/assets/24c71883-d624-48d1-b484-43c5a1b2b87a" alt="form_view_screenshot" height="250">
</p>

<p align="center">
The combination of UIStackView(Vertical Axis) and UIScrollView, and more.
</p>

----------------

## Key Features

1. **Row Alignment**: Easily configure row alignments.
2. **Multiple Views in one Row**: Add multiple views to a single row.
3. **Section**: Organizing items into distinct sections.
4. **Keyboard Handling**: Automatically adjusts its `contentInset` based on keyboard visibility.
6. **Customizable Background**: Supports applying custom background to both the entire FormView and individual sections.
7. **Flexible Item Spacing**: Customize the spacing between items using three different approaches:
   - Set a global `itemSpacing` for the entire FormView.
   - Insert custom spacers using the `FormSpacer`.
   - Adjust item-specific spacing using the `settingCustomSpacingAfter` method on individual form items.
8. **DSL Syntax**：Supports a DSL syntax for a SwiftUI-like experience.

## Requirements
- iOS 13.0+
- tvOS 13.0+

## Usage Example

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

### Snapshot
| iOS | tvOS|
|----|----|
| <img src="https://github.com/user-attachments/assets/15b11c1b-bbd8-45bc-b1a2-7572a11d1535" alt="simulator_screenshot_60B125DB-0A0B-4B6E-9DBF-307E7A7360D" height="300"> |  <img src="https://github.com/user-attachments/assets/fb4f593c-73c8-467c-8e8b-366a2a4e75a8" alt="simulator_screenshot_60B125DB-0A0B-4B6E-9DBF-307E7A7360D" height="300"> |

## Installation

**Using [Swift Package Manager](https://swift.org/package-manager)**:

```swift
import PackageDescription

let package = Package(
  name: "MyAwesomeApp",
  dependencies: [
    .Package(url: "https://github.com/xueqooy/Form", majorVersion: 2),
  ]
)
```

## License
Form is licensed under the MIT License. See LICENSE for more information.

## Contact
- GitHub: https://github.com/xueqooy/XUI
- Email: xue_qooy@163.com
