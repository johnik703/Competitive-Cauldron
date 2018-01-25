//
//  DataFetcherHelper.h
//  Cauldron
//
//  Created by John Nik on 3/25/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoginUser.h"
#import "Team.h"

@interface DataFetcherHelper : NSObject

+ (NSData *)base64DataFromString: (NSString *)string;
+ (LoginUser*)getloginDataFromDict:(NSDictionary*)loginDataDict;
+ (Team*)getCurrentTeamDataFromDict:(NSDictionary*)recieveDataDict;
+ (NSArray*)getAllPlayerDataFromDict:(NSDictionary*)recieveDataDict;
+ (NSArray*)getAllTeamDataFromDict:(NSDictionary*)recieveDataDict;
+ (NSArray*)getAllChallengeDataFromDict:(NSDictionary*)recieveDataDict;
+ (NSArray*)getAllCategoryDataFromDict:(NSDictionary*)recieveDataDict;
+ (NSArray*)getAllChallangeImageDataFromDict:(NSDictionary*)recieveDataDict;
+ (NSArray*)getAllScoreStatesDataFromDict:(NSDictionary*)recieveDataDict;
+ (NSArray*)getAllJournalDataFromDict:(NSDictionary*)recieveDataDict;
+ (NSArray*)getAllRankingDataFromDict:(NSDictionary*)recieveDataDict;
+ (NSArray*)getAllCoachesDataFromDict:(NSDictionary*)recieveDataDict;

@end
