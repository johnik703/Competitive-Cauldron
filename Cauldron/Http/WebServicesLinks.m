//
//  WebServiceManager.m
//  Cauldron
//
//  Created by John Nik on 6/1/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "WebServicesLinks.h"



NSString* const imageURL = @"http://competitive-cauldron.com/test/stats/media/Team/thumb/";

/* For Test, Local Web Server URL */

//static NSString * const BaseURLStringForLogin = @"http://192.168.2.116/Cauldron/stats/web_service/checklogin.php?";
//static NSString * const BaseURLStringForData = @"http://192.168.2.116/Cauldron/stats/web_service/getAppData.php?";
//
//NSString* const loginServiceURL = @"http://192.168.2.116/Cauldron/stats/web_service/checklogin.php?username=%@&password=%@";
//NSString* const newLoginServiceURL = @"http://192.168.2.116/Cauldron/stats/web_service/checklogin.php?username=%@&password=%@";
//NSString* const playerServiceURL = @"http://192.168.2.116/Cauldron/stats/web_service/getAppData.php?data=player&teamid=%d";
//NSString* const teamServiceURL = @"http://192.168.2.116/Cauldron/stats/web_service/getAppData.php?data=team&teamid=%d";
//NSString* const challengeServiceURL = @"http://192.168.2.116/Cauldron/stats/web_service/getAppData.php?data=challenge&teamid=%d";
//NSString* const chalngCategoryServiceURL = @"http://192.168.2.116/Cauldron/stats/web_service/getAppData.php?data=category&teamid=%d";
//NSString* const chalngImageServiceURL = @"http://192.168.2.116/Cauldron/stats/web_service/getAppData.php?data=chlimagedata&teamid=%d";
//NSString* const journalEntry = @"http://192.168.2.116/Cauldron/stats/web_service/getAppData.php?teamid=%d&data=journal";
//NSString* const chalngStateServiceURL = @"http://192.168.2.116/Cauldron/stats/web_service/getAppData.php?data=stats&teamid=%d";
//NSString* const rankingEntryTeam =   @"http://192.168.2.116/Cauldron/stats/web_service/getRankingReport.php?TeamID=%d&ChallengeID=%@&startDate=%@&endDate=%@";
//NSString* const rankingEntryPlayer = @"http://192.168.2.116/Cauldron/stats/web_service/getRankingReport.php?TeamID=%d&ChallengeID=%@&PlayerID=%d&startDate=%@&endDate=%@";
//NSString* const attendanceReportPlayer = @"http://192.168.2.116/Cauldron/stats/web_service/getAttendanceReport.php?TeamID=%d&startDate=%@&endDate=%@&PlayerID=%d";
//NSString* const attendanceReportTeam = @"http://192.168.2.116/Cauldron/stats/web_service/getAttendanceReport.php?TeamID=%d&startDate=%@&endDate=%@";
//NSString* const editProfile = @"http://192.168.2.116/Cauldron/stats/web_service/updateTeam.php?TeamID=%d";
//NSString* const editUserProfile = @"http://192.168.2.116/Cauldron/stats/web_service/updateuser.php?UserID=%d";
//NSString* const newPlayerEdit = @"http://192.168.2.116/Cauldron/stats/web_service/newPlayerEdit?teamID=%d&playerId=%d";
//NSString* const signUpURL = @"http://192.168.2.116/Cauldron/stats/web_service/signup.php";
//NSString* const sportsList =@"http://192.168.2.116/Cauldron/stats/web_service/getSportsList.php";
//NSString* const postionList=@"http://192.168.2.116/Cauldron/stats/web_service/getPositionList.php?TeamID=%d";
//NSString* const rankingReport=@"http://192.168.2.116/Cauldron/stats/playerfinalreport/preview?hideprint=1&code=%@";
//
///* URL for Live Server itune */
//NSString* const syncToServerServiceURL = @"http://192.168.2.116/Cauldron/stats/web_service/getStats.php";
//NSString* const syncToServerServiceURLAttandace =@"http://192.168.2.116/Cauldron/stats/web_service/getAttendance.php";
//NSString* const syncToServerServiceURLJournal =@"http://192.168.2.116/Cauldron/stats/web_service/getJournal.php";
//NSString* const syncToServerServiceURLPlayer =@"http://192.168.2.116/Cauldron/stats/web_service/roster.php";



