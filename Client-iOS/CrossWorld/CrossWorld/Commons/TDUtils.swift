//
//  TDUtils.swift
//  socket
//
//  Created by My Macbook Pro on 11/18/16.
//  Copyright © 2016 My Macbook Pro. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SystemConfiguration
import Kingfisher
import AVFoundation
import PopupController

enum LayoutMode : Int{
    case TopLeft = 1
    case TopCenter = 2
    case TopRight = 3
    case CenterLeft = 4
    case Center = 5
    case CenterRight = 6
    case BottomLeft = 7
    case BottomRight = 9
    case BottomCenter = 8
    case belowLeft = 10
    case belowCenter = 11
    case belowRigth = 12
}
enum ImageMode : String{
    case Top = "bg_layout_top"
    case Center = "bg_layout_center"
    case Bottom = "bg_layout_bottom"
}

func delegate() -> AppDelegate {
    return UIApplication.shared.delegate as! AppDelegate
}

func applicationDocumentsDirectory() -> NSURL {
    return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last! as NSURL
}

func randomStringWithLength (len : Int) -> NSString {
    
    let letters : NSString = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789+/="
    
    let randomString : NSMutableString = NSMutableString(capacity: len)
    
    for _ in 0..<len {
        let length = UInt32 (letters.length)
        let rand = arc4random_uniform(length)
        randomString.appendFormat("%C", letters.character(at: Int(rand)))
    }
    
    return randomString
}

func writeFileWithPathURLToDocumentsDirectory(videoURL: NSURL, type: String)-> String{
    
    let videoData = NSData(contentsOf: videoURL as URL)!
    var paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
    let documentsDirectory = paths[0]
    let dateFormat = DateFormatter()
    dateFormat.dateFormat = "dd-MM-yyyy-HH:mm:SS"
    let now = NSDate()
    let theDate = dateFormat.string(from: now as Date)
    let dataPath = NSURL(fileURLWithPath: documentsDirectory).appendingPathComponent("Default Album")?.absoluteString
    if FileManager.default.fileExists(atPath: dataPath!) {
        do {
            (try FileManager.default.createDirectory(atPath: dataPath!, withIntermediateDirectories: false, attributes: nil))
        }
        catch _ {
            print("error")
        }
    }
    let videopath = String("\(documentsDirectory)/\(theDate)\(type)")
    let success = videoData.write(toFile: videopath!, atomically: false)
    print("Successs:::: \(success ? "YES" : "NO")")
    print("video path --> \(videopath)")
    
    return videopath!
}


func deleteFileInDocumentDerectorWithPath(urlFile: String) {
    let fileManager = FileManager.default
    
    if (try? fileManager.removeItem(atPath: urlFile)) != nil {
        print("Delete Success")
    }else{
        print("Could not delete file ")
    }
}


//Doc: https://gist.github.com/dufferzafar/8408391
func getSuggestQueriesYoutube(query: String, handleResponse: @escaping (_ listSuggest: NSArray)->()){
    let  OWN_DEFAULT_KEY_WORD = "" //karaoke , pokemon
    let key = query + OWN_DEFAULT_KEY_WORD
    
    let URLString = "http://suggestqueries.google.com/complete/search?json&client=firefox&ds=yt"
    
    Alamofire.request(URLString, method: .get, parameters: ["q": "\(key)"], encoding: URLEncoding.default, headers: nil).responseJSON { (Response) in
        print(Response)
        if let jsonData = try? JSONSerialization.jsonObject(with: Response.data!, options: .allowFragments) as! NSArray {
            print(jsonData)
            
            if let listSuggest = jsonData.lastObject{
                handleResponse(listSuggest as! NSArray)
            }
        }
    }
}

func getThumbnailFromFilePath(urlFilePath: NSURL)-> UIImage?{
    let movieAsset = AVURLAsset(url: urlFilePath as URL)
    let assetImageGemerator = AVAssetImageGenerator(asset: movieAsset)
    assetImageGemerator.appliesPreferredTrackTransform = true
    
    if let frameRef: CGImage = try? assetImageGemerator.copyCGImage(at: CMTimeMake(1, 1), actualTime: nil) {
        return UIImage(cgImage: frameRef)
    }
    print("thumbnail is nil")
    return nil
}

func getSizeFile(url: NSURL) -> String{
    
    let fileAttributes = try! FileManager.default.attributesOfItem(atPath: url.path!)
    let fileSizeNumber = fileAttributes[FileAttributeKey.size] as! NSNumber
    let fileSize = fileSizeNumber.int64Value
    
    var sizeMB = Double(fileSize / 1024)
    sizeMB = Double(sizeMB / 1024)
    
    let size = String(format: "%.2f", sizeMB) + " MB"
    print(size)
    return size
}

