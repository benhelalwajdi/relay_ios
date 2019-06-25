import UIKit
import Alamofire

class HomeController: UIViewController,  UICollectionViewDelegate, UICollectionViewDataSource{

    @IBOutlet weak var newReleasesCollectionView: UICollectionView!
    @IBOutlet weak var recommendedStoresCollectionView: UICollectionView!
    @IBOutlet weak var topRatedProductsCollectionView: UICollectionView!
    
    var newReleases:NSArray = []
    var recommendedStores:NSArray = []
    var topRatedProducts:NSArray = []

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchNewReleases()
        fetchRecommendedStores()
        fetchTopRatedProducts()
        

    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView == self.newReleasesCollectionView) {
            return newReleases.count
        }else if (collectionView == self.recommendedStoresCollectionView){
            return recommendedStores.count
        }else {
            return topRatedProducts.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if(collectionView == self.newReleasesCollectionView) {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "product", for: indexPath)
            let contentview = cell.viewWithTag(0)
            let image = contentview?.viewWithTag(1) as! UIImageView
            let productName = contentview?.viewWithTag(2) as! UILabel
            
            let products = newReleases[indexPath.item] as! Dictionary<String , Any>
            productName.text = products["name"] as? String
            
            let imgURL = "http://"+Constant.IP_ADDRESS+":11809/uploads/\(products["image"] as! String)"
            image.af_setImage(withURL: URL(string: imgURL)!)
            return cell

            
        } else if (collectionView == self.recommendedStoresCollectionView){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "store", for: indexPath)

            let contentview = cell.viewWithTag(0)
            let storeName = contentview?.viewWithTag(2) as! UILabel
            let storeImage = contentview?.viewWithTag(1) as! UIImageView
            
            let stores = recommendedStores[indexPath.item] as! Dictionary<String , Any>
            storeName.text = stores["store_name"] as? String
            
            let imgURL = "http://"+Constant.IP_ADDRESS+":11809/uploads/\(stores["image"] as! String)"
            storeImage.af_setImage(withURL: URL(string: imgURL)!)
            
            storeImage.layer.cornerRadius = storeImage.frame.size.width/2
            storeImage.clipsToBounds = true
            return cell
        }else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "product", for: indexPath)
            let contentview = cell.viewWithTag(0)
            let image = contentview?.viewWithTag(1) as! UIImageView
            let productName = contentview?.viewWithTag(2) as! UILabel
            
            let products = topRatedProducts[indexPath.item] as! Dictionary<String , Any>
            productName.text = products["name"] as? String
            
            let imgURL = "http://"+Constant.IP_ADDRESS+":11809/uploads/\(products["image"] as! String)"
            image.af_setImage(withURL: URL(string: imgURL)!)
            return cell
        }
    }
    
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView == self.recommendedStoresCollectionView){
            performSegue(withIdentifier: "listProducts", sender: indexPath)
        }else if (collectionView == self.newReleasesCollectionView){
             performSegue(withIdentifier: "detailsNewProduct", sender: indexPath)
        }else {
            performSegue(withIdentifier: "detailsTopRatedProduct", sender: indexPath)

        }

    
    }
 
    func fetchNewReleases (){
        let jsonUrl = "http://"+Constant.IP_ADDRESS+":11809/products/";
        print (jsonUrl)
        Alamofire.request(jsonUrl)
            .responseJSON{response in
                self.newReleases = response.result.value! as! NSArray
                self.newReleasesCollectionView.reloadData()
                
        }
    }
    
    func fetchRecommendedStores(){
        let jsonUrl = "http://"+Constant.IP_ADDRESS+":11809/stores/";
        print (jsonUrl)
        Alamofire.request(jsonUrl)
            .responseJSON{response in
                self.recommendedStores = response.result.value! as! NSArray
                self.recommendedStoresCollectionView.reloadData()
                
    }
    }
    
    func fetchTopRatedProducts(){
        let jsonUrl = "http://"+Constant.IP_ADDRESS+":11809/products/rated";
        print (jsonUrl)
        Alamofire.request(jsonUrl)
            .responseJSON{response in
                self.topRatedProducts = response.result.value! as! NSArray
                self.topRatedProductsCollectionView.reloadData()
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "listProducts"){
            let indexPath = sender as! IndexPath
            let stores = recommendedStores[indexPath.item] as! Dictionary<String , Any>
            let destinationViewController = segue.destination as? ListProductsController
            destinationViewController?.storeId = String(describing: stores["id"] as! Int)
            destinationViewController?.sender = "STORE"

        
        }else if (segue.identifier == "detailsNewProduct"){
            let indexPath = sender as! IndexPath
            let products = newReleases[indexPath.item] as! Dictionary<String , Any>
            let destinationViewController = segue.destination as? ProductDetailsController
            destinationViewController?.idProduct = String(describing: products["id"] as! Int)
            destinationViewController?.idStore = products["id_store"] as? String

        }else if (segue.identifier == "detailsTopRatedProduct"){
            let indexPath = sender as! IndexPath
            let products = topRatedProducts[indexPath.item] as! Dictionary<String , Any>
            let destinationViewController = segue.destination as? ProductDetailsController
            destinationViewController?.idProduct = String(describing: products["id"] as! Int)
            destinationViewController?.idStore = products["id_store"] as? String
        }else if (segue.identifier == "moreNew"){
            let destinationViewController = segue.destination as? ListProductsController
            destinationViewController?.sender = "NEW"
        }else if (segue.identifier == "moreTopRated"){
            let destinationViewController = segue.destination as? ListProductsController
            destinationViewController?.sender = "TOPRATED"
        }
    }

}
