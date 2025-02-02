//
//  ViewController.swift
//  experiences
//
//  Created by Hector Steven on 7/12/19.
//  Copyright © 2019 Hector Steven. All rights reserved.
//

import UIKit
import MapKit

import AVFoundation

class MapViewController: UIViewController {
	var videoPlayer: AVPlayer?
	var audioPlayer: AudioPlayer?
	
	let experienceController = ExperienceController()
	
	let locationManager = CLLocationManager()
	
	@IBOutlet var mapview: MKMapView!
	@IBOutlet var postButton: UIButton!
	
	override func viewDidLoad() {
		super.viewDidLoad()
		requestLocationAccess()
		
	}
	
	override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		
		mapview.reloadInputViews()
		mapview.delegate = self
		mapview?.addAnnotations(experienceController.experinces)
		mapview.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "ExperienceAnotationView")		
	}

	@IBAction func postButtonPressed(_ sender: Any) {
	}
	
	func requestLocationAccess() {
		let status = CLLocationManager.authorizationStatus()
		
		switch status {
		case .authorizedAlways, .authorizedWhenInUse:
			return
		case .denied, .restricted:
			print("location access denied")
		default:
			locationManager.requestWhenInUseAuthorization()
		}
	}
	
	override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
		if segue.identifier == "PostViewController" {
			guard let vc = segue.destination as? PostViewController else { return }
			experienceController.currentLocation = locationManager.location?.coordinate
			vc.experienceController = experienceController
		}
	}
	
}

extension MapViewController: MKMapViewDelegate {
	func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
		guard let experience = annotation as? Experience else { return nil }
		
		let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "ExperienceAnotationView", for: annotation) as! MKMarkerAnnotationView
		
//		annotationView.glyphImage = experience.image!
		annotationView.glyphTintColor = .white
		annotationView.markerTintColor = .black
		annotationView.canShowCallout = true
		
		
		let dv = DetailView(frame: .zero)
		dv.experience = experience
		annotationView.detailCalloutAccessoryView = dv
		
		return annotationView
	}
	
	func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
//		audioPlayer?.pause()
//		audioPlayer = nil
	}
	
	func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
		
		guard let fileTitle = view.annotation?.title  else { return }
		let fileString = String(fileTitle!)
		
		audioPlayer =  AudioPlayer(name: fileString)
		
		if let duration = audioPlayer?.duration {
			print(duration)
			
		}
		audioPlayer?.play()
	}
	

	
	func playMovie(url: URL) -> AVPlayerLayer{
		videoPlayer = AVPlayer(url: url)
		let playerLayer = AVPlayerLayer(player: videoPlayer)
	//	var topRect = self.view.bounds
	//	topRect.size.width = topRect.width / 4
	//	topRect.size.height = topRect.height / 4
	//	topRect.origin.y = view.layoutMargins.top
		playerLayer.frame = .zero
		
	
		return playerLayer
	}
	
}
