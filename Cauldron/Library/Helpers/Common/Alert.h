//
//  Alert.h
//  Cauldron
//
//  Created by John Nik on 3/25/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^AlertCompleteHandler) ();

@interface Alert : NSObject

+ (void) showAlert:(NSString *)title message:(NSString *)message viewController:(UIViewController *)viewController;
+ (void) showAlert:(NSString *)title message:(NSString *)message viewController:(UIViewController *)viewController complete:(AlertCompleteHandler)handler;
+ (void) showOKCancelAlert:(NSString *)title message:(NSString *)message viewController:(UIViewController *)viewController complete:(AlertCompleteHandler)okHandler canceled:(AlertCompleteHandler)canceledHandler;

+ (void) showYesNoAlert:(NSString *)title message:(NSString *)message viewController:(UIViewController *)viewController complete:(AlertCompleteHandler)okHandler canceled:(AlertCompleteHandler)canceledHandler;

@end
