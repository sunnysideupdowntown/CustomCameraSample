//
//  ViewController.swift
//  CustomCameraSample
//
//  Created by YOUNGSUN on 4/9/23.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        // 카메라 화면 여는 버튼 추가
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Camera", for: .normal)
        button.setTitleColor(.blue, for: .normal)
        button.addTarget(self, action: #selector(cameraButtonTapped), for: .touchUpInside)
        
        self.view.addSubview(button)
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    @objc private func cameraButtonTapped() {
        
        let status = AVCaptureDevice.authorizationStatus(for: .video)
        
        switch status {
            
        // 권한 O -> 카메라 화면 보여줌
        case .authorized:
            let cameraViewController = CustomCameraViewController()
            cameraViewController.modalPresentationStyle = .overFullScreen
            cameraViewController.modalTransitionStyle = .coverVertical
            self.present(cameraViewController, animated: true)
            
        // 결정 X -> 권한 요청
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) {_ in }
        
        default:
            break
        }
    }
}

