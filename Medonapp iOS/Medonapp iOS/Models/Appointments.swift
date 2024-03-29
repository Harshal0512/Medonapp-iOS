//
//  Appointment.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 27/10/22.
//

// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let appointment = try? newJSONDecoder().decode(Appointment.self, from: jsonData)

//
// To parse values from Alamofire responses:
//
//   Alamofire.request(url).responseAppointment { response in
//     if let appointment = response.result.value {
//       ...
//     }
//   }

import Foundation
import Alamofire

typealias Appointments = [AppointmentElement]

class AppointmentElement: Codable {
    var id, doctorID, patientID: Int?
    var patientURL, doctorURL: String?
    var patient: Patient?
    var doctor: Doctor?
    var startTime, endTime, status, duration: String?
    var review: Review?
    var symptoms: String?

    enum CodingKeys: String, CodingKey {
        case id
        case doctorID = "doctorId"
        case patientID = "patientId"
        case patient, doctor, startTime, endTime, status, duration, review, symptoms
    }

    init(id: Int?, doctorID: Int?, patientID: Int?, patientURL: String?, doctorURL: String?, patient: Patient?, doctor: Doctor?, startTime: String?, endTime: String?, status: String?, duration: String?, review: Review?, symptoms: String?    ) {
        self.id = id
        self.doctorID = doctorID
        self.patientID = patientID
        self.patientURL = patientURL
        self.doctorURL = doctorURL
        self.startTime = startTime
        self.endTime = endTime
        self.status = status
        self.duration = duration
        self.review = review
        self.symptoms = symptoms
    }
    
    static private var appointments: Appointments = Prefs.allAppointments
    static private var appointmentsByDate: [Int: [Int]] = [:]
    
    static func getAppointments() -> Appointments {
        return appointments
    }
    
    static func getAppointmentDate() -> [Int: [Int]] {
        return appointmentsByDate
    }
    
    static func clearAppointments() {
        appointments = []
        appointmentsByDate = [:]
    }
    
    static func refreshAppointments(completionHandler: @escaping (Bool) -> ()) {
        APIService(data: [:], headers: ["Authorization" : "Bearer \(User.getUserDetails().token ?? "")"], url: nil, service: .getAppointmentsWithPatientID(User.getUserDetails().patient!.id!), method: .get, isJSONRequest: false).executeQuery() { (result: Result<Appointments, Error>) in
            switch result{
            case .success(let app):
                AppointmentElement.initAppointments(appointments: app)
                completionHandler(true)
            case .failure(let error):
                print(error)
                completionHandler(false)
            }
        }
    }
    
    static private func populateDoctorAndPatient() {
        for appointment in appointments {
            appointment.doctor = Doctor.getDoctor(withID: appointment.doctorID!)
            appointment.patient = User.getUserDetails().patient!
        }
    }
    
    static func sortAppointments(order: ComparisonResult) {
        appointments = appointments.sorted(by: { Date.dateFromISOString(string: $0.startTime!, timezone: "GMT")!.compare(Date.dateFromISOString(string: $1.startTime!, timezone: "GMT")!) == order })
    }
    
    static func initAppointments(appointments: Appointments) {
        self.appointments = appointments
        populateDoctorAndPatient()
        AppointmentElement.sortAppointments(order: .orderedAscending)
        Prefs.allAppointments = appointments
    }
    
    static func arrangeAppointmentsByDate(month: Int, year: Int) {
        appointmentsByDate = [1 : [], 2 : [], 3 : [], 4 : [], 5 : [], 6 : [], 7 : [], 8 : [], 9 : [], 10 : [], 11 : [], 12 : [], 13 : [], 14 : [], 15 : [], 16 : [], 17 : [], 18 : [], 19 : [], 20 : [], 21 : [], 22 : [], 23 : [], 24 : [], 25 : [], 26 : [], 27 : [], 28 : [], 29 : [], 30 : [], 31 : []]
        for i in 1...31 {
            for index in stride(from: 0, to: appointments.count, by: 1) {
                if Int(Date.getDayFromDate(date: Date.dateFromISOString(string: appointments[index].startTime!)!)) == i &&
                    Int(Date.getMonthFromDate(date: Date.dateFromISOString(string: appointments[index].startTime!)!)) == month &&
                    Int(Date.getYearFromDate(date: Date.dateFromISOString(string: appointments[index].startTime!)!)) == year {
                    appointmentsByDate[i]?.append(index)
                }
            }
        }
    }
}

