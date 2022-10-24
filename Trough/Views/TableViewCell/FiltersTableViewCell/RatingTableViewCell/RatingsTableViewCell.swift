//
//  RatingsTableViewCell.swift
//  Trough
//
//  Created by Irfan Malik on 05/01/2021.
//

import UIKit

protocol  RatingsTableViewCellDelegate:AnyObject {
    func ratingSelected(index: Int)
}

class RatingsTableViewCell: UITableViewCell {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingImageView: UIImageView!

    var selectedIndex = -1
    var ratings = [String]()
    weak var delegate: RatingsTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib.init(nibName: "RatingCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "RatingCollectionViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func config(ratings:[String],isClear:Bool){
        self.ratings = ratings
        if isClear{
            self.selectedIndex = -1
        }
        self.collectionView.reloadData()
    }
}

extension RatingsTableViewCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.ratings.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "RatingCollectionViewCell", for: indexPath) as! RatingCollectionViewCell
        cell.ratingLabel.text = self.ratings[indexPath.row]
        if indexPath.row == self.selectedIndex{
            
            cell.ratingBackView.backgroundColor = UIColor.init(hexString: "#EEAD30")
            cell.ratingLabel.textColor = UIColor.white
        }else{
            cell.ratingBackView.backgroundColor = UIColor.white
            cell.ratingLabel.textColor = UIColor.init(hexString: "#EEAD30")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        self.selectedIndex = indexPath.row
        self.delegate?.ratingSelected(index: self.selectedIndex)
        self.collectionView.reloadData()
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width/3, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
}
