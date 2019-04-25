//
//  AddRegistrationTableViewController.swift
//  Hotel Manzana
//
//  Created by Ivan Nikitin on 23/04/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

class AddRegistrationTableViewController: UITableViewController {
    
    // MARK: - @IBOutlets
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var firstNameTextField: UITextField!
    @IBOutlet weak var lastNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var checkInDateLabel: UILabel!
    @IBOutlet weak var checkOutDateLabel: UILabel!
    @IBOutlet weak var checkInDatePicker: UIDatePicker!
    @IBOutlet weak var checkOutDatePicker: UIDatePicker!
    @IBOutlet weak var numberOfAdultsLabel: UILabel!
    @IBOutlet weak var numberOfAdultsStepper: UIStepper!
    @IBOutlet weak var numberOfChildrenLabel: UILabel!
    @IBOutlet weak var numberOfChildrenStepper: UIStepper!
    @IBOutlet weak var wifiSwitch: UISwitch!
    @IBOutlet weak var wifiCostLabel: UILabel!
    @IBOutlet weak var roomTypeLabel: UILabel!
    @IBOutlet weak var roomTypeSelectLabel: UILabel!
    
    
    //MARK: - Properties
    var addRegistration: Registration?
    
    let checkInDatePickerIndexPath = IndexPath(row: 1, section: 1)
    let checkOutDatePickerIndexPath = IndexPath(row: 3, section: 1)
    
    var isCheckInDatePickerShown = false {
        didSet {
            checkInDatePicker.isHidden = !isCheckInDatePickerShown
        }
    }
    var isCheckOutDatePickerShown = false {
        didSet {
            checkOutDatePicker.isHidden = !isCheckOutDatePickerShown
        }
    }
    
    var numberOfDays: Double {
        return checkOutDatePicker.date.timeIntervalSince(checkInDatePicker.date) / (60*60*24)
    }
    
    var roomType: RoomType? {
        didSet {
            roomTypeLabel.text = roomType?.name
            roomTypeSelectLabel.text = "change"
        }
    }
    
    //MARK: - @IBActions
    @IBAction func datePickerValueChanged() {
        updateDateViews()
    }
    
    @IBAction func saveButtonTapped() {
        addRegistration?.firstName = firstNameTextField.text ?? ""
        addRegistration?.lastNane = lastNameTextField.text ?? ""
        addRegistration?.emailAdres = emailTextField.text ?? ""
        addRegistration?.checkInDate = checkInDatePicker.date
        addRegistration?.checkOutDate = checkOutDatePicker.date
        addRegistration?.numberOfAdults = Int(numberOfAdultsStepper.value)
        addRegistration?.numberOfChildren = Int(numberOfChildrenStepper.value)
        addRegistration?.wifi = wifiSwitch.isOn
        if let roomType = roomType {
            addRegistration?.roomType = roomType
        }
    }
    
    @IBAction func stepperValueChanged() {
        updateNumberOfGuests()
    }
    
    @IBAction func wifiSwitchToggle(){
        updateWiFiCost()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI()
        saveButton.isEnabled = areFieldsReady()
//        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard)))
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let roomType = roomType {
            roomTypeLabel.text = roomType.name
        }
    }
    //MARK: - Custom Methods
    func setupDateViews() {
        let midnightToday = Calendar.current.startOfDay(for: Date())
        checkInDatePicker.minimumDate = midnightToday
        checkInDatePicker.date = midnightToday
        
    }
    
    func setupUI(){
        setupDateViews()
        updateNumberOfGuests()
        setupTextFields()
    }
    func updateDateViews(){
        checkOutDatePicker.minimumDate = checkInDatePicker.date.addingTimeInterval(60 * 60 * 24)
        
        let formatter = DateFormatter()
        formatter.locale = Locale.current
        formatter.dateStyle = .medium
        checkInDateLabel.text = formatter.string(from:  checkInDatePicker.date)
        checkOutDateLabel.text = formatter.string(from: checkOutDatePicker.date)
        updateWiFiCost()
    }
    
    func updateUI() {
        updateDateViews()
    }
    
    func updateNumberOfGuests() {
        numberOfAdultsLabel.text = "\(Int(numberOfAdultsStepper.value))"
        numberOfChildrenLabel.text = "\(Int(numberOfChildrenStepper.value))"
    }
    func updateWiFiCost() {
        if wifiSwitch.isOn {
            let wifiCost = 9.99 * numberOfDays
            wifiCostLabel.text = "Wi-Fi cost: \(wifiCost.roundToCents())$"
        } else {
            wifiCostLabel.text = "Wi-Fi ( 9.99$ per day)"
        }
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    func setupTextFields() {
        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        emailTextField.delegate = self
    }
    
    func areFieldsReady() -> Bool {
        return !firstNameTextField.isEmpty && !lastNameTextField.isEmpty && emailIsReady() && roomType != nil
    }
    
    func emailIsReady() -> Bool{
        if let email = emailTextField.text {
            if email.contains("@") && email.contains(".") {
                if email.distance(from: email.startIndex, to: email.lastIndex(of: "@")!) < email.distance(from: email.startIndex, to: email.lastIndex(of: ".")!) {
                    return true
                }
            }
        }
        return false
    }
}

// MARK: - Table View Data Source
extension AddRegistrationTableViewController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let autoHeight = UITableView.automaticDimension
        
        switch indexPath {
        case checkInDatePickerIndexPath:
            return isCheckInDatePickerShown ? autoHeight : 0
        case checkOutDatePickerIndexPath:
            return isCheckOutDatePickerShown ? autoHeight : 0
        default:
            return autoHeight
        }
    }
}

// MARK: - Table View Delegate
extension AddRegistrationTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        switch indexPath {
        case checkInDatePickerIndexPath.prevRow:
            isCheckInDatePickerShown.toggle()
            
            isCheckOutDatePickerShown = isCheckInDatePickerShown ? false : isCheckOutDatePickerShown
            
        case checkOutDatePickerIndexPath.prevRow:
            isCheckOutDatePickerShown.toggle()
            isCheckInDatePickerShown = isCheckOutDatePickerShown ? false : isCheckInDatePickerShown
        case IndexPath(row: 0, section: 4):
            performSegue(withIdentifier: "RoomTypeSegue", sender: self)
        default:
            return
        }
        
        tableView.beginUpdates()
        tableView.endUpdates()
    }
}

// MARK: - Navigation
extension AddRegistrationTableViewController {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "RoomTypeSegue" else { return }
        guard let controller = segue.destination as? RoomTypeTableViewController else { return }
            controller.numberOfDays = numberOfDays
            print(#function, #line, numberOfDays)
            if let roomType = roomType {
                controller.choosenRoomType = roomType
            }
    }
    @IBAction func dismissToRegistration(segue: UIStoryboardSegue){
        guard segue.identifier == "UnwindRoomTypeSegue" else { return }
        guard let controller = segue.source as? RoomTypeTableViewController else { return }
        roomType = controller.choosenRoomType
    }
}

extension AddRegistrationTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    @IBAction func textFieldIsReady() {
        saveButton.isEnabled = areFieldsReady()
    }
}
