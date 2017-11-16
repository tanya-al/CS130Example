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
        captureSession?.addInput(input!)
        
        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)
        self.view.layer.addSublayer(videoPreviewLayer!)
        videoPreviewLayer?.frame = self.view.layer.frame
        captureSession?.startRunning()
        
        let dataOutput = AVCaptureVideoDataOutput()
        if captureSession!.canAddOutput(dataOutput) {
            captureSession?.addOutput(dataOutput)
        }
        captureSession?.commitConfiguration()
        
        let queue = DispatchQueue(label: "com.Simplicity.ItsLikeXForY")
        dataOutput.setSampleBufferDelegate(self, queue: queue)
    }
    
//    func takePhoto(
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
