//
//  AudioPlayer.swift
//  experiences
//
//  Created by Hector Steven on 7/12/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import AVFoundation

class AudioPlayer: NSObject {
	let name: String
	private var audioPlayer: AVAudioPlayer?
	var timer: Timer?
	
	init(name: String) {
		self.name = name
		
	}
	
	private func setupPlayer() {
		let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
		
		let url = documentsDirectory.appendingPathComponent(name).appendingPathExtension("caf")
		
		do {
			audioPlayer = try AVAudioPlayer(contentsOf: url)
			audioPlayer?.delegate = self
		} catch {
			NSLog("audioPlayer: \(error)")
		}
		
		audioPlayer?.play()
		print(url)
	}
	
	func play() {
		setupPlayer()
	}
	
	func pause() {
		audioPlayer?.pause()
	}

	var isPlaying: Bool {
		return audioPlayer?.isPlaying ?? false
	}
	
	var elapsedTime: TimeInterval? {
		return audioPlayer?.currentTime
	}
	
	var duration: TimeInterval? {
		return audioPlayer?.duration
	}
	
}

extension AudioPlayer: AVAudioPlayerDelegate {
	
	func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
		if let error = error {
			fatalError("audioPlayerDecodeErrorDidOccur: \(error)")
		}
	}
	func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
		NotificationCenter.default.post(name: .audioPlayerDidFinishPlaying, object: nil)
		print("audioPlayerDidFinishPlaying")
	}
}

extension Notification.Name {
	static let audioPlayerDidFinishPlaying =  Notification.Name("AudioPlayerDidFinishPlaying")
}
