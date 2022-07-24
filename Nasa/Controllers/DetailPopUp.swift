//
//  DetailPopUp.swift
//  Nasa
//
//  Created by Ozan Salman on 24.07.2022.
//

import UIKit

class DetailPopUp: UIViewController {

    @IBOutlet weak var viewMain: UIView!
    @IBOutlet weak var chooseLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var photoDate: UILabel!
    @IBOutlet weak var roverName: UILabel!
    @IBOutlet weak var cameraName: UILabel!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var launchDate: UILabel!
    @IBOutlet weak var landingDate: UILabel!
    
    var chosenModel: NasaModel.Photo?
    let const = Const()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        const.viewMainCustomWithShadow(view: viewMain)
        
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(choseLabelTapped))
        chooseLabel.isUserInteractionEnabled = true
        chooseLabel.addGestureRecognizer(tapGestureRecognizer)
        
        
        imageView.contentMode = .scaleToFill
        let url = URL(string: chosenModel!.imgSrc)
        let data = try? Data(contentsOf: url!)
        if let imageData = data {
            imageView.image = UIImage(data: imageData)
        }
        
        photoDate.text = "Çekim Tarihi : \(chosenModel?.earthDate ?? "")"
        roverName.text = "Araç Adı : \(chosenModel?.rover.name ?? "")"
        cameraName.text = "Kamera Adı : \(chosenModel?.camera.name ?? "")"
        status.text = "Görev Durumu : \(chosenModel?.rover.status ?? "")"
        launchDate.text = "Fırlatma Tarihi : \(chosenModel?.rover.launchDate ?? "")"
        landingDate.text = "İniş Tarihi : \(chosenModel?.rover.landingDate ?? "")"
        
    
    }
    
    @objc func choseLabelTapped() {
        dismiss(animated: true, completion: nil)
    }

}
