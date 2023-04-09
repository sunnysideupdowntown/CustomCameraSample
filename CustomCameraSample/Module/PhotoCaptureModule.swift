//
//  PhotoCaptureModule.swift
//  CustomCameraSample
//
//  Created by YOUNGSUN on 4/9/23.
//

import Foundation
import AVFoundation

class PhotoCaptureModule {
    
    enum ConfigureError: Error {
        case Device_Not_Found
        case Cannot_Add_Input
        case Cannot_Add_Output
        case Cannot_Set_Preset
    }
    
    private var session: AVCaptureSession!
    private var output: AVCapturePhotoOutput!
    
    /// 셋업 되었는지?
    private(set) var isSetUp = false
}

// MARK: - setup
extension PhotoCaptureModule {
    
    /// 사진 찍기 위한 AVCaptureSession을 구성한다.
    func setup(with preview: PreviewView) throws {
        
        guard self.isSetUp == false else { return }
        
        self.session = AVCaptureSession()
        self.session.beginConfiguration()
        
        do {
            try self.setupInput()
            try self.setupOutput()
            try self.setupPreset()
            self.setupPreview(preview)
        } catch {
            print(error)
            self.session = nil
            self.output = nil
            throw error
        }
        
        self.session.commitConfiguration()
        self.isSetUp = true
    }
    
    private func setupInput() throws {
        
        // Device 가져오기
        guard let videoDevice = AVCaptureDevice.default(for: .video) else {
            throw ConfigureError.Device_Not_Found
        }
        
        // 1. Input 생성
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice),
              self.session.canAddInput(videoDeviceInput)
        else {
            throw ConfigureError.Cannot_Add_Input
        }
        
        // 2. Session에 Input 추가
        self.session.addInput(videoDeviceInput)
    }
    
    private func setupOutput() throws {
        
        // 1. Output 생성
        self.output = AVCapturePhotoOutput()
        
        // 2. Session에 Output 추가
        guard self.session.canAddOutput(self.output) else {
            throw ConfigureError.Cannot_Add_Output
        }
        self.session.addOutput(self.output)
    }
    
    private func setupPreset() throws {
        
        // preset 설정
        guard self.session.canSetSessionPreset(.photo) else {
            throw ConfigureError.Cannot_Set_Preset
        }
        self.session.sessionPreset = .photo
    }
    
    private func setupPreview(_ preview: PreviewView) {
        
        // preview 설정
        preview.previewLayer.session = self.session
        preview.previewLayer.videoGravity = .resizeAspectFill
    }
}

// MARK: - Public API
extension PhotoCaptureModule {
    
    func start() {
        
        guard self.isSetUp,
              !self.session.isRunning
        else {
            return
        }
        
        DispatchQueue.global().async {
            self.session.startRunning()
        }
    }
    
    func stop() {
        
        guard self.isSetUp,
              self.session.isRunning
        else {
            return
        }
        
        DispatchQueue.global().async {
            self.session.stopRunning()
        }
    }
    
    func capture(_ delegate: AVCapturePhotoCaptureDelegate) {
        
        guard self.isSetUp,
              self.session.isRunning
        else {
            return
        }
        
        let setting = AVCapturePhotoSettings()
        setting.photoQualityPrioritization = .speed
        self.output.capturePhoto(with: setting, delegate: delegate)
    }
}
