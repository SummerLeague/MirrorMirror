//
//  SLCameraSessionController.swift
//  MirrorMirror
//
//  Created by Bradley Griffith on 6/19/14.
//  Copyright (c) 2014 Summer League. All rights reserved.
//

import UIKit
import AVFoundation
import CoreMedia
import CoreImage

@objc protocol SLCameraSessionControllerDelegate {
	@optional func cameraSessionDidOutputSampleBuffer(sampleBuffer: CMSampleBuffer!)
}

class SLCameraSessionController: NSObject, AVCaptureVideoDataOutputSampleBufferDelegate {
	
	var session: AVCaptureSession!
	var sessionQueue: dispatch_queue_t!
	var videoDeviceInput: AVCaptureDeviceInput!
	var videoDeviceOutput: AVCaptureVideoDataOutput!
	var stillImageOutput: AVCaptureStillImageOutput!
	var runtimeErrorHandlingObserver: AnyObject?
	
	var sessionDelegate: SLCameraSessionControllerDelegate?
	
	
	/* Class Methods
	------------------------------------------*/
	
	class func deviceWithMediaType(mediaType: NSString, position: AVCaptureDevicePosition) -> AVCaptureDevice {
		var devices: NSArray = AVCaptureDevice.devicesWithMediaType(mediaType)
		var captureDevice: AVCaptureDevice = devices.firstObject as AVCaptureDevice
		
		for object:AnyObject in devices {
			let device = object as AVCaptureDevice
			if (device.position == position) {
				captureDevice = device
				break
			}
		}
		
		return captureDevice
	}
	
	
	/* Lifecycle
	------------------------------------------*/
	
	init() {
		super.init();
		
		self.session = AVCaptureSession()
		
		self.authorizeCamera();
		
		self.sessionQueue = dispatch_queue_create("SLCameraSessionController Session", DISPATCH_QUEUE_SERIAL)
		
		dispatch_async(self.sessionQueue, {
			self.session.beginConfiguration()
			self.addVideoInput()
			self.addVideoOutput()
			self.addStillImageOutput()
			self.session.commitConfiguration()
		})
	}
	
	
	/* Instance Methods
	------------------------------------------*/
	
	func authorizeCamera() {
		AVCaptureDevice.requestAccessForMediaType(AVMediaTypeVideo, completionHandler: {
			(granted: Bool) -> Void in
			// If permission hasn't been granted, notify the user.
			if !granted {
				dispatch_async(dispatch_get_main_queue(), {
					UIAlertView(
						title: "Could not use camera!",
						message: "This application does not have permission to use camera. Please update your privacy settings.",
						delegate: self,
						cancelButtonTitle: "OK").show()
					})
			}
		});
	}
	
	func addVideoInput() -> Bool {
		var success: Bool = false
		var error: NSError?
		
		var videoDevice: AVCaptureDevice = SLCameraSessionController.deviceWithMediaType(AVMediaTypeVideo, position: AVCaptureDevicePosition.Back)
		self.videoDeviceInput = AVCaptureDeviceInput.deviceInputWithDevice(videoDevice, error: &error) as AVCaptureDeviceInput;
		if !error {
			if self.session.canAddInput(self.videoDeviceInput) {
				self.session.addInput(self.videoDeviceInput)
				success = true
			}
		}
		
		return success
	}
	
	func addVideoOutput() {
		var rgbOutputSettings: NSDictionary = NSDictionary(object: Int(CInt(kCIFormatRGBA8)), forKey: kCVPixelBufferPixelFormatTypeKey)
		
		self.videoDeviceOutput = AVCaptureVideoDataOutput()
		//self.videoDeviceOutput.videoSettings = rgbOutputSettings
		self.videoDeviceOutput.alwaysDiscardsLateVideoFrames = true
		
		self.videoDeviceOutput.setSampleBufferDelegate(self, queue: self.sessionQueue)
		
		if self.session.canAddOutput(self.videoDeviceOutput) {
			self.session.addOutput(self.videoDeviceOutput)
		}
	}
	
	func addStillImageOutput() {
		self.stillImageOutput = AVCaptureStillImageOutput()
		self.stillImageOutput.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG]
		
		if self.session.canAddOutput(self.stillImageOutput) {
			self.session.addOutput(self.stillImageOutput)
		}
	}
	
	func startCamera() {
		dispatch_async(self.sessionQueue, {
			var weakSelf: SLCameraSessionController? = self
			self.runtimeErrorHandlingObserver = NSNotificationCenter.defaultCenter().addObserverForName(AVCaptureSessionRuntimeErrorNotification, object: self.sessionQueue, queue: nil, usingBlock: {
				(note: NSNotification!) -> Void in
				
				let strongSelf: SLCameraSessionController = weakSelf!
				
				dispatch_async(strongSelf.sessionQueue, {
					strongSelf.session.startRunning()
				})
			})
			self.session.startRunning()
		})
	}
	
	func teardownCamera() {
		dispatch_async(self.sessionQueue, {
			self.session.stopRunning()
			NSNotificationCenter.defaultCenter().removeObserver(self.runtimeErrorHandlingObserver)
		})
	}
	
	func focusAndExposeAtPoint(point: CGPoint) {
		dispatch_async(self.sessionQueue, {
			var device: AVCaptureDevice = self.videoDeviceInput.device
			var error: NSErrorPointer!
			
			if device.lockForConfiguration(error) {
				if device.focusPointOfInterestSupported && device.isFocusModeSupported(AVCaptureFocusMode.AutoFocus) {
					device.focusPointOfInterest = point
					device.focusMode = AVCaptureFocusMode.AutoFocus
				}
				
				if device.exposurePointOfInterestSupported && device.isExposureModeSupported(AVCaptureExposureMode.AutoExpose) {
					device.exposurePointOfInterest = point
					device.exposureMode = AVCaptureExposureMode.AutoExpose
				}
				
				device.unlockForConfiguration()
			}
			else {
				// TODO: Log error.
			}
			})
	}
	
	func captureImage(completion:((image: UIImage?, error: NSError?) -> Void)?) {
		if !completion || !self.stillImageOutput {
			return
		}
		
		dispatch_async(self.sessionQueue, {
			
			self.stillImageOutput.captureStillImageAsynchronouslyFromConnection(self.stillImageOutput.connectionWithMediaType(AVMediaTypeVideo), completionHandler: {
				(imageDataSampleBuffer: CMSampleBuffer?, error: NSError?) -> Void in
				if !imageDataSampleBuffer || error {
					completion!(image:nil, error:nil)
				}
				else if imageDataSampleBuffer {
					var imageData: NSData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(imageDataSampleBuffer?)
					var image: UIImage = UIImage(data: imageData)
					completion!(image:image, error:nil)
				}
				})
			})
	}
	
	
	/* AVCaptureVideoDataOutput Delegate
	------------------------------------------*/

	func captureOutput(captureOutput: AVCaptureOutput!, didOutputSampleBuffer sampleBuffer: CMSampleBuffer!, fromConnection connection: AVCaptureConnection!) {
		self.sessionDelegate?.cameraSessionDidOutputSampleBuffer?(sampleBuffer)
	}
	
}