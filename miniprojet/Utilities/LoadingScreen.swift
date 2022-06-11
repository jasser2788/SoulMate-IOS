//
//  LoadingScreen.swift
//  miniprojet
//
//  Created by iMac on 19/4/2022.
//

import Foundation
import UIKit

class SpinnerViewController: UIViewController {
    var spinner = UIActivityIndicatorView(style: .large)
  


    override func loadView() {
        spinner.color = UIColor.mycolor2
        view = UIView()
        view.backgroundColor = UIColor(white: 1, alpha: 0.7)

        spinner.translatesAutoresizingMaskIntoConstraints = false
        spinner.startAnimating()
        view.addSubview(spinner)

        spinner.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        spinner.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
