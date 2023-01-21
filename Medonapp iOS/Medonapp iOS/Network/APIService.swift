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
        case login, signUp, checkEmailExists, sendOtp, getAllDoctors, bookAppointment, postReview
        case getAppointmentsWithPatientID(Int)
        case getPatientWithID(Int)
        case addFavorite(Int)
        case removeFavorite(Int)
        case deleteReview(Int)
        case editFeedback(Int)
        case editAppointment(Int)
        case cancelAppointment(Int)
        
        var endpoint: String {
            switch self {
            case .login:
                return "auth/login"
            case .signUp:
                return "v1/patient/add"
            case .checkEmailExists:
                return "auth/checkEmailExists"
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
            case .cancelAppointment(let appointmentID):
                return "v1/appointment/\(appointmentID)/cancel"
            }
        }
    }
    
    var parameters = Parameters()
    var headers = HTTPHeaders()
    var method: HTTPMethod!
    var api_endpoint: String! = Constants.BASE_URI
    var encoding: ParameterEncoding! = JSONEncoding.default
    
    init(data: [String:Any],headers: [String:String] = [:], url :String?, service :services? = nil, method: HTTPMethod = .post, isJSONRequest: Bool = true){
        super.init()
        data.forEach{parameters.updateValue($0.value, forKey: $0.key)}
        headers.forEach({self.headers.add(name: $0.key, value: $0.value)})
        if url == nil, service != nil{
            self.api_endpoint += service!.endpoint
        }else{
            self.api_endpoint = url
        }
        if !isJSONRequest{
            encoding = URLEncoding.default
        }
        self.method = method
        print("Service: \(service?.endpoint ?? self.api_endpoint ?? "") \n data: \(parameters)")
    }
    
    func executeQuery<T>(completion: @escaping (Result<T, Error>) -> Void) where T: Codable {
        AF.request(api_endpoint,method: method,parameters: parameters,encoding: encoding, headers: headers).responseData(completionHandler: {response in
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
                if error._code == NSURLErrorTimedOut {
                    print("Request timeout!")
                } else {
                    completion(.failure(error))
                }
            }
        })
    }
    
    static func uploadFile(file: Data, fileName: String, params: [String: Any], progressAlert: CircularProgressBar?, completion: @escaping (Bool) -> Void) {
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data",
            "Accept": "application/json",
            "Authorization" : "Bearer \(User.getUserDetails().token ?? "")"
        ]
        AF.upload(
            multipartFormData: { multipartFormData in
                for (key, value) in params {
                    if let temp = value as? String {
                        multipartFormData.append(temp.data(using: .utf8)!, withName: key)
                    }
                    if let temp = value as? Int {
                        multipartFormData.append("\(temp)".data(using: .utf8)!, withName: key)
                    }
                    if let temp = value as? NSArray {
                        temp.forEach({ element in
                            let keyObj = key + "[]"
                            if let string = element as? String {
                                multipartFormData.append(string.data(using: .utf8)!, withName: keyObj)
                            } else
                            if let num = element as? Int {
                                let value = "\(num)"
                                multipartFormData.append(value.data(using: .utf8)!, withName: keyObj)
                            }
                        })
                    }
                }
                multipartFormData.append(file, withName: "file", fileName: fileName, mimeType: "patientMedicalFile")
            },
            to: "\(Constants.BASE_URI)v1/patient/\((User.getUserDetails().patient?.id!)!)/upload",
            method: .post,
            headers: headers)
        .uploadProgress(queue: .main, closure: { progress in
            progressAlert?.setProgress(to: progress.fractionCompleted, withAnimation: false)
        })
        .responseJSON { (resp) in
            if let code = resp.response?.statusCode{
                switch code {
                case 200...299:
                    completion(true)
                default:
                    let error = NSError(domain: resp.debugDescription, code: code, userInfo: resp.response?.allHeaderFields as? [String: Any])
                    completion(false)
                }
            }
            completion(false)
        }
    }
    
    static func downloadFile(fileUrl: URL, fileName: String, progressBar: CircularProgressBar?, headers: [String: String], completion: @escaping (URL?) -> Void) {
        var requestHeaders: HTTPHeaders = HTTPHeaders()

        headers.forEach({requestHeaders.add(name: $0.key, value: $0.value)})
        let progressQueue = DispatchQueue(label: "com.alamofire.progressQueue", qos: .utility)

        let destination: DownloadRequest.Destination = { _, _ in
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = documentsURL.appendingPathComponent(fileName)

            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }

        AF.download(fileUrl, headers: requestHeaders, to: destination).downloadProgress(queue: .main, closure: { progress in
            progressBar?.setProgress(to: progress.fractionCompleted, withAnimation: false)
        }).response { response in
            progressBar?.setProgress(to: 0, withAnimation: false)
            debugPrint(response)
            
            if response.error == nil, let path = response.fileURL {
                completion(path)
            }
            completion(nil)
            
//            if response.error == nil, let imagePath = response.fileURL?.path {
//                let image = UIImage(contentsOfFile: imagePath)
//            }
        }
    }
}
