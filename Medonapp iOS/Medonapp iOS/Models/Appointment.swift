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

class Appointment: Codable {
    var id, doctorID, patientID: Int?
    var patient: Patient?
    var doctor: Doctor?
    var startTime, endTime, status, duration: String?

    enum CodingKeys: String, CodingKey {
        case id
        case doctorID = "doctorId"
        case patientID = "patientId"
        case patient, doctor, startTime, endTime, status, duration
    }

    init(id: Int?, doctorID: Int?, patientID: Int?, patient: Patient?, doctor: Doctor?, startTime: String?, endTime: String?, status: String?, duration: String?) {
        self.id = id
        self.doctorID = doctorID
        self.patientID = patientID
        self.patient = patient
        self.doctor = doctor
        self.startTime = startTime
        self.endTime = endTime
        self.status = status
        self.duration = duration
    }
}

