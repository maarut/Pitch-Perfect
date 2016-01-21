//
//  RecordSoundsViewController.swift
//  Pitch Perfect
//
//  Created by Maarut Chandegra on 06/01/2016.
//  Copyright © 2016 Maarut Chandegra. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var recordedAudio: RecordedAudio!
    let fileName = "PitchPerfect-UserVoice.wav"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func viewWillAppear(animated: Bool)
    {
        self.stopButton.hidden = true
        self.recordButton.enabled = true
        self.recordingLabel.text = "Tap to record"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func recordAudio(sender: UIButton)
    {
        self.recordingLabel.text = "Recording"
        self.stopButton.hidden = false
        self.recordButton.enabled = false
        
        let directory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let filePath = NSURL.fileURLWithPathComponents([directory, fileName])!
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
            try! self.audioRecorder = AVAudioRecorder(URL: filePath, settings: [:])
            self.audioRecorder.delegate = self
            self.audioRecorder.meteringEnabled = true
            self.audioRecorder.prepareToRecord()
            self.audioRecorder.record()
        }
        catch {
            NSLog("Unable to set session for recording")
        }
        
    }

    @IBAction func stopRecording(sender: UIButton)
    {
        self.recordingLabel.text = nil
        self.audioRecorder.stop()
        try! AVAudioSession.sharedInstance().setActive(false)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool)
    {
        if flag {
            self.recordedAudio = RecordedAudio(filePathURL: recorder.url, title: recorder.url.lastPathComponent!)
            self.performSegueWithIdentifier("stopRecording", sender: self.recordedAudio)
        }
        else {
            NSLog("Unable to record audio")
            self.stopButton.hidden = true
            self.recordButton.enabled = true
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?)
    {
        if segue.identifier == "stopRecording" {
            let destinationVC = segue.destinationViewController as! PlaySoundsViewController
            destinationVC.recordedAudio = sender as! RecordedAudio
        }
    }
}