/* Live WebService  http://competitive-cauldron.com/ To upload on iTune */
//competi1.wwwls7.a2hosted.com

static NSString * const BaseURLStringForLogin = @"http://competi1.wwwls7.a2hosted.com/stats/web_service/checklogin.php?";
static NSString * const BaseURLStringForData = @"http://competi1.wwwls7.a2hosted.com/stats/web_service/getAppData.php?";

NSString* const loginServiceURL = @"http://competi1.wwwls7.a2hosted.com/stats/web_service/checklogin.php?username=%@&password=%@";
NSString* const newLoginServiceURL = @"http://competi1.wwwls7.a2hosted.com/stats/web_service/checklogin.php?username=%@&password=%@";
NSString* const forgotPasswordURL = @"http://competitive-cauldron.com/stats/restfulAPI/forgot_password?username=%@";
NSString* const signUpURL = @"http://competi1.wwwls7.a2hosted.com/stats/web_service/signup.php";
NSString* const sportsList =@"http://competi1.wwwls7.a2hosted.com/stats/web_service//getSportsList.php";
NSString* const postionList=@"http://competi1.wwwls7.a2hosted.com/stats/web_service/getPositionList.php?TeamID=%d";

NSString* const demoPostionList=@"http://competi1.wwwls7.a2hosted.com/stats/web_service/getDemoPosition.php?sportID=%d";

NSString* const editProfile = @"http://competi1.wwwls7.a2hosted.com/stats/web_service/updateTeam.php?TeamID=%d";
NSString* const editUserProfile = @"http://competi1.wwwls7.a2hosted.com/stats/web_service/updateuser.php?UserID=%d";
NSString* const newPlayerEdit = @"http://competi1.wwwls7.a2hosted.com/stats/web_service/newPlayerEdit?teamID=%d&playerId=%d";

NSString* const playerServiceURL = @"http://competi1.wwwls7.a2hosted.com/stats/web_service/getAppData.php?data=player&teamid=%d";
NSString* const teamServiceURL = @"http://competi1.wwwls7.a2hosted.com/stats/web_service/getAppData.php?data=team&teamid=%d&PlayerID=%d&mode=%d";
NSString* const challengeServiceURL = @"http://competi1.wwwls7.a2hosted.com/stats/web_service/getAppData.php?data=challenge&teamid=%d";
NSString* const chalngCategoryServiceURL = @"http://competi1.wwwls7.a2hosted.com/stats/web_service/getAppData.php?data=category&teamid=%d";
NSString* const chalngImageServiceURL = @"http://competi1.wwwls7.a2hosted.com/stats/web_service/getAppData.php?data=chlimagedata&teamid=%d";
NSString* const journalEntry = @"http://competi1.wwwls7.a2hosted.com/stats/web_service/getAppData.php?teamid=%d&data=journal";
NSString* const journalDataURL = @"http://competi1.wwwls7.a2hosted.com/stats/web_service/getAppData.php?data=journal&teamid=%d&playerid=%d";
NSString* const journalTeamDataURL = @"http://competi1.wwwls7.a2hosted.com/stats/web_service/getAppData.php?data=journal&teamid=%d";
NSString* const chalngStateServiceURL = @"http://competi1.wwwls7.a2hosted.com/stats/web_service/getAppData.php?data=stats&teamid=%d";

NSString* const rankingEntryTeam = @"https://competitive-cauldron.com/stats/statsrank/rankingmobile?TeamID=%d&ChallengeID=%@&startDate=%@&endDate=%@";

