//
//  Doctor.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 17/10/22.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let doctor = try? newJSONDecoder().decode(Doctor.self, from: jsonData)

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseDoctor { response in
//     if let doctor = response.result.value {
//       ...
//     }
//   }

import Foundation
import CoreLocation
import Alamofire

class Doctor: Codable, Hashable {
    static func == (lhs: Doctor, rhs: Doctor) -> Bool {
        return lhs.id! == rhs.id! && lhs.credential!.email! == rhs.credential!.email!
    }
    
    public func hash(into hasher: inout Hasher) {
        return hasher.combine(id)
    }
    
    var id: Int?
    var credential: Credential?
    var profileImage: ProfileImage?
    var name: NameInclMiddleName?
    var address: FullAddress?
    var mobile: MobileWithCountryCode?
    var gender, specialization: String?
    var experience: Double?
    var about: [String]?
    var fees: Double?
    var liveStatus: Bool?
    var avgRating: Double?
    var availableFromInWeekdays, availableFromInWeekends: String?
    var maxAppointmentsInWeekdays, maxAppointmentsInWeekends: Int?
    var appointmentDuration: String?
    var weekdayAppointmentSlots, weekendAppointmentSlots, bookedSlots: [String]?
    var patientCount: Int?
    var reviewCount: Int?
    var distanceFromUser: Double = 0.0
    
    enum CodingKeys: CodingKey {
        case id
        case credential
        case profileImage
        case name
        case address
        case mobile
        case gender
        case specialization
        case experience
        case about
        case fees
        case liveStatus
        case avgRating
        case availableFromInWeekdays
        case availableFromInWeekends
        case maxAppointmentsInWeekdays
        case maxAppointmentsInWeekends
        case appointmentDuration
        case weekdayAppointmentSlots
        case weekendAppointmentSlots
        case bookedSlots
        case patientCount
        case reviewCount
    }
    
    init(id: Int?, credential: Credential?, profileImage: ProfileImage?, name: NameInclMiddleName?, address: FullAddress?, mobile: MobileWithCountryCode?, gender: String?, specialization: String?, experience: Double?, about: [String]?, fees: Double?, liveStatus: Bool?, avgRating: Double?, availableFromInWeekdays: String?, availableFromInWeekends: String?, maxAppointmentsInWeekdays: Int?, maxAppointmentsInWeekends: Int?, appointmentDuration: String?, weekdayAppointmentSlots: [String]?, weekendAppointmentSlots: [String]?, bookedSlots: [String]?, patientCount: Int?, reviewCount: Int?) {
        self.id = id
        self.credential = credential
        self.profileImage = profileImage
        self.name = name
        self.address = address
        self.mobile = mobile
        self.gender = gender
        self.specialization = specialization
        self.experience = experience
        self.about = about
        self.fees = fees
        self.liveStatus = liveStatus
        self.avgRating = avgRating
        self.availableFromInWeekdays = availableFromInWeekdays
        self.availableFromInWeekends = availableFromInWeekends
        self.maxAppointmentsInWeekdays = maxAppointmentsInWeekdays
        self.maxAppointmentsInWeekends = maxAppointmentsInWeekends
        self.appointmentDuration = appointmentDuration
        self.weekdayAppointmentSlots = weekdayAppointmentSlots
        self.weekendAppointmentSlots = weekendAppointmentSlots
        self.bookedSlots = bookedSlots
        self.patientCount = patientCount
        self.reviewCount = reviewCount
    }
    
    static private var doctors: [Doctor] = []
    static private var liveDoctors: [Doctor] = []
    
    static func sortDoctors(doctors: [Doctor]) -> [Doctor] {
        return doctors.sorted(by: { $0.fees! < $1.fees! }).sorted(by: { $0.reviewCount! > $1.reviewCount! }).sorted(by: { $0.avgRating! > $1.avgRating! })
    }
    
    static func calculateLiveStatus() {
        liveDoctors = []
        for doctor in doctors {
            if doctor.liveStatus == true {
                liveDoctors.append(doctor)
            }
        }
    }
    
    static func getDistanceFromUser(userLocation: CLLocation) {
        for doctor in doctors {
            doctor.distanceFromUser = CLLocation(latitude: doctor.address!.latitude!,
                                                 longitude: doctor.address!.longitude!)
            .distance(from: CLLocation(latitude: userLocation.coordinate.latitude,
                                       longitude: userLocation.coordinate.longitude))
        }
        
    }
    
    static func getDoctors() -> [Doctor] {
        return doctors
    }
    
    static func clearDoctors() {
        doctors = []
    }
    
    static func refreshDoctors(completionHandler: @escaping (Bool) -> ()) {
        APIService(data: [:], headers: ["Authorization" : "Bearer \(User.getUserDetails().token ?? "")"], url: nil, service: .getAllDoctors, method: .get, isJSONRequest: false).executeQuery() { (result: Result<[Doctor], Error>) in
            switch result{
            case .success(_):
                try? Doctor.initDoctors(doctors: result.get())
                completionHandler(true)
            case .failure(let error):
                print(error)
                completionHandler(false)
            }
        }
    }
    
    static func initDoctors(doctors: [Doctor]) {
        self.doctors = doctors
    }
}
