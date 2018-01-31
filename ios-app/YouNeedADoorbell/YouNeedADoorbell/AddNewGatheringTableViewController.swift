//
//  AddNewGatheringTableViewController.swift
//  YouNeedADoorbell
//
//  Created by Micah Smith on 1/30/18.
//  Copyright © 2018 Micah Smith. All rights reserved.
//

import UIKit
import AVFoundation

class AddNewGatheringTableViewController: UITableViewController {
    
    var gathering: Gathering?
    
    // MARK: - outlets
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    @IBOutlet weak var assignHostsSwitch: UISwitch!
    @IBOutlet weak var assignRandomlySwitch: UISwitch!
    @IBOutlet weak var voicePicker: UIPickerView!
    
    // MARK: - custom voice picker
    let pickerDataSourceAndDelegate = VoicePickerDataSourceAndDelegate()
    
    func setupVoicePicker() {
        voicePicker.delegate = pickerDataSourceAndDelegate
        voicePicker.dataSource = pickerDataSourceAndDelegate
    }
    
    func initGathering() {
        if gathering == nil {
            gathering = Gathering()
        }
        
        // set fields
        nameTextField.text = gathering?.title
        if let date = gathering?.start {
            startDatePicker.date = date
        }
        if let date = gathering?.end {
            endDatePicker.date = date
        }
        if let isOn = gathering?.assignHosts {
            assignHostsSwitch.isOn = isOn
        }
        if let isOn = gathering?.assignRandomly {
            assignRandomlySwitch.isOn = isOn
        }
        
        // elaborate way of selecting proper row in picker
        let voice = gathering?.doorbell.voice.colloquialIdentifier
        var row = 0
        var found = false
        for v in pickerDataSourceAndDelegate.voicePickerData {
            if v == voice {
                found = true
                break
            }
            row = row + 1
        }
        if found {
            let component = 0
            voicePicker.selectRow(row, inComponent: component, animated: false)
        }
        
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // setup
        setupVoicePicker() // must come first
        initGathering()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    /*
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }
    */

    /*
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    */

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        updateGathering()
        
    }
    
    func updateGathering() {
        self.gathering?.title = self.nameTextField.text
        self.gathering?.start = self.startDatePicker.date
        self.gathering?.end = self.endDatePicker.date
        self.gathering?.assignRandomly = self.assignRandomlySwitch.isOn
        self.gathering?.assignHosts = self.assignHostsSwitch.isOn

        // get item from voice picker
        let voicePicker = self.voicePicker
        let component = 0 // implementation detail
        let delegate = voicePicker!.delegate
        let row = voicePicker!.selectedRow(inComponent: component)
        let voiceIdentifier = delegate?.pickerView!(voicePicker!, titleForRow: row, forComponent: component)
        let voice = AVSpeechSynthesisVoice.fromColloquialIdentifier(identifier: voiceIdentifier!)
        self.gathering?.doorbell.voice = voice!
    }

}

class VoicePickerDataSourceAndDelegate: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
    var voicePickerData: [String]  = AVSpeechSynthesisVoice.speechVoices().map { $0.colloquialIdentifier }

    // MARK: - voicePicker delegates
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return voicePickerData[row]
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return voicePickerData.count
    }
    
    
}
