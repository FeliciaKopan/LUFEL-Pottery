//
//  UILabelExtensions.swift
//  LUFEL
//
//  Created by Felicia Alamorean on 07.06.2024.
//

import UIKit

extension UIButton {
    func setAttributedText(
        _ text: String?,
        lineHeightMultiple: CGFloat?,
        kern: CGFloat?,
        alignment: NSTextAlignment? = .left
    ) {
        guard let text = text else { return }
        var attributes: [NSAttributedString.Key : Any] = [:]
        let paragraphStyle = NSMutableParagraphStyle()
        if let lineHeight = lineHeightMultiple {
            paragraphStyle.lineHeightMultiple = lineHeight
            paragraphStyle.lineBreakMode = .byTruncatingTail
        }
        if let alignment = alignment {
            paragraphStyle.alignment = alignment
        }
        if let kern = kern {
            attributes[.kern] = kern
        }
        attributes[.paragraphStyle] = paragraphStyle
        let attributedText = NSAttributedString(
            string: text,
            attributes: attributes
        )

        setAttributedTitle(attributedText, for: .normal)
    }
}

extension UILabel {
    func setAttributedText(
        _ text: String?,
        lineHeightMultiple: CGFloat?,
        kern: CGFloat?,
        alignment: NSTextAlignment? = .left,
        animated: Bool = false
    ) {
        guard let text = text else { return }
        var attributes: [NSAttributedString.Key : Any] = [:]
        let paragraphStyle = NSMutableParagraphStyle()
        if let lineHeight = lineHeightMultiple {
            paragraphStyle.lineHeightMultiple = lineHeight
            paragraphStyle.lineBreakMode = .byTruncatingTail
        }
        if let alignment = alignment {
            paragraphStyle.alignment = alignment
        }
        if let kern = kern {
            attributes[.kern] = kern
        }
        attributes[.paragraphStyle] = paragraphStyle
        if animated {
            UIView.transition(with: self, duration: 1, options: .transitionCrossDissolve) { [weak self] in
                self?.attributedText = NSAttributedString(
                    string: text,
                    attributes: attributes
                )
            }
        } else {
            attributedText = NSAttributedString(
                string: text,
                attributes: attributes
            )
        }
    }
}

extension UITextView {
    func setAttributedText(
        _ text: String?,
        lineHeightMultiple: CGFloat?,
        kern: CGFloat?,
        font: UIFont? = nil,
        textColor: UIColor? = nil
    ) {
        guard let text = text else { return }
        var attributes: [NSAttributedString.Key : Any] = [:]
        if let lineHeight = lineHeightMultiple {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineHeightMultiple = lineHeight
//            paragraphStyle.lineBreakMode = .byTruncatingTail
            attributes[.paragraphStyle] = paragraphStyle
        }
        if let kern = kern {
            attributes[.kern] = kern
        }
        if let textColor = textColor {
            attributes[.foregroundColor] = textColor
        }
        if let font = font {
            attributes[.font] = font
        }
        attributedText = NSAttributedString(
            string: text,
            attributes: attributes
        )
    }
}

