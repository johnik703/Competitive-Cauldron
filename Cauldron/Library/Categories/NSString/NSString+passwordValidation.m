//
//  passwordValidation.m
//  Cauldron
//
//  Created by John Nik on 3/25/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "NSString+passwordValidation.h"

@implementation NSString (passwordValidation)

- (BOOL)isUpperLowerDigitalPassword:(int)length {
    
    if (self.length < length) {
        return false;
    }
    
    NSRegularExpression* regex = [[NSRegularExpression alloc] initWithPattern:@"^.*(?=.{6,})(?=.*[a-z])(?=.*[0-9])(?=.*[A-Z]).*$" options:0 error:nil];
    return [regex numberOfMatchesInString:self options:0 range:NSMakeRange(0, self.length)] > 0;
}

- (BOOL)isZeroLengthWithoutTrimWhiteSpace {
    NSCharacterSet *whitespace = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    if ([[self stringByTrimmingCharactersInSet:whitespace] length] == 0) {
        return true;
    }
    
    return false;
}

@end
