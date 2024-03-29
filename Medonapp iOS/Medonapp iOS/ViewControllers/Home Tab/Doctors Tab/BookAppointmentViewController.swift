//
//  BookAppointmentViewController.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 14/10/22.
//

import UIKit
import EventKit

import Toast_Swift

class BookAppointmentViewController: UIViewController, UICollectionViewDelegateFlowLayout {
    
    private var backButton: UIImageView?
    private var navTitle: UILabel?
    private var scrollView: UIScrollView?
    private var contentView: UIView?
    private var datePicker: UIDatePicker?
    private var timeSelectView: UIView?
    private var timeViewNavTitle: UILabel?
    private var timeCollectionView: UICollectionView?
    private var makeAppointmentButton: UIButtonVariableBackgroundVariableCR?
    
    var dayOfWeek: Int = 1
    var activeItem: Int = -1
    
    public var symptoms: String = ""
    public var doctor: Doctor?
    public var isEditingAppointment: Bool = false
    public var appointment: AppointmentElement?
    
    let eventStore = EKEventStore()
    var isRemindersAccess: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialise()
        setupUI()
        setConstraints()
        
        timeCollectionView?.register(AppointmentTimeCollectionViewCell.nib(), forCellWithReuseIdentifier: AppointmentTimeCollectionViewCell.identifier)
        timeCollectionView?.delegate = self
        timeCollectionView?.dataSource = self
        
        dateChanged()
        
