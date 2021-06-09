//
//  CustomToast.swift
//  demoTextField
//
//  Created by Ios Team on 09/06/21.
//

import Foundation
import UIKit

//MARK: Extension on UILabel for adding insets - for adding padding in top, bottom, right, left.

extension UILabel
{
    private struct AssociatedKeys {
        static var padding = UIEdgeInsets()
    }
    
    var padding: UIEdgeInsets? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.padding) as? UIEdgeInsets
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.padding, newValue as UIEdgeInsets?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    override open func draw(_ rect: CGRect) {
        if let insets = padding {
            
            self.drawText(in: UIEdgeInsetsInsetRect(rect, insets))
        } else {
            self.drawText(in: rect)
        }
    }
    
    override open var intrinsicContentSize: CGSize {
        get {
            var contentSize = super.intrinsicContentSize
            if let insets = padding {
                contentSize.height += insets.top + insets.bottom
                contentSize.width += insets.left + insets.right
            }
            return contentSize
        }
    }
    
    var optimalLabelHeight : CGFloat {
        get
        {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.width, height: CGFloat.greatestFiniteMagnitude))
            label.font = self.font
            label.text = self.text
            label.numberOfLines = 0
            label.lineBreakMode = NSLineBreakMode.byTruncatingTail
            label.sizeToFit()
            return label.frame.height + 20
        }
        
    }
}

//MARK:- Toast Structure
struct ToastMessage {
    
    static func showToast(in vc: UIViewController, message: String) {
        /*let toastLabel = UILabel(frame: CGRect(x: vc.view.frame.size.width / 2 - 150,
                                               y: vc.view.frame.size.height - 100,
                                               width: 300,
                                               height: 40))*/
        let lbl = UILabel()
        lbl.text = message
        
        let lblHeight = lbl.optimalLabelHeight
        print("lblheight ",lblHeight)
        
        let viewToast = UIView(frame: CGRect(x: 16,
                                             y: vc.view.frame.size.height - 100,
                                             width: vc.view.frame.size.width - 32,
                                             height: lblHeight + 10))
        viewToast.backgroundColor = UIColor.white
        viewToast.layer.cornerRadius = 10
        vc.view.addSubview(viewToast)
        
        let toastLabel = UILabel(frame: CGRect(x: 5,
                                               y: 5,
                                               width: viewToast.frame.size.width - 10,
                                               height: lblHeight))
        /*let toastLabel = UILabel(frame: CGRect(x: 16,
                                               y: vc.view.frame.size.height - 100,
                                               width: vc.view.frame.size.width - 32,
                                               height: lblHeight))*/
//        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.9)
        toastLabel.textColor = UIColor.black
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.systemFont(ofSize: 15.0) //UIFont(name: "Mark Pro", size: 15.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
//        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds = true
        toastLabel.numberOfLines = 0
        toastLabel.lineBreakMode = NSLineBreakMode.byTruncatingTail
        toastLabel.sizeToFit()
       
        toastLabel.padding = UIEdgeInsets(top: 15, left: 15, bottom: 10, right: 15)
        viewToast.addSubview(toastLabel)
//        vc.view.addSubview(toastLabel)
        UIView.animate(withDuration: 1, delay: 1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0
            viewToast.alpha = 0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
            viewToast.removeFromSuperview()
        })
    }
}
