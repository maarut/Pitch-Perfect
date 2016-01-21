//
//  PlaySoundsViewController.swift
//  Pitch Perfect
//
//  Created by Maarut Chandegra on 12/01/2016.
//  Copyright © 2016 Maarut Chandegra. All rights reserved.
//

import AVFoundation
import UIKit

class PlaySoundsViewController: UIViewController {

    private var audioPlayerNode: AVAudioPlayerNode!
    private var audioEngine: AVAudioEngine!
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        audioPlayerNode = AVAudioPlayerNode()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func stopPlayback(sender: AnyObject)
    {
        audioPlayerNode.stop()
    }
    
    @IBAction func playSoundQuickly(sender: AnyObject)
    {
        playSoundAtRate(1.5)
    }
    
    @IBAction func playSoundSlowly(sender: AnyObject)
    {
        playSoundAtRate(0.5)
    }
    
    @IBAction func playAudioWithChipmunkFilter(sender: AnyObject)
    {
        let pitchUnit = AVAudioUnitTimePitch()
        pitchUnit.pitch = 1000
        setUpAudioEngineWithAudioUnit(pitchUnit)
        audioPlayerNode.play()
    }
    
    @IBAction func playAudioWithDarthVadarFilter(sender: AnyObject)
    {
        let pitchUnit = AVAudioUnitTimePitch()
        pitchUnit.pitch = -1000
        setUpAudioEngineWithAudioUnit(pitchUnit)
        audioPlayerNode.play()
    }
    
    private func setUpAudioEngineWithAudioUnit(unit: AVAudioUnit)
    {
        audioEngine = AVAudioEngine()
        audioPlayerNode.stop()
        audioPlayerNode.reset()
        audioEngine.attachNode(audioPlayerNode)
        audioEngine.attachNode(unit)
        audioEngine.connect(audioPlayerNode, to: unit, format: nil)
        audioEngine.connect(unit, to: audioEngine.outputNode, format: nil)
        try! audioPlayerNode.scheduleFile(AVAudioFile(forReading: recordedAudio.filePathURL), atTime: nil, completionHandler: nil)
        try! audioEngine.start()
    }
    
    private func playSoundAtRate(rate: Float)
    {
        let timeUnit = AVAudioUnitTimePitch()
        timeUnit.rate = rate
        setUpAudioEngineWithAudioUnit(timeUnit)
        audioPlayerNode.play()
    }

}
