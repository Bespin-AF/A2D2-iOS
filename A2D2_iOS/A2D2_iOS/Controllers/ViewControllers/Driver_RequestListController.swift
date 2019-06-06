//
//  Driver_RequestListController.swift
//  A2D2_iOS
//
//  Created by Daniel Crean on 1/16/19.
//  Copyright © 2019 Bespin. All rights reserved.
//
// NOTE: May break sections into an enum later for cleanliness
//

import UIKit

class Driver_RequestListController: UIViewController {
    
    @IBOutlet weak var requestTableView: RideRequestTableView!
    
    
    override func viewWillAppear(_ animated: Bool) {
        requestTableView.prepareForDispay()
        requestTableView.setRequestFilter(.Completed)
    }
    
    
    // NOTE: Assumes only segue is to the detail page
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //let detailView = segue.destination as! Driver_RequestDetailsController
        //let index = tableView.indexPathForSelectedRow!
        //detailView.request = getRequest(atIndex: index)
    }
}
