//
//  Toast.h
//  Cauldron
//
//  Created by John Nik on 3/25/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ISMessages.h"

@interface KCBToast : NSObject

+ (void) showSuccessToast:(NSString *)title message:(NSString *)message;
+ (void) showErrorToast:(NSString *)title message:(NSString *)message;

@end
