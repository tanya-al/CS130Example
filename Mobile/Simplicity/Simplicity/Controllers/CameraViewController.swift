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

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
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
        
        let verticalBottom: CGFloat = UIScreen.main.bounds.minY
        let horizontalCenter: CGFloat = UIScreen.main.bounds.midX
        
        let captureButton = UIButton(type: .roundedRect)
        captureButton.backgroundColor = .red
        captureButton.sizeThatFits(CGSize(width: 40, height: 40))
        captureButton.center = CGPoint(x: horizontalCenter, y: verticalBottom+80)
        captureButton.addTarget(self, action: #selector(takePhoto(_:)), for: .touchUpInside)
        self.view.insertSubview(captureButton, at: 0)
        
        let dataOutput = AVCaptureVideoDataOutput()
        if captureSession!.canAddOutput(dataOutput) {
            captureSession?.addOutput(dataOutput)
        }
        captureSession?.commitConfiguration()
        
        let queue = DispatchQueue(label: "com.ItsLikeX4Y.Simplicity")
        dataOutput.setSampleBufferDelegate(self, queue: queue)
    }
    
    func captureOutput(_ output: AVCaptureOutput, didDrop sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if takePhoto {
            takePhoto = false
            //getImagefromsmaplebuffer
            if let image = self.getImageFromSampleBuffer(buffer: sampleBuffer) {
                let photoVC = UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! PhotoViewController
                photoVC.takenPhoto = image
                
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
    
    @objc func takePhoto(_ sender  : Any) {
        takePhoto = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
