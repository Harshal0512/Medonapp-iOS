//
//  DoctorsScreenViewController.swift
//  Medonapp iOS
//
//  Created by Harshal Kulkarni on 10/10/22.
//

import UIKit

class DoctorsScreenViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    private var backButton: UIImageView?
    private var navTitle: UILabel?
    private var searchField: SearchBarWithSearchAndFilterIcon?
    var scrollView: UIScrollView?
    var contentView: UIView?
    var liveDoctorsLabel: UILabel?
    private var doctorsCollectionView: UICollectionView?

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
    }
    
    func initialise() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
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
        
        scrollView = UIScrollView()
        contentView = UIView()
        
        view.addSubview(scrollView!)
        scrollView?.addSubview(contentView!)
        
        liveDoctorsLabel = UILabel()
        liveDoctorsLabel?.text = "Live Doctors"
        liveDoctorsLabel?.textColor = .black
        liveDoctorsLabel?.font = UIFont(name: "NunitoSans-Bold", size: 17)
        contentView?.addSubview(liveDoctorsLabel!)
        
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 93, height: 93)
        layout.scrollDirection = .horizontal
        
        doctorsCollectionView =  UICollectionView(frame: CGRect(x: 0, y: 0, width: 93, height: 93), collectionViewLayout: layout)
        view.addSubview(doctorsCollectionView!)
        doctorsCollectionView?.showsHorizontalScrollIndicator = false
        doctorsCollectionView?.showsVerticalScrollIndicator = false
    }
    
    func setConstraints() {
        backButton?.translatesAutoresizingMaskIntoConstraints = false
        navTitle?.translatesAutoresizingMaskIntoConstraints = false
        searchField?.translatesAutoresizingMaskIntoConstraints = false
        scrollView?.translatesAutoresizingMaskIntoConstraints = false
        contentView?.translatesAutoresizingMaskIntoConstraints = false
        liveDoctorsLabel?.translatesAutoresizingMaskIntoConstraints = false
        doctorsCollectionView?.translatesAutoresizingMaskIntoConstraints = false
        
        
        backButton?.topAnchor.constraint(equalTo: view.topAnchor, constant: 65).isActive = true
        backButton?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 28).isActive = true
        backButton?.widthAnchor.constraint(equalToConstant: 50).isActive = true
        backButton?.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        navTitle?.topAnchor.constraint(equalTo: view.topAnchor, constant: 78).isActive = true
        navTitle?.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        navTitle?.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        searchField?.topAnchor.constraint(equalTo: navTitle!.bottomAnchor, constant: 25).isActive = true
        searchField?.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 27).isActive = true
        searchField?.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -27).isActive = true
        searchField?.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        scrollView?.topAnchor.constraint(equalTo: searchField!.bottomAnchor, constant: 10).isActive = true
        scrollView?.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        scrollView?.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        scrollView?.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        
        contentView?.topAnchor.constraint(equalTo: scrollView!.topAnchor).isActive = true
        contentView?.leadingAnchor.constraint(equalTo: scrollView!.leadingAnchor).isActive = true
        contentView?.trailingAnchor.constraint(equalTo: scrollView!.trailingAnchor).isActive = true
        contentView?.bottomAnchor.constraint(equalTo: scrollView!.bottomAnchor).isActive = true
        contentView?.widthAnchor.constraint(equalTo: scrollView!.widthAnchor).isActive = true
        
        liveDoctorsLabel?.topAnchor.constraint(equalTo: contentView!.topAnchor, constant: 9).isActive = true
        liveDoctorsLabel?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 27).isActive = true
        liveDoctorsLabel?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -27).isActive = true
        
        doctorsCollectionView?.topAnchor.constraint(equalTo: liveDoctorsLabel!.bottomAnchor, constant: 17).isActive = true
        doctorsCollectionView?.leadingAnchor.constraint(equalTo: contentView!.leadingAnchor, constant: 27).isActive = true
        doctorsCollectionView?.trailingAnchor.constraint(equalTo: contentView!.trailingAnchor, constant: -27).isActive = true
        doctorsCollectionView?.heightAnchor.constraint(equalToConstant: 100).isActive = true
    }
    
    @objc func handleBackAction(_ sender: UITapGestureRecognizer? = nil) {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            
            // if keyboard size is not available for some reason, dont do anything
            return
        }
        
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: keyboardSize.height , right: 0.0)
        scrollView!.contentInset = contentInsets
        scrollView!.scrollIndicatorInsets = contentInsets
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInsets = UIEdgeInsets(top: 0.0, left: 0.0, bottom: 0.0, right: 0.0)
        
        // reset back the content inset to zero after keyboard is gone
        scrollView!.contentInset = contentInsets
        scrollView!.scrollIndicatorInsets = contentInsets
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
    }
    
    func refreshCollectionView() {
        doctorsCollectionView?.reloadData()
    }
}

extension DoctorsScreenViewController : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
}
