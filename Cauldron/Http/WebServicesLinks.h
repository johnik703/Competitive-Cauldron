//
//  WebServiceManager.h
//  Cauldron
//
//  Created by John Nik on 6/1/17.
//  Copyright © 2017 johnik703. All rights reserved.
//



#import <Foundation/Foundation.h>

// Recieve Services
extern NSString* const loginServiceURL;
extern NSString* const newLoginServiceURL;
extern NSString* const forgotPasswordURL;

extern NSString* const playerServiceURL;
extern NSString* const challengeServiceURL;
extern NSString* const teamServiceURL;
extern NSString* const chalngCategoryServiceURL;
extern NSString* const chalngImageServiceURL;
extern NSString* const chalngStateServiceURL;
extern NSString* const journalEntry;
extern NSString* const journalDataURL;
extern NSString* const journalTeamDataURL;
extern NSString* const rankingEntryTeam;
extern NSString* const rankingEntryPlayer;
extern NSString* const attendanceReportPlayer;
extern NSString* const attendanceReportTeam;
extern NSString* const editProfile;
extern NSString* const newPlayerEdit;
extern NSString* const signUpURL;
extern NSString* const sportsList;
extern NSString* const postionList;
extern NSString* const getLoginReport;
extern NSString* const demoPostionList;
extern NSString* const rankingReport;
extern NSString* const editUserProfile;
extern NSString* const finalRanking;
extern NSString* const fitnessPassFailRanking;
extern NSString* const deleteStatsURL;
// Sending Services
extern NSString* const syncToServerSendStatsToCoachServiceURL;
extern NSString* const syncToServerSendAttendenceToCoachServiceURL;
extern NSString* const syncToServerServiceURL;
extern NSString* const syncToServerServiceURLAttandace;
extern NSString* const syncToServerServiceURLJournal;
extern NSString* const syncToServerServiceURLPlayer;
extern NSString* const syncToServerServiceURLManageTeam;
extern NSString* const syncToServerServiceURLManageChallenge;
extern NSString* const syncToServerServiceURLManageCoach;
