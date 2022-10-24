//
//  BrowserCategoriesViewController.swift
//  Trough
//
//  Created by Imed on 15/09/2021.
//

import UIKit

class BrowserCategoriesViewController: BaseViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
//    var imagesArray = [#imageLiteral(resourceName: "Pizza.png"),#imageLiteral(resourceName: "Chinese.png"),#imageLiteral(resourceName: "Fast Food.png"),#imageLiteral(resourceName: "sushi.png"),#imageLiteral(resourceName: "foodre.png"),#imageLiteral(resourceName: "chief"),#imageLiteral(resourceName: "Top Eats.png"),#imageLiteral(resourceName: "Burgers.png"),#imageLiteral(resourceName: "Mexican.png"),#imageLiteral(resourceName: "Asain.png")]
//    var imagesTwoArray = [#imageLiteral(resourceName: "Desserts.png"),#imageLiteral(resourceName: "Italian.png"),#imageLiteral(resourceName: "Healthy.png"),#imageLiteral(resourceName: "amrecian.png"),#imageLiteral(resourceName: "Indian.png"),#imageLiteral(resourceName: "Thai.png"),#imageLiteral(resourceName: "pasta.png"),#imageLiteral(resourceName: "\"Ice Cream.png"),#imageLiteral(resourceName: "pngegg.png"),#imageLiteral(resourceName: "pngegg (1).png"),#imageLiteral(resourceName: "pngegg (2).png"),#imageLiteral(resourceName: "pngegg (3).png"),#imageLiteral(resourceName: "pngegg (4).png"),#imageLiteral(resourceName: "pngegg (5).png"),#imageLiteral(resourceName: "pngegg (6).png"),#imageLiteral(resourceName: "pngegg (7).png"),#imageLiteral(resourceName: "pngegg (9).png"),#imageLiteral(resourceName: "pngegg (10).png"),#imageLiteral(resourceName: "pngegg (11).png"),#imageLiteral(resourceName: "pngegg (12).png"),#imageLiteral(resourceName: "pngegg (13).png"),#imageLiteral(resourceName: "pngegg (14).png"),#imageLiteral(resourceName: "pngegg (15).png"),#imageLiteral(resourceName: "pngegg (16).png"),#imageLiteral(resourceName: "pngegg (8).png")]
//
//    var combineArray : NSMutableArray!
//    var sectionArray = ["Top Categories", "More Categories"]
//
//    var topArray = ["Pizza","Chinese","Fast Food","Sushi","Deals","Resturant Rewards","Top Eats","Burgers","Mexican","Asain"]
//    var moreArray = ["Desserts","Italian","Healthy","American","Indian","Thai","Pasta","Ice Cream","Sandwich","Comfort Food","SeaFood","BBQ","Salads","Japanese","Deli","Frozen Yogurt","BreakFast and Brunch","Latin American","Juice and Smoothies","Coffee & Tea","Convenience","Vegan","Caribbean","Pakistani","Chicken"]
    
    var selectedCategories = [CategoriesViewModel]()
    var searchCategory = [CategoriesViewModel]()
    
    private let minItemSpacing: CGFloat = 10
    private let itemWidth: CGFloat      = 170
    
//    private let headerHeight: CGFloat   = 140

    override func viewDidLoad() {
        super.viewDidLoad()
//        combineArray = NSMutableArray(array: [imagesArray, imagesTwoArray])
        self.getCategoriesList()

    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        // Create our custom flow layout that evenly space out the items, and have them in the center
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: itemWidth, height: itemWidth)
        layout.minimumInteritemSpacing = minItemSpacing
        layout.minimumLineSpacing = minItemSpacing
        
//        layout.headerReferenceSize = CGSize(width: 0, height: headerHeight)

        // Find n, where n is the number of item that can fit into the collection view
        
        var n: CGFloat = 1
        let containerWidth = collectionView.bounds.width
        while true {
            let nextN = n + 1
            let totalWidth = (nextN*itemWidth) + (nextN-1)*minItemSpacing
            if totalWidth > containerWidth {
                break
            } else {
                n = nextN
            }
        }
        
        // Calculate the section inset for left and right.
        // Setting this section inset will manipulate the items such that they will all be aligned horizontally center.
        
        let inset = max(minItemSpacing, floor( (containerWidth - (n*itemWidth) - (n-1)*minItemSpacing) / 3 ) )
        layout.sectionInset = UIEdgeInsets(top: minItemSpacing, left: inset, bottom: minItemSpacing, right: inset)

        collectionView.collectionViewLayout = layout

    }
    
    
    @IBAction func actiionNotification(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "NotificationsViewController") as?         NotificationsViewController{
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func actionSearch(_ sender: UITextField) {
        if sender.text == "" {
            selectedCategories  = searchCategory
        }else {
            selectedCategories  = searchCategory.filter({ (data) -> Bool in
                return   (data.name?.lowercased().contains(sender.text?.lowercased() ?? ""))!
            })
        }
        collectionView.reloadData()
    }
    
}
    
extension BrowserCategoriesViewController : UICollectionViewDelegate , UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return categoryNameArray.count
        return selectedCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CategoriesCollectionViewCell
//        cell.nameLabel.text = categoryNameArray[indexPath.row]
//        cell.categoryImage?.image = categoryImageArray[indexPath.row]
        let item = self.selectedCategories[indexPath.row]
        cell.configure(getCategories: item)
        return cell
    }
            func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                let vc = self.storyboard?.instantiateViewController(identifier: "SelectedCategoryListViewController") as! SelectedCategoryListViewController
    
                vc.text = selectedCategories[indexPath.row].name ?? ""
                vc.categoryID = selectedCategories[indexPath.row].categoryId ?? 0
                self.navigationController?.pushViewController(vc, animated: true)
            }
}


extension BrowserCategoriesViewController{
    //GetFoodCategories
    func getCategoriesList(){
        
        var params: [String:Any] = [String:Any]()
        params = [:] as [String : Any]
        
        let service = UserServices()
        GCD.async(.Main) {
        }
        GCD.async(.Default) {
            
            service.GetFoodCategories(params: params) { (serviceResponse) in
                GCD.async(.Main) {
                }
                switch serviceResponse.serviceResponseType {
                case .Success :
                    GCD.async(.Main) {
                        
                        if let categoriesList = serviceResponse.data as? [CategoriesViewModel] {
                            self.selectedCategories = categoriesList
                            self.selectedCategories.sort(){
                                $0.name ?? ""  < $1.name ?? ""
                            }
                            self.searchCategory = self.selectedCategories
                            
                            self.collectionView.reloadData()

                            print("------")
                        }
                        else {
                            print("No Item Found!")
                        }
                    }
                case .Failure :
                    GCD.async(.Main) {
                        print("No Item Found!!!")
                    }
                default :
                    GCD.async(.Main) {
                        print("No Item Found!!")
                    }
                }
            }
        }
    }
}
