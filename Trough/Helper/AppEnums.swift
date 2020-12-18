//
//  AppEnum.swift
//  Trough
//
//  Created by Irfan Malik on 17/12/2020.
//

import Foundation
enum NavigationController {
    case ServiceProviderNavigationController
    var rawValue : String {
        switch self {
        case .ServiceProviderNavigationController:
            return  "ServiceProviderNavigationController"
        }
    }
}
enum StoryBoard {
    case Main
    
    var rawValue : String {
        switch self {
        case .Main:
            return "Main"
        }
    }
}
enum TableViewCell {
    case ServiceProvidersTableViewCell
    var rawValue : String {
        switch self {
        case .ServiceProvidersTableViewCell:
            return "ServiceProvidersTableViewCell"
        }
    }
}
enum CollectionViewCell {
    case ServicesCollectionViewCell
    var rawValue : String {
        switch self {
        case .ServicesCollectionViewCell:
            return "ServicesCollectionViewCell"
        }
    }
}
enum ViewControllers {
    case ProvidersListViewController
    var rawValue : String {
        switch self {
        case .ProvidersListViewController:
            return "ProvidersListViewController"
        }
    }
}
