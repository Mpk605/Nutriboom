//
//  OnboardingViewController.swift
//  Nutriboom
//
//  Created by Jules Combelles on 12/06/2022.
//

import UIKit

class OnboardingViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var scollView: UIScrollView!
    @IBOutlet weak var showMainAppButton: UIButton!
    
    func createSlides() -> [Slide] {
        let slide1:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide1.backgroundImage?.image = UIImage(named: "5.png")
        slide1.titleLabel.text = "Avoir une trace de vos produits"
        slide1.descriptionLabel.text = "Gardez à l'oeil l'historique des produits scannés."

        let slide2:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide2.backgroundImage?.image = UIImage(named: "3.png")
        slide2.titleLabel.text = "Scannez vos produits"
        slide2.descriptionLabel.text = "Scannez les produits alimentaires dont les compositions vous intéressent."
        
        let slide3:Slide = Bundle.main.loadNibNamed("Slide", owner: self, options: nil)?.first as! Slide
        slide3.backgroundImage?.image = UIImage(named: "4.png")
        slide3.titleLabel.text = "Analysez leurs compositions"
        slide3.descriptionLabel.text = "Découvrez leur Nutriscore ainsi que leurs compositions d'une manière claire et précise."
        
        return [slide1, slide2, slide3]
    }
    
    func setupSlideScrollView(slides : [Slide]) {
        scollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        scollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scollView.addSubview(slides[i])
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        setupSlideScrollView(slides: slides)
    }
        
    
    var slides:[Slide] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scollView.delegate = self
        
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
        view.bringSubviewToFront(showMainAppButton)
    }
    
    
    @IBAction func showMainApp(_ sender: Any) {
        let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let nav = mainStoryboard.instantiateViewController(withIdentifier: "MainView") as! UITabBarController
        let appDelegate = self.view.window?.windowScene?.delegate as! SceneDelegate
        
        appDelegate.window?.rootViewController = nav
    }
}
