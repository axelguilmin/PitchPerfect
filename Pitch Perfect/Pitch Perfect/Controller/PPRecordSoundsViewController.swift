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

    // MARK: - CONST
    
    private let kLabelTapToRecord = "Tap to record"
    private let kLabelTapToPause = "Tap to pause"
    private let kLabelTapToContinue = "Tap to continue"
    private let kLabelRecording = "Recording"
    private let kLabelPaused = "Paused"
    private let kSegueStopRecording = "stopRecording"

    // MARK: - OUTLETS
    
    @IBOutlet private weak var _infoLabel: UILabel!
    @IBOutlet private weak var _recordingLabel: UILabel!
    @IBOutlet private weak var _stopButton: UIButton!
    @IBOutlet private weak var _recordButton: UIButton!
    @IBOutlet private weak var _vuMeter: UIProgressView!
   
    // MARK: - PROPERTIES
    
    private var _audioRecorder: AVAudioRecorder!
    private var _vuMeterTimer: NSTimer?
    private var _recordedAudio: PPRecordedAudio!
    
    // MARK: - LAYOUT
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        layoutSubviews()
    }
    
    private func layoutSubviews() {
        _infoLabel.text = kLabelTapToRecord
        _recordingLabel.text = kLabelRecording
        _recordingLabel.hidden = true
        _vuMeter.hidden = true;
        _stopButton.hidden = true
        _audioRecorder = nil
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - ACTIONS
    
    @IBAction private func recordAudio() {
        if nil == _audioRecorder { // Start recording
            
            var session = AVAudioSession.sharedInstance()
            var error:NSError?
            if session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: &error) == false {
                println("setCategory was not sucessful : \(error)")
                return
            }
            
            _audioRecorder = AVAudioRecorder(URL: filePath(), settings: nil, error: &error)
            if error != nil {
                println("Can't create AVAudioRecorder : \(error)")
                return
            }
            _audioRecorder.delegate = self
            _audioRecorder.meteringEnabled = true
            _audioRecorder.prepareToRecord()
            _audioRecorder.record()
            _vuMeterTimer = NSTimer.scheduledTimerWithTimeInterval(0.03334, target: self, selector: "updateVuMeter:", userInfo: nil, repeats: true)
            
            _infoLabel.text = kLabelTapToPause
            _recordingLabel.hidden = false;
            _vuMeter.hidden = false;
            _stopButton.hidden = false
        }
        else if _audioRecorder.recording { // Pause recording
            _infoLabel.text = kLabelTapToContinue
            _recordingLabel.text = kLabelPaused
            _audioRecorder.pause()
        }
        else { // Continue recording
            _infoLabel.text = kLabelTapToPause
            _recordingLabel.text = kLabelRecording
            _audioRecorder.record()
        }
    }
    
    @IBAction private func stopRecordingAudio() {
        _recordingLabel.hidden = true
        _vuMeter.hidden = true
        _stopButton.hidden = true
        _vuMeterTimer?.invalidate()
        
        _audioRecorder.stop();
        var session = AVAudioSession.sharedInstance()
        session.setActive(false, error: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == kSegueStopRecording {
            let playSoundsVC:PPPlaySoundsViewController = segue.destinationViewController as PPPlaySoundsViewController
            let data = sender as PPRecordedAudio
            playSoundsVC.recievedAudio = data
        }
    }

    // MARK: - PRIVATE
    
    private func filePath() -> NSURL {
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime) + ".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        
        return filePath!
    }
    
    @objc private func updateVuMeter(timer: NSTimer) {
        _audioRecorder.updateMeters()
        // -160 to ~0 from documentation, but rarely < -100
        let power = _audioRecorder.averagePowerForChannel(0)
        _vuMeter.progress = (power + 100.0) / 100.0
    }

    // MARK: - AVAudioRecorderDelegate
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
        if flag {
            _recordedAudio = PPRecordedAudio(filePathUrl:recorder.url, title:recorder.url.lastPathComponent)
            performSegueWithIdentifier(kSegueStopRecording, sender: _recordedAudio)
        }
        else {
            println("Recording was not successful")
            layoutSubviews()
        }
    }
}