func getFilePathWithCurrentTime(type: String)-> NSURL{
    
    let _TYPE = type //.mov
    
    let date = NSDate()
    let formater = DateFormatter()
    formater.dateFormat = "yyyy-MM-dd HH:mm:ss"
    let nameFile = formater.string(from: date as Date) + "\(_TYPE)"
    
    let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    let filePath = documentsURL.appendingPathComponent("\(nameFile)")
    
    //print(filePath.description)
    
    return filePath as NSURL
}

func shareToSocial(forViewController: UIViewController, title: String, link: String){
    print("share click",title, link)
    
    let myWebsite = NSURL(string: link)
    
    let shareItems:Array = [title, myWebsite as AnyObject] as [Any]
    let activityVC = UIActivityViewController(activityItems: shareItems, applicationActivities: nil)
    // activityVC.excludedActivityTypes = [UIActivityTypePostToFacebook, UIActivityTypePostToTwitter]
    forViewController.present(activityVC, animated: true, completion: nil)
}

// 1200 -> 1,2K 9000000-> 9M
func suffixNumber(numberInput :String) -> String {
    let number = Double(numberInput)
    
    var num = Double(number!)
    let sign = ((num < 0) ? "-" : "" );
    
    num = fabs(num);
    
    if (num < 1000.0){
        return "\(sign)\(num)";
    }
    
    let exp:Int = Int(log10(num) / 3.0 ); //log10(1000));
    
    let units:[String] = ["K","M","B","T","P","E"];
    
    let roundedNum:Double = round(10 * num / pow(1000.0,Double(exp))) / 10;
    
    return "\(sign)\(roundedNum)\(units[exp-1])";
}

func randomCGFloat() -> CGFloat {
    return CGFloat(arc4random()) / CGFloat(UInt32.max)
}

func clearCacheKingfishter(){
    let cache = KingfisherManager.shared.cache
    cache.calculateDiskCacheSize { (size) in
        print("disk size in bytes: \(size)")
    }
    cache.clearDiskCache(completion: {
        cache.calculateDiskCacheSize { (size) in
            print("disk size in bytes: \(size)")
        }
    })
}

func openWifiSetting() {
    let alertController = UIAlertController (title: "Alert", message: "Turn on cellular data or use Wi-Fi to access data", preferredStyle: .alert)
    
    let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
        
//        let url:NSURL! = NSURL(string: "prefs:root=WIFI")
//        if UIApplication.shared.canOpenURL(url as URL){
//            UIApplication.shared.openURL(url as URL)
//        }else{
//            UIApplication.shared.openURL(NSURL(string: UIApplicationOpenSettingsURLString) as! URL)
//        }
        
        let urlNew = URL(string: "App-Prefs:root=WIFI") //for WIFI setting app
        let app = UIApplication.shared
        app.openURL(urlNew! as URL)
    }
    
    alertController.addAction(settingsAction)
    
    alertController.willCancel().show()
}

func isInternetAvailable() -> Bool{
    var zeroAddress = sockaddr_in()
    zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
    zeroAddress.sin_family = sa_family_t(AF_INET)
    
    let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
        $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
            SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
        }
    }
    
    var flags = SCNetworkReachabilityFlags()
    if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
        return false
    }
    let isReachable = (flags.rawValue & UInt32(kSCNetworkFlagsReachable)) != 0
    let needsConnection = (flags.rawValue & UInt32(kSCNetworkFlagsConnectionRequired)) != 0
    return (isReachable && !needsConnection)
}
//PTFormater used by Youtube API
func getTimePTFormater(videoDuration: String) -> String{
    
    var videoDurationString = videoDuration as NSString
    
    var hours: Int = 0
    var minutes: Int = 0
    var seconds: Int = 0
    let timeRange = videoDurationString.range(of: "T")
    
    videoDurationString = videoDurationString.substring(from: timeRange.location) as NSString
    while videoDurationString.length > 1 {
        
        videoDurationString = videoDurationString.substring(from: 1) as NSString
        
        let scanner = Scanner(string: videoDurationString as String) as Scanner
        var part: NSString?
        
        scanner.scanCharacters(from: NSCharacterSet.decimalDigits, into: &part)
        
        let partRange: NSRange = videoDurationString.range(of: part! as String)
        
        videoDurationString = videoDurationString.substring(from: partRange.location + partRange.length) as NSString
        let timeUnit: String = videoDurationString.substring(to: 1)
        
        
        if (timeUnit == "H") {
            hours = Int(part as! String)!
        }
        else if (timeUnit == "M") {
            minutes = Int(part as! String)!
        }
        else if (timeUnit == "S") {
            seconds   = Int(part! as String)!
        }
        else{
        }
        
    }
    if hours == 0 {
        return String(format: "%02d:%02d", minutes, seconds)
    }
    return String(format: "%02d:%02d:%02d", hours, minutes, seconds)
}

