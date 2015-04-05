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

    // MARK: - PROPERTIES
    
    var recievedAudio:PPRecordedAudio!
    
    private var _audioFile:AVAudioFile!
    private var _audioPlayerNode:AVAudioPlayerNode!
    private var _audioUnitTimePitch:AVAudioUnitTimePitch!
    private var _audioEngine:AVAudioEngine!
    
    // MARK: - LAYOUT
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _audioFile = AVAudioFile(forReading: recievedAudio.filePathUrl, error: nil)
        _audioPlayerNode = AVAudioPlayerNode()
        _audioUnitTimePitch = AVAudioUnitTimePitch()
        _audioEngine = AVAudioEngine()
        
        _audioEngine.attachNode(_audioPlayerNode)
        _audioEngine.attachNode(_audioUnitTimePitch)
        _audioEngine.connect(_audioPlayerNode, to: _audioUnitTimePitch, format: nil)
        _audioEngine.connect(_audioUnitTimePitch, to: _audioEngine.outputNode, format: nil)
        _audioEngine.startAndReturnError(nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    // MARK: - ACTIONS

    @IBAction func playSlow() {
        playAudio(rate: 2.0)
    }
    
    @IBAction func playFast() {
        playAudio(rate: 0.5)
    }
    
    @IBAction func playChipmunk() {
        playAudio(pitch: 1000.0)
    }

    @IBAction func playDarthvader() {
        playAudio(pitch: -1000.0)
    }
    
    @IBAction func stop() {
        stopAudio()
    }
    
    // MARK: - PRIVATE
    
    private func playAudio(rate:Float = 1.0, pitch:Float = 1.0) {
        _audioUnitTimePitch.pitch = pitch
        _audioUnitTimePitch.rate = rate
        
        _audioPlayerNode.stop()
        _audioPlayerNode.scheduleFile(_audioFile, atTime: nil, completionHandler: nil)
        _audioPlayerNode.play()
    }
    
    private func stopAudio() {
        _audioPlayerNode.stop()
    }
}
