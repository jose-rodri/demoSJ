//
//  PrimeroViewController.swift
//  JSDDUPDT
//
//  Created by Jose Leoncio Quispe Rodriguez on 6/5/21.
//

import UIKit

class PrimeroViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        
        let backbutton = UIBarButtonItem(image: UIImage(named: "left_arrow_change_password") , style: .plain, target: self, action: #selector(backArrow))
        backbutton.imageInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        navigationItem.leftBarButtonItem = backbutton
    }
    
    @objc func backArrow() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                let navigationController = UINavigationController(rootViewController: vc)
        self.present(navigationController, animated: true, completion: nil)
        
    }

}
