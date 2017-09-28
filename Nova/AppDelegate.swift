//
//  Copyright 2017 Andrej Jurkin.
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//
//
//  AppDelegate.swift
//  Nova
//
//  Created by Andrej Jurkin on 9/3/17.
//
import Cocoa
import RxSwift
import RealmSwift

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    
    var menuBarView: MenuBarView?
    
    static func shared() -> AppDelegate {
        return NSApp.delegate as! AppDelegate
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.initRealm()
        self.menuBarView = MenuBarView()
        self.fileNotifications()
    }
    
    func initRealm() {
        let realmConfig = Realm.Configuration(deleteRealmIfMigrationNeeded: true)
        Realm.Configuration.defaultConfiguration = realmConfig
    }
    
    func clearRealm() {
        let realm = try! Realm()
        
        try! realm.write {
            realm.deleteAll()
        }
    }
    
    func onWakeNote(note: NSNotification) {
        self.menuBarView?.resume()
    }
    
    func onSleepNote(note: NSNotification) {
        self.menuBarView?.pause()
    }
    
    func fileNotifications() {
        NSWorkspace.shared().notificationCenter.addObserver(
            self, selector: #selector(onWakeNote(note:)),
            name: Notification.Name.NSWorkspaceDidWake, object: nil)
        
        NSWorkspace.shared().notificationCenter.addObserver(
            self, selector: #selector(onSleepNote(note:)),
            name: Notification.Name.NSWorkspaceWillSleep, object: nil)
    }
}

