//
//  DistanceTableViewCell.swift
//  Trough
//
//  Created by Irfan Malik on 05/01/2021.
//

import UIKit
import RangeSeekSlider
protocol DistanceTableViewCellDelagate: AnyObject {
    func selectedRadius(min: Int,max:Int)
}

class DistanceTableViewCell: UITableViewCell,RangeSeekSliderDelegate {

    @IBOutlet weak var distanceRangeSlider: RangeSeekSlider!
    var delegate:DistanceTableViewCellDelagate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.distanceRangeSlider.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func didEndTouches(in slider: RangeSeekSlider) {
        self.delegate?.selectedRadius(min: Int(self.distanceRangeSlider.selectedMinValue), max: Int(self.distanceRangeSlider.selectedMaxValue))
    }
    
    func config(){
        self.distanceRangeSlider.selectedMaxValue = 25
    }
    
}
