//
//  CommentTableViewCell.swift
//  Trough
//
//  Created by Imed on 25/10/2021.
//

import UIKit

protocol CommentTableViewCellDelgate {
    func pleaseReloadSection(index: Int)
    func buttonTapped(cell: UITableViewCell)
//    func commentActionPerform(index: Int, btnTitle: String, complete:@escaping((_ success: Bool)->Void))
}

class CommentTableViewCell: UITableViewCell{
  
    
//    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var tableViewHeigthConstraint: NSLayoutConstraint!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var commentDateLAbel: UILabel!
    @IBOutlet weak var commentImageView: UIImageView!
    
    @IBOutlet weak var commentLikeImageView: UIImageView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var checkbutton: UIButton!
    @IBOutlet weak var commentLikeCountLabel: UILabel!
    @IBOutlet weak var likedButtonImageView: UIImageView!
    
    var comments = [CommentViewModel]()
    var replies = commentModel()
    var pos = -1
    var index = -1
    var delegate : CommentTableViewCellDelgate?
    
    var onInvite: (() -> Void)?
    var onLike : (()-> Void)?

//    var buttonAction: ((_ sender: AnyObject) -> Void)?

    override func awakeFromNib() {
        super.awakeFromNib()
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
//        self.tableView.register(UINib(nibName: "RepliesTableViewCell", bundle: nil), forCellReuseIdentifier: "RepliesTableViewCell")
//        self.tableView.register(UINib(nibName: "SeeReplyTableViewCell", bundle: nil), forCellReuseIdentifier: "SeeReplyTableViewCell")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    func configureDate(data:CommentViewModel){
//        self.commentLabel.text = "\(data.comment ?? "")"
//        self.userNameLabel.text = "\(data.fullName ?? "")"
//        self.commentDateLAbel.text = "\(String(describing: data.createdDate?.date(with: .DATE_TIME_FORMAT_ISO8601)?.getPastTime()))"
        
        self.commentLikeCountLabel.text = "\(data.commentLikeCount ?? 0)"
        
        if data.isCommentLiked ?? false{
//        if data.isCommentLiked == true{
            self.likedButtonImageView.image = UIImage(named: "likedButton")
        }else{
            self.likedButtonImageView.image = UIImage(named: "likeButton")
        }
        
//        if data.profileUrl != "" && data.profileUrl != nil{
//            let url = URL(string: BASE_URL+data.profileUrl!) ?? URL.init(string: "https://www.google.com")!
//            self.commentImageView.setImage(url: url)
//        }else{
//            self.commentImageView.image = UIImage(named: "PlaceHolder2")
//
//        }
        
        if data.profileUrl != "" && data.profileUrl != nil{
            if let url = URL(string: data.profileUrl   ?? "") {
                DispatchQueue.main.async {
                    self.commentImageView.setImage(url: url)
                }
            }
        }else{
            self.commentImageView.image = UIImage(named: "PlaceHolder2")
        }
        
    }
    func config(reples:commentModel){
        self.replies = reples
//        self.tableView.reloadData()
    }
    @IBAction func actiionButton(_ sender: UIButton) {
//        if sender.isSelected == false {
//            sender.isSelected = true
//        } else {
//           sender.isSelected = false
//        }
        onLike?()
//        self.delegate?.buttonTapped(cell: self)
//        self.buttonAction?(sender)

    }
    
    @IBAction func replybutton(_ sender: Any) {
        onInvite?()
    }
    
}
//extension CommentTableViewCell: UITableViewDelegate,UITableViewDataSource{
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

extension CommentTableViewCell: SeeReplyTableViewCellDelegate{
    func seeMorePressed(index: Int) {
        self.replies.isSeeMore = true
        self.delegate?.pleaseReloadSection(index: pos)
       // self.tableView.reloadData()
    }
}


