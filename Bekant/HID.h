//
//  HID.h
//  Bekant
//
//  Created by Vojtech Rinik on 6/19/15.
//  Copyright (c) 2015 Vojtech Rinik. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "hidapi.h"

@interface HID : NSObject {
    hid_device *handle;
}

- (void)open:(unsigned int)index;
- (void)close:(unsigned int)index;

- (Boolean)requestAccessibility;

@end
