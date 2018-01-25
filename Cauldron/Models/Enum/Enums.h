//
//  Enums.h
//  Cauldron
//
//  Created by John Nik on 6/1/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef cauldron_enum
#define cauldron_enum

typedef NS_ENUM(NSInteger, UserLevel) {
    watcher = 1,
    coach = 3,
    trainer = 4,
    parent = 9,
};

typedef NS_ENUM(NSInteger, NavigationStatus) {
    NavigationStateRanking,
    NavigationStateChallenge
};

typedef NS_ENUM(NSInteger, RegisterState) {
    RegisterState_Update,
    RegisterState_Singup,
};

typedef NS_ENUM(NSInteger, TeamState) {
    
    TeamState_Update,
    TeamState_Create,
    TeamState_Add,
    TeamState_Login,
};

typedef NS_ENUM(NSInteger, RosterState) {
    
    RosterState_Update,
    RosterState_Create,
    RosterState_Add,
};

typedef NS_ENUM(NSInteger, CreateControllerState) {
    CreateControllerState_Signup,
    CreateControllerState_Logedin,
};

typedef NS_ENUM(NSInteger, CategoryState) {
    CategoryState_Add,
    CategoryState_Edit,
};

typedef NS_ENUM(NSInteger, ChallengeListState) {
    ChallengeListState_Add,
    ChallengeListState_Edit,
    ChallengeListState_Delete,
};

typedef NS_ENUM(NSInteger, CoachState) {
    CoachState_Add,
    CoachState_Edit,
    CoachState_Delete,
};

typedef NS_ENUM(NSInteger, CustomChallengeState) {
    CustomChallengeState_Add,
    CustomChallengeState_Edit,
};

typedef NS_ENUM(NSInteger, ChallengeFitnessState) {
    ChallengeFitnessState_IS,
    ChallengeFitnessState_NOT,
};

typedef NS_ENUM(NSInteger, SyncFromServerState) {
    SyncFromServerState_StartService,
    SyncFromServerState_PlayerService,
    SyncFromServerState_TeamService,
    SyncFromServerState_ChallengeService,
    SyncFromServerState_CategoryService,
    SyncFromServerState_CalStatService,
    SyncFromServerState_JournalService,
    SyncFromServerState_ChalImgaeService,
};

#endif
