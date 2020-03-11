//
//  ViewController.swift
//  mvcSample
//
//  Created by Leszek Barszcz on 05/03/2020.
//  Copyright © 2020 lpb. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func loadView() {
        super.loadView()

        /*
         Here view is being initiated from storyboards, xibs
         */
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view. Usually we set data here, no final sizes are set here

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(red: 85.0/255.0, green: 157.0/255.0, blue: 1.0, alpha: 1.0).cgColor, UIColor.white.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // Here setup everything what depends on actual device size
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Here you can start some animations which are required to be seen by users from beginning
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        // Here you can start saving data when leaving screen
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        // View is no longer visible, eg. stop animating things
    }

    @IBAction func unitTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
    }
}

