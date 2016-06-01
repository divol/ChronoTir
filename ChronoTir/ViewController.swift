//
//  ViewController.swift
//  ChronoTir
//
//  Created by Nicolas CHEVALIER on 4/11/16.
//  Copyright © 2016 Nicolas CHEVALIER. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {

	@IBOutlet weak var timeLabel: UILabel!
	@IBOutlet weak var timePreference: UISwitch!
    @IBOutlet weak var centerview:UIView!
    
	var timer = NSTimer()
	var count = 10
	var tapRecognizer: UITapGestureRecognizer!
	let beep = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bip", ofType: "wav")!)
	let doubleBeep = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bip2", ofType: "wav")!)
	let tripleBeep = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("bip3", ofType: "wav")!)
	var audioPlayer =  AVAudioPlayer()

	override func viewDidLoad() {
		super.viewDidLoad()
		
		UIApplication.sharedApplication().idleTimerDisabled = true

		self.tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.manageTimer))
		self.view.addGestureRecognizer(tapRecognizer)
		self.initViewWithValue(10, andColor: UIColor.redColor())
        
        timeLabel.font = UIFont(name: "DBLCDTempBlack", size: 60.0)
        
        timeLabel.textColor = UIColor.greenColor()
        timeLabel.backgroundColor = UIColor.blackColor()
        
        
        centerview.layer.cornerRadius = 10.0;
        centerview.layer.masksToBounds = true;
        
        
		self.updateLabel()
	}
	
	func playSound(file: NSURL) {
		do {
			try audioPlayer = AVAudioPlayer(contentsOfURL: file)
			try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
			try AVAudioSession.sharedInstance().setActive(true)
			try AVAudioSession.sharedInstance().overrideOutputAudioPort(AVAudioSessionPortOverride.Speaker)
			audioPlayer.play()
		} catch {
			print(error)
		}
	}

	func updateLabel() {
		self.timeLabel.text = "\(self.count)"
	}

	func initViewWithValue(value: Int, andColor color: UIColor) {
		count = value
		self.view.backgroundColor = color
	}
	
	func firstTimer() {
		count -= 1
		updateLabel()

		if (count == 0) {
			// Play sound
			playSound(doubleBeep)
			initViewWithValue(self.timePreference.on ? 240 : 120, andColor: UIColor.greenColor())
			updateLabel()
			timer.invalidate()
			timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ViewController.timerAction), userInfo: nil, repeats: true)
		}
	}
	
	func manageTimer() {
		if (timer.valid) {
			timer.invalidate()
			playSound(tripleBeep)
			initViewWithValue(10, andColor: UIColor.redColor())
			updateLabel()
		} else {
			// Play sound
			playSound(beep)
			timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(ViewController.firstTimer), userInfo: nil, repeats: true)
		}
	}

	func timerAction() {
		count -= 1
		if (count == 0) {
			// Play sound
			playSound(tripleBeep)
			self.view.backgroundColor = UIColor.redColor()
			timer.invalidate()
			initViewWithValue(10, andColor: UIColor.redColor())
		} else if (count <= 30) {
			self.view.backgroundColor = UIColor.yellowColor()
		} else {
			self.view.backgroundColor = UIColor.greenColor()
		}
		updateLabel()
	}

}
