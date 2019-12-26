//
//  GoHomeController.swift
//  Vita WatchKit Extension
//
//  Created by Mohith Damarapati on 12/1/19.
//  Copyright © 2019 New York University. All rights reserved.
//

import WatchKit
import Foundation


class GoHomeController: WKInterfaceController {

    @IBOutlet weak var map: WKInterfaceMap!
    
    @IBOutlet weak var image: WKInterfaceImage!
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        let lat = Double("40.72858")
        let long = Double("-73.99552")
        map.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2DMake(lat!, long!), latitudinalMeters: 500, longitudinalMeters: 500))
        let funImage: UIImage = #imageLiteral(resourceName: "dream")
        image.setImage(funImage)
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }

}
