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
    
    
    //MARK: - Properties
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
    var roomType = RoomType(id: 2, name: "Good nomer", shortName: "GN", price: 100)
    
//    var roomType: RoomType? {
//        didSet {
//            roomTypeLabel.text = roomType?.name
//        }
//    }
    
    //MARK: - @IBActions
    @IBAction func datePickerValueChanged() {
        updateDateViews()
    }
    
    @IBAction func saveButtonTapped() {
        let firstName = firstNameTextField.text ?? ""
        let lastName = lastNameTextField.text ?? ""
        let email = emailTextField.text ?? ""
        let checkInDate = checkInDatePicker.date
        let checkOutDate = checkOutDatePicker.date
        let numberOfAdults = numberOfAdultsStepper.value
        let numberOfChildren = numberOfChildrenStepper.value
        let wifi = wifiSwitch .isOn
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
        print(#function, #line, numberOfDays)
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
        if segue.identifier == "RoomTypeSegue" {
//            guard let roomType = roomType else { return }
            let controller = segue.destination as! RoomTypeTableViewController
            controller.choosenRoomType = roomType
        }
    }
}
