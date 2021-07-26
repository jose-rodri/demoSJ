//
//  ContainerViewController.swift
//  JSDDUPDT
//
//  Created by Jose Leoncio Quispe Rodriguez on 6/3/21.
//

import UIKit
import FrameworkEhCOS
class ContainerViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let backbutton = UIBarButtonItem(image: UIImage(named: "left_arrow_change_password") , style: .plain, target: self, action: #selector(backArrow))
        backbutton.imageInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        navigationItem.leftBarButtonItem = backbutton
     
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print("ContainerViewController")
        
        
       
      
    }
    
    @objc func backArrow() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "TerceroViewController") as! TerceroViewController
                let navigationController = UINavigationController(rootViewController: vc)
        self.present(navigationController, animated: true, completion: nil)
        
    }
    
   
    @IBAction func NextRemote(_ sender: Any) {
        let login = LoginRouter.createModule()
        login.modalPresentationStyle = .fullScreen
        self.present(login, animated: true, completion: nil)
        
    }
    

    
}
