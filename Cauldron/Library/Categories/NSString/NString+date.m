//
//  NString+date.m
//  Cauldron
//
//  Created by John Nik on 3/25/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "NString+date.h"

@implementation NSString (date)

-(NSDate *)dateWithFormat:(NSString *)format {
    NSDate *date;
    @try {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:format];
        date = [formatter dateFromString:self];
    } @catch (NSException *exception) {
    }
    
    return date;
}

@end