func secondsToHoursMinutesSeconds (seconds : Int) -> String {
    if seconds >= 60*60 {
        
    }else {
        return (seconds/60).addZeroToNumber() + ":" + (seconds%60).addZeroToNumber()
    }
    
    return (seconds/60/60).addZeroToNumber() + ":" + ((seconds%3600)/60).addZeroToNumber() + ":" + ((seconds%3600)%60).addZeroToNumber()
}



/**
 How to use it
 ````
 AlertView
 .alert("Are you sure?", message: "Send this message to your friend")
 .will("OK") {
 // Do something because User choose OK
 }
 // Have a cancle button
 .willCancel()
 
 ````
 */
final class AlertView {
    /**
     A builder function to make an UIAlertController.
     
     - parameter title:   Title will appear in AlertView
     - parameter message: Message in alert view
     - parameter style:   You can choose .ActionSheet or .Alert
     
     - returns: an UIAlertController, which can be config action button by DSL function below.
     */
    static func alert(title: String? = nil, message: String? = nil, style: UIAlertControllerStyle = .alert) -> UIAlertController {
        let alert = UIAlertController(
            title: title,
            message: message,
            preferredStyle: style
        )
        return alert
    }
}

extension UIAlertController {
    
    /**
     It add a cancel button into Alert View, which will close the Alert when touch on that.
     
     - parameter title:   Label of cancel button, integrated with LocalizedString.
     - parameter handler: Closure which will be notified when cancel button be tapped.
     
     - returns: an UIAlertController
     */
    func willCancel(title: String = "Cancel", handler: ((UIAlertAction) -> ())? = nil) -> UIAlertController {
//        if Define.DEV_MODE {
//            _ = self.willCopyError()
//        }
        
        return will(title: title, style: .cancel, handler: handler)
    }
    
    /**
     It add a Copy Error button into Alert View, which will close the Alert when touch on that and copy error's Description to iPhone's clipboard.
     You can copy error's Description to your Macbook's clipboard via textfile in the alert
     
     - parameter title:   Label of button, integrated with LocalizedString.
     
     - returns: an UIAlertController
     */
    func willCopyError(title: String = "Copy Error")->UIAlertController{
        self.addTextField(configurationHandler:  { (textField : UITextField!) -> Void in
            textField.text = self.title
        })
        return will(title: title, style: .default, handler: { (CopyAction) in
            UIPasteboard.general.string = self.title
        })
    }
    
    /**
     Add a button into Alert View.
     
     - parameter title:   Label of button. Integrated with LocalizedString
     - parameter style:   It can be .Default, .Cancel or .Destructive
     - parameter handler: Be notified when this button be tapped
     
     - returns: an UIAlertController
     */
    func will(title: String, style: UIAlertActionStyle = .default, handler: ((_ alertAction: UIAlertAction) -> Void)? = nil) -> UIAlertController {
        self.addAction(UIAlertAction(title: title, style: style, handler: handler))
        return self
    }
    
    /**
     Show the alert view on screen.
     
     - parameter viewController: The ViewController what you want to show AlertView above.
     - parameter animated:       Be true if you want to animate the presenting of AlertView
     - parameter completion:     Be notified when presentation finished
     */
    func present(on viewController: UIViewController, animated: Bool = true, completion: (() -> Void)? = nil) {
        viewController.present(self, animated: animated, completion: completion)
    }
    
    /**
     Show the alert view on screen.
     
     - option 1:
     myAlertController.show()
     - option 2:
     myAlertController.present(animated: true) {
     //completion code...
     }
     */
    func show() {
        //present(animated: true, completion: nil)
        UIAlertController.topViewController()?.present(self, animated: true, completion: { 
            
        })
    }
    
    func present(animated: Bool, completion: (() -> Void)?) {
        if let rootVC = UIApplication.shared.keyWindow?.rootViewController {
            presentFromController(controller: rootVC, animated: animated, completion: completion)
        }
    }
    
    private func presentFromController(controller: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if  let navVC = controller as? UINavigationController,
            let visibleVC = navVC.visibleViewController {
            presentFromController(controller: visibleVC, animated: animated, completion: completion)
        } else {
            if  let tabVC = controller as? UITabBarController,
                let selectedVC = tabVC.selectedViewController {
                presentFromController(controller: selectedVC, animated: animated, completion: completion)
            } else {
                controller.present(self, animated: animated, completion: completion)
            }
        }
    }
    
