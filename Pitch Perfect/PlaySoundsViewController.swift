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

//    private var audioPlayer: AVAudioPlayer!
    private var audioPlayerNode: AVAudioPlayerNode!
    private var audioEngine: AVAudioEngine!
    var recordedAudio: RecordedAudio!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.audioPlayerNode = AVAudioPlayerNode()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    @IBAction func stopPlayback(sender: AnyObject)
    {
        self.audioPlayerNode.stop()
    }
    
    @IBAction func playSoundQuickly(sender: AnyObject)
    {
        self.playSoundAtRate(1.5)
    }
    
    @IBAction func playSoundSlowly(sender: AnyObject)
    {
        self.playSoundAtRate(0.5)
    }
    
    @IBAction func playAudioWithChipmunkFilter(sender: AnyObject)
    {
        let pitchUnit = AVAudioUnitTimePitch()
        pitchUnit.pitch = 1000
        self.setUpAudioEngineWithAudioUnit(pitchUnit)
        audioPlayerNode.play()
    }
    
    @IBAction func playAudioWithDarthVadarFilter(sender: AnyObject)
    {
        let pitchUnit = AVAudioUnitTimePitch()
        pitchUnit.pitch = -1000
        self.setUpAudioEngineWithAudioUnit(pitchUnit)
        audioPlayerNode.play()
    }
    
    private func setUpAudioEngineWithAudioUnit(unit: AVAudioUnit)
    {
        self.audioEngine = AVAudioEngine()
        self.audioPlayerNode.stop()
        self.audioPlayerNode.reset()
        self.audioEngine.attachNode(self.audioPlayerNode)
        self.audioEngine.attachNode(unit)
        self.audioEngine.connect(self.audioPlayerNode, to: unit, format: nil)
        self.audioEngine.connect(unit, to: self.audioEngine.outputNode, format: nil)
        try! self.audioPlayerNode.scheduleFile(AVAudioFile(forReading: recordedAudio.filePathURL), atTime: nil, completionHandler: nil)
        try! audioEngine.start()
    }
    
    private func playSoundAtRate(rate: Float)
    {
        let timeUnit = AVAudioUnitTimePitch()
        timeUnit.rate = rate
        self.setUpAudioEngineWithAudioUnit(timeUnit)
        self.audioPlayerNode.play()
    }

}
