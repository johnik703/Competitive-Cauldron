//
//  NSArray+KCBJSONString.m
//  SWP
//
//  Created by John Nik on 5/7/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "NSArray+KCBJSONString.h"

@implementation NSArray (KCBJSONString)

-(NSString*) jsonStringWithPrettyPrint:(BOOL) prettyPrint {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:(NSJSONWritingOptions) (prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

-(id) objectOfType:(NSString *)name array:(NSArray *)array {
    
    return [array filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"class == %@", NSClassFromString(name)]].lastObject;
}


-(NSString *) commaStringFromArray:(NSArray *)array {
    
    NSString *returnStr = [array firstObject];
    for (int i = 1; i < array.count; i++) {
        returnStr = [returnStr stringByAppendingString:[NSString stringWithFormat:@",%@", array[i]].lowercaseString];
    }
    return returnStr;
}

@end
