//
//  NibLoadableView.swift
//  Unsplash
//
//  Created by Yura Voevodin on 13.11.2019.
//  Copyright © 2019 Yura Voevodin. All rights reserved.
//

import UIKit

protocol NibLoadableView: class { }

extension NibLoadableView where Self: UIView {
  
  static var nibName: String {
    return String(describing: self)
  }
}
