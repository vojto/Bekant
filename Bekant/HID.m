//
//  HID.m
//  Bekant
//
//  Created by Vojtech Rinik on 6/19/15.
//  Copyright (c) 2015 Vojtech Rinik. All rights reserved.
//

#import "HID.h"
#import "hidapi.h"

@implementation HID

-(id)init {
    if (self = [super init]) {
        NSLog(@"Initializing HID");
        
        [self setup];
    }
    return self;
}

- (void)setup {
    struct hid_device_info *devs, *cur_dev;
    
    
    devs = hid_enumerate(0x0, 0x0);

    cur_dev = devs;
    while (cur_dev) {
        printf("wtf");
        printf("Device Found\n  type: %04hx %04hx",
               cur_dev->vendor_id, cur_dev->product_id);
        printf("\n");
//        printf("  Manufacturer: %ls\n", cur_dev->manufacturer_string);
//        printf("  Product:      %ls\n", cur_dev->product_string);
//        printf("\n");
        cur_dev = cur_dev->next;
    }
    hid_free_enumeration(devs);

    handle = hid_open(0x16c0, 0x05df, NULL);
}

- (Boolean)requestAccessibility {
    return AXIsProcessTrustedWithOptions(CFDictionaryCreate(NULL, (const void*[]){ kAXTrustedCheckOptionPrompt }, (const void*[]){ kCFBooleanTrue }, 1, NULL, NULL));
}

- (void)open:(unsigned int)index {
    unsigned char buf[7];
    
    buf[0] = 0x00;
    buf[1] = 0xff;
    buf[2] = index;
    hid_write(handle, buf, 7);
}

- (void)close:(unsigned int)index {
    unsigned char buf[7];
    
    buf[0] = 0x00;
    buf[1] = 0xfd;
    buf[2] = index;
    hid_write(handle, buf, 7);
}

@end
