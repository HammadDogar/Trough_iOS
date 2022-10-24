//
//  EventTableViewCell.swift
//  traf
//
//  Created by Mateen Nawaz on 12/01/2021.
//

import UIKit
protocol EventCommentsTableViewCellDelegate {
    func pleaseReloadSection(index: Int)
//    func commentActionPerform(index: Int, btnTitle: String, complete:@escaping((_ success: Bool)->Void))
}

class EventCommentsTableViewCell: UITableViewCell {
  
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tableViewHeigthConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var commentDateLAbel: UILabel!
    @IBOutlet weak var commentImageView: UIImageView!
    
    @IBOutlet weak var commentLikeImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    
    var replies = commentModel()
    var pos = -1
    var delegate:EventCommentsTableViewCellDelegate?
    var index = -1

    override func awakeFromNib() {
        super.awakeFromNib()
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
//        self.tableView.register(UINib(nibName: "RepliesTableViewCell", bundle: nil), forCellReuseIdentifier: "RepliesTableViewCell")
//        self.tableView.register(UINib(nibName: "SeeReplyTableViewCell", bundle: nil), forCellReuseIdentifier: "SeeReplyTableViewCell")
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        
        super.setSelected(selected, animated: animated)
    }
    
    func config(reples:commentModel){
        self.replies = reples

        self.tableView.reloadData()
    }
    @IBAction func actionPrint(_ sender: UIButton) {
        print("something")
    }
    
    @IBAction func actionLikeComment(_ sender: UIButton) {
//        self.delegate?.commentActionPerform(index: self.index, btnTitle: "like"){(success) in
//            if success{
//            }
//        }
    }
}


//extension EventCommentsTableViewCell: UITableViewDelegate,UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        if !self.replies.isSeeMore && self.replies.replies.count > 0{
//            return 1
//
//        }
//        return self.replies.replies.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
//    UITableViewCell {
//        
//        if self.replies.isSeeMore{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "RepliesTableViewCell",for: indexPath) as! RepliesTableViewCell
//            cell.replyLabel.text = self.replies.replies[indexPath.row].comment
//           
//            return cell
//        }else{
//            let cell = tableView.dequeueReusableCell(withIdentifier: "SeeReplyTableViewCell",for: indexPath) as! SeeReplyTableViewCell
//            cell.index = self.replies.replies[indexPath.row].commentId!
//            cell.delegate = self
//
//        
//            return cell
//        }
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if self.replies.isSeeMore{
//            return 117
//        }else{
//            return 44
//        }
//    }
//    
//   // func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//    //}
//}
//
//extension EventCommentsTableViewCell: SeeReplyTableViewCellDelegate{
//    func seeMorePressed(index: Int) {
//        self.replies.isSeeMore = true
//        self.delegate?.pleaseReloadSection(index: pos)
//       // self.tableView.reloadData()
//    }
//}
//
