//
//  APIS.swift
//  Trough
//
//  Created by Irfan Malik on 17/12/2020.
//

import Foundation

//API MESSAGE
let STRING_SUCCESS = ""
let FAILED_MESSAGE = "Failed Please Try Again!"
let STRING_UNEXPECTED_ERROR = ""
let TIMEOUT_MESSAGE = "Request Time out"
let ERROR_NO_NETWORK = "Connection lost. Please check your internet connection and try again. "//"Internet connection is currently unavailable."

let USER_SUCCESS = "Success"
let USER_EMAIL_SUCCESS = "Email not exist"
let ADD_CUSTOMER_MESSAGE = "User added successfully !"
let PHONE_NUMBER_ALREADY_EXIST_MESSAGE = "Customer Already Exist With This Phone !"

let BASE_URL                          = "https://troughapi.azurewebsites.net"
let USER_LOGIN_URL                    = BASE_URL + "/api/Auth/Login"
let USER_LOGIN_With_OTHERS_URL        = BASE_URL + "/api/Users/SocialRegister"

let USER_REGISTRATION_URL             = BASE_URL + "/api/Users/Register"
let USER_DEVICE_TOKEN_URL             = BASE_URL + "/api/Notification/AddUpdateFcmDeviceToken"
let UPDATE_USER_PROFILE                = BASE_URL + "/api/Users/UpdateUserProfile"

let USER_NOTIFICATION_URL             = BASE_URL + "/api/Notification/GetALL"


let USER_EMAIL_EXISTS_URL             = BASE_URL + "/api/Users/IsEmailExist/"
let USER_FORGOT_PASSWORD_URL          = BASE_URL + "/api/Users/ForgotPassword"
let USER_PROFILE_IMAGE_UPLOAD_URL     = BASE_URL + "/api/Users/UploadFile"

let GET_EVENTS_LISTING_URL            = BASE_URL + "/api/Event/GetEvents"
let GET_ACTIVITY_LISTING_URL          = BASE_URL + "/api/Event/GetUserActivityOnEvents"

let EVENT_GOING_MAYBE_URL             = BASE_URL + "/api/Event/AddRemoveUserInEvent"
let NEW_OR_EDIT_EVENT_URL             = BASE_URL + "/api/Event/AddEditEvent"
let FOOD_CATEGORIES_LIST_URL          = BASE_URL + "/api/Category/GetAllCategories"
let GET_NEAR_BY_TRUCKS                = BASE_URL + "/api/FoodTruck/GetNearbyTrucks"
let INVITE_AND_UNINVITE_TRUCK_URL     = BASE_URL + "/api/Event/InviteUninviteTrucks"

let ADD_EDIT_COMMENT_LIKE_URL         = BASE_URL + "/api/Comments/AddEditCommentOrLike"

let GET_ALL_USER                      = BASE_URL + "/api/Users/GetAllUsers"

let RESET_PASSWORD_REQUEST = BASE_URL + "/api/Users/ResetPassword"

let GET_ALL_FRIEND = BASE_URL + "/api/Users/GetAllFriends"

let ADD_FRIEND_REQUEST = BASE_URL + "/api/Users/AddFriend"

let REMOVE_FRIEND_REQUEST = BASE_URL + "/api/Users/RemoveFriend"

let GET_USER_FAVOURITE_LOCATIONS = BASE_URL + "/api/UsersFavoriteLocation/GetAll"

//let ADD_EDIT_USER_FAVOURITE_LOCATION = BASE_URL + "/api/UsersFavoriteLocation/AddEdit"

let ADD_EDIT_USER_FAVOURITE_LOCATION = BASE_URL + "​/api/UsersFavoriteLocation/AddEditV2"

//Stripe Apis

let CREATE_STRIPE_CONNECT_ACCOUNT = BASE_URL + "/api/Payments/CreateStripeConnectAccount"

let CREATE_CUSTOMER_STRIPE_URL        = BASE_URL + "/api/Payments/CreateStripeCustomer"

let GET_ALL_PAYMENT_METHOD_URL        = BASE_URL + "/api/Payments/GetPaymentMethods"


let GET_USER_CART = BASE_URL + "/api/Orders/GetUserCart"

let PLACE_ORDER = BASE_URL + "/api/Orders/PlaceOrder"

let PLACE_PRE_ORDER = BASE_URL + "/api/Orders/PrePlaceOrder"


let ADD_TO_CART = BASE_URL + "/api/Orders/AddToCart"

let GET_ORDER_BY_USER = BASE_URL + "/api/Orders/GetOrdersByUser"

let GET_PRIVACY_AND_TERMS = BASE_URL + "/api/Privacy/GetPrivacyAndTerms"


///new
let GET_METHOD = "GET"
let POST_METHOD = "POST"

let  FOOD_CATEGORIES = BASE_URL + "/api/FoodTruckCategoreis/GetAllCategories"
let GET_FOOD_TRUCK_BY_CATEGORIES = BASE_URL + "/api/FoodTruck/GetTrucksByCategoryId"

let LIKE_COMMENT = BASE_URL + "/api/Comments/AddCommentLikes"

let GET_PRE_ORDER_BY_USER = BASE_URL + "/api/Orders/GetPreOrdersByUser"

let GET_ALL_FRIEND_REQUEST = BASE_URL + "/api/Users/GetFriendRequestReceived"
let ACCEPT_REJECT_FRIEND_REQUEST = BASE_URL + "/api/Users/AcceptOrRejectFriend"

let USER_WHO_ACCEPT = BASE_URL + "/api/Event/AcceptedInvitedEventTrucks"

let TRUCK_WHO_ACCEPT = BASE_URL + "/api/Event/GetAllAcceptedInvitionbyUser"

//Services Cites

let GET_SERVICES_CITES = BASE_URL + "/api/ServicesCity/GetServicesCity"
let ADD_SERVICES_CITES = BASE_URL + "/api/ServicesCity/AddServicesCityUser"
let REQUEST_CITY = BASE_URL + "/api/ServicesCity/ApprovalCities"
