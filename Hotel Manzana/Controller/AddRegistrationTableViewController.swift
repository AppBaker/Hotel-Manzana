//
//  AddRegistrationTableViewController.swift
//  Hotel Manzana
//
//  Created by Ivan Nikitin on 23/04/2019.
//  Copyright © 2019 Ivan Nikitin. All rights reserved.
//

import UIKit

protocol SaveRegistrationProtocol {
    func saveRegistration(registration: Registration)
}

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
            if roomType != nil {
            roomTypeLabel.text = roomType?.name
            roomTypeSelectLabel.text = "change"
            }
        }
    }
    
    var delegate: SaveRegistrationProtocol?
    
    //MARK: - @IBActions
    @IBAction func datePickerValueChanged() {
        updateDateViews()
    }
    
    @IBAction func saveButtonTapped() {
        guard let roomType = roomType else { return }
        
        let registration = Registration(
            firstName: firstNameTextField.text ?? "",
            lastNane: lastNameTextField.text ?? "",
            emailAdres: emailTextField.text ?? "",
            checkInDate: checkInDatePicker.date,
            checkOutDate: checkOutDatePicker.date,
            numberOfAdults: Int(numberOfAdultsStepper.value),
            numberOfChildren: Int(numberOfChildrenStepper.value),
            roomType: roomType,
            wifi: wifiSwitch.isOn
        )
        delegate?.saveRegistration(registration: registration)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func stepperValueChanged() {
        updateNumberOfGuests()
    }
    
    @IBAction func wifiSwitchToggle(){
        updateWiFiAndTotalCost()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        updateUI()
        saveButton.isEnabled = areFieldsReady()
        
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
        updateWiFiAndTotalCost()
    }
    
    func updateUI() {
        updateDateViews()
    }
    
    func updateNumberOfGuests() {
        numberOfAdultsLabel.text = "\(Int(numberOfAdultsStepper.value))"
        numberOfChildrenLabel.text = "\(Int(numberOfChildrenStepper.value))"
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
    
    func updateWiFiAndTotalCost(){
        var wifiCost: Double = 0
        if wifiSwitch.isOn {
            wifiCost = 9.99 * numberOfDays
            wifiCostLabel.text = "Wi-Fi cost: \(wifiCost.roundToCents())$"
        } else {
            wifiCostLabel.text = "Wi-Fi ( 9.99$ per day)"
        }
        guard let roomType = roomType else { return }
        let roomCost = roomType.price * numberOfDays
        title = "Total cost: \((roomCost + wifiCost).roundToCents())$"
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
        controller.delegate = self
        controller.numberOfDays = numberOfDays
        if let roomType = roomType {
            controller.choosenRoomType = roomType
        }
    }
    @IBAction func dismissToRegistration(segue: UIStoryboardSegue){
        guard segue.identifier == "UnwindRoomTypeSegue" else { return }
        guard let controller = segue.source as? RoomTypeTableViewController else { return }
        roomType = controller.choosenRoomType
        saveButton.isEnabled = areFieldsReady()
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

// MARK: - RoomTypeProtocol
extension AddRegistrationTableViewController: RoomTypeProtocol {
    func setRoomType(roomType: RoomType) {
        self.roomType = roomType
        updateWiFiAndTotalCost()
        numberOfAdultsStepper.maximumValue = Double(roomType.numberOfRooms * 2)
        numberOfChildrenStepper.maximumValue = Double(roomType.numberOfRooms * 2)
        if numberOfAdultsStepper.value >= numberOfAdultsStepper.maximumValue {
            numberOfAdultsStepper.value = numberOfAdultsStepper.maximumValue
            numberOfAdultsLabel.text = "\(Int(numberOfAdultsStepper.maximumValue))"
        }
        if numberOfChildrenStepper.value >= numberOfChildrenStepper.maximumValue {
            numberOfChildrenStepper.value = numberOfChildrenStepper.maximumValue
            numberOfChildrenLabel.text = "\(Int(numberOfChildrenStepper.maximumValue))"
        }
        saveButton.isEnabled = areFieldsReady()
    }
}
