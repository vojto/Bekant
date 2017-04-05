//
//  AppDelegate.swift
//  Bekant
//
//  Created by Vojtech Rinik on 6/19/15.
//  Copyright (c) 2015 Vojtech Rinik. All rights reserved.
//

import Foundation
import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    var hid: HID?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        self.hid = HID()
    }


    func sync(rows: Array<Array<String>>) {
        let rows2 = rows.map { $0.joined(separator: ",") }
        let str = rows2.joined(separator: "\n") + "\n"
        
        let location = "/Users/vojto/Desktop/keystrokes.txt"
        let contents = try? String(contentsOfFile: location, encoding: String.Encoding.utf8)

        let newContents = contents!.appendingFormat(str)
        do {
            try newContents.write(toFile: location, atomically: true, encoding: String.Encoding.utf8)
        } catch _ {
        }
    }

    @IBAction func shortUp(sender: AnyObject) {
        send(1, duration: 0.5)
    }
    
    @IBAction func shortDown(sender: AnyObject) {
        send(2, duration: 0.5)
    }
    
    @IBAction func top(sender: AnyObject) {
        send(1, duration: 13)
    }
    
    @IBAction func bottom(sender: AnyObject) {
        send(2, duration: 13.5)
    }
    

    func send(_ index: UInt32, duration: TimeInterval) {
        hid!.open(index)
        
        Timer.scheduledTimer(timeInterval: duration, target: BlockOperation(block: { () -> Void in
            self.hid!.close(index)
        }), selector: #selector(Operation.main), userInfo: nil, repeats: false)

        
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

}


private class NSTimerActor {
    var block: () -> ()
    
    init(block: @escaping () -> ()) {
        self.block = block
    }
    
    dynamic func fire() {
        block()
    }
}




