//
//  CountryDetailsVC.swift
//  Task_21_elizbar_kheladze
//
//  Created by alta on 8/11/22.
//

import UIKit

class CountryDetailsVC: UIViewController {

    @IBOutlet weak var countryName: UILabel!
    @IBOutlet weak var countryPop: UILabel!
    @IBOutlet weak var countryImage: UIImageView!
    var countName = ""
    var countpop = ""
    var countImg = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        
        // Do any additional setup after loading the view.
    }
    

    func configure(){
        countryName.text = countName
        countryPop.text = countpop
        if let url = URL(string: countImg) {
            URLSession.shared.dataTask(with: url) {[weak self] data, _, error in
                guard let data = data , error == nil else {
                    return
                }
                DispatchQueue.main.async {
                    self?.countryImage.image = UIImage(data: data)
                }
            }.resume()
        }
    
    }

}
