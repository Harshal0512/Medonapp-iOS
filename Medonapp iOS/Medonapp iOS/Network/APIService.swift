//
//  APIService.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 25/10/22.
//

import Foundation
import Alamofire

class APIService : NSObject{
    
    enum services {
        case login, signUp, sendOtp, getAllDoctors, bookAppointment, postReview
        case getAppointmentsWithPatientID(Int)
        case getPatientWithID(Int)
        case addFavorite(Int)
        case removeFavorite(Int)
        case deleteReview(Int)
        case editFeedback(Int)
        case editAppointment(Int)
        
        var endpoint: String {
            switch self {
            case .login:
                return "auth/login"
            case .signUp:
                return "v1/patient/add"
            case .sendOtp:
                return "auth/otp"
            case .getAllDoctors:
                return "v1/doctor/all"
            case .getPatientWithID(let patientID):
                return "v1/patient/\(patientID)"
            case .bookAppointment:
                return "v1/appointment/add"
            case .postReview:
                return "v1/review/add"
            case .getAppointmentsWithPatientID(let patientID):
                return "v1/patient/\(patientID)/Appointments"
            case .addFavorite(let patientID):
                return "v1/patient/\(patientID)/addFavouriteDoctor"
            case .removeFavorite(let patientID):
                return "v1/patient/\(patientID)/removeFavouriteDoctor"
            case .deleteReview(let reviewID):
                return "v1/review/\(reviewID)/delete"
            case .editFeedback(let reviewID):
                return "v1/review/\(reviewID)/update"
            case .editAppointment(let appointmentID):
                return "v1/appointment/\(appointmentID)/update"
            }
        }
    }
    
    var parameters = Parameters()
    var headers = HTTPHeaders()
    var method: HTTPMethod!
    var url :String! = "http://34.100.156.30:8080/api/"
    var encoding: ParameterEncoding! = JSONEncoding.default
    
    init(data: [String:Any],headers: [String:String] = [:], url :String?, service :services? = nil, method: HTTPMethod = .post, isJSONRequest: Bool = true){
        super.init()
        data.forEach{parameters.updateValue($0.value, forKey: $0.key)}
        headers.forEach({self.headers.add(name: $0.key, value: $0.value)})
        if url == nil, service != nil{
            self.url += service!.endpoint
        }else{
            self.url = url
        }
        if !isJSONRequest{
            encoding = URLEncoding.default
        }
        self.method = method
        print("Service: \(service?.endpoint ?? self.url ?? "") \n data: \(parameters)")
    }
    
    func executeQuery<T>(completion: @escaping (Result<T, Error>) -> Void) where T: Codable {
        AF.request(url,method: method,parameters: parameters,encoding: encoding, headers: headers).responseData(completionHandler: {response in
            switch response.result{
            case .success(let res):
                if let code = response.response?.statusCode{
                    switch code {
                    case 200...299:
                        do {
                            completion(.success(try JSONDecoder().decode(T.self, from: res)))
                        } catch let error {
                            print(String(data: res, encoding: .utf8) ?? "nothing received")
                            completion(.failure(error))
                        }
                    default:
                        let error = NSError(domain: response.debugDescription, code: code, userInfo: response.response?.allHeaderFields as? [String: Any])
                        completion(.failure(error))
                    }
                }
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
