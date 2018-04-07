//
//  VideoCaptureView.swift
//  Go
//
//  Created by Kaichi Momose on 2018/04/06.
//  Copyright © 2018 Chris Mauldin. All rights reserved.
//

import UIKit
import AVFoundation
import SnapKit

class VideoCaptureView: UIView, AVCaptureFileOutputRecordingDelegate, CameraButtonDelegate, SwitchCameraDelegate {
    
    let progress = ProgressView(frame: CGRect(x: 0, y: 0, width: 110, height: 110))
    let recordButton = CameraButton()
    let switchButton = SwitchCamButton()
    let captureSession = AVCaptureSession()
    let movieOutput = AVCaptureMovieFileOutput()
    var preViewLayer: AVCaptureVideoPreviewLayer!
    var activeInput: AVCaptureDeviceInput!
    var outputURL: URL!
    
    enum CameraPosition {
        case frout
        case rear
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = UIColor.black
        
        if setupSession() {
            setupPreview()
            startSession()
        }
        
        recordButton.cameraButtonDelegate = self
        switchButton.delegate = self
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupSession() -> Bool {
        // sets quality level or bitrate of the output
        captureSession.sessionPreset = AVCaptureSession.Preset.high
        
        // Setup Camera
        guard let camera = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .unspecified) else {return false}

        do {
            let input = try AVCaptureDeviceInput(device: camera)
            if captureSession.canAddInput(input) {
                captureSession.addInput(input)
                activeInput = input
            }
        } catch {
            print("Error setting device video input: \(error)")
            return false
        }
        
        // Setup Microphone
        guard let microphone = AVCaptureDevice.default(for: .audio) else {return false}
        
        do  {
            let micInput = try AVCaptureDeviceInput(device: microphone)
            if captureSession.canAddInput(micInput) {
                captureSession.addInput(micInput)
            }
        } catch {
            print("Error setting device audio input: \(error)")
            return false
        }
        
        // Movie output
        if captureSession.canAddOutput(movieOutput) {
            captureSession.addOutput(movieOutput)
        }
        
        return true
    }
    
    /// Swap camera and reconfigures camera session with new input
    func switchCam() {

        // Get current input
        guard let input = captureSession.inputs[0] as? AVCaptureDeviceInput else { return }
        
        // Begin new session configuration and defer commit
        captureSession.beginConfiguration()
        defer { captureSession.commitConfiguration() }
        
        // Create new capture device
        var newDevice: AVCaptureDevice?
        if activeInput.device.position == .back {
            newDevice = captureDevice(with: .front)
        } else {
            newDevice = captureDevice(with: .back)
        }
        
        guard let newDev = newDevice else { return }
        // Create new capture input
        var deviceInput: AVCaptureDeviceInput!
        do {
            deviceInput = try AVCaptureDeviceInput(device: newDev)
        } catch let error {
            print(error.localizedDescription)
            return
        }
        
        // Swap capture device inputs
        captureSession.removeInput(input)
        if captureSession.canAddInput(deviceInput) {
            captureSession.addInput(deviceInput)
            activeInput = deviceInput
        } else {
            print("switch failed")
        }
    }
    
    /// Create new capture device with requested position
    fileprivate func captureDevice(with position: AVCaptureDevice.Position) -> AVCaptureDevice? {
        
        let devices = AVCaptureDevice.DiscoverySession(deviceTypes: [ .builtInWideAngleCamera, .builtInMicrophone, .builtInDualCamera, .builtInTelephotoCamera ], mediaType: AVMediaType.video, position: .unspecified).devices
        
        for device in devices {
            if device.position == position {
                return device
            }
        }
        
        return nil
    }
    
    func setupPreview() {
        // Configure previewLayer
        preViewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        preViewLayer.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        preViewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        self.layer.addSublayer(preViewLayer)
    }
    
    func startSession() {
        if !captureSession.isRunning {
            DispatchQueue.main.async {
                self.captureSession.startRunning()
            }
        }
    }
    
    //delegation
    func capture() {
        startRecording()
    }
    
    func stopCapture() {
        stopRecording()
    }
    
    func stopSession() {
        if captureSession.isRunning {
            DispatchQueue.main.async {
                self.captureSession.stopRunning()
            }
        }
    }
    
    func currentVideoOrientation() -> AVCaptureVideoOrientation {
        
        switch UIDevice.current.orientation {
        case .portrait:
            return .portrait
        case .landscapeLeft:
            return .landscapeLeft
        case .portraitUpsideDown:
            return .portraitUpsideDown
        default:
            return .landscapeRight
        }
        
    }
    
    func startRecording() {
        if !movieOutput.isRecording {
            guard let connection = movieOutput.connection(with: .video) else {return}
            if connection.isVideoOrientationSupported {
                connection.videoOrientation = currentVideoOrientation()
            }
            
            if connection.isVideoStabilizationSupported {
                connection.preferredVideoStabilizationMode = AVCaptureVideoStabilizationMode.auto
            }
            
            let device = activeInput.device
            if device.isSmoothAutoFocusSupported {
                do {
                    try device.lockForConfiguration()
                    device.isSmoothAutoFocusEnabled = false
                    device.unlockForConfiguration()
                } catch {
                    print("Error setting configuration: \(error)")
                }
            }
        } else {
            stopRecording()
        }
        
        outputURL = tempURL()
        movieOutput.startRecording(to: outputURL, recordingDelegate: self)
    }
    
    func stopRecording() {
        if movieOutput.isRecording == true {
            movieOutput.stopRecording()
        }
    }
    
    func tempURL() -> URL? {
        let directory = NSTemporaryDirectory() as NSString
        let date = Date()
        if directory != "" {
            let path = directory.appendingPathComponent(date.convertToString() + ".mp4")
            return URL(fileURLWithPath: path)
        }
        
        return nil
    }
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        if let err = error {
            print("Error recording movie: \(err.localizedDescription)")
        } else {
            progress.didAnimate = false
            let videoPlayBackVC = VideoPlayBackViewController()
            videoPlayBackVC.videoURL = outputFileURL
            var thisVC = UIApplication.shared.keyWindow?.rootViewController
            while thisVC?.presentedViewController != nil {
                thisVC = thisVC?.presentedViewController
            }
            thisVC?.present(videoPlayBackVC, animated: true, completion: nil)
//            thisVC?.show(videoPlayBackVC, sender: self)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        self.addSubview(progress)
        self.addSubview(recordButton)
        self.addSubview(switchButton)
        setupConstraints()
        
    }
    
    func setupConstraints() {
        self.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        recordButton.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
//            make.centerY.equalToSuperview()
            make.bottom.equalToSuperview().offset(-40)
            make.height.equalTo(100)
            make.width.equalTo(100)
        }
        
        progress.snp.makeConstraints { (make) in
            make.center.equalTo(recordButton.snp.center)
            make.height.equalTo(110)
            make.width.equalTo(110)
        }
        
        switchButton.snp.makeConstraints { (make) in
            make.left.equalTo(recordButton.snp.right).offset(20)
            make.centerY.equalTo(recordButton.snp.centerY)
            make.height.equalTo(32)
            make.width.equalTo(32)
        }
    }
    
    func captureDuration(seconds: Int) {
        progress.didAnimate = true
        progress.animateCircle(duration: TimeInterval(seconds))
    }
}
