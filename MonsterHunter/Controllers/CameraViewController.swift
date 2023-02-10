//
//  CameraViewController.swift
//  MonsterHunter
//
//  Created by Дмитрий on 09.02.2023.
//

import UIKit
import AVFoundation

class CameraViewController: UIViewController {
    
    let catchButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.alpha = 0.6
        button.setTitle("Попробовать поймать", for: .normal)
        button.layer.cornerRadius = 15
        button.setTitleColor(.systemBlue, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 26)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(nil, action: #selector(catchMonster), for: .touchUpInside)
        return button
    }()
    
    let monsterView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(named: "Pitun")
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleToFill
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        var textForLabel = NSMutableAttributedString(string: "Name \n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)])
        textForLabel.append(NSMutableAttributedString(string: "Level 1", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)]))
        label.attributedText = textForLabel
        label.numberOfLines = 0
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 13
        label.backgroundColor = .black.withAlphaComponent(0.6)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let catchLabel: UILabel = {
        let label = UILabel()
        var textForLabel = NSMutableAttributedString(string: "Ура! \n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)])
        textForLabel.append(NSMutableAttributedString(string: "Вы поймали монстра Name\n в свою команду!", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)]))
        label.attributedText = textForLabel
        label.numberOfLines = 0
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 20
        label.backgroundColor = .black.withAlphaComponent(0.6)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    let attemptLabel: UILabel = {
        let label = UILabel()
        var textForLabel = NSMutableAttributedString(string: "Не вышло:( \n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)])
        textForLabel.append(NSMutableAttributedString(string: "Попробуйте поймать еще раз!", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)]))
        label.attributedText = textForLabel
        label.numberOfLines = 0
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 20
        label.backgroundColor = .black.withAlphaComponent(0.6)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    let loseLabel: UILabel = {
        let label = UILabel()
        var textForLabel = NSMutableAttributedString(string: "Печалька:( \n", attributes: [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 18)])
        textForLabel.append(NSMutableAttributedString(string: "Монстр убежал", attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 15)]))
        label.attributedText = textForLabel
        label.numberOfLines = 0
        label.layer.masksToBounds = true
        label.layer.cornerRadius = 20
        label.backgroundColor = .black.withAlphaComponent(0.6)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.isHidden = true
        return label
    }()
    
    var video = AVCaptureVideoPreviewLayer()
    // настройка сессии
    let session = AVCaptureSession()
    let cameraQueue = DispatchQueue(label: "com.shpeklord.CapturingModelQueue")

    override func viewDidLoad() {
        super.viewDidLoad()
        
        animationMonster()
        setupVideo()
        startRunning()
        setConstraints()
    }
    
    func setupVideo() {
        
        // настройка устройства видео
        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)
        
        // настройка input
        do {
            guard let device = captureDevice else { return }
            let input = try AVCaptureDeviceInput(device: device)
            session.addInput(input)
        } catch {
            fatalError(error.localizedDescription)
        }
        
        // настройка output
        let output = AVCaptureMetadataOutput()
        session.addOutput(output)
        
        video = AVCaptureVideoPreviewLayer(session: session)
        video.frame = view.layer.bounds
    }
    
    func startRunning() {
        view.layer.addSublayer(video)
        view.addSubview(catchButton)
        view.addSubview(monsterView)
        view.addSubview(nameLabel)
        view.addSubview(catchLabel)
        view.addSubview(attemptLabel)
        view.addSubview(loseLabel)
        cameraQueue.async {
            self.session.startRunning()
        }
    }
    
    @objc func catchMonster() {
        
        if catchButton.currentTitle == "Перейти к карте" {
            _ = navigationController?.popViewController(animated: true)
        } else {
            let percentCapture = [1, 2, 3, 4, 5].randomElement()
            if percentCapture == 1 {
                catchLabel.isHidden = false
                loseLabel.isHidden = true
                attemptLabel.isHidden = true
                animationMonsterCatch()
                catchButton.setTitle("Перейти к карте", for: .normal)
            } else {
                let percentEscape = [1, 2, 3].randomElement()
                if percentEscape == 1 {
                    loseLabel.isHidden = false
                    catchLabel.isHidden = true
                    attemptLabel.isHidden = true
                    animationMonsterRunAway()
                    catchButton.setTitle("Перейти к карте", for: .normal)
                } else {
                    attemptLabel.isHidden = false
                    loseLabel.isHidden = true
                    catchLabel.isHidden = true
                }
            }
        }
    }
    
    
}

extension CameraViewController {
    
    func animationMonster() {
        UIView.animateKeyframes(withDuration: 0.6,
                                delay: 0,
                                options: [.repeat, .autoreverse]) {
            self.monsterView.transform = CGAffineTransform(scaleX: 1.05, y: 1.05)
        }
    }
    
    func animationMonsterCatch() {
        UIView.animateKeyframes(withDuration: 1,
                                delay: 0) {
            self.monsterView.transform = CGAffineTransform(translationX: self.view.center.x, y: 1000)
        }
    }
    
    func animationMonsterRunAway() {
        UIView.animateKeyframes(withDuration: 1,
                                delay: 0) {
            self.monsterView.transform = CGAffineTransform(translationX: self.view.center.x, y: -1000)
        }
    }
}

extension CameraViewController {
    
    func setConstraints() {
        NSLayoutConstraint.activate([
            catchButton.heightAnchor.constraint(equalToConstant: 60),
            catchButton.widthAnchor.constraint(equalToConstant: 300),
            catchButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -30),
            catchButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            monsterView.heightAnchor.constraint(equalToConstant: 230),
            monsterView.widthAnchor.constraint(equalToConstant: 160),
            monsterView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            monsterView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.heightAnchor.constraint(equalToConstant: 50),
            nameLabel.widthAnchor.constraint(equalToConstant: 100),
            nameLabel.topAnchor.constraint(equalTo: monsterView.topAnchor, constant: -60),
            nameLabel.rightAnchor.constraint(equalTo: monsterView.rightAnchor, constant: 30)
        ])
        
        NSLayoutConstraint.activate([
            catchLabel.heightAnchor.constraint(equalToConstant: 100),
            catchLabel.widthAnchor.constraint(equalToConstant: 240),
            catchLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            catchLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            attemptLabel.heightAnchor.constraint(equalToConstant: 100),
            attemptLabel.widthAnchor.constraint(equalToConstant: 200),
            attemptLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            attemptLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        NSLayoutConstraint.activate([
            loseLabel.heightAnchor.constraint(equalToConstant: 100),
            loseLabel.widthAnchor.constraint(equalToConstant: 200),
            loseLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            loseLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
}
