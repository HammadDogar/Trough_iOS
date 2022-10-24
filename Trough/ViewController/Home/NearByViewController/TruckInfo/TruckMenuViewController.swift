//
//  TruckMenuViewController.swift
//  Trough
//
//  Created by Macbook on 30/03/2021.
//

import UIKit
import MaterialComponents.MaterialBottomSheet

class TruckMenuViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource {
    
    //    var truckId = 0
    //    var eventId = 0
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var menuChange: UISegmentedControl!
    @IBOutlet weak var cartView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var noResultLabel: UILabel!
    @IBOutlet weak var cartButton: UIButton!
    
    var truckMenu = [TruckMenuViewModel]()
    var dealMenu = [MenuCategoryViewModel]()
    var regularMenu = [MenuCategoryViewModel]()
    var selectedMenu = [MenuCategoryViewModel]()
    //    var truckId:String = ""
    var id = 0
    var evntId = 0
    var cartMenu = [GetCartDetails]()

    var event :EventViewModel?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        self.noResultLabel.isHidden = true

        selectedMenu = dealMenu
        
        
        if cartMenu.count > 0 {
            self.cartView.isHidden = false
        }else{
            self.cartView.isHidden = true
        }
//        self.cartView.isHidden = false
        tableView.reloadData()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getTruckMenuList()
        
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Show the navigation bar on other view controllers
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    
    @IBAction func backButton(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func menuChange(_ sender: UISegmentedControl) {
        
        switch sender.selectedSegmentIndex {
        case 0:
            selectedMenu = dealMenu
        case 1:
            selectedMenu = regularMenu
        //        case 2:
        //            selectedMenu = regularMenu
        default:
            print("----------------")
        }
        
        tableView.reloadData()
    }
    
    @IBAction func cartButton(_ sender: UIButton) {
    
        let sb = UIStoryboard(name: "Cart", bundle: nil)
        if #available(iOS 13.0, *) {
            let vc = sb.instantiateViewController(identifier: "NewCartViewController") as! NewCartViewController
            let navVc = UINavigationController(rootViewController: vc)
            let bottomSheet: MDCBottomSheetController = MDCBottomSheetController(contentViewController: navVc)
            bottomSheet.trackingScrollView = vc.tableView
            bottomSheet.preferredContentSize = CGSize(width: self.view.frame.size.width, height: self.view.frame.size.height / 1.5)
            vc.delagte = self
            vc.evntId = self.evntId
            print(vc.evntId)
            vc.event = self.event

            
            present(bottomSheet, animated: true, completion: nil)

//            self.navigationController?.pushViewController(bottomSheet, animated: true)
//            self.navigationController?.pushViewController( vc, animated: true)

        } else {
            // Fallback on earlier versions
        }
    }

    func getTruckMenuList(){
        
        var params: [String:Any] = [String:Any]()
        //        params = [
        //            :
        //        ]
        //        params = (["truckId" : truckId]) as [String : Any]
        params = (["truckId" : id]) as [String : Any]
        
        let service = UserServices()
        print(params)
        GCD.async(.Main) {
            self.startActivityWithMessage(msg: "")
        }
        GCD.async(.Default) {
            service.GetTruckMenu(params: params, truckId: Int(self.id)) { (serviceResponse) in
                
                //            service.GetTruckMenu(params: params, truckId: Int(47)) { (serviceResponse) in
                GCD.async(.Main) {
                    self.stopActivity()
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        if let Menu = serviceResponse.data as? [TruckMenuViewModel] {
                            self.truckMenu = Menu
                            self.regularMenu.removeAll()
                            self.dealMenu.removeAll()
                            //                            self.fastMenu.removeAll()
                            for category in Menu[0].categories!{
                                
                                if category.typeId == 9{
                                    self.regularMenu.append(category)
                                    print("Regular")
                                    
                                }
                                else {
                                    print("Deal")
                                    self.dealMenu.append(category)
                                    self.selectedMenu = self.dealMenu
                                }
                            }
                            self.tableView.reloadData()
                            print("done")
                        }
                        else {
                            print("No Deal Found!")
                        }
                    }
                case .Failure :
                    GCD.async(.Main) {
                        print("No Deal Found!")
                    }
                default :
                    GCD.async(.Main) {
                        print("No Deal Found!")
                    }
                }
            }
        }
    }
    
}

extension TruckMenuViewController{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if selectedMenu.count > 0 {
            self.noResultLabel.isHidden = true
            return self.selectedMenu.count
        }
        else {
            self.noResultLabel.isHidden = false
        }
        
        return selectedMenu.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! TruckMenuTableViewCell
        let dish = selectedMenu[indexPath.row]
        cell.delegate = self
        cell.setUpData(dish: dish)
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
            
            let label = UILabel()
            label.frame = CGRect.init(x: 20, y: 5, width: headerView.frame.width-10, height: headerView.frame.height-10)
            label.text = "Popular items"
            label.font = .boldSystemFont(ofSize: 20)
        headerView.addSubview(label)
            return headerView
        }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 50
        }
}

extension TruckMenuViewController:AddToCartBtnClickDelegate{
    func actionAddtoCartBtn(menu: MenuCategoryViewModel, eventTruckID: NearbyTrucksViewModel, eventId: EventViewModel) {
        
        
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "TruckMenuDetailViewController") as? TruckMenuDetailViewController{
            vc.menu = menu
            //            vc.eventId = eventId.eventId ?? 0
            //            vc.truckId = eventTruckID.truckId ?? 0
            //            vc.evntId = eventId.eventId ?? 0
            //            vc.id = eventTruckID.truckId ?? 0
            vc.evntId = evntId
            vc.id = id
            vc.delegate = self
            print(vc.evntId)
            print(vc.id)
            self.navigationController?.pushViewController(vc, animated: true)
//            self.cartView.isHidden = false
        }
    }
    
    //    func actionAddtoCartBtn(menu: MenuCategoryViewModel) {
    //
    //        if let vc = storyboard?.instantiateViewController(withIdentifier: "TruckMenuDetailViewController") as? TruckMenuDetailViewController{
    //
    //            vc.menu = menu
    //
    //            self.navigationController?.pushViewController(vc, animated: true)
    //        }
    //    }
    
}
extension TruckMenuViewController : CartViewDelgate, MenuDetialDelegate{
    
    func didTapCartButton(tapped: Bool) {
        self.cartView.isHidden = false
    }
    
    func didTapButton(cartID: [GetCartDetails]) {
                let sb = UIStoryboard(name: "Cart", bundle: nil)
                if #available(iOS 13.0, *) {
                    let vc = sb.instantiateViewController(identifier: "ConfirmPaymentViewController") as! ConfirmPaymentViewController
                    vc.cart = cartID
                    vc.id = self.id
                    vc.evntId = self.evntId
                    print(vc.evntId)
                    vc.event = self.event
                    present(vc, animated: true, completion: nil)
                    self.navigationController?.pushViewController( vc, animated: true)
                } else {
                    // Fallback on earlier versions
                }
    }
    
}
