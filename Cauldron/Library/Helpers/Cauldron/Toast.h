//
//  Toast.h
//  Cauldron
//
//  Created by Admin on 3/26/17.
//  Copyright © 2017 Logic express. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Toast : NSObject

+ (void) showWithTitle:(NSString *)title message:(NSString *)message;

@end
