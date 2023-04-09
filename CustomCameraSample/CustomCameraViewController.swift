//
//  CustomCameraViewController.swift
//  CustomCameraSample
//
//  Created by YOUNGSUN on 4/9/23.
//

import UIKit
import AVFoundation

class CustomCameraViewController: UIViewController {
    
    private lazy var previewView = PreviewView()
    private lazy var captureModule = PhotoCaptureModule()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if !self.captureModule.isSetUp {
            self.setupCaptureModule()
        }
        self.captureModule.start()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.captureModule.stop()
    }
    
    private func setupUI() {
        self.view.backgroundColor = .white
        
        // Capture 버튼
        let button = UIButton()
        button.setTitle("Capture", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(captureButtonTapped), for: .touchUpInside)
        
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        // Preview
        self.view.addSubview(previewView)
        previewView.translatesAutoresizingMaskIntoConstraints = false
        previewView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        previewView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        previewView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        previewView.heightAnchor.constraint(equalTo: previewView.widthAnchor).isActive = true
    }
    
    private func setupCaptureModule() {
        do {
            try self.captureModule.setup(with: previewView)
        } catch {
            // Error -> Alert 보여준다.
            let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
            let alertAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(alertAction)
            self.present(alert, animated: true)
        }
    }
    
    @objc private func captureButtonTapped() {
        self.captureModule.capture(self)
    }
}

extension CustomCameraViewController: AVCapturePhotoCaptureDelegate {
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishProcessingPhoto photo: AVCapturePhoto, error: Error?) {
        
        let data = photo.fileDataRepresentation()
        
        // TODO: data 사용
    }
    
    func photoOutput(_ output: AVCapturePhotoOutput, didFinishCaptureFor resolvedSettings: AVCaptureResolvedPhotoSettings, error: Error?) {
        
        // 사진 찍었으니 멈춤
        self.captureModule.stop()
    }
}