//NSString* const rankingEntryTeam =   @"http://competi1.wwwls7.a2hosted.com/stats/web_service/getRankingReport.php?TeamID=%d&ChallengeID=%@&startDate=%@&endDate=%@";

//NSString* const rankingEntryPlayer = @"http://competi1.wwwls7.a2hosted.com/stats/web_service/getRankingReport.php?TeamID=%d&ChallengeID=%@&PlayerID=%d&startDate=%@&endDate=%@";

NSString* const rankingEntryPlayer = @"https://competitive-cauldron.com/stats/statsrank/rankingmobile?TeamID=%d&ChallengeID=%@&PlayerID=%d&startDate=%@&endDate=%@";




NSString* const attendanceReportPlayer = @"http://competi1.wwwls7.a2hosted.com/stats/web_service/getAttendanceReport.php?TeamID=%d&startDate=%@&endDate=%@&PlayerID=%@";
NSString* const attendanceReportTeam = @"http://competi1.wwwls7.a2hosted.com/stats/web_service/getAttendanceReport.php?TeamID=%d&startDate=%@&endDate=%@";
NSString* const rankingReport=@"http://competi1.wwwls7.a2hosted.com/stats/playerfinalreport/preview2?hideprint=1&code=%@";
NSString* const finalRanking = @"http://competitive-cauldron.com/stats/rankingmobile?mobile=3&TeamID=%d&User_Type=%d&PlayerID=%@";
NSString* const fitnessPassFailRanking = @"http://competitive-cauldron.com/stats/fitnessmobile?mobile=3&TeamID=%d&User_Type=%d&PlayerID=%@";
////
/////* URL for Live Server itune */

NSString* const syncToServerSendStatsToCoachServiceURL = @"http://competi1.wwwls7.a2hosted.com/stats/web_service/sendstatstocoach.php?";
NSString* const syncToServerSendAttendenceToCoachServiceURL = @"http://competi1.wwwls7.a2hosted.com/stats/web_service/sendattendancecoach.php?";
NSString* const syncToServerServiceURL = @"http://competi1.wwwls7.a2hosted.com/stats/web_service/getStats.php";
NSString* const syncToServerServiceURLAttandace =@"http://competi1.wwwls7.a2hosted.com/stats/web_service/getAttendance.php";
NSString* const syncToServerServiceURLJournal =@"http://competi1.wwwls7.a2hosted.com/stats/web_service/getJournal.php";
NSString* const syncToServerServiceURLPlayer =@"http://competi1.wwwls7.a2hosted.com/stats/web_service/roster.php";
NSString* const syncToServerServiceURLManageTeam = @"http://competi1.wwwls7.a2hosted.com/stats/web_service/teammanagement.php";
NSString* const syncToServerServiceURLManageChallenge = @"http://competi1.wwwls7.a2hosted.com/stats/web_service/challenge.php";
NSString* const syncToServerServiceURLManageCoach = @"http://competi1.wwwls7.a2hosted.com/stats/web_service/coach.php";


//static NSString * const BaseURLStringForLogin = @"http://192.168.0.8/stats/web_service/checklogin.php?";
//static NSString * const BaseURLStringForData = @"http://192.168.0.8/stats/web_service/getAppData.php?";

