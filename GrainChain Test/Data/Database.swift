//
//  Database.swift
//  GrainChain Test
//
//  Created by Misael Rivera on 30/07/20.
//  Copyright © 2020 Misael Rivera. All rights reserved.
//

import Foundation
import SQLite
import CoreLocation

class Database {
    
    var database: Connection!
    
    let routesTable = Table("routes")
    let id = Expression<Int>("id")
    let name = Expression<String>("name")
    let km = Expression<String>("km")
    let time = Expression<String>("time")
    let latitudes = Expression<String>("latitudes")
    let longitudes = Expression<String>("longitudes")
    
    func initDatabase() {
        do {
            let documentDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let fileUrl = documentDirectory.appendingPathComponent("routes").appendingPathExtension("sqlite3")
            let database = try Connection(fileUrl.path)
            self.database = database
        } catch {
            print(error)
        }
    }
    
    func createDatabase() {
        print("CREATE TAPPED")
        
        let createTable = self.routesTable.create { (table) in
            table.column(self.id, primaryKey: true)
            table.column(self.name)
            table.column(self.km)
            table.column(self.time)
            table.column(self.latitudes)
            table.column(self.longitudes)
        }
        
        do {
            try self.database.run(createTable)
            print("Created Table")
        } catch {
            print(error)
        }
    }
    
    func insertRoute(latitudes: String, longitudes: String, route: Route, completion:@escaping (_ success:Bool) ->()  ) {
        
        let routeToInsert = self.routesTable.insert(self.name <- route.name , self.km <- route.km , self.time <- route.time, self.latitudes <- latitudes, self.longitudes <- longitudes)
        
        do {
            try self.database.run(routeToInsert)
            print("INSERTED ROUTE")
            completion(true)
        } catch {
            print(error)
            completion(false)
        }
        
    }
    
    func deletePlace(idRoute: Int, completion:@escaping (_ success:Bool) ->()  ) {
        
        let place = self.routesTable.filter(self.id == idRoute)
        let deletePlace = place.delete()
        
        do {
            try self.database.run(deletePlace)
            completion(true)
        }catch {
            print(error)
            completion(false)
        }
        
    }
    
    func listRoutes() -> [Route] {
        print("LIST TAPPED")
        var routesToReturn = [Route]()
        do {
            let routes = try self.database.prepare(self.routesTable)
            for route in routes {
                routesToReturn.append(Route(name: route[self.name], km: route[self.km], time: route[self.time]))
            }
            return routesToReturn
        } catch {
            print(error)
            return routesToReturn
        }
    }
}
