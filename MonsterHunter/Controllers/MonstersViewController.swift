//
//  MonstersViewController.swift
//  MonsterHunter
//
//  Created by Дмитрий on 07.02.2023.
//

import UIKit

class MonstersViewController: UIViewController {
    
    @IBOutlet weak var monstersTableView: UITableView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        monstersTableView.register(UINib(nibName: "MonsterCell", bundle: nil), forCellReuseIdentifier: "MonsterCell")

    }
}

extension MonstersViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MonstersBrain.shared.monsters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MonsterCell", for: indexPath) as? MonsterCell
        var monster = MonstersBrain.shared.monsters[indexPath.row]
        cell?.nameLabel.text = monster.name
        cell?.levelLabel.text = monster.level
        cell?.imageMonster.image = monster.currentImage
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        180
    }
}
