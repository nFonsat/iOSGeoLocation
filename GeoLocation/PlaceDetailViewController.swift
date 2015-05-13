//
//  PlaceDetailViewController.swift
//  GeoLocation
//
//  Created by iem on 12/05/2015.
//  Copyright (c) 2015 iem. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class PlaceDetailViewController: UIViewController, FloatRatingViewDelegate {
    var place:Place!

    @IBOutlet weak var labelTitle: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var rateStar: FloatRatingView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Detail"
        
        labelTitle.text = place.name
        
        // Optional params
        self.rateStar.delegate = self
        self.rateStar.rating = Float(place.note)
        
        initJson()
    }
    
    // MARK: Helper UI
    
    func initJson() {
        var request = GooglePlaceService.SharedManager.getDetailPlace(place.placeId)
        
        request.responseJSON { (request, response, json, error) in
            let jsonObject = JSON(json!)
            let results = jsonObject["result"]
            
            let address = results["adr_address"].string
            if let descriptionString = address {
                let attributedOptions : [String: AnyObject] = [
                    NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType,
                    NSCharacterEncodingDocumentAttribute: NSUTF8StringEncoding
                ]
                
                let encodedData = descriptionString.dataUsingEncoding(NSUTF8StringEncoding)!
                
                var attribute = NSAttributedString(data: encodedData, options: attributedOptions, documentAttributes: nil, error: nil)
                
                if let desc = attribute {
                    self.descriptionTextView.attributedText = attribute
                }
            }
            
            let photo = results["photos"][0]
            let photoReference = photo["photo_reference"].string
            
            if let reference = photoReference {
                var size = self.imageView.frame.width
                var getPictureRequest = GooglePlaceService.SharedManager.getPicture(reference, maxWidth: Int(size))
                getPictureRequest.response { (request, response, data, error) in
                    if error == nil {
                        if let pictureDownloaded = data as? NSData{
                            var image : UIImage = UIImage(data: pictureDownloaded)!
                            self.imageView.image = image
                        }
                    }
                }
            }
        }
    }
    
    // MARK: Action
    
    @IBAction func clearAction(sender: UIButton) {
        self.rateStar.rating = 0
        PlaceManager.SharedManager.addNoteForPlace(self.place, note: 0)
    }
    
    // MARK: FloatRatingViewDelegate
    
    func floatRatingView(ratingView: FloatRatingView, didUpdate rating: Float) {
        PlaceManager.SharedManager.addNoteForPlace(self.place, note: rating)
    }
}