    class func topViewController(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(nav.topViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(selected)
            }
        }
        if let child = base?.childViewControllers.last {
            return topViewController(child)
        }
        if let presented = base?.presentedViewController {
            return topViewController(presented)
        }
        return base
    }
}
extension UIView {
    func layerGradient() {
        let layer : CAGradientLayer = CAGradientLayer()
        layer.frame.size = self.frame.size
        layer.frame.origin = CGPoint(x: 0.0, y: 0.0)
        layer.cornerRadius = CGFloat(frame.width / 20)
        
        let color0 = UIColor(red:250.0/255, green:250.0/255, blue:250.0/255, alpha:0.5).cgColor
        let color1 = UIColor(red:200.0/255, green:200.0/255, blue: 200.0/255, alpha:0.1).cgColor
        let color2 = UIColor(red:150.0/255, green:150.0/255, blue: 150.0/255, alpha:0.1).cgColor
        let color3 = UIColor(red:100.0/255, green:100.0/255, blue: 100.0/255, alpha:0.1).cgColor
        let color4 = UIColor(red:50.0/255, green:50.0/255, blue:50.0/255, alpha:0.1).cgColor
        let color5 = UIColor(red:0.0/255, green:0.0/255, blue:0.0/255, alpha:0.1).cgColor
        let color6 = UIColor(red:150.0/255, green:150.0/255, blue:150.0/255, alpha:0.1).cgColor
        
        layer.colors = [color0,color1,color2,color3,color4,color5,color6]
        self.layer.insertSublayer(layer, at: 0)
    }
}
extension Double {
    var degreesToRadians : Double {
        return Double(self) * Double(M_PI) / 180.0
    }
    
    func average(nums: [Double]) -> Double {
        var total = 0.0
        for vote in nums{
            total += Double(vote)
        }
        let votesTotal = Double(nums.count)
        return total/votesTotal
    }
}

extension Int{
    func average(nums: [Int]) -> Int {
        var total = 0
        for vote in nums{
            total += vote
        }
        let votesTotal = nums.count
        return total/votesTotal
    }
    
    // 9 -> 09, 5-> 05
    func addZeroToNumber()-> String{
        if self < 10 {
            return "0\(self)"
        }else {
            return "\(self)"
        }
    }
}
extension UIColor {
    static func randomColor() -> UIColor {
        let r = randomCGFloat()
        let g = randomCGFloat()
        let b = randomCGFloat()
        
        // If you wanted a random alpha, just create another
        // random number for that too.
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    static func HexToColor(hexString: String, alpha:CGFloat? = 1.0) -> UIColor {
        // Convert hex string to an integer
        let hexint = Int(self.intFromHexString(hexStr: hexString))
        let red = CGFloat((hexint & 0xff0000) >> 16) / 255.0
        let green = CGFloat((hexint & 0xff00) >> 8) / 255.0
        let blue = CGFloat((hexint & 0xff) >> 0) / 255.0
        let alpha = alpha!
        // Create color object, specifying alpha as well
        let color = UIColor(red: red, green: green, blue: blue, alpha: alpha)
        return color
    }
    static func intFromHexString(hexStr: String) -> UInt32 {
        var hexInt: UInt32 = 0
        // Create scanner
        let scanner: Scanner = Scanner(string: hexStr)
        // Tell scanner to skip the # character
        scanner.charactersToBeSkipped = NSCharacterSet(charactersIn: "#") as CharacterSet
        // Scan hex value
        scanner.scanHexInt32(&hexInt)
        return hexInt
    }
}

extension String {
    var isPhoneNumber: Bool {
        do {
            let detector = try NSDataDetector(types: NSTextCheckingResult.CheckingType.phoneNumber.rawValue)
            let matches = detector.matches(in: self, options: [], range: NSMakeRange(0, self.characters.count))
            if let res = matches.first {
                return res.resultType == .phoneNumber && res.range.location == 0 && res.range.length == self.characters.count
            } else {
                return false
            }
        } catch {
            return false
        }
    }
}

extension String {
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
    }
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    func mixWith(string: String) -> String{
        var outPut = ""
        for i in 0..<self.characters.count {
            let index = self.index(self.startIndex, offsetBy: i)
            outPut += String(self[index])
            let indexMix = string.index(string.startIndex, offsetBy: i)
            outPut += String(string[indexMix])
        }
        
        return outPut
    }
    
