//
//  SegundoViewController.swift
//  JSDDUPDT
//
//  Created by Jose Leoncio Quispe Rodriguez on 6/5/21.
//

import UIKit

class SegundoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let backbutton = UIBarButtonItem(image: UIImage(named: "left_arrow_change_password") , style: .plain, target: self, action: #selector(backArrow))
        backbutton.imageInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
        navigationItem.leftBarButtonItem = backbutton
        
        
    }
    
    @objc func backArrow() {
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "PrimeroViewController") as! PrimeroViewController
                let navigationController = UINavigationController(rootViewController: vc)
        self.present(navigationController, animated: true, completion: nil)
        
    }
    
    
    @IBAction func nextView(_ sender: Any) {
        
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
