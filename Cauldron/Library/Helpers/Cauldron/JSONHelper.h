//
//  JSONHelper.h
//  Cauldron
//
//  Created by John Nik on 3/25/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JSONHelper : NSObject
+ (NSDictionary *)loadJSONDataFromURL:(NSString *)urlString;
+ (NSDictionary *)loadJSONDataFromURLForSync:(NSString *)urlString;
+ (NSArray *)loadJSONDataFromURLArray:(NSString *)urlString;

@end
