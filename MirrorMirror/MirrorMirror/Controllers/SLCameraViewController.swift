//
//  SLCameraViewController.swift
//  MirrorMirror
//
//  Created by Bradley Griffith on 6/2/14.
//  Copyright (c) 2014 Summer League. All rights reserved.
//

import UIKit
import CoreMedia
import AVFoundation

class SLCameraViewController: UIViewController, SLCameraSessionControllerDelegate {
	
	var cameraSessionController: SLCameraSessionController!
	var previewLayer: AVCaptureVideoPreviewLayer!
	
	
	/* Lifecycle
	------------------------------------------*/
	
	init() {
		super.init(nibName: "SLCameraView", bundle:nil);
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.cameraSessionController = SLCameraSessionController()
		self.cameraSessionController.sessionDelegate = self
		self.setupPreviewLayer()
	}
	
	override func viewWillAppear(animated: Bool) {
		super.viewWillAppear(animated)
		
		//self.navigationController.setNavigationBarHidden(true, animated: animated)
		self.cameraSessionController.startCamera()
	}
	
	override func viewWillDisappear(animated: Bool) {
		super.viewWillDisappear(animated)
		
		self.cameraSessionController.teardownCamera()
	}
	
	
	/* Instance Methods
	------------------------------------------*/
	
	func setupPreviewLayer() {
		var minSize: Float = min(self.view.bounds.size.width, self.view.bounds.size.height)
		var bounds: CGRect = CGRectMake(0.0, 0.0, minSize, minSize)
		self.previewLayer = AVCaptureVideoPreviewLayer(session: self.cameraSessionController.session)
		self.previewLayer.bounds = bounds
		self.previewLayer.position = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds))
		self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
		self.previewLayer.backgroundColor = UIColor.blackColor().CGColor // UNNECESSARY PROBABLY
		self.view.layer.addSublayer(self.previewLayer)
	}
	
	
	func cameraSessionDidOutputSampleBuffer(sampleBuffer: CMSampleBuffer!) {
	
		var imageBuffer: CVImageBufferRef = CMSampleBufferGetImageBuffer(sampleBuffer).takeUnretainedValue();

		//var width: size_t = CVPixelBufferGetWidthOfPlane(imageBuffer, 0);
		//size_t height = CVPixelBufferGetHeightOfPlane(imageBuffer, 0);
		//size_t bytesPerRow = CVPixelBufferGetBytesPerRowOfPlane(imageBuffer, 0);
	}
	
}
