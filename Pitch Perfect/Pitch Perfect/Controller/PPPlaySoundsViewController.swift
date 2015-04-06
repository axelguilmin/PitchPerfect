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
    
    var recievedAudio: PPRecordedAudio!
    
    private var _audioFile: AVAudioFile!
    private var _audioPlayerNode: AVAudioPlayerNode!
    private var _audioUnitTimePitch: AVAudioUnitTimePitch!
    private var _audioReverb: AVAudioUnitReverb!
    private var _audioDelay: AVAudioUnitDelay!
    private var _audioEngine: AVAudioEngine!
    
    // MARK: - LAYOUT
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        _audioFile = AVAudioFile(forReading: recievedAudio.filePathUrl, error: nil)
        _audioPlayerNode = AVAudioPlayerNode()
        _audioUnitTimePitch = AVAudioUnitTimePitch()
        _audioReverb = AVAudioUnitReverb()
        _audioDelay = AVAudioUnitDelay()
        _audioEngine = AVAudioEngine()
        
        _audioEngine.attachNode(_audioPlayerNode)
        _audioEngine.attachNode(_audioUnitTimePitch)
        _audioEngine.attachNode(_audioReverb)
        _audioEngine.attachNode(_audioDelay)
        
        // Player >> TimePitch >> Reverb >> Echo >> Output
        _audioEngine.connect(_audioPlayerNode, to: _audioUnitTimePitch, format: nil)
        _audioEngine.connect(_audioUnitTimePitch, to: _audioReverb, format: nil)
        _audioEngine.connect(_audioReverb, to: _audioDelay, format: nil)
        _audioEngine.connect(_audioDelay, to: _audioEngine.outputNode, format: nil)
        
        _audioEngine.startAndReturnError(nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
        
    // MARK: - ACTIONS

    @IBAction func playSlow() {
        playAudio(rate: 0.5)
    }
    
    @IBAction func playFast() {
        playAudio(rate: 2.0)
    }
    
    @IBAction func playChipmunk() {
        playAudio(pitch: 1000.0)
    }

    @IBAction func playDarthvader() {
        playAudio(pitch: -1000.0)
    }
    
    @IBAction func playEcho() {
        playAudio(echo: 40.0)
    }
    
    @IBAction func playReverb() {
        playAudio(reverb: 50.0)
    }
    
    @IBAction func stop() {
        stopAudio()
    }
    
    // MARK: - PRIVATE
    
    /**
    @param rate   1/32 -> 32.0
    @param pitch  -2400 -> 2400
    @param reverb 0 -> 100
    @param echo   0 -> 100
    */
    private func playAudio(rate: Float = 1.0, pitch: Float = 1.0, reverb: Float = 0.0, echo: Float = 0.0) {
        stopAudio()
        
        _audioReverb.wetDryMix = reverb
        _audioDelay.wetDryMix = echo
        _audioUnitTimePitch.pitch = pitch
        _audioUnitTimePitch.rate = rate
        
        _audioPlayerNode.scheduleFile(_audioFile, atTime: nil, completionHandler: nil)
        _audioPlayerNode.play()
    }
    
    private func stopAudio() {
        _audioPlayerNode.stop()
        _audioPlayerNode.reset()
        _audioReverb.reset()
        _audioDelay.reset()
    }
}
