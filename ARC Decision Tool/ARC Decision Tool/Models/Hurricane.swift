//
//  Hurricane.swift
//  ARC Decision Tool
//
//  Created by Michael McKenna on 2/20/18.
//  Copyright © 2018 Michael McKenna. All rights reserved.
//

import Foundation
import RealmSwift

/// An object managed by `Realm` representing the current hurricane
class Hurricane: Object {
    /// String: uuid of the `Hurricane`
    @objc dynamic var id: String = ""
    
    /// String: Name of the `Hurricane`
    @objc dynamic var name: String = ""
    
    /// String: Location of the `Hurricane`
    @objc dynamic var location: String = ""
    
    /// String: Describes the evacuation order during a `Hurricane` event
    @objc dynamic var evacOrder: String = ""
    
    /// Date: Landfall of the `Hurricane`
    @objc dynamic var landfall: Date = Date()
    
    @available(*, unavailable, message: "Use `landfall` instead")
    @objc dynamic var galeForceWindArrive: Date = Date()
    
    /// Date: Airport close time for the `Hurricane` event
    @objc dynamic var airportsCloseTime: Date = Date()
    
    /// Date: Lead time to open shelters for the `Hurricane` event
    @objc dynamic var leadTimeToOpenShelters: Date = Date()
    
    /// Date: Hunker down time for the `Hurricane` event
    @objc dynamic var hunkerDownTime: Date = Date()
    
    /// Date: Expected re-entry of the `Hurricane`
    @objc dynamic var expectedReEntryTime: Date = Date()
    
    /// List<Date>: list of the conference call times for Region
    let conferenceCallTimeForRegion: List<Date> = List<Date>()
    
    // List<Date>: list of the conference call times for NHQ
    let conferenceCallTimeForNHQ: List<Date> = List<Date>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
}