    func remix()->String{
        var outPut = ""
        for i in 0..<self.characters.count{
            if i % 2 == 0 {
                let index = self.index(self.startIndex, offsetBy: i)
                outPut += String(self[index])
            }
        }
        return outPut
    }
}

extension NSDictionary{
    func toJsonString()->String?{
        
        if let theJSONData = try? JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.init(rawValue: 0)){
            let theJSONText = NSString(data: theJSONData,
                                       encoding: String.Encoding.ascii.rawValue)
            return theJSONText as String?
        }else{
            return nil
        }
    }
}

extension UIView {
    func addTopBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addRightBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: self.frame.size.width - width, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
    
    func addBottomBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: width)
        self.layer.addSublayer(border)
    }
    
    func addLeftBorderWithColor(color: UIColor, width: CGFloat) {
        let border = CALayer()
        border.backgroundColor = color.cgColor
        border.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
        self.layer.addSublayer(border)
    }
}

extension UIImage {
    static func fromColor(color: UIColor) -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContext(rect.size)
        let context = UIGraphicsGetCurrentContext()
        context!.setFillColor(color.cgColor)
        context!.fill(rect)
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return img!
    }
}

extension String {
    func encripEmail() -> String{
        let token =  self.components(separatedBy: "@")
        if let email = token.first {
            let index = email.index(email.endIndex, offsetBy: -4)
            var  data = email.substring(to: index)
            data += "****@" + token.last!
            return data
        }else{
            return "@ don't exit in \(self)"
        }
    }
    
    func ecripNumber() -> String{
        if self.characters.count <= 4 {
            return self
        }
        let index = self.index(self.endIndex, offsetBy: -4)
        let right = self.substring(from: index)
        var leftString = ""
        for _ in 1...(self.characters.count - 4) {
            leftString += "*"
        }
        return leftString + right
    }
   
}

/*
 Usage:
 
 let formattedString = NSMutableAttributedString()
 formattedString
 .bold("Bold Text")
 .normal(" Normal Text ")
 .bold("Bold Text")
 */
extension NSMutableAttributedString {
    func bold(_ text:String, fontSize: CGFloat = 20, color: UIColor?) -> NSMutableAttributedString {
        var attrs:[String:AnyObject] = [NSFontAttributeName : UIFont.boldSystemFont(ofSize: fontSize)]
        if let color = color{
            attrs[NSForegroundColorAttributeName] = color
        }
        let boldString = NSMutableAttributedString(string:"\(text)", attributes:attrs)
        self.append(boldString)
        return self
    }
    
    func normal(_ text:String, color: UIColor? = nil)->NSMutableAttributedString {
        
        if let color = color {
            let attrs:[String:AnyObject] = [NSForegroundColorAttributeName : color]
            let normal = NSMutableAttributedString(string:"\(text)", attributes:attrs)
            self.append(normal)
            return self
        }else{
            let normal =  NSAttributedString(string: text)
            self.append(normal)
            return self
        }
    }
    
    func italic(_ text: String, fontSize: CGFloat = 17, color: UIColor?)-> NSMutableAttributedString {
        
        var attribute: [String: AnyObject] = [NSFontAttributeName: UIFont.italicSystemFont(ofSize: fontSize)]
        if let color = color{
            attribute[NSForegroundColorAttributeName] = color
        }
        let italic = NSAttributedString(string: text, attributes: attribute)
        self.append(italic)
        return self
    }
}


class TDUtils {
    
    class func findViewControllerToShowPopup(_ base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if base!.isKind(of: PopupController.self){
            return base?.parent?.navigationController ?? base?.parent!
        }
        
        if let nav = base as? UINavigationController {
            return findViewControllerToShowPopup(nav.topViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return findViewControllerToShowPopup(selected)
            }
        }
        
        if let child = base?.childViewControllers.last {
            return findViewControllerToShowPopup(child)
        }
        if let presented = base?.presentedViewController {
            return findViewControllerToShowPopup(presented)
        }
        return base?.navigationController ?? base
    }

    static func callPhoneNumber(phone: String?){
        guard phone != nil else {
            print("Phone is nil")
            return
        }
        let tel = "telprompt://" + phone!
        if let url = URL(string: tel) {
            UIApplication.shared.openURL(url)
        }

    }
    
    static func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
    static func isValidPhoneNumber(value: String) -> Bool {
        return value.isPhoneNumber
    }
    
    static func isValidName(name: String) -> Bool {
        let valid_block = "(?:[\\p{L}\\p{M}]|\\d)"
        if name.range(of: "^" + valid_block + "$|^" + valid_block + "{16,}$", options: .regularExpression, range: nil, locale: nil) != nil{
            return true
        }

        return false
    }
    
}
