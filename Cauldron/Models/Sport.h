//
//  Sport.h
//  Cauldron
//
//  Created by John Nik on 6/1/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sport : NSObject

@property (nonatomic, copy) NSString *sportID;
@property (nonatomic, copy) NSString *sportTitle;
@property (nonatomic, strong) NSArray *position;

+ (Sport *)initWithDictionary:(NSDictionary *)dic;

+ (NSString *)getIDFromTitle:(NSString *)title sports:(NSArray *)sports;
+ (Sport *)getSportInSports:(NSArray *)sports sportID:(int)sport_id;

@end