        askForPermission {
            self.isRemindersAccess = true
        }
    }
    
    func askForPermission(grantedAction: @escaping () -> Void) {
        eventStore.requestAccess(to: .event) { (granted, error) in
            if let error = error {
                print(error)
                return
            }
            
            if granted {
                grantedAction()
            }
        }
    }
    
    func initialise() {
        NotificationCenter.default.addObserver(self, selector: #selector(goToDashboard), name: Notification.Name("goToDashboard"), object: nil)
    }
    
    func setupUI() {
        backButton = UIImageView()
        backButton?.image = UIImage(named: "backIcon_White")?.resizeImageTo(size: CGSize(width: 50, height: 50))
        backButton?.contentMode = .scaleAspectFit
        view.addSubview(backButton!)
        let backTap = UITapGestureRecognizer(target: self, action: #selector(self.handleBackAction(_:)))
        backButton?.addGestureRecognizer(backTap)
        backButton?.isUserInteractionEnabled = true
        
        navTitle = UILabel()
        navTitle?.text = isEditingAppointment ? "Edit Appointment" : "Appointment"
        navTitle?.textAlignment = .center
        navTitle?.textColor = .black
        navTitle?.font = UIFont(name: "NunitoSans-Bold", size: 18)
        view.addSubview(navTitle!)
        
        scrollView = UIScrollView()
        contentView = UIView()
        
        view.addSubview(scrollView!)
        scrollView?.addSubview(contentView!)
        
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.preferredDatePickerStyle = .inline
        datePicker?.minimumDate = Date()
        datePicker?.maximumDate = Calendar.current.date(byAdding: .year, value: 1, to: Date())
        contentView?.addSubview(datePicker!)
        datePicker?.addTarget(self, action: #selector(dateChanged), for: .valueChanged)
        
        timeSelectView = UIView()
        timeSelectView?.backgroundColor = UIColor(red: 0.11, green: 0.42, blue: 0.64, alpha: 1.00)
        timeSelectView?.layer.cornerRadius = 32
        timeSelectView?.clipsToBounds = true
        timeSelectView?.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        contentView?.addSubview(timeSelectView!)
        
        timeViewNavTitle = UILabel()
        timeViewNavTitle?.text = "Time"
        timeViewNavTitle?.textColor = .white
        timeViewNavTitle?.font = UIFont(name: "NunitoSans-ExtraBold", size: 24)
        timeSelectView?.addSubview(timeViewNavTitle!)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 92, height: 42)
        //        layout.scrollDirection = .horizontal
        
        timeCollectionView =  UICollectionView(frame: CGRect(x: 0, y: 0, width: contentView!.frame.width-45, height: 300), collectionViewLayout: layout)
        timeCollectionView?.backgroundColor = .clear
        timeSelectView?.addSubview(timeCollectionView!)
        timeCollectionView?.showsHorizontalScrollIndicator = false
        //        timeCollectionView?.showsVerticalScrollIndicator = false
        
        makeAppointmentButton = UIButtonVariableBackgroundVariableCR()
        makeAppointmentButton?.initButton(title: isEditingAppointment ? "Confirm Time" : "Make Appointment", cornerRadius: 14, variant: .whiteBack, titleColor: UIColor(red: 0.11, green: 0.42, blue: 0.64, alpha: 1.00))
        timeSelectView?.addSubview(makeAppointmentButton!)
        makeAppointmentButton?.addTarget(self, action: #selector(goToAppointmentStatusVC), for: .touchUpInside)
    }
    
    func setConstraints() {
        backButton?.translatesAutoresizingMaskIntoConstraints = false
        navTitle?.translatesAutoresizingMaskIntoConstraints = false
        scrollView?.translatesAutoresizingMaskIntoConstraints = false
        contentView?.translatesAutoresizingMaskIntoConstraints = false
        datePicker?.translatesAutoresizingMaskIntoConstraints = false
        timeSelectView?.translatesAutoresizingMaskIntoConstraints = false
        timeViewNavTitle?.translatesAutoresizingMaskIntoConstraints = false
        timeCollectionView?.translatesAutoresizingMaskIntoConstraints = false
        makeAppointmentButton?.translatesAutoresizingMaskIntoConstraints = false
        
        
        backButton?.topAnchor.constraint(equalTo: view.topAnchor, constant: 65).isActive = true
        backButton?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 28).isActive = true
        backButton?.widthAnchor.constraint(equalToConstant: 50).isActive = true
        backButton?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        navTitle?.topAnchor.constraint(equalTo: view.topAnchor, constant: 78).isActive = true
        navTitle?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        navTitle?.widthAnchor.constraint(equalToConstant: 150).isActive = true
        
        
        scrollView?.topAnchor.constraint(equalTo: backButton!.bottomAnchor, constant: 10).isActive = true
        scrollView?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        
        contentView?.topAnchor.constraint(equalTo: scrollView!.topAnchor).isActive = true
        contentView?.leadingAnchor.constraint(equalTo: scrollView!.leadingAnchor).isActive = true
        contentView?.trailingAnchor.constraint(equalTo: scrollView!.trailingAnchor).isActive = true
        contentView?.bottomAnchor.constraint(equalTo: scrollView!.bottomAnchor).isActive = true
        contentView?.widthAnchor.constraint(equalTo: scrollView!.widthAnchor).isActive = true
        
        datePicker?.topAnchor.constraint(equalTo: contentView!.topAnchor, constant: 0).isActive = true
        datePicker?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 10).isActive = true
        datePicker?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -10).isActive = true
        datePicker?.heightAnchor.constraint(equalToConstant: 350).isActive = true
        
        timeSelectView?.topAnchor.constraint(equalTo: datePicker!.bottomAnchor, constant: 10).isActive = true
        timeSelectView?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor).isActive = true
        timeSelectView?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor).isActive = true
        timeSelectView?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        timeSelectView?.bottomAnchor.constraint(equalTo: contentView!.bottomAnchor).isActive = true
        
        timeViewNavTitle?.leadingAnchor.constraint(equalTo: timeSelectView!.leadingAnchor, constant: 30).isActive = true
        timeViewNavTitle?.topAnchor.constraint(equalTo: timeSelectView!.topAnchor, constant: 40).isActive = true
        timeViewNavTitle?.widthAnchor.constraint(equalToConstant: 70).isActive = true
        
        timeCollectionView?.topAnchor.constraint(equalTo: timeViewNavTitle!.bottomAnchor, constant: 20).isActive = true
        timeCollectionView?.leadingAnchor.constraint(equalTo: timeSelectView!.leadingAnchor, constant: 20).isActive = true
        timeCollectionView?.trailingAnchor.constraint(equalTo: timeSelectView!.trailingAnchor, constant: -20).isActive = true
        
        makeAppointmentButton?.topAnchor.constraint(equalTo: timeCollectionView!.bottomAnchor, constant: 20).isActive = true
        makeAppointmentButton?.leadingAnchor.constraint(equalTo: timeSelectView!.leadingAnchor, constant: 20).isActive = true
        makeAppointmentButton?.trailingAnchor.constraint(equalTo: timeSelectView!.trailingAnchor, constant: -20).isActive = true
        makeAppointmentButton?.bottomAnchor.constraint(equalTo: timeSelectView!.bottomAnchor, constant: -20).isActive = true
        makeAppointmentButton?.heightAnchor.constraint(equalToConstant: 56).isActive = true
    }
    
    @objc func handleBackAction(_ sender: UITapGestureRecognizer? = nil) {
        if isEditingAppointment {
            self.dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @objc func dateChanged() {
        dayOfWeek = Int(Date.getDayOfWeekFromDate(date: datePicker!.date))!
        activeItem = -1
        timeCollectionView?.reloadData()
    }
    
    @objc func goToAppointmentStatusVC() {
        if activeItem < 0 {
            return
        }
        view.isUserInteractionEnabled = false
        view.makeToastActivity(.center)
        
        let appointmentStatusVC = UIStoryboard.init(name: "HomeTab", bundle: Bundle.main).instantiateViewController(withIdentifier: "appointmentStatusVC") as? AppointmentStatusViewController
        
        var selectedTime = ""
        if dayOfWeek == 1 || dayOfWeek == 7 {
            selectedTime = (doctor?.weekendAppointmentSlots![self.activeItem])!
        } else {
            selectedTime = (doctor?.weekdayAppointmentSlots![self.activeItem])!
        }
        
        APIService(data: ["patientId": User.getUserDetails().patient!.id!,
                          "doctorId": doctor!.id!,
                          "startTime": Date.combineDateWithTimeReturnISO(date: Date.stringFromDate(date: datePicker!.date), time: selectedTime).appending("Z"),
                          //TODO: Change end time if time duration of appointment changes in future
                          "endTime": Date.addMinutes(ISODateString: Date.combineDateWithTimeReturnISO(date: Date.stringFromDate(date: datePicker!.date), time: selectedTime), minutes: 30 * 60.0).appending("Z"),
                          "symptoms": symptoms],
                   headers: ["Authorization" : "Bearer \(User.getUserDetails().token ?? "")"],
                   url: nil,
                   service: isEditingAppointment ? .editAppointment(appointment!.id!) : .bookAppointment,
                   method: isEditingAppointment ? .put : .post,
                   isJSONRequest: true).executeQuery() { [self] (result: Result<AppointmentElement, Error>) in
            switch result{
            case .success(let appointment):
                if appointment.status?.lowercased() == "booked" {
                    appointmentStatusVC?.appointmentIsSuccess = true
                    appointmentStatusVC?.actionButtonCommand = .dashboard
                    guard let calendar = self.eventStore.defaultCalendarForNewEvents else { break }
                    let appointmentReminder = EKEvent(eventStore: self.eventStore)
                    appointmentReminder.calendar = calendar
                    appointmentReminder.title = "Appointment with \(self.doctor!.fullNameWithTitle)"
                    appointmentReminder.startDate = Date.dateFromISOString(string: Date.combineDateWithTimeReturnISO(date: Date.stringFromDate(date: datePicker!.date), time: selectedTime))!
                    appointmentReminder.endDate = Date.dateFromISOString(string: Date.addMinutes(ISODateString: Date.combineDateWithTimeReturnISO(date: Date.stringFromDate(date: datePicker!.date), time: selectedTime), minutes: 30 * 60.0))!
                    let alarm = EKAlarm.init(absoluteDate: Date.init(timeInterval: -3600, since: appointmentReminder.startDate))
                    appointmentReminder.addAlarm(alarm)
                    let structuredLocation = EKStructuredLocation(title: doctor!.fullNameWithTitle)
                    structuredLocation.geoLocation = CLLocation(latitude: (doctor?.address!.latitude!)!, longitude: (doctor?.address!.longitude!)!)
                    appointmentReminder.structuredLocation = structuredLocation
                    //TODO: Mention address of doctor in notes
                    appointmentReminder.notes = "Speciality: \(doctor!.specialization!)"
                    try! self.eventStore.save(appointmentReminder, span: .thisEvent)
                    appointmentStatusVC?.reminderIsSet = true
                } else {
                    appointmentStatusVC?.appointmentIsSuccess = false
                    appointmentStatusVC?.actionButtonCommand = .previousScreen
                    view.isUserInteractionEnabled = true
                    view.hideToastActivity()
                    dateChanged()
                }
                
            case .failure(let error):
                print(error)
                appointmentStatusVC?.appointmentIsSuccess = false
                appointmentStatusVC?.actionButtonCommand = .previousScreen
                view.isUserInteractionEnabled = true
                view.hideToastActivity()
                dateChanged()
            }
            
            appointmentStatusVC?.modalPresentationStyle = .fullScreen
            self.present(appointmentStatusVC!, animated: true, completion: nil)
        }
    }
    
    @objc func goToDashboard() {
        if isEditingAppointment {
            self.dismiss(animated: true) {
                NotificationCenter.default.post(name: Notification.Name("goToBookedAPPT"), object: nil)
            }
        } else {
            self.navigationController?.popToRootViewController(animated: true)
        }
    }
    
}

extension BookAppointmentViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if dayOfWeek == 1 || dayOfWeek == 7 {
            return (doctor?.weekendAppointmentSlots?.count)!
        } else {
            return (doctor?.weekdayAppointmentSlots?.count)!
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AppointmentTimeCollectionViewCell.identifier, for: indexPath) as! AppointmentTimeCollectionViewCell
        
        var isBooked = false
        var isNotAvailable = false
        for bookedSlot in doctor!.bookedSlots ?? [] {
            if (
                Int(Date.getDayFromDate(date: datePicker!.date)) == Int(Date.getDayFromDate(date: Date.dateFromISOString(string: bookedSlot, timezone: "GMT")!)) &&
                Int(Date.getMonthFromDate(date: datePicker!.date)) == Int(Date.getMonthFromDate(date: Date.dateFromISOString(string: bookedSlot, timezone: "GMT")!)) &&
                Int(Date.getYearFromDate(date: datePicker!.date)) == Int(Date.getYearFromDate(date: Date.dateFromISOString(string: bookedSlot, timezone: "GMT")!)) &&
                Date.dateTimeChangeFormat(str: (
                    (dayOfWeek == 1 || dayOfWeek == 7) ?
                    doctor?.weekendAppointmentSlots![indexPath.row] :
                        doctor?.weekdayAppointmentSlots![indexPath.row]
                )!,
                                          inDateFormat:  "HH:mm:ss",
                                          outDateFormat: "hh:mm a") == Date.dateTimeChangeFormat(str: bookedSlot,
                                                                                                 inDateFormat:  "yyyy-MM-dd'T'HH:mm:ss",
                                                                                                 outDateFormat: "hh:mm a")
            ) {
                if !(isEditingAppointment && (Int(Date.getDayFromDate(date: datePicker!.date)) == Int(Date.getDayFromDate(date: Date.now)) &&
                                            Int(Date.getMonthFromDate(date: datePicker!.date)) == Int(Date.getMonthFromDate(date: Date.now)) &&
                                            Int(Date.getYearFromDate(date: datePicker!.date)) == Int(Date.getYearFromDate(date: Date.now)) &&
                                            Date.dateTimeChangeFormat(str: (
                                                (dayOfWeek == 1 || dayOfWeek == 7) ?
                                                doctor?.weekendAppointmentSlots![indexPath.row] :
                                                    doctor?.weekdayAppointmentSlots![indexPath.row]
                                            )!,
                                                                      inDateFormat:  "HH:mm:ss",
                                                                      outDateFormat: "HH:mm:ss") == Date.dateTimeChangeFormat(str: (appointment?.startTime)!,
                                                                                                                              inDateFormat:  "yyyy-MM-dd'T'HH:mm:ss",
                                                                                                                              outDateFormat: "HH:mm:ss")
                                        )) {
                    isBooked = true
                }
                break
            }
        }
        if (Int(Date.getDayFromDate(date: datePicker!.date)) == Int(Date.getDayFromDate(date: Date.now)) &&
            Int(Date.getMonthFromDate(date: datePicker!.date)) == Int(Date.getMonthFromDate(date: Date.now)) &&
            Int(Date.getYearFromDate(date: datePicker!.date)) == Int(Date.getYearFromDate(date: Date.now)) &&
            Date.dateTimeChangeFormat(str: (
                (dayOfWeek == 1 || dayOfWeek == 7) ?
                doctor?.weekendAppointmentSlots![indexPath.row] :
                    doctor?.weekdayAppointmentSlots![indexPath.row]
            )!,
                                      inDateFormat:  "HH:mm:ss",
                                      outDateFormat: "HH:mm:ss") <= Date.dateTimeChangeFormat(str: Date.ISOStringFromDate(date: Date.now),
                                                                                              inDateFormat:  "yyyy-MM-dd'T'HH:mm:ss",
                                                                                              outDateFormat: "HH:mm:ss")
        ) {
            isNotAvailable = true
        }
        cell.configure(timeString: (
            (dayOfWeek == 1 || dayOfWeek == 7) ?
            doctor?.weekendAppointmentSlots![indexPath.row] :
                doctor?.weekdayAppointmentSlots![indexPath.row]
        )!, isActive: (indexPath.row == activeItem) ? true : false, isBooked: isBooked, isNotAvailable: isNotAvailable)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let sectionInsets = UIEdgeInsets(
            top: 50.0,
            left: 20.0,
            bottom: 50.0,
            right: 20.0)
        let paddingSpace = sectionInsets.left * (3 + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / 3
        
        return CGSize(width: widthPerItem, height: 42)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView.cellForItem(at: indexPath) as! AppointmentTimeCollectionViewCell).isNotAvailable {
            Utils.displaySPIndicatorNotifWithoutMessage(title: "Time slot is before current time.", iconPreset: .error, hapticPreset: .error, duration: 1)
        } else if (collectionView.cellForItem(at: indexPath) as! AppointmentTimeCollectionViewCell).isBooked {
            Utils.displaySPIndicatorNotifWithoutMessage(title: "Time slot already booked.", iconPreset: .error, hapticPreset: .error, duration: 1)
        } else {
            activeItem = indexPath.row
            collectionView.reloadData()
        }
    }
}
