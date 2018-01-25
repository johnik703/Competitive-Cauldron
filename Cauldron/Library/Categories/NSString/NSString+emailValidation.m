//
//  emailValidation.m
//  Cauldron
//
//  Created by John Nik on 3/25/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "NSString+emailValidation.h"

@implementation NSString (emailValidation)

- (BOOL)isValidEmail {
    BOOL stricterFilter = NO; // Discussion http://blog.logichigh.com/2010/09/02/validating-an-e-mail-address/
    NSString *stricterFilterString = @"^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$";
    NSString *laxString = @"^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:self];
}

- (NSString *)stringByReplacingWhiteSpace {
    return [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]stringByReplacingOccurrencesOfString:@" "withString:@"%20"];
}

- (BOOL)isEmpty {
    if (self == nil || [self isEqualToString:@""]) {
        return true;
    }
    
    return false;
}

@end
