//
//  emailValidation.h
//  Cauldron
//
//  Created by John Nik on 3/25/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (emailValidation)

- (BOOL)isValidEmail;
- (NSString *)stringByReplacingWhiteSpace;
- (BOOL)isEmpty;

@end
