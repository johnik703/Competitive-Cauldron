//
//  Alert.m
//  Cauldron
//
//  Created by John Nik on 3/25/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "Alert.h"

@implementation Alert

+ (void) showAlert:(NSString *)title message:(NSString *)message viewController:(UIViewController *)viewController {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    
    [viewController presentViewController:alert animated:true completion:nil];
}

+ (void) showAlert:(NSString *)title message:(NSString *)message titleForButton:(NSString *)titleOfButton viewController:(UIViewController *)viewController {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:titleOfButton style:UIAlertActionStyleDefault handler:nil];
    [alert addAction:okAction];
    
    [viewController presentViewController:alert animated:true completion:nil];
}

+ (void) showAlert:(NSString *)title message:(NSString *)message viewController:(UIViewController *)viewController complete:(AlertCompleteHandler)handler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        handler();
    }];
    [alert addAction:okAction];
    
    [viewController presentViewController:alert animated:true completion:nil];
}

+ (void) showOKCancelAlert:(NSString *)title message:(NSString *)message viewController:(UIViewController *)viewController complete:(AlertCompleteHandler)okHandler canceled:(AlertCompleteHandler)canceledHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (okHandler != nil) {
            okHandler();
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (canceledHandler != nil) {
            canceledHandler();
        }
    }];
    
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    
    [viewController presentViewController:alert animated:true completion:nil];
}

+ (void) showYesNoAlert:(NSString *)title message:(NSString *)message viewController:(UIViewController *)viewController complete:(AlertCompleteHandler)okHandler canceled:(AlertCompleteHandler)canceledHandler {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (okHandler != nil) {
            okHandler();
        }
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        if (canceledHandler != nil) {
            canceledHandler();
        }
    }];
    
    [alert addAction:okAction];
    [alert addAction:cancelAction];
    
    [viewController presentViewController:alert animated:true completion:nil];
}

@end
