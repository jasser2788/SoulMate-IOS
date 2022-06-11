//
//  ObservableObject.swift
//  miniprojet
//
//  Created by Mac2021 on 12/4/2022.
//

import Foundation
import UIKit
class ObservableObject<T>{
    var value: T? {
        didSet{
            listener?(value)
        }
    }
    init(_ value: T?){
        self.value = value
    }
    private var listener: ((T?) -> Void)?
    
    func bind(_ listener: @escaping (T?) -> Void) {
        listener(value)
        self.listener = listener
    }
}

