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
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        stopButton.hidden = true
        recordButton.enabled = true
        recordingLabel.text = "Tap to record"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    @IBAction func recordAudio(sender: UIButton)
    {
        recordingLabel.text = "Recording"
        stopButton.hidden = false
        recordButton.enabled = false
        
        let directory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        let filePath = NSURL.fileURLWithPathComponents([directory, fileName])!
        
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
            try! audioRecorder = AVAudioRecorder(URL: filePath, settings: [:])
            audioRecorder.delegate = self
            audioRecorder.meteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        }
        catch {
            NSLog("Unable to set session for recording")
        }
        
    }

    @IBAction func stopRecording(sender: UIButton)
    {
        recordingLabel.text = nil
        audioRecorder.stop()
        try! AVAudioSession.sharedInstance().setActive(false)
    }
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool)
    {
        if flag {
            recordedAudio = RecordedAudio(filePathURL: recorder.url, title: recorder.url.lastPathComponent!)
            performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        }
        else {
            NSLog("Unable to record audio")
            stopButton.hidden = true
            recordButton.enabled = true
            recordingLabel.text = "Tap to record"
            let alertController = UIAlertController(title: "Failed to record audio", message: "The audio failed to record. Please ensure you have enough space to perform the recording", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Dismiss", style: .Default, handler: nil))
            presentViewController(alertController, animated: true, completion: nil)
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

