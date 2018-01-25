//
//  Toast.m
//  Cauldron
//
//  Created by John Nik on 3/25/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "Toast.h"

@implementation KCBToast

+ (void) showSuccessToast:(NSString *)title message:(NSString *)message {
    [ISMessages showCardAlertWithTitle:title
                               message:message
                              duration:1.f
                           hideOnSwipe:YES
                             hideOnTap:YES
                             alertType:ISAlertTypeSuccess
                         alertPosition:ISAlertPositionBottom
                               didHide:^(BOOL finished) {
                                   NSLog(@"Alert did hide.");
                               }];
}

+ (void) showErrorToast:(NSString *)title message:(NSString *)message {
    [ISMessages showCardAlertWithTitle:title
                               message:message
                              duration:1.f
                           hideOnSwipe:YES
                             hideOnTap:YES
                             alertType:ISAlertTypeError
                         alertPosition:ISAlertPositionBottom
                               didHide:^(BOOL finished) {
                                   NSLog(@"Alert did hide.");
                               }];
}

@end
