//
//  ResultViewController.swift
//  Nasa
//
//  Created by Ozan Salman on 24.07.2022.
//

import UIKit

class ResultViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var pageIndex: Int!
    let webService = WebService()
    var model: NasaModel?
    var itemsArray = [String]()
    var loadingView: LoadingReusableView?
    var isLoading = false
    var roverName = String()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        let itemCellNib = UINib(nibName: "CollectionViewItemCell", bundle: nil)
        self.collectionView.register(itemCellNib, forCellWithReuseIdentifier: "collectionviewitemcellid")
        
        let loadingReusableNib = UINib(nibName: "LoadingReusableView", bundle: nil)
        collectionView.register(loadingReusableNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "loadingresuableviewid")

        webService.getRoverData(roverName: self.getRoverName(), camera: "") { (NasaModel) in
            self.model = NasaModel
            self.loadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(singlePickerSelect), name: Notification.Name("singlePickerSelect"), object: nil)
    }
    
    
    @IBAction func filteredButtonClicked(_ sender: Any) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "PickerViewNavId") as! PickerViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @objc func singlePickerSelect() {
        self.itemsArray.removeAll()
        collectionView.reloadData()
        webService.getRoverData(roverName: self.getRoverName(), camera: Const.singlePicker.selectValue.selectedValue) { (NasaModel) in
            if NasaModel.photos.count > 0 {
                self.model = NasaModel
                self.itemsArray.removeAll()
                self.loadData()
            } else {
                let alert = UIAlertController(title: "Uyarı", message: "Seçtiğiniz kamera bu araçta aktif değildir", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Tamam", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func loadData() {
        isLoading = false
        collectionView.collectionViewLayout.invalidateLayout()
        for i in 0...0 {
            itemsArray.append((model?.photos[i].imgSrc) ?? "")
        }
        self.collectionView.reloadData()
    }

    func getRoverName() -> String {
        if pageIndex == 0 {
            return "Curiosity"
        } else if pageIndex == 1 {
            return "Opportunity"
        } else {
            return "Spirit"
        }
    }
}

extension ResultViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsArray.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionviewitemcellid", for: indexPath) as! CollectionViewItemCell
        cell.imageView.contentMode = .scaleToFill
        let url = URL(string: itemsArray[indexPath.row])
        let data = try? Data(contentsOf: url!)
        if let imageData = data {
            cell.imageView.image = UIImage(data: imageData)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "DetailPopUpNavId") as! DetailPopUp
        vc.chosenModel = model?.photos[indexPath.row]
        self.present(vc, animated: true, completion: nil)
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == itemsArray.count - 1, !self.isLoading {
            loadMoreData()
        }
    }

    func loadMoreData() {
        if !self.isLoading {
            self.isLoading = true
            let start = itemsArray.count
            let end = start
            if model?.photos.count ?? 0 > itemsArray.count {
                DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)) { // Remove the 1-second delay if you want to load the data without waiting
                    for i in start...end {
                        self.itemsArray.append((self.model?.photos[i].imgSrc)!)
                    }
                    DispatchQueue.main.async {
                        self.collectionView.reloadData()
                        self.isLoading = false
                    }
                }
            }
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        if self.isLoading {
            return CGSize.zero
        } else {
            return CGSize(width: collectionView.bounds.size.width, height: 100)
        }
    }

    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let aFooterView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "loadingresuableviewid", for: indexPath) as! LoadingReusableView
            loadingView = aFooterView
            loadingView?.backgroundColor = UIColor.clear
            return aFooterView
        }
        return UICollectionReusableView()
    }

    func collectionView(_ collectionView: UICollectionView, willDisplaySupplementaryView view: UICollectionReusableView, forElementKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.startAnimating()
        }
    }

    func collectionView(_ collectionView: UICollectionView, didEndDisplayingSupplementaryView view: UICollectionReusableView, forElementOfKind elementKind: String, at indexPath: IndexPath) {
        if elementKind == UICollectionView.elementKindSectionFooter {
            self.loadingView?.activityIndicator.stopAnimating()
        }
    }
}