//NSString* const loginServiceURL = @"http://192.168.0.8/stats/web_service/checklogin.php?username=%@&password=%@";
//NSString* const newLoginServiceURL = @"http://192.168.0.8/stats/web_service/checklogin.php?username=%@&password=%@";
//NSString* const forgotPasswordURL = @"http://competitive-cauldron.com/stats/restfulAPI/forgot_password?username=%@";
//NSString* const signUpURL = @"http://192.168.0.8/stats/web_service/signup.php";
//NSString* const sportsList =@"http://192.168.0.8/stats/web_service//getSportsList.php";
//NSString* const postionList=@"http://192.168.0.8/stats/web_service/getPositionList.php?TeamID=%d";
//
//NSString* const demoPostionList=@"http://192.168.0.8/stats/web_service/getDemoPosition.php?sportID=%d";
//
//NSString* const editProfile = @"http://192.168.0.8/stats/web_service/updateTeam.php?TeamID=%d";
//NSString* const editUserProfile = @"http://192.168.0.8/stats/web_service/updateuser.php?UserID=%d";
//NSString* const newPlayerEdit = @"http://192.168.0.8/stats/web_service/newPlayerEdit?teamID=%d&playerId=%d";
//
//NSString* const playerServiceURL = @"http://192.168.0.8/stats/web_service/getAppData.php?data=player&teamid=%d";
//NSString* const teamServiceURL = @"http://192.168.0.8/stats/web_service/getAppData.php?data=team&teamid=%d&PlayerID=%d&mode=%d";
//NSString* const challengeServiceURL = @"http://192.168.0.8/stats/web_service/getAppData.php?data=challenge&teamid=%d";
//NSString* const chalngCategoryServiceURL = @"http://192.168.0.8/stats/web_service/getAppData.php?data=category&teamid=%d";
//NSString* const chalngImageServiceURL = @"http://192.168.0.8/stats/web_service/getAppData.php?data=chlimagedata&teamid=%d";
//NSString* const journalEntry = @"http://192.168.0.8/stats/web_service/getAppData.php?teamid=%d&data=journal";
//NSString* const journalDataURL = @"http://192.168.0.8/stats/web_service/getAppData.php?data=journal&teamid=%d&playerid=%d";
//NSString* const journalTeamDataURL = @"http://192.168.0.8/stats/web_service/getAppData.php?data=journal&teamid=%d";
//NSString* const chalngStateServiceURL = @"http://192.168.0.8/stats/web_service/getAppData.php?data=stats&teamid=%d";
//NSString* const rankingEntryTeam =   @"http://192.168.0.8/stats/web_service/getRankingReport.php?TeamID=%d&ChallengeID=%@&startDate=%@&endDate=%@";
//NSString* const rankingEntryPlayer = @"http://192.168.0.8/stats/web_service/getRankingReport.php?TeamID=%d&ChallengeID=%@&PlayerID=%d&startDate=%@&endDate=%@";
//NSString* const attendanceReportPlayer = @"http://192.168.0.8/stats/web_service/getAttendanceReport.php?TeamID=%d&startDate=%@&endDate=%@&PlayerID=%d";
//NSString* const attendanceReportTeam = @"http://192.168.0.8/stats/web_service/getAttendanceReport.php?TeamID=%d&startDate=%@&endDate=%@";
//NSString* const rankingReport=@"http://http://192.168.0.8/stats/playerfinalreport/preview2?hideprint=1&code=%@";
//NSString* const finalRanking = @"http://competitive-cauldron.com/stats/rankingmobile?mobile=3&TeamID=%d";
//NSString* const fitnessPassFailRanking = @"http://competitive-cauldron.com/stats/fitnessmobile?mobile=3&TeamID=%d";
//
///* URL for Live Server itune */
//NSString* const syncToServerServiceURL = @"http://192.168.0.8/stats/web_service/getStats.php";
//NSString* const syncToServerServiceURLAttandace =@"http://192.168.0.8/stats/web_service/getAttendance.php";
//NSString* const syncToServerServiceURLJournal =@"http://192.168.0.8/stats/web_service/getJournal.php";
//NSString* const syncToServerServiceURLPlayer =@"http://192.168.0.8/stats/web_service/roster.php";
//NSString* const syncToServerServiceURLManageTeam = @"http://192.168.0.8/stats/web_service/teammanagement.php";
//NSString* const syncToServerServiceURLManageChallenge = @"http://192.168.0.8/stats/web_service/challenge.php";
//NSString* const syncToServerServiceURLManageCoach = @"http://192.168.0.8/stats/web_service/coach.php";













