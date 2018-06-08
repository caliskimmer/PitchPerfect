//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Matas Empakeris on 6/3/18.
//  Copyright © 2018 MatasEmpakeris. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController {
    @IBOutlet weak var recordLabel: UILabel!
    
    let audioSession: AVAudioSession = .sharedInstance()
    var audioRecorder: AVAudioRecorder!
    var isRecording = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // TODO: send audio to next view
    }

    @IBAction func toggleRecording(_ sender: UIButton) {
        if isRecording {
            let recordImage = UIImage(named: "Microphone") as UIImage?
            sender.setBackgroundImage(recordImage, for: .normal)
            recordLabel.text = "Tap to start recording"
            isRecording = false
            
            stopRecording()
        } else {
            let stopImage = UIImage(named: "Stop") as UIImage?
            sender.setBackgroundImage(stopImage, for: .normal)
            recordLabel.text = "Tap to stop recording"
            isRecording = true
            
            recordAudio()
        }
    }
}

extension RecordViewController: AVAudioRecorderDelegate {
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "ShowEffects", sender: audioRecorder.url)
        } else {
            print("Failed to record")
        }
    }
}

private extension RecordViewController {
    func recordAudio() {
        let directory = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let filename = "voiceRecord.wav"
        let filePath = URL(string: "\(directory)/\(filename)")
        
        do {
            try audioSession.setCategory(AVAudioSessionCategoryPlayAndRecord, with: .defaultToSpeaker)
            try audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        } catch {
            print("Something went wrong...")
        }
    }
    
    func stopRecording() {
        audioRecorder.stop()
        
        do {
            try audioSession.setActive(false)
        } catch {
            print ("The audio session could not be stopped")
        }
    }
}

