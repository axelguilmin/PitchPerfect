//
//  PPRecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Axel Guilmin on 3/10/15.
//
//

import UIKit
import AVFoundation

class PPRecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    // MARK: - OUTLETS
    
    @IBOutlet private weak var _recordingLabel: UILabel!
    @IBOutlet private weak var _stopButton: UIButton!
    @IBOutlet private weak var _recordButton: UIButton!
    
    // MARK: - PROPERTIES
    
    private var _audioRecorder:AVAudioRecorder!
    private var _recordedAudio:PPRecordedAudio!
    
    // MARK: - LAYOUT
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        _recordButton.enabled = true
        _recordingLabel.hidden = true
        _stopButton.hidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - ACTIONS
    
    @IBAction private func recordAudio() {
        _recordButton.enabled = false
        _recordingLabel.hidden = false
        _stopButton.hidden = false
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime) + ".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        _audioRecorder = AVAudioRecorder(URL: filePath, settings: nil, error: nil)
        _audioRecorder.delegate = self
        _audioRecorder.meteringEnabled = true
        _audioRecorder.prepareToRecord()
        _audioRecorder.record()
    }
    
    @IBAction private func stopRecordingAudio() {
        _recordingLabel.hidden = true
        _stopButton.hidden = true
        
        _audioRecorder.stop();
        var session = AVAudioSession.sharedInstance()
        session.setActive(false, error: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC:PPPlaySoundsViewController = segue.destinationViewController as PPPlaySoundsViewController
            let data = sender as PPRecordedAudio
            playSoundsVC.recievedAudio = data
        }
    }
    
    // MARK: - AVAudioRecorderDelegate
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if flag {
            _recordedAudio = PPRecordedAudio()
            _recordedAudio.filePathUrl = recorder.url
            _recordedAudio.title = recorder.url.lastPathComponent
            
            self.performSegueWithIdentifier("stopRecording", sender: _recordedAudio)
        }
        else {
            println("Recording was not successful")
            _recordButton.enabled = true
        }
    }
}

