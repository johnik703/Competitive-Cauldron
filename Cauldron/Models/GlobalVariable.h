//
//  GlobalVariable.h
//  Cauldron
//
//  Created by John Nik on 6/1/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef Global
#define Global [GlobalVariable sharedInstance]
#endif
#define USER_MODE_CLUB 2
#define USER_MODE_INDIVIDUAL 6
#define USER_MODE_COACH 3
#define USER_MODE_PLAYER 4
#define USER_MODE_DEMO 5
@interface GlobalVariable : NSObject

@property (nonatomic, assign) int teamSportID;
@property (nonatomic, assign) BOOL isHiddenEditProfile;

@property (nonatomic, retain) NSString *teamName;
@property (nonatomic, retain) NSString *startDate;
@property (nonatomic, retain) NSString *endDate;
@property (nonatomic, retain) NSString *appName;
@property (nonatomic, retain) NSString *playerIDFinal;

@property (nonatomic, assign) int mode;
@property (nonatomic, retain) NSMutableArray *arrTeamsId;
@property (nonatomic, retain) NSString *teamIdsForWhere;
@property (nonatomic, retain) Team *currntTeam;
@property (nonatomic, retain) NSMutableDictionary *currentChallenge;

@property (nonatomic, retain) NSArray *currendCategoryArr;
@property (nonatomic, assign) int currentTeamId;
@property (nonatomic, assign) int masterTeamId;
@property(nonatomic ,assign) int PlayerID;
@property(nonatomic, assign) int syncCount;
@property(nonatomic, assign) int attendenceSyncCount;

@property (nonatomic, retain) Signup *objSignUp;


@property (nonatomic, retain) NSMutableArray *globalInfoArr;
@property (nonatomic, retain) NSMutableArray *journalReportArr;
@property (nonatomic, retain) NSMutableArray *attendenceDateArr;
//@property (nonatomic, assign) NSInteger index;

+ (GlobalVariable *)sharedInstance;

-(void)loadUserProfileDataInLocal;

@end
