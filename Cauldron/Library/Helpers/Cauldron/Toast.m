//
//  Toast.m
//  Cauldron
//
//  Created by Admin on 3/26/17.
//  Copyright © 2017 Logic express. All rights reserved.
//

#import "Toast.h"

@implementation Toast

+ (void) show {
    [ISMessages showCardAlertWithTitle:@"This is your title!"
                               message:@"This is your message!"
                              duration:3.f
                           hideOnSwipe:YES
                             hideOnTap:YES
                             alertType:ISAlertTypeSuccess
                         alertPosition:ISAlertPositionTop
                               didHide:^(BOOL finished) {
                                   NSLog(@"Alert did hide.");
                               }];
}
@end
