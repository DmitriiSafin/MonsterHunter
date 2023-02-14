//
//  Monster.swift
//  MonsterHunter
//
//  Created by Дмитрий on 07.02.2023.
//

import UIKit

struct Monster: Codable {
    let name: String
    let level: String
    
    lazy var currentImage: UIImage = {
        let image = UIImage(named: name)
        return image ?? UIImage()
    }()
}


