//
//  SelfSizingTableView.swift
//  Redhanded
//
//  Created by Majid Hussain on 3/29/21.
//

import UIKit

class SelfSizingTableView: UITableView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func reloadData() {
        super.reloadData()
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
    }
    
    override func reloadSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) {
        super.reloadSections(sections, with: animation)
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }
    
    override func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        super.insertRows(at: indexPaths, with: animation)
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }
    
    override func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        super.deleteRows(at: indexPaths, with: animation)
        self.invalidateIntrinsicContentSize()
        self.layoutIfNeeded()
    }
    
    override var intrinsicContentSize: CGSize {
        setNeedsLayout()
        layoutIfNeeded()
        return CGSize(width: contentSize.width, height: contentSize.height)
    }

}

extension UITableView {

    func isCellVisible(section: Int, row: Int) -> Bool {
        guard let indexes = self.indexPathsForVisibleRows else {
            return false
        }
        return indexes.contains{ $0.section == section && $0.row == row }
    }
    
    func refreshHeaderTitle(inSection section: Int) {
        UIView.setAnimationsEnabled(false)
        beginUpdates()

        let headerView = self.headerView(forSection: section)
        headerView?.textLabel?.text = self.dataSource?.tableView?(self, titleForHeaderInSection: section)?.uppercased()
        headerView?.sizeToFit()

        endUpdates()
        UIView.setAnimationsEnabled(true)
    }

    func refreshFooterTitle(inSection section: Int) {
        UIView.setAnimationsEnabled(false)
        beginUpdates()

        let footerView = self.footerView(forSection: section)
        footerView?.textLabel?.text = self.dataSource?.tableView?(self, titleForFooterInSection: section)
        footerView?.sizeToFit()

        endUpdates()
        UIView.setAnimationsEnabled(true)
    }
    
    func refreshFooter(inSection section: Int, isHidden: Bool) {
        UIView.setAnimationsEnabled(false)
        beginUpdates()

        let footerView = self.footerView(forSection: section)
        footerView?.sizeToFit()
        footerView?.isHidden = isHidden
        
        endUpdates()
        UIView.setAnimationsEnabled(true)
    }

    func refreshAllHeaderAndFooterTitles() {
        for section in 0..<self.numberOfSections {
            refreshHeaderTitle(inSection: section)
            refreshFooterTitle(inSection: section)
        }
    }
}
