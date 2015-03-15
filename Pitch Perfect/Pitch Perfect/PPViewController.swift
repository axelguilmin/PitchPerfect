//
//  PPViewController.swift
//  Pitch Perfect
//
//  Created by Axel Guilmin on 3/10/15.
//
//

import UIKit

class PPViewController: UIViewController {
    
    @IBOutlet weak var _recordingLabel: UILabel!
    @IBOutlet weak var _stopButton: UIButton!
    @IBOutlet weak var _recordButton: UIButton!
    
    // MARK: - LAYOUT
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        _recordButton.enabled = true;
        _recordingLabel.hidden = true;
        _stopButton.hidden = true;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - ACTION
    
    @IBAction func recordAudio() {
        // TODO: Record audio
        
        _recordButton.enabled = false;
        _recordingLabel.hidden = false;
        _stopButton.hidden = false;
    }
    
    @IBAction func stopRecordingAudio() {
        _recordButton.enabled = true;
        _recordingLabel.hidden = true;
        _stopButton.hidden = true;
    }
}

