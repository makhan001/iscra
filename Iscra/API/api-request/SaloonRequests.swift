//
//  SaloonRequests.swift
//  ScarlettUser
//
//  Created by Mohd Ali Khan on 06/03/21.
//

import Foundation

//struct SaloonRequests:RequestRepresentable {
//    
//    var saloonList: SaloonParams.SaloonList?
//    var saloonDetail: SaloonParams.SaloonDetail?
//    var saloonServices: SaloonParams.SaloonServices?
//    var addReview: SaloonParams.AddReview?
//    var reviews: SaloonParams.SaloonReviews?
//    var gallery: SaloonParams.Gallery?
//    var like: SaloonParams.Like?
//    var employeeList: SaloonParams.EmployeeList?
//    var bookAppointment : SaloonParams.BookAppointment?
//    var myBooking: SaloonParams.MyBooking?
//    var favoriteList: SaloonParams.FavoriteList?
//    var createCustomer: SaloonParams.CreateCustomer?
//    var addCard: SaloonParams.AddCard?
//    var filterSaloon: SaloonParams.FilterSaloon?
//    
//    let requestType: RequestType
//    enum RequestType {
//        case saloonList
//        case saloonDetail
//        case saloonServices
//        case addReview
//        case saloonReviews
//        case userReviews
//        case gallery
//        case like
//        case employeeList
//        case bookAppointment
//        case myBooking
//        case favoriteList
//        case cards
//        case createCustomer
//        case addCard
//        case filterSaloon
//    }
//    
//    init(requestType: RequestType) {
//        self.requestType = requestType
//    }
//    
//    init(type: RequestType, params:Codable) {
//        self.requestType = type
//        switch params {
//        case is SaloonParams.SaloonList:
//            self.saloonList = params as? SaloonParams.SaloonList
//        case is SaloonParams.SaloonDetail:
//            self.saloonDetail = params as? SaloonParams.SaloonDetail
//        case is SaloonParams.SaloonServices:
//            self.saloonServices = params as? SaloonParams.SaloonServices
//        case is SaloonParams.SaloonReviews:
//            self.reviews = params as? SaloonParams.SaloonReviews
//        case is SaloonParams.AddReview:
//            self.addReview = params as? SaloonParams.AddReview
//        case is SaloonParams.Gallery:
//            self.gallery = params as? SaloonParams.Gallery
//        case is SaloonParams.Like:
//            self.like = params as? SaloonParams.Like
//        case is SaloonParams.EmployeeList:
//            self.employeeList = params as? SaloonParams.EmployeeList
//        case is SaloonParams.BookAppointment:
//            self.bookAppointment = params as? SaloonParams.BookAppointment
//        case is SaloonParams.MyBooking:
//            self.myBooking = params as? SaloonParams.MyBooking
//        case is SaloonParams.FavoriteList:
//            self.favoriteList = params as? SaloonParams.FavoriteList
//        case is SaloonParams.CreateCustomer:
//            self.createCustomer = params as? SaloonParams.CreateCustomer
//        case is SaloonParams.AddCard:
//            self.addCard = params as? SaloonParams.AddCard
//        case is SaloonParams.FilterSaloon:
//            self.filterSaloon = params as? SaloonParams.FilterSaloon
//        default:
//            break
//        }
//    }
//    
//    var method: HTTPMethod {
//        if requestType == .cards {
//            return .get
//        }
//        return .post
//    }
//    
//    var endpoint: String {
//        switch self.requestType {
//        case .saloonList:
//            return "users/dashboard"
//        case .saloonDetail:
//            return "users/saloon_detail"
//        case .saloonServices:
//            return "saloon/service_get"
//        case .saloonReviews:
//            return "saloon/review_get"
//        case .userReviews:
//            return "saloon/user_review_get"
//        case .addReview:
//            return "saloon/rating_add"
//        case .gallery:
//            return "saloon/assets_get"
//        case .like:
//            return "saloon/favorite"
//        case .employeeList:
//            return "employees/employee_list"
//        case .bookAppointment:
//            return "booking/add"
//        case .myBooking:
//            return "users/my_booking"
//        case .favoriteList:
//            return "saloon/favorite_list"
//        case .cards:
//            return "payment_stripe/getcard"
//        case .addCard:
//            return "payment_stripe/addcard"
//        case .createCustomer:
//            return "payment_stripe/createCustomer"
//        case .filterSaloon:
//            return "users/search"
//        }
//    }
//    
//    var parameters: Parameters {
//        switch self.requestType {
//        case .saloonList:
//            return .body(data: encodeBody(data: saloonList))
//        case .saloonDetail:
//            return .body(data: encodeBody(data: saloonDetail))
//        case .saloonServices:
//            return .body(data: encodeBody(data: saloonServices))
//        case .saloonReviews, .userReviews:
//            return .body(data: encodeBody(data: reviews))
//        case .addReview:
//            return .body(data: encodeBody(data: addReview))
//        case .gallery:
//            return .body(data: encodeBody(data: gallery))
//        case .like:
//            return .body(data: encodeBody(data: like))
//        case .employeeList:
//            return .body(data: encodeBody(data: employeeList))
//        case .bookAppointment:
//            return .body(data: encodeBody(data: bookAppointment))
//        case .myBooking:
//            return .body(data: encodeBody(data: myBooking))
//        case .favoriteList:
//            return .body(data: encodeBody(data: favoriteList))
//        case .addCard:
//            return .body(data: encodeBody(data: addCard))
//        case .createCustomer:
//            return .body(data: encodeBody(data: createCustomer))
//        case .filterSaloon:
//            return .body(data: encodeBody(data: filterSaloon))
//        
//        default:
//            return .none
//        }
//    }
//}
