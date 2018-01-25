//
//  Sport.m
//  Cauldron
//
//  Created by John Nik on 6/1/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "Sport.h"

@implementation Sport

+ (Sport *) initWithDictionary:(NSDictionary *)dic {
    Sport *sport = [[Sport alloc] init];
    sport.sportID = dic[@"ID"];
    sport.sportTitle = dic[@"Sport"];
    sport.position = (NSArray *) dic[@"position"];
    
    return sport;
}

+ (NSString *)getIDFromTitle:(NSString *)title sports:(NSArray *)sports {
    for (Sport *sport in sports) {
        if (sport.sportTitle == title) {
            return sport.sportID;
        }
    }
    
    return @"";
}

+ (Sport *)getSportInSports:(NSArray *)sports sportID:(int)sport_id {
    for (Sport *sport in sports) {
        if (sport.sportID.intValue == sport_id) {
            return sport;
        }
    }
    
    return nil;
}

@end
