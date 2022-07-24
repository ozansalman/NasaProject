//
//  LoadingReusableView.swift
//  Nasa
//
//  Created by Ozan Salman on 24.07.2022.
//

import UIKit

class LoadingReusableView: UICollectionReusableView {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        activityIndicator.color = UIColor.white
    }
    
}
