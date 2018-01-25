//
//  NSDateFormatter+Utils.m
//  Cauldron
//
//  Created by John Nik on 3/25/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "NSDateFormatter+Utils.h"

@implementation NSDateFormatter (Utils)
+ (instancetype) formatterFromFormatString:(NSString *)formatStr {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = formatStr;
    
    return formatter;
}
@end
