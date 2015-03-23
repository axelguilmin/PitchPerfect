//
//  PPPlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Axel Guilmin on 3/15/15.
//
//

import UIKit
import AVFoundation

class PPPlaySoundsViewController: UIViewController {

    var _audioPlayer:AVAudioPlayer!
    
    // MARK: - LAYOUT
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let fileURL:NSURL? = NSBundle.mainBundle().URLForResource("movie_quote", withExtension:"mp3") {
            _audioPlayer = AVAudioPlayer(contentsOfURL:fileURL, error: nil)
            _audioPlayer.enableRate = true
        }
        else {
            println("the fileURL is empty, can't init _audioPlayer");
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - ACTION

    @IBAction func playSlow() {
        _audioPlayer.rate = 0.5
        _audioPlayer.play()
    }
    @IBAction func playFast() {
        _audioPlayer.rate = 2.0
        _audioPlayer.play()
    }
    
    @IBAction func stop() {
        _audioPlayer.stop();
    }
    
}
