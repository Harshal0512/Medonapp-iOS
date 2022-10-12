//
//  DoctorsScreenViewController.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 10/10/22.
//

import UIKit

class DoctorsScreenViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private var backButton: UIImageView?
    private var navTitle: UILabel?
    private var searchField: SearchBarWithSearchAndFilterIcon?
    private var liveDoctorsLabel: UILabel?
    private var doctorsCollectionView: UICollectionView?
    private var popularDoctorsLabel: UILabel?
    var doctorsTable: UITableView?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Doctors"
        navigationController?.navigationBar.prefersLargeTitles = false
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        navigationController?.isNavigationBarHidden = true
        
        self.dismissKeyboard()

        initialise()
        setupUI()
        setConstraints()
        
        doctorsCollectionView?.register(DoctorsScreenCarouselCollectionViewCell.nib(), forCellWithReuseIdentifier: DoctorsScreenCarouselCollectionViewCell.identifier)
        doctorsCollectionView?.delegate = self
        doctorsCollectionView?.dataSource = self
        
        doctorsTable?.register(DoctorInfoTableViewCell.nib(), forCellReuseIdentifier: DoctorInfoTableViewCell.identifier)
        doctorsTable?.delegate = self
        doctorsTable?.dataSource = self
    }
    
    func initialise() {
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
        navTitle?.text = "Doctors"
        navTitle?.textAlignment = .center
        navTitle?.textColor = .black
        navTitle?.font = UIFont(name: "NunitoSans-Bold", size: 18)
        view.addSubview(navTitle!)
        
        searchField = SearchBarWithSearchAndFilterIcon()
        searchField?.setupUI()
        searchField?.delegate = self
        searchField?.setPlaceholder(placeholder: "Search Doctor")
        view.addSubview(searchField!)
        
        liveDoctorsLabel = UILabel()
        liveDoctorsLabel?.text = "Live Doctors"
        liveDoctorsLabel?.textColor = .black
        liveDoctorsLabel?.font = UIFont(name: "NunitoSans-Bold", size: 17)
        view.addSubview(liveDoctorsLabel!)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 93, height: 93)
        layout.scrollDirection = .horizontal
        
        doctorsCollectionView =  UICollectionView(frame: CGRect(x: 0, y: 0, width: 93, height: 93), collectionViewLayout: layout)
        view.addSubview(doctorsCollectionView!)
        doctorsCollectionView?.showsHorizontalScrollIndicator = false
        doctorsCollectionView?.showsVerticalScrollIndicator = false
        
        popularDoctorsLabel = UILabel()
        popularDoctorsLabel?.text = "Popular Doctors"
        popularDoctorsLabel?.textColor = .black
        popularDoctorsLabel?.font = UIFont(name: "NunitoSans-Bold", size: 17)
        view.addSubview(popularDoctorsLabel!)
        
        doctorsTable = UITableView()
        doctorsTable?.separatorStyle = .none
        view.addSubview(doctorsTable!)
    }
    
    func setConstraints() {
        backButton?.translatesAutoresizingMaskIntoConstraints = false
        navTitle?.translatesAutoresizingMaskIntoConstraints = false
        searchField?.translatesAutoresizingMaskIntoConstraints = false
        liveDoctorsLabel?.translatesAutoresizingMaskIntoConstraints = false
        doctorsCollectionView?.translatesAutoresizingMaskIntoConstraints = false
        popularDoctorsLabel?.translatesAutoresizingMaskIntoConstraints = false
        doctorsTable?.translatesAutoresizingMaskIntoConstraints = false
        
        
        backButton?.topAnchor.constraint(equalTo: view.topAnchor, constant: 65).isActive = true
        backButton?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 28).isActive = true
        backButton?.widthAnchor.constraint(equalToConstant: 50).isActive = true
        backButton?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        navTitle?.topAnchor.constraint(equalTo: view.topAnchor, constant: 78).isActive = true
        navTitle?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        navTitle?.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        searchField?.topAnchor.constraint(equalTo: navTitle!.bottomAnchor, constant: 25).isActive = true
        searchField?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 27).isActive = true
        searchField?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -27).isActive = true
        searchField?.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        liveDoctorsLabel?.topAnchor.constraint(equalTo: searchField!.bottomAnchor, constant: 10).isActive = true
        liveDoctorsLabel?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 27).isActive = true
        liveDoctorsLabel?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -27).isActive = true
        
        doctorsCollectionView?.topAnchor.constraint(equalTo: liveDoctorsLabel!.bottomAnchor, constant: 17).isActive = true
        doctorsCollectionView?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 27).isActive = true
        doctorsCollectionView?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -27).isActive = true
        doctorsCollectionView?.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        popularDoctorsLabel?.topAnchor.constraint(equalTo: doctorsCollectionView!.bottomAnchor, constant: 30).isActive = true
        popularDoctorsLabel?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 27).isActive = true
        popularDoctorsLabel?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -27).isActive = true
        
        doctorsTable?.topAnchor.constraint(equalTo: popularDoctorsLabel!.bottomAnchor, constant: 10).isActive = true
        doctorsTable?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        doctorsTable?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -10).isActive = true
        doctorsTable?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
    }
    
    @objc func handleBackAction(_ sender: UITapGestureRecognizer? = nil) {
        navigationController?.popViewController(animated: true)
    }
    
    
    //MARK: Collection View Methods
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DoctorsScreenCarouselCollectionViewCell.identifier, for: indexPath) as! DoctorsScreenCarouselCollectionViewCell
        cell.configure(doctorImage: UIImage(named: "cat")!)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        doctorsCollectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        refreshCollectionView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let doctorsDetailsVC = UIStoryboard.init(name: "HomeTab", bundle: Bundle.main).instantiateViewController(withIdentifier: "doctorsDetailsVC") as? DoctorDetailsViewViewController
            self.navigationController?.pushViewController(doctorsDetailsVC!, animated: true)
            collectionView.deselectItem(at: indexPath, animated: true)
        }
    }
    
    func refreshCollectionView() {
        doctorsCollectionView?.reloadData()
    }
    
    //MARK: Table View Methods
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let tableCell = tableView.dequeueReusableCell(withIdentifier: DoctorInfoTableViewCell.identifier, for: indexPath) as! DoctorInfoTableViewCell
        
        tableCell.configure(doctorImage: UIImage(named: "cat")!, doctorName: "Dr. Suryansh Sharma", designation: "Cardiologist at Apollo Hospital", rating: 4.5, numberOfReviews: 17)
        return tableCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        doctorsTable?.scrollToRow(at: indexPath, at: .middle, animated: true)
        refreshTableView()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            let doctorsDetailsVC = UIStoryboard.init(name: "HomeTab", bundle: Bundle.main).instantiateViewController(withIdentifier: "doctorsDetailsVC") as? DoctorDetailsViewViewController
            self.navigationController?.pushViewController(doctorsDetailsVC!, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
    
    func refreshTableView() {
        doctorsTable?.reloadData()
    }
    
}

extension DoctorsScreenViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
