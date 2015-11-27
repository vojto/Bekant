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

    func applicationDidFinishLaunching(aNotification: NSNotification) {
        self.hid = HID()
        
        /*
[NSEvent addGlobalMonitorForEventsMatchingMask:NSKeyDownMask
handler:^(NSEvent *event){

// Activate app when pressing cmd+ctrl+alt+T
if([event modifierFlags] == 1835305 && [[event charactersIgnoringModifiers] compare:@"t"] == 0) {

[NSApp activateIgnoringOtherApps:YES];
}
}];
*/
        print("Setting up the event trap");
        
        /*
        
        hid!.requestAccessibility()
        
        var last = NSDate().timeIntervalSince1970
        var rows:[[String]] = []
        
        NSEvent.addGlobalMonitorForEventsMatchingMask(.KeyDownMask, handler: { (event) -> Void in
            let date = NSDate()
            let now = date.timeIntervalSince1970
            let diff = now - last
            last = now
            
            if (diff < 1) {
                let diffStr = String(format: "%f", diff)
                rows.append([date.description, diffStr])
            }

            
            if (rows.count > 100) {
                self.sync(rows)
                rows = []
            }
        });

        */
    }
    
    func sync(rows: Array<Array<String>>) {
        let rows2 = rows.map { $0.joinWithSeparator(",") }
        let str = rows2.joinWithSeparator("\n") + "\n"
        
        let location = "/Users/vojto/Desktop/keystrokes.txt"
        let contents = try? String(contentsOfFile: location, encoding: NSUTF8StringEncoding)

        let newContents = contents!.stringByAppendingString(str)
        do {
            try newContents.writeToFile(location, atomically: true, encoding: NSUTF8StringEncoding)
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
    

    func send(index: UInt32, duration: NSTimeInterval) {
        hid!.open(index)
        
        NSTimer.scheduledTimerWithTimeInterval(duration, target: NSBlockOperation(block: { () -> Void in
            self.hid!.close(index)
        }), selector: "main", userInfo: nil, repeats: false)

        
    }
    
    func applicationWillTerminate(aNotification: NSNotification) {
        // Insert code here to tear down your application
    }

}


private class NSTimerActor {
    var block: () -> ()
    
    init(block: () -> ()) {
        self.block = block
    }
    
    dynamic func fire() {
        block()
    }
}




