//
//  EventSlotsTableViewCell.swift
//  Trough
//
//  Created by Irfan Malik on 05/01/2021.
//

import UIKit
//protocol EventSlotsTableViewCellDelegate:AnyObject {
//    func slotSelected(index:Int)
//}

class EventSlotsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var collectionView: UICollectionView!
    var selectedIndex = -1
//    var slots = [WorkHours]()
    var slots = [String]()
//    weak var delegate:EventSlotsTableViewCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib.init(nibName: "EventSlotCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EventSlotCollectionViewCell")
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    func config(slots:[String],isClear:Bool){
        
//        self.slots = Global.shared.truckTimeSlot
        self.slots = slots
        if isClear{
            self.selectedIndex = -1
        }
        self.collectionView.reloadData()
    }
}
extension EventSlotsTableViewCell:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.slots.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collectionView.dequeueReusableCell(withReuseIdentifier: "EventSlotCollectionViewCell", for: indexPath) as! EventSlotCollectionViewCell
//        cell.ratingLabel.text = "\(self.slots[indexPath.row].startTime ?? "") - \(self.slots[indexPath.row].endTime ?? "")"
        cell.eventTimeLabel.text = self.slots[indexPath.row]
        if indexPath.row == self.selectedIndex{
            cell.eventBackView.backgroundColor = UIColor.init(hexString: "#EDBB6E")
            cell.eventTimeLabel.textColor = UIColor.white
        }else{
            cell.eventBackView.backgroundColor = UIColor.white
            cell.eventTimeLabel.textColor = UIColor.init(hexString: "#EDBB6E")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectedIndex = indexPath.row
//        self.delegate?.slotSelected(index: self.selectedIndex)
        self.collectionView.reloadData()
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.frame.size.width/2, height: 40)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 5, bottom: 0, right: 5)
    }
}
