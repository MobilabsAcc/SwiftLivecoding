//
//  DashboardViewController.swift
//  mvcSample
//
//  Created by Leszek Barszcz on 05/03/2020.
//  Copyright © 2020 lpb. All rights reserved.
//

import UIKit

class DashboardViewController: UIViewController {
    
    @IBOutlet weak var bottomBar: UIView!
    
    var listViewController: UIViewController?
    let viewModel: DashboardViewModel = DashboardViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel.delegate = self
        viewModel.cityListViewModels.bind() { cityListViewModels in
            self.showCityList(cityListViewModels)
        }

        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [UIColor(red: 85.0/255.0, green: 157.0/255.0, blue: 1.0, alpha: 1.0).cgColor, UIColor.white.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 0, y: 1)
        gradientLayer.frame = view.bounds
        view.layer.insertSublayer(gradientLayer, at: 0)
        
        let mask = CAShapeLayer()
        
        mask.frame = bottomBar.bounds
        
        let path = UIBezierPath(rect: bottomBar.bounds)
        
        let amplitude: CGFloat = 0.1
        
        let width = bottomBar.frame.width
        let height = bottomBar.frame.height
        let origin = CGPoint(x: 0, y: height / 2)
        path.move(to: origin)
        for angle in stride(from: 0, through: 360.0, by: 5.0) {
            let x = origin.x + CGFloat(angle/360.0) * width
            let y = origin.y - CGFloat(sin(angle/180.0 * Double.pi)) * height * amplitude
            path.addLine(to: CGPoint(x: x, y: y))
        }
        path.addLine(to: CGPoint(x: bottomBar.frame.width, y: 0))
        path.addLine(to: CGPoint.zero)
        
        path.close()
        
        mask.path = path.cgPath
        
        bottomBar.layer.mask = mask
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.loadDataWithComobine()
    }
    
    func showCityList(_ weathers: [LocationWeatherViewModel]) {
        
        if let cityListVC = listViewController as? LocationListViewController {
            cityListVC.cityList = weathers
        } else {
            let cityListVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "LocationListViewController") as! LocationListViewController
            cityListVC.cityList = weathers
            view.insertSubview(cityListVC.view, belowSubview: bottomBar)
            
            cityListVC.view.translatesAutoresizingMaskIntoConstraints = false
            
            self.listViewController = cityListVC
            addChild(cityListVC)
            
            cityListVC.view.snp.makeConstraints { maker in
                maker.top.bottom.equalTo(view.safeAreaLayoutGuide)
                maker.leading.trailing.equalToSuperview()
            }
        }
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
    
    @IBAction func plusTapped(_ sender: UIButton) {
        //        1. Navigate to details page using segue
        //        navigateWithSegue()
        //        2. Navigate to details page using navigation controller
        //        navigateWithNavigationController()
        //        3. Navigate to details page using modal presentation
        //        navigateWithModalPresent()
        
        navigationController?.pushViewController(SearchViewController(), animated: true)
    }
    
    //    Called when we return to this view controller
    @IBAction func unwindToDashboard(_ unwindSegue: UIStoryboardSegue) {
        
        print("we're back")
    }
    
    //    Called before each segue is actually performed
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier! {
        case "toDeatails":
            print("going to details")
        case "toSettings":
            print("going to Setting")
        default:
            fatalError()
        }
        print(String(describing: sender))
        print(String(describing: segue.identifier))
    }
    
    private func navigateWithSegue() {
        //        We pass in segue identifier which was set in storyboard
        performSegue(withIdentifier: "toDeatails", sender: nil)
    }
    
    private func navigateWithNavigationController() {
        //        We instantiate the storyboard by passing it's file name to constructor.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        By having storyboard instance we can instantiate destination view controller
        let detailsViewController = storyboard.instantiateViewController(identifier: "DetailsViewController")
        //        Pushing new view controller onto navigation stack
        self.navigationController?.pushViewController(detailsViewController, animated: true)
    }
    
    private func navigateWithModalPresent() {
        //        We instantiate the storyboard by passing it's file name to constructor.
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        //        By having storyboard instance we can instantiate destination view controller
        let detailsViewController = storyboard.instantiateViewController(identifier: "DetailsViewController")
        //        We present modaly detailsViewController from current view controller
        self.present(detailsViewController, animated: true, completion: nil)
    }
}

extension DashboardViewController: DashboardViewModelDelegate {
    
    func reloadData(_ data: [LocationWeatherViewModel]) {
//        showCityList(data)
    }
}
