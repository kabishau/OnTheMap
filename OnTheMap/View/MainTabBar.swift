import UIKit

class MainTabBar: UITabBar {

    override func layoutSubviews() {
        super.layoutSubviews()
        
        let offset: CGFloat = 6.0
   
        let imageInset = UIEdgeInsets(top: offset, left: 0, bottom: -offset, right: 0)
        
        for tabBarItem in items ?? [] {
            tabBarItem.title = ""
            tabBarItem.imageInsets = imageInset
        }
    }

}
