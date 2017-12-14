//
//  CameraViewController.swift
//  Simplicity
//
//  Created by Tanya A on 11/13/17.
//  Copyright © 2017 LikeX4Y. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

/// CameraViewController: runs an AVCapture session to take pictures from
class CameraViewController: UIViewController, AVCapturePhotoCaptureDelegate {
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var takePhotoVar = false
    var dataOutput : AVCaptureVideoDataOutput?
    var stillCameraOutput : AVCapturePhotoOutput?
    var queue = DispatchQueue(label: "com.ItsLikeX4Y.Simplicity")
    var imageView : UIImageView?
    
    enum errors : Error {
        case captureSessionMissing
    }

    /// viewDidLoad
    /// - Description: sets up and starts running a camera session so the user can take a photo
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        displayCaptureButton()
        let leftBackNavigationBar = LeftBackNavigationBar(frame: view.frame, title: "Take Photo", parentVC: self)
        view.addSubview(leftBackNavigationBar)
        
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        var input : AVCaptureInput?
        do {
            input = try AVCaptureDeviceInput(device: captureDevice!)
        } catch {
            print(error)
        }
        captureSession = AVCaptureSession()
        captureSession?.sessionPreset = AVCaptureSession.Preset.photo
        captureSession?.addInput(input!)

        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        self.view.layer.addSublayer(videoPreviewLayer!)
        videoPreviewLayer?.frame = self.view.layer.frame
        
        //capture image
        stillCameraOutput = AVCapturePhotoOutput()
        stillCameraOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecJPEG])], completionHandler: nil)

        if self.captureSession!.canAddOutput(self.stillCameraOutput!) {
            self.captureSession?.addOutput(self.stillCameraOutput!)
        }
        captureSession?.commitConfiguration()
        captureSession?.startRunning()

    }
    
    /// displayCaptureButton()
    /// - Description: adds the UIButton for the user to take a photo
    func displayCaptureButton() {
        view.backgroundColor = UIColor.white
        let verticalBottom: CGFloat = UIScreen.main.bounds.maxY
        let horizontalCenter: CGFloat = UIScreen.main.bounds.midX
        
        let captureButton = UIButton(type: .custom)
        captureButton.frame = CGRect(x: self.view.frame.size.width - 20, y: 42, width: 50, height: 50)
        captureButton.layer.cornerRadius = 0.5 * captureButton.bounds.size.width
        captureButton.clipsToBounds = true
        captureButton.backgroundColor = .red
        captureButton.center = CGPoint(x: horizontalCenter, y: verticalBottom-40)
        captureButton.addTarget(self, action: #selector(takePhoto(_:)), for: .touchUpInside)
        self.view.insertSubview(captureButton, at: 0)
    }
    
    @objc func takePhoto(_ sender : Any) {
        capturePhoto()
    }
    
    /// capturePhoto()
    /// - Description: captures still camera output from the screen and triggers the photoOutput delegate
    /// - See: `photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?)`
    func capturePhoto() {
        
        let settings = AVCapturePhotoSettings()
        let previewPixelType = settings.availablePreviewPhotoPixelFormatTypes.first!
        let previewFormat = [kCVPixelBufferPixelFormatTypeKey as String: previewPixelType,
                             kCVPixelBufferWidthKey as String: 160,
                             kCVPixelBufferHeightKey as String: 160]
        settings.previewPhotoFormat = previewFormat
        self.stillCameraOutput?.capturePhoto(with: settings, delegate: self)
        
    }
    
    /// photoOutput
    ///
    /// - Description: gets the camera image, converts it to a JPEG, then a UIImage and instantiates PhotoViewController with that image
    ///
    /// - Parameters:
    ///   - output: output given by the camera
    ///   - photoSampleBuffer: photo is stored in a sample buffer
    ///   - previewPhotoSampleBuffer: preview buffer
    ///   - resolvedSettings: photo settings
    ///   - bracketSettings: still image settings
    ///   - error: any errors that occurred while taking the photo
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photoSampleBuffer: CMSampleBuffer?, previewPhoto previewPhotoSampleBuffer: CMSampleBuffer?, resolvedSettings: AVCaptureResolvedPhotoSettings, bracketSettings: AVCaptureBracketedStillImageSettings?, error: Error?) {

        if let error = error {
            print(error.localizedDescription)
        }
        
        if let sampleBuffer = photoSampleBuffer, let previewBuffer = previewPhotoSampleBuffer, let dataImage = AVCapturePhotoOutput.jpegPhotoDataRepresentation(forJPEGSampleBuffer: sampleBuffer, previewPhotoSampleBuffer: previewBuffer) {
            
            if let image = UIImage(data: dataImage) {
                print(image.size)
                let imageView = UIImageView(image: image)
                let photoVC = PhotoViewController(capturedImage: imageView)

                DispatchQueue.main.async {
                    self.present(photoVC, animated: true, completion: nil)
                }
            }
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
