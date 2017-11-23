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

class CameraViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    var captureSession: AVCaptureSession?
    var videoPreviewLayer: AVCaptureVideoPreviewLayer?
    var takePhoto = false
    var dataOutput : AVCaptureVideoDataOutput?
    var queue = DispatchQueue(label: "com.ItsLikeX4Y.Simplicity")
    
    enum errors : Error {
        case captureSessionMissing
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        displayButton()
        
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
        captureSession?.startRunning()
        
        //capture image
        dataOutput = AVCaptureVideoDataOutput()
//        dataOutput?.setPreparedPhotoSettingsArray([AVCapturePhotoSettings(format: [AVVideoCodecKey : AVVideoCodecJPEG])], completionHandler: nil)
        dataOutput?.videoSettings = [((kCVPixelBufferPixelFormatTypeKey as NSString) as String) : NSNumber(value: kCVPixelFormatType_420YpCbCr8BiPlanarFullRange as UInt32)]
        dataOutput?.alwaysDiscardsLateVideoFrames = true
        
        if captureSession!.canAddOutput(dataOutput!) {
            captureSession?.addOutput(dataOutput!)
        }
        captureSession?.commitConfiguration()

        dataOutput?.setSampleBufferDelegate(self, queue: queue)
    }
    
    @objc func displayPreview(on view: UIView) throws {
       let photoVC = PhotoViewController(capturedImage: UIImageView(frame: (videoPreviewLayer?.frame)!))
        DispatchQueue.main.async {
            self.present(photoVC, animated: true, completion: nil)
        }
        
//        view.layer.insertSublayer(self.videoPreviewLayer!, at: 0)
//        self.videoPreviewLayer?.frame = view.frame
    }
    
    func displayButton() {
        view.backgroundColor = UIColor.white
        let verticalBottom: CGFloat = UIScreen.main.bounds.maxY
        let horizontalCenter: CGFloat = UIScreen.main.bounds.midX
        
        let captureButton = UIButton(type: .custom)
        captureButton.frame = CGRect(x: self.view.frame.size.width - 20, y: 42, width: 40, height: 40)
        captureButton.layer.cornerRadius = 0.5 * captureButton.bounds.size.width
        captureButton.clipsToBounds = true
        captureButton.backgroundColor = .red
        captureButton.center = CGPoint(x: horizontalCenter, y: verticalBottom-40)
        captureButton.addTarget(self, action: #selector(displayPreview(on:)), for: .touchUpInside)
        self.view.insertSubview(captureButton, at: 0)
    }
    
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if takePhoto {
            takePhoto = false
            //getImagefromsmaplebuffer
            if let image = self.getImageFromSampleBuffer(buffer: sampleBuffer) {
                let photoVC = PhotoViewController(capturedImage: UIImageView(image: image))
                
                DispatchQueue.main.async {
                    self.present(photoVC, animated: true, completion: nil)
                }
            }
        }
    }
    
    func getImageFromSampleBuffer (buffer : CMSampleBuffer) -> UIImage? {
        if let pixelBuffer = CMSampleBufferGetImageBuffer(buffer) {
            let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
            let context = CIContext()
            
            let imageRect = CGRect(x: 0, y: 0, width: CVPixelBufferGetWidth(pixelBuffer), height: CVPixelBufferGetHeight(pixelBuffer))
            
            if let image = context.createCGImage(ciImage, from: imageRect) {
                return UIImage(cgImage: image, scale: UIScreen.main.scale, orientation: .right)
            }
        }
        return nil
    }
    
    @IBAction func takePhoto(_ sender  : Any) {
        takePhoto = true
        captureOutput(dataOutput!, didOutput: dataOutput?.sampleBufferDelegate as! CMSampleBuffer, from: (videoPreviewLayer?.connection)!)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
