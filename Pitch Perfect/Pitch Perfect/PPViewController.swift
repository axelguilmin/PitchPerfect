//
//  PPViewController.swift
//  Pitch Perfect
//
//  Created by Axel Guilmin on 3/10/15.
//
//

import UIKit

class PPViewController: UIViewController {
    
    @IBOutlet var _recording: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - ACTION
    
    @IBAction func recordAudio() {
        // TODO: Record audio
        
        _recording.hidden = false;
    }
    
    @IBAction private func stopRecordingAudio() {
        _recording.hidden = true;
    }
}

