//
//  DataFetcherHelper.m
//  Cauldron
//
//  Created by John Nik on 3/25/17.
//  Copyright © 2017 johnik703. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "DataFetcherHelper.h"
#import "Player.h"
#import "Team.h"
#import "Challenge.h"
#import "ChallengeCatgry.h"
#import "SCSQLite.h"
#import "challengeImage.h"
#import "ChallengeState.h"
#import "Journal.h"
#import "Ranking.h"
#import "Coach.h"


@implementation DataFetcherHelper

+(LoginUser*)getloginDataFromDict:(NSDictionary*)loginDataDict
{
    LoginUser *aUser = [[LoginUser alloc]init];
    aUser.FirstName = [loginDataDict objectForKey:@"FirstName"];
    aUser.Grade = [loginDataDict objectForKey:@"Grade"];
    aUser.LastName = [loginDataDict objectForKey:@"LastName"];
    aUser.PEmail = [loginDataDict objectForKey:@"PEmail"];
    aUser.Password = [loginDataDict objectForKey:@"Password"];
    aUser.PlayerID = (int)[[loginDataDict objectForKey:@"PlayerID"]integerValue];
    aUser.Position = [loginDataDict objectForKey:@"Position"];
    aUser.TeamID = (int)[[loginDataDict objectForKey:@"TeamID"]integerValue];
    aUser.UserLevel =(int) [[loginDataDict objectForKey:@"UserLevel"]integerValue];
    aUser.UserName = [loginDataDict objectForKey:@"UserName"];
    aUser.auth = (int)[[loginDataDict objectForKey:@"auth"]integerValue];
    aUser.Mode = (int)[[loginDataDict objectForKey:@"Mode"] integerValue];
    aUser.teams = [loginDataDict objectForKey:@"teams"];
    aUser.userState= [loginDataDict objectForKey:@"UserState"];
    aUser.Sport= [loginDataDict objectForKey:@"Sport"];
    
    aUser.arrTeams = [[NSMutableArray alloc] init];
    NSArray* arrTemp = [[NSArray alloc] initWithArray:[aUser.teams componentsSeparatedByString:@"<id>"]];
    
//    NSLog(@"composentArr, %@", arrTemp);
    int cnt = (int)[arrTemp count];
    for (int i = 1; i < cnt; i++){
        NSNumber *val = [NSNumber numberWithInteger:[[arrTemp objectAtIndex:i] intValue]];
        [aUser.arrTeams addObject:val];
    }
    return aUser;
}

+(NSArray*)getAllPlayerDataFromDict:(NSDictionary*)recieveDataDict
{
    
//    NSLog(@"players info = %@",recieveDataDict);
    
    NSMutableArray *allPlayers = [[NSMutableArray alloc]init];
    
    [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
    
    for(NSDictionary *onePlayer in recieveDataDict)
    {
        Player *aPlayer = [[Player alloc]init];
        aPlayer.PlayerID = (int)[[onePlayer objectForKey:@"PlayerID"] integerValue];
        aPlayer.TeamID = (int)[[onePlayer objectForKey:@"TeamID"] integerValue];
        aPlayer.LastName  = [onePlayer objectForKey:@"LastName"];
        aPlayer.FirstName  = [onePlayer objectForKey:@"FirstName"];
        aPlayer.Grade  = [onePlayer objectForKey:@"Grade"];
        aPlayer.Position  = [onePlayer objectForKey:@"Position"];
        aPlayer.BirthDate  = [onePlayer objectForKey:@"BirthDate"];
        aPlayer.GraduationDate  = [onePlayer objectForKey:@"GraduationDate"];
        aPlayer.PEmail = [onePlayer objectForKey:@"PEmail"];
        aPlayer.EmailPRpt = (int)[[onePlayer objectForKey:@"EmailPRpt"]integerValue];
        aPlayer.MEmail = [onePlayer objectForKey:@"MEmail"];
        aPlayer.EmailMRpt =(int) [[onePlayer objectForKey:@"EmailMRpt"]integerValue];
        aPlayer.DEmail = [onePlayer objectForKey:@"DEmail"];
        aPlayer.EmailDRpt = (int)[[onePlayer objectForKey:@"EmailDRpt"]integerValue];
        aPlayer.Notes = [onePlayer objectForKey:@"Notes"];
        aPlayer.UserName = [onePlayer objectForKey:@"UserName"];
        aPlayer.Password = [onePlayer objectForKey:@"Password"];
        aPlayer.UserLevel = (int)[[onePlayer objectForKey:@"UserLevel"]integerValue];
        aPlayer.Photo = [onePlayer objectForKey:@"Photo"];
        aPlayer.modified = [onePlayer objectForKey:@"modified"];
        aPlayer.jercyNo=[onePlayer objectForKey:@"Jersey"];
        aPlayer.Phone=[onePlayer objectForKey:@"Phone1"];
        [allPlayers addObject:aPlayer];
        //NSLog(@"Query ==== %@",aPlayer);

        NSString *inserQuery = [NSString stringWithFormat:@"INSERT INTO PlayersInfo (TeamID,PlayerID,LastName,FirstName,Grade,Position,BirthDate,GraduationDate,PEmail,EmailPRpt,MEmail,EmailMRpt, DEmail,EmailDRpt,Notes,UserName,Password,UserLevel,Photo,modified,JourcyNo,Phone,Sync) VALUES(%d,%d,'%@','%@','%@','%@','%@','%@','%@',%d,'%@',%d,'%@',%d,'%@','%@','%@',%d,'%@','%@','%@','%@',%d)",aPlayer.TeamID,aPlayer.PlayerID,aPlayer.LastName,aPlayer.FirstName,aPlayer.Grade,aPlayer.Position,aPlayer.BirthDate,aPlayer.GraduationDate,aPlayer.PEmail,aPlayer.EmailPRpt,aPlayer.MEmail,aPlayer.EmailMRpt,aPlayer.DEmail,aPlayer.EmailDRpt,aPlayer.Notes,aPlayer.UserName,aPlayer.Password,aPlayer.UserLevel,aPlayer.Photo,aPlayer.modified,aPlayer.jercyNo,aPlayer.Phone,0];
        
        
        BOOL success = [SCSQLite executeSQL:inserQuery];
        
        if(success)
        {
//            NSLog(@"SuccessFully Inserted Player ID = %d",aPlayer.PlayerID);
        }
    }
    return allPlayers;
}

+ (NSArray *)getAllCoachesDataFromDict:(NSDictionary *)recieveDataDict {
    
//    NSLog(@"coachesreceiveDic, %@", recieveDataDict);
    
    NSMutableArray *allCoaches = [[NSMutableArray alloc]init];
    
    [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
    
    for(NSDictionary *oneCoach in recieveDataDict)
    {
        Coach *aCoach = [[Coach alloc]init];
        aCoach.playerID = Global.playerIDFinal;
        aCoach.coachID  = (int)[[oneCoach objectForKey:@"user_id"] integerValue];
        aCoach.contactName  = [oneCoach objectForKey:@"contact_name"];
        aCoach.contactAddress  = [oneCoach objectForKey:@"address"];
        aCoach.contactState  = [oneCoach objectForKey:@"state"];
        aCoach.contactCity  = [oneCoach objectForKey:@"city"];
        aCoach.contactZip  = [oneCoach objectForKey:@"zip"];
        aCoach.contactPhone = [oneCoach objectForKey:@"phone"];
        aCoach.coachLoginName  = [oneCoach objectForKey:@"admin_name"];
        aCoach.coachPassword  = [oneCoach objectForKey:@"password_text"];
        aCoach.coachEmail  = [oneCoach objectForKey:@"email"];
        aCoach.emailCoachRanking  = (int)[[oneCoach objectForKey:@"email_ranking"] integerValue];
        aCoach.teams = [oneCoach objectForKey:@"teams"];
        [allCoaches addObject:aCoach];
        //NSLog(@"Query ==== %@",aPlayer);
        
        NSString *inserQuery = [NSString stringWithFormat:@"INSERT INTO CoachesInfo (PlayerID, coachID, contactName, contactAddress, contactState, contactCity, contactZip, contactPhone, coachLoginName, coachPassword, coachEmail, emailCoachRanking, teams) VALUES(%@,%d,'%@','%@','%@','%@','%@', '%@' ,'%@','%@','%@','%d','%@')",aCoach.playerID, aCoach.coachID, aCoach.contactName, aCoach.contactAddress, aCoach.contactState, aCoach.contactCity, aCoach.contactZip, aCoach.contactPhone, aCoach.coachLoginName, aCoach.coachPassword, aCoach.coachEmail, aCoach.emailCoachRanking, aCoach.teams];
        
        
        BOOL success = [SCSQLite executeSQL:inserQuery];
        
        if(success)
        {
//            NSLog(@"SuccessFully Inserted coach ID = %d",aCoach.coachID);
        }
    }
    return allCoaches;
    
}


//+(BOOL*)addAllTeamData:(NSString*)teamID :(NSString *)teams
//{
//    NSMutableArray *allTeamInfo = [[NSMutableArray alloc]init];
//    
//    [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
//    
//    
//        NSString *inserQuery = [NSString stringWithFormat:@"INSERT INTO TeamInfo (TeamID,Sports,Stats_Year,Team_Name,Website_Logo,Team_Desc1,Team_Desc2,Team_Desc3,admin_name,admin_pw,admin_email,EmailAdminRpt,mgr_name,mgr_pw,mgr_email,EmailMgrRpt,contact_name,contact_address,contact_city,contact_state,contact_zip,contact_email,contact_phone,trial,SubscriptionEnd,Activated,Notes,Desc1,Email1,EmailDesc1Rpt,Desc2,Email2,EmailDesc2Rpt,Desc3,Email3,EmailDesc3Rpt,ReprtFitness,SeasonStart,SeasonEnd,Bulk_Import,Team_Picture,Display_Picture,demoTeam,modified,quote,noofmonth,team_position,birthdayAlert,sendBirthday,currently_running,run_only_once,time_of_day,selected_option,day_of_week ,userLevel,Sync) VALUES(%d,'%@','%@','%@','%@','%@','%@','%@','%@','%@','%@',%d,'%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@',%d,'%@','%@','%@','%@','%@','%@','%@','%@','%@','%@',%d,'%@','%@',%d,'%@',%d,%d,'%@','%@',%d,'%@','%@','%@','%@','%@','%@','%@','%@','%@',%d)",aTeam.TeamID,aTeam.Sport,aTeam.Stats_Year,aTeam.Team_Name,aTeam.Website_Logo,aTeam.Team_Desc1,aTeam.Team_Desc2,aTeam.Team_Desc3,aTeam.admin_name,aTeam.admin_pw,aTeam.admin_email,aTeam.EmailAdminRpt,aTeam.mgr_name,aTeam.mgr_pw,aTeam.mgr_email,aTeam.EmailMgrRpt,aTeam.contact_name,aTeam.contact_address,aTeam.contact_city,aTeam.contact_state,aTeam.contact_zip,aTeam.contact_email,aTeam.contact_phone,aTeam.trial,aTeam.subscription_end,aTeam.Activated,aTeam.Notes,aTeam.Desc1,aTeam.Email1,aTeam.EmailDesc1Rpt,aTeam.Desc2,aTeam.Email2,aTeam.EmailDesc2Rpt,aTeam.Desc3,aTeam.Email3,aTeam.EmailDesc3Rpt,aTeam.rptFitness,aTeam.SeasonStart,aTeam.SeasonEnd,aTeam.Bulk_Import,aTeam.Team_Picture,aTeam.Display_Picture,aTeam.demoTeam,aTeam.modified,aTeam.quote,aTeam.noofmonth,aTeam.team_position,aTeam.birthdayAlert,aTeam.sendBirthdayAlert,aTeam.currently_running,aTeam.run_only_once,aTeam.time_of_day,aTeam.selected_option,aTeam.day_of_week,aTeam.userLevel,0];
//        
//        NSLog(@"Query ==== %@",inserQuery);
//        
//        BOOL success = [SCSQLite executeSQL:inserQuery];
//        
//        if(success)
//        {
//            NSLog(@"SuccessFully Inserted Team ID = %d",teamID);
//            return TRUE;
//
//        }
//    else
//    {
//        return FALSE;
//    }
//}
//

+(Team *)getCurrentTeamDataFromDict:(NSDictionary *)oneTeam
{
    Team *ateam = [[Team alloc] init];
    
//    NSLog(@"currentteamsDic, %@", oneTeam);
    
    ateam.userLevel = [oneTeam objectForKey:@"UserLevel"];
    ateam.Website_Logo = [oneTeam objectForKey:@"Website_logo"];
    ateam.admin_email = [oneTeam objectForKey:@"admin_email"];
    ateam.admin_name = [oneTeam objectForKey:@"admin_name"];
    ateam.admin_pw = [oneTeam objectForKey:@"admin_pw"];
    ateam.birthdayAlert = (int)[[oneTeam objectForKey:@"birthdayAlert"] intValue];
    ateam.contact_address = [oneTeam objectForKey:@"contact_address"];
    ateam.contact_city = [oneTeam objectForKey:@"contact_city"];
    ateam.contact_email = [oneTeam objectForKey:@"contact_email"];
    ateam.contact_name = [oneTeam objectForKey:@"contact_name"];
    ateam.contact_phone = [oneTeam objectForKey:@"contact_phone"];
    ateam.contact_state = [oneTeam objectForKey:@"contact_state"];
    ateam.contact_zip = [oneTeam objectForKey:@"contact_zip"];
    ateam.currently_running = [oneTeam objectForKey:@"currently_running"];
    ateam.emailCoachRanking  = (int)[[oneTeam objectForKey:@"emailCoachRanking"] integerValue];
    //missing date_of_month
    
    ateam.day_of_week = [oneTeam objectForKey:@"day_of_week"];
    ateam.email_journal = (int)[[oneTeam objectForKey:@"email_journal"] intValue];
    ateam.email_login = (int)[[oneTeam objectForKey:@"email_login"] intValue];
    ateam.mgr_email = [oneTeam objectForKey:@"mgr_email"];
    ateam.mgr_name = [oneTeam objectForKey:@"mgr_name"];
    ateam.modified = [oneTeam objectForKey:@"modified"];
    ateam.noofmonth = [oneTeam objectForKey:@"noofmonth"];
    ateam.quote = [oneTeam objectForKey:@"quote"];
    ateam.rptFitness = (int)[[oneTeam objectForKey:@"ReprtFitness"] integerValue];
    ateam.run_only_once = (int)[[oneTeam objectForKey:@"run_only_once"] intValue];
    ateam.selected_option = [oneTeam objectForKey:@"selected_option"];
    ateam.sendBirthdayAlert = (int)[[oneTeam objectForKey:@"sendBirthdayAlert"] intValue];
    ateam.showbest = (int)[[oneTeam objectForKey:@"showbest"] intValue];
    ateam.showlegend = (int)[[oneTeam objectForKey:@"showlegend"] intValue];
    ateam.showworst = (int)[[oneTeam objectForKey:@"showworst"] intValue];
    ateam.subscription_end = [oneTeam objectForKey:@"SubscriptionEnd"];
    ateam.team_position = [oneTeam objectForKey:@"team_position"];
    ateam.time_of_day = [oneTeam objectForKey:@"time_of_day"];
    ateam.trial = [oneTeam objectForKey:@"trial"];
    ateam.Activated = (int)[[oneTeam objectForKey:@"Activated"] integerValue];
    ateam.Bulk_Import = (int)[[oneTeam objectForKey:@"Bulk_Import"] integerValue];
    ateam.Desc1 = [oneTeam objectForKey:@"Desc1"];
    ateam.Desc2 = [oneTeam objectForKey:@"Desc2"];
    ateam.Desc3 = [oneTeam objectForKey:@"Desc3"];
    ateam.Display_Picture = (int)[[oneTeam objectForKey:@"Display_Picture"] integerValue];
    ateam.Email1 = [oneTeam objectForKey:@"Email1"];
    ateam.Email2 = [oneTeam objectForKey:@"Email2"];
    ateam.Email3 = [oneTeam objectForKey:@"Email3"];
    ateam.EmailAdminRpt = [oneTeam objectForKey:@"EmailAdminRpt"];
    ateam.EmailDesc1Rpt = [oneTeam objectForKey:@"EmailDesc1Rpt"];
    ateam.EmailDesc2Rpt = [oneTeam objectForKey:@"EmailDesc2Rpt"];
    ateam.EmailDesc3Rpt = [oneTeam objectForKey:@"EmailDesc3Rpt"];
    ateam.EmailMgrRpt = [oneTeam objectForKey:@"EmailMgrRpt"];
    ateam.Notes = [oneTeam objectForKey:@"Notes"];
    ateam.SeasonEnd = [oneTeam objectForKey:@"SeasonEnd"];
    ateam.SeasonStart = [oneTeam objectForKey:@"SeasonStart"];
    ateam.Stats_Year = [oneTeam objectForKey:@"Stats_Year"];
    ateam.TeamID = (int)[[oneTeam objectForKey:@"TeamID"] integerValue];
    ateam.Sport = [oneTeam objectForKey:@"Sports"];
    ateam.Team_Desc1 = [oneTeam objectForKey:@"Team_Desc1"];
    ateam.Team_Desc2 = [oneTeam objectForKey:@"Team_Desc2"];
    ateam.Team_Desc3 = [oneTeam objectForKey:@"Team_Desc3"];
    ateam.Team_Name = [oneTeam objectForKey:@"Team_Name"];
    ateam.Team_Picture = [oneTeam objectForKey:@"Team_Picture"];
    ateam.isSubscribe = (int)[[oneTeam objectForKey:@"isSubscribe"] integerValue];
    
    
    NSLog(@"email coach ranking: %d", ateam.emailCoachRanking);
    return ateam;
}

+(NSArray*)getAllTeamDataFromDict:(NSDictionary*)recieveDataDict
{
    
//    NSLog(@"teamsDic, %@", recieveDataDict);
    NSMutableArray *allTeamInfo = [[NSMutableArray alloc]init];
    
    [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
    
    for(NSDictionary *oneTeam in recieveDataDict)
    {
        
        

        NSString *teams = [[NSUserDefaults standardUserDefaults] stringForKey:@"teams"];

        Team *aTeam = [[Team alloc]init];
        
        
        aTeam.TeamID = (int)[[oneTeam objectForKey:@"TeamID"] integerValue];
        aTeam.Sport  = [oneTeam objectForKey:@"Sport"];
        aTeam.Stats_Year = [oneTeam objectForKey:@"Stats_Year"];
        aTeam.Team_Name = [oneTeam objectForKey:@"Team_Name"];
        aTeam.Website_Logo = [oneTeam objectForKey:@"Website_Logo"];
        aTeam.Team_Desc1 = [oneTeam objectForKey:@"Team_Desc1"];
        aTeam.Team_Desc2 = [oneTeam objectForKey:@"Team_Desc2"];
        aTeam.Team_Desc3 = [oneTeam objectForKey:@"Team_Desc3"];
        aTeam.admin_name = [oneTeam objectForKey:@"admin_name"];
        aTeam.admin_pw = [oneTeam objectForKey:@"admin_pw"];
        //        aTeam.admin_name = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"SAVEDUSERID"]];
        //        aTeam.admin_pw = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] stringForKey:@"SAVEDUSERPASS"]];
        aTeam.admin_email = [oneTeam objectForKey:@"admin_email"];
        aTeam.EmailAdminRpt = [oneTeam objectForKey:@"EmailAdminRpt"];
        aTeam.emailCoachRanking  = (int)[[oneTeam objectForKey:@"email_ranking"] integerValue];
        aTeam.mgr_name = [oneTeam objectForKey:@"mgr_name"];
        aTeam.mgr_pw = [oneTeam objectForKey:@"mgr_pw"];
        aTeam.mgr_email = [oneTeam objectForKey:@"mgr_email"];
        aTeam.EmailMgrRpt = [oneTeam objectForKey:@"EmailMgrRpt"];
        aTeam.contact_name = [oneTeam objectForKey:@"contact_name"];
        aTeam.contact_address = [oneTeam objectForKey:@"contact_address"];
        aTeam.contact_city = [oneTeam objectForKey:@"contact_city"];
        aTeam.contact_state = [oneTeam objectForKey:@"contact_state"];
        aTeam.contact_zip = [oneTeam objectForKey:@"contact_zip"];
        aTeam.contact_email = [oneTeam objectForKey:@"contact_email"];
        aTeam.contact_phone = [oneTeam objectForKey:@"contact_phone"];
        aTeam.trial = [oneTeam objectForKey:@"trial"];
        aTeam.subscription_end = [oneTeam objectForKey:@"subscription_end"];
        aTeam.Activated = (int)[[oneTeam objectForKey:@"Activated"]integerValue];
        aTeam.Notes = [oneTeam objectForKey:@"Notes"];
        aTeam.Desc1 = [oneTeam objectForKey:@"Desc1"];
        aTeam.Email1 = [oneTeam objectForKey:@"Email1"];
        aTeam.EmailDesc1Rpt = [oneTeam objectForKey:@"EmailDesc1Rpt"];
        aTeam.Desc2 = [oneTeam objectForKey:@"Desc2"];
        aTeam.Email2 = [oneTeam objectForKey:@"Email2"];
        aTeam.EmailDesc2Rpt = [oneTeam objectForKey:@"EmailDesc2Rpt"];
        aTeam.Desc3 = [oneTeam objectForKey:@"Desc3"];
        aTeam.Email3 = [oneTeam objectForKey:@"Email3"];
        aTeam.EmailDesc3Rpt = [oneTeam objectForKey:@"EmailDesc3Rpt"];
        aTeam.rptFitness = (int)[[oneTeam objectForKey:@"rptFitness"]integerValue];
        aTeam.SeasonStart = [oneTeam objectForKey:@"SeasonStart"];
        aTeam.SeasonEnd = [oneTeam objectForKey:@"SeasonEnd"];
        aTeam.Bulk_Import = (int)[[oneTeam objectForKey:@"Bulk_Import"]integerValue];
        aTeam.Team_Picture = [oneTeam objectForKey:@"Team_Picture"];
        aTeam.Display_Picture = (int)[[oneTeam objectForKey:@"Display_Picture"] integerValue];
        aTeam.demoTeam = (int)[[oneTeam objectForKey:@"demoTeam"]integerValue];
        aTeam.modified = [oneTeam objectForKey:@"modified"];
        aTeam.quote = [oneTeam objectForKey:@"quote"];
        aTeam.noofmonth = [oneTeam objectForKey:@"noofmonth"];
        aTeam.team_position = [oneTeam objectForKey:@"team_position"];
        
//        aTeam.run_only_once = (int)[[oneTeam objectForKey:@"run_only_once"] integerValue];
        
        NSString *runOnlyOnceString = [oneTeam objectForKey:@"run_only_once"];
        if (runOnlyOnceString == (NSString *)[NSNull null]) {
            aTeam.run_only_once = 0;
        } else {
            aTeam.run_only_once = (int)[runOnlyOnceString integerValue];
        }
        
        aTeam.selected_option = [oneTeam objectForKey:@"selected_option"];
        aTeam.sendBirthdayAlert = (int)[[oneTeam objectForKey:@"sendBirthdayAlert"] integerValue];
        aTeam.subscription_end = [oneTeam objectForKey:@"subscription_end"];
        aTeam.time_of_day = [oneTeam objectForKey:@"time_of_day"];
        aTeam.birthdayAlert = (int)[[oneTeam objectForKey:@"birthdayAlert"] integerValue];
        aTeam.day_of_week = [oneTeam objectForKey:@"day_of_week"];
        
//        aTeam.currently_running= [oneTeam objectForKey:@"currently_running"];
        NSString *currentlyRunning = [oneTeam objectForKey:@"currently_running"];
        if (currentlyRunning == (NSString *)[NSNull null]) {
            aTeam.currently_running = @"0";
        } else {
            aTeam.currently_running = currentlyRunning;
        }
        
        aTeam.showbest= (int)[[oneTeam objectForKey:@"showbest"] integerValue];
        aTeam.showworst= (int)[[oneTeam objectForKey:@"showworst"] integerValue];
        aTeam.showlegend= (int)[[oneTeam objectForKey:@"showlegend"] integerValue];
        aTeam.email_login= (int)[[oneTeam objectForKey:@"email_login"] integerValue];
        aTeam.email_journal= (int)[[oneTeam objectForKey:@"email_journal"] integerValue];
        aTeam.show_report_to_player = (int)[[oneTeam objectForKey:@"show_report_to_player"] integerValue];
        aTeam.isSubscribe = (int)[[oneTeam objectForKey:@"isSubscribe"] integerValue];

        NSString *prevLevel = [[NSUserDefaults standardUserDefaults] stringForKey:@"ONLINE_PREVIOUS_LOG_USERLEVEL"];
        aTeam.userLevel = prevLevel;

        aTeam.teams=teams;
        
        NSLog(@"TeamID, %d", aTeam.TeamID);
        NSLog(@"admin_name, %@", aTeam.admin_name);
        NSLog(@"email coach ranking: %d", aTeam.emailCoachRanking);
        
        
        [allTeamInfo addObject:aTeam];
        

        NSString *inserQuery = [NSString stringWithFormat:@"INSERT INTO TeamInfo (TeamID,Sports,Stats_Year,Team_Name,Website_Logo,Team_Desc1,Team_Desc2,Team_Desc3,admin_name,admin_pw,admin_email,EmailAdminRpt,mgr_name,mgr_pw,mgr_email,EmailMgrRpt,contact_name,contact_address,contact_city,contact_state,contact_zip,contact_email,contact_phone,trial,SubscriptionEnd,Activated,Notes,Desc1,Email1,EmailDesc1Rpt,Desc2,Email2,EmailDesc2Rpt,Desc3,Email3,EmailDesc3Rpt,ReprtFitness,SeasonStart,SeasonEnd,Bulk_Import,Team_Picture,Display_Picture,demoTeam,modified,quote,noofmonth,team_position,birthdayAlert,sendBirthday,currently_running,run_only_once,time_of_day,selected_option,day_of_week ,userLevel,teams,Sync,showbest,showworst,showlegend,email_login,email_journal, isSubscribe, emailCoachRanking) VALUES(%d,'%@','%@','%@','%@','%@','%@','%@','%@','%@','%@',%d,'%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@','%@',%d,'%@','%@','%@','%@','%@','%@','%@','%@','%@','%@',%d,'%@','%@',%d,'%@',%d,%d,'%@','%@',%d,'%@','%d','%d','%@','%d','%@','%@','%@','%@','%@',%d,'%d','%d','%d','%d','%d', '%d','%d')",aTeam.TeamID,aTeam.Sport,aTeam.Stats_Year,aTeam.Team_Name,aTeam.Website_Logo,aTeam.Team_Desc1,aTeam.Team_Desc2,aTeam.Team_Desc3,aTeam.admin_name,aTeam.admin_pw,aTeam.admin_email,aTeam.EmailAdminRpt,aTeam.mgr_name,aTeam.mgr_pw,aTeam.mgr_email,aTeam.EmailMgrRpt,aTeam.contact_name,aTeam.contact_address,aTeam.contact_city,aTeam.contact_state,aTeam.contact_zip,aTeam.contact_email,aTeam.contact_phone,aTeam.trial,aTeam.subscription_end,aTeam.Activated,aTeam.Notes,aTeam.Desc1,aTeam.Email1,aTeam.EmailDesc1Rpt,aTeam.Desc2,aTeam.Email2,aTeam.EmailDesc2Rpt,aTeam.Desc3,aTeam.Email3,aTeam.EmailDesc3Rpt,aTeam.rptFitness,aTeam.SeasonStart,aTeam.SeasonEnd,aTeam.Bulk_Import,aTeam.Team_Picture,aTeam.Display_Picture,aTeam.demoTeam,aTeam.modified,aTeam.quote,aTeam.noofmonth,aTeam.team_position,aTeam.birthdayAlert,aTeam.sendBirthdayAlert,aTeam.currently_running,aTeam.run_only_once,aTeam.time_of_day,aTeam.selected_option,aTeam.day_of_week,aTeam.userLevel,aTeam.teams,0,aTeam.showbest,aTeam.showworst,aTeam.showlegend,aTeam.email_login,aTeam.email_journal, aTeam.isSubscribe, aTeam.emailCoachRanking];


        
//        NSLog(@"Insert Into TeamInfor Query ==== %d",aTeam.TeamID);
        
        BOOL success = [SCSQLite executeSQL:inserQuery];
        
        if(success)
        {
//            NSLog(@"SuccessFully Inserted Team ID = %d",aTeam.TeamID);
        }
    }
    return allTeamInfo;
}


+(NSArray*)getAllChallengeDataFromDict:(NSDictionary*)recieveDataDict
{
    NSMutableArray *allChallenges = [[NSMutableArray alloc]init];
    
    [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
    
//    NSLog(@"testRecieveChallengeData, %@", recieveDataDict);
    
    for(NSDictionary *oneChallenge in recieveDataDict)
    {
        Challenge *aChalng = [[Challenge alloc]init];
        
        aChalng.topPerformer = (int)[[oneChallenge objectForKey:@"topPerformer"] integerValue];
        aChalng.standard0 = [oneChallenge objectForKey:@"standard0"];
        aChalng.isAvg = (int)[[oneChallenge objectForKey:@"isAvg"] integerValue];
        aChalng.isAdding = (int)[[oneChallenge objectForKey:@"isAdding"] integerValue];
        aChalng.fields = [oneChallenge objectForKey:@"fields"];
        aChalng.stats_exist = (int)[[oneChallenge objectForKey:@"stats_exist"] integerValue];
        aChalng.Rorder = [oneChallenge objectForKey:@"Rorder"];
        aChalng.RankFormula = [oneChallenge objectForKey:@"RankFormula"];
        
        aChalng.Challenge_Fitness_Include = (int)[[oneChallenge objectForKey:@"Fitness_Rpt"] integerValue];
        
        aChalng.TeamID = (int)[[oneChallenge objectForKey:@"TeamID"] integerValue];
        aChalng.ID = (int)[[oneChallenge objectForKey:@"ID"] integerValue];
        aChalng.Challenge_Name = [oneChallenge objectForKey:@"Challenge_Name"];
        aChalng.Challenge_Menu = [oneChallenge objectForKey:@"Challenge_Menu"];
        aChalng.Challenge_Text1 = [oneChallenge objectForKey:@"Challenge_Text1"];
        aChalng.Challenge_Text2 = [oneChallenge objectForKey:@"Challenge_Text2"];
        aChalng.Challenge_Text3 = [oneChallenge objectForKey:@"Challenge_Text3"];
        aChalng.Challenge_Multiplier = (int)[[oneChallenge objectForKey:@"Challenge_Multiplier"]integerValue];
        aChalng.Challenge_Type = [oneChallenge objectForKey:@"Challenge_Type"];
        aChalng.Challenge_Exclude = (int)[[oneChallenge objectForKey:@"Challenge_Exclude"]integerValue];
        aChalng.Challenge_Category = (int)[[oneChallenge objectForKey:@"Challenge_Category"]integerValue];
        aChalng.Challenge_Desc = [oneChallenge objectForKey:@"Challenge_Desc"];
        aChalng.Challenge_Detail = [oneChallenge objectForKey:@"Challenge_Detail"];
        aChalng.WLT =(int) [[oneChallenge objectForKey:@"WLT"]integerValue];
        aChalng.Show_Ties = (int)[[oneChallenge objectForKey:@"Show_Ties"] integerValue];
        aChalng.Video_Name = [oneChallenge objectForKey:@"Video_Name"];
        aChalng.Enabled =(int) [[oneChallenge objectForKey:@"Enabled"]integerValue];
        aChalng.isDecimal = (int)[[oneChallenge objectForKey:@"isDecimal"] integerValue];
        aChalng.Challenge_Pic = [oneChallenge objectForKey:@"Challenge_Pic"];
        aChalng.isHome = (int)[[oneChallenge objectForKey:@"isHome"]integerValue];
        aChalng.playersCount =(int) [[oneChallenge objectForKey:@"playerCount"]integerValue];
        aChalng.modified = [oneChallenge objectForKey:@"modified"];
        
        /*
         NSLog(@"TeamID = %d",aChalng.TeamID);
         NSLog(@"Challange ID = %d",aChalng.ID);
         NSLog(@"Challenge_Name = %@",aChalng.Challenge_Name);
         NSLog(@"Challenge_Menu = %@",aChalng.Challenge_Menu);
         NSLog(@"Challenge_Text1 = %@",aChalng.Challenge_Text1);
         NSLog(@"Challenge_Text2 = %@",aChalng.Challenge_Text2);
         NSLog(@"Challenge_Text3 = %@",aChalng.Challenge_Text3);
         NSLog(@"Challenge_Multiplier = %d",aChalng.Challenge_Multiplier);
         NSLog(@"Challenge_Type = %@",aChalng.Challenge_Type);
         NSLog(@"Challenge_Exclude = %d",aChalng.Challenge_Exclude);
         NSLog(@"Challenge_Category = %d",aChalng.Challenge_Category);
         NSLog(@"Challenge_Desc = %@",aChalng.Challenge_Desc);
         NSLog(@"Challenge_Detail = %@",aChalng.Challenge_Detail);
         NSLog(@"WLT = %d",aChalng.WLT);
         NSLog(@"Show_Ties = %@",aChalng.Show_Ties);
         NSLog(@"Video_Name = %@",aChalng.Video_Name);
         NSLog(@"Enabled = %d",aChalng.Enabled);
         NSLog(@"isDecimal = %@",aChalng.isDecimal);
         NSLog(@"Challenge_Pic = %@",aChalng.Challenge_Pic);
         NSLog(@"isHome = %d",aChalng.isHome);
         NSLog(@"playersCount = %d",aChalng.playersCount);
         NSLog(@"modified = %@",aChalng.modified);
        */

        [allChallenges addObject:aChalng];
        
        //CREATE TABLE Challanges (ID integer,TeamID integer,Challenge_Name varchar,Challenge_Menu varchar,Challenge_Text1 varchar,Challenge_Text2 varchar,Challenge_Text3 varchar,Challenge_Multiplier integer,Challenge_Type varchar,Challenge_Exclude integer,Challenge_Category integer,Challenge_Desc varchar,Challenge_Detail varchar,WLT integer,Show_Ties varchar,Video_Name varchar,Enable integer,isDecimal varchar,ChallagePic varchar,isHome integer,playerCount integer,modified varchar,Sync integer)//
        
        NSString *inserQuery = [NSString stringWithFormat:@"INSERT INTO Challanges (ID,TeamID,Challenge_Name,Challenge_Menu,Challenge_Text1,Challenge_Text2,Challenge_Text3,Challenge_Multiplier ,Challenge_Type,Challenge_Exclude,Challenge_Category,Challenge_Desc,Challenge_Detail,WLT ,Show_Ties,Video_Name,Enable,isDecimal,ChallagePic,isHome,playerCount,modified ,Sync, topPerformer,standard0,isAvg,isAdding,fields,stats_exist,Rorder,RankFormula,Fitness_Rpt) VALUES(%d,%d,'%@','%@','%@','%@','%@',%d,'%@',%d,%d,'%@','%@',%d,%d,'%@',%d,%d,'%@',%d,%d,'%@',%d,%d,'%@',%d,%d,'%@',%d,'%@','%@',%d)",aChalng.ID,aChalng.TeamID,aChalng.Challenge_Name,aChalng.Challenge_Menu,aChalng.Challenge_Text1,aChalng.Challenge_Text2,aChalng.Challenge_Text3,aChalng.Challenge_Multiplier ,aChalng.Challenge_Type,aChalng.Challenge_Exclude,aChalng.Challenge_Category,aChalng.Challenge_Desc,aChalng.Challenge_Detail,aChalng.WLT ,aChalng.Show_Ties,aChalng.Video_Name,aChalng.Enabled,aChalng.isDecimal,aChalng.Challenge_Pic,aChalng.isHome,aChalng.playersCount,aChalng.modified ,0, aChalng.topPerformer,aChalng.standard0,aChalng.isAvg,aChalng.isAdding,aChalng.fields,aChalng.stats_exist,aChalng.Rorder,aChalng.RankFormula,aChalng.Challenge_Fitness_Include];
        
        //NSLog(@"Query ==== %@",inserQuery);
        
        BOOL success = [SCSQLite executeSQL:inserQuery];
        
        if(success)
        {
//            NSLog(@"SuccessFully Inserted Challenge ID = %d, %@",aChalng.ID, aChalng.Challenge_Type);
        }
    }
    return allChallenges;
}

+(NSArray*)getAllCategoryDataFromDict:(NSDictionary*)recieveDataDict
{
    NSMutableArray *allCategory = [[NSMutableArray alloc]init];
    
//    NSLog(@"testRecieveCategoryData, %@", recieveDataDict);
    
    [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
    
    for(NSDictionary *oneCatgry in recieveDataDict)
    {
        ChallengeCatgry *aCatgry = [[ChallengeCatgry alloc]init];
        
        aCatgry.catID = (int)[[oneCatgry objectForKey:@"id"]integerValue];
        aCatgry.TeamID = (int)[[oneCatgry objectForKey:@"TeamID"]integerValue];
        aCatgry.categoryname = [oneCatgry objectForKey:@"categoryname"];
        aCatgry.shortname = [oneCatgry objectForKey:@"shortname"];
        aCatgry.catOrder =(int) [[oneCatgry objectForKey:@"catOrder"]integerValue];
        
         //NSLog(@"catID = %d",aCatgry.catID);
         //NSLog(@"TeamID = %d",aCatgry.TeamID);
         //NSLog(@"categoryname = %@",aCatgry.categoryname);
         //NSLog(@"shortname = %@",aCatgry.shortname);
         //NSLog(@"catOrder = %d",aCatgry.catOrder);

        [allCategory addObject:aCatgry];
        
        //CREATE TABLE ChallengeCategory (CatID integer,TeamID integer,CategoryName varchar,ShortName varchar,CatOrder integer, Sync integer)
        
        NSString *inserQuery = [NSString stringWithFormat:@"INSERT INTO ChallengeCategory (CatID,TeamID,CategoryName,ShortName,CatOrder,Sync) VALUES(%d,%d,'%@','%@',%d,%d)",aCatgry.catID,aCatgry.TeamID,aCatgry.categoryname,aCatgry.shortname,aCatgry.catOrder,0];
        
        //NSLog(@"Query ==== %@",inserQuery);
        
        BOOL success = [SCSQLite executeSQL:inserQuery];
        
        if(success)
        {
//            NSLog(@"SuccessFully Inserted Category ID = %d",aCatgry.catID);
        }
    }
    return allCategory;
}

+(NSArray*)getAllChallangeImageDataFromDict:(NSDictionary*)recieveDataDict
{
    NSMutableArray *allChalngImage = [[NSMutableArray alloc]init];
    
    [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
    
    for(NSDictionary *oneChalngImage in recieveDataDict)
    {
        challengeImage *aChalngImage = [[challengeImage alloc]init];
        
        aChalngImage.ChalngID = (int)[[oneChalngImage objectForKey:@"challengeID"]integerValue];
        aChalngImage.ChalngImageData = [oneChalngImage objectForKey:@"imgData"];
        
        //NSLog(@"Challenge ID = %d",aChalngImage.ChalngID);
        //NSLog(@"ChallengeImageData = %@",aChalngImage.ChalngImageData);
        
        [allChalngImage addObject:aChalngImage];
        
        //CREATE TABLE ChallengeImage (ChallangeID integer,imgData text)
        
        
        UIImage* image = [UIImage imageWithData:[self base64DataFromString:aChalngImage.ChalngImageData]];

        
        NSData *imgData= UIImageJPEGRepresentation(image,0.1 /*compressionQuality*/);
        
        
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0]; // Get documents folder
        NSString *dataPath = [documentsDirectory stringByAppendingPathComponent:@"/images"];

        [imgData writeToFile:[dataPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%d.%@", aChalngImage.ChalngID, @"png"]] options:NSAtomicWrite error:nil];
        
        NSString *inserQuery = [NSString stringWithFormat:@"INSERT INTO ChallengeImage (ChallangeID,imgData,Sync) VALUES(%d,'%@',%d)",aChalngImage.ChalngID,[NSString stringWithFormat:@"%@/%d.png",dataPath,aChalngImage.ChalngID],0];
        
        //NSLog(@"Query ==== %@",inserQuery);
        
        BOOL success = [SCSQLite executeSQL:inserQuery];
        
        if(success)
        {
//            NSLog(@"SuccessFully Inserted ChallengeImage ID = %d", aChalngImage.ChalngID);
        }
    }
    return allChalngImage;
}

+(NSArray*)getAllScoreStatesDataFromDict:(NSDictionary*)recieveDataDict
{
    NSMutableArray *allScoreStates = [[NSMutableArray alloc]init];
    
    [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
    
    for(NSDictionary *oneScoreStat in recieveDataDict)
    {
        ChallengeState *aScoreState = [[ChallengeState alloc]init];
        
        aScoreState.StatID = (int)[[oneScoreStat objectForKey:@"ID"]integerValue];
        aScoreState.chStTeamID = (int)[[oneScoreStat objectForKey:@"TeamID"]integerValue];
        aScoreState.chalStID = (int)[[oneScoreStat objectForKey:@"ChallengeID"]integerValue];
        aScoreState.chalStPlayerID = (int)[[oneScoreStat objectForKey:@"PlayerID"]integerValue];
        aScoreState.chalStColName = [oneScoreStat objectForKey:@"column_name"];
        aScoreState.chalStColVal = [oneScoreStat objectForKey:@"column_val"];
        aScoreState.chalModDate = [oneScoreStat objectForKey:@"Date"];
        
        [allScoreStates addObject:aScoreState];
        
        //CREATE TABLE ChallangeStat (ChStatID integer,TeamID integer,ChallangeID integer,PlayerID integer,column_name varchar,column_val varchar,Date varchar,Sync integer)
        
        NSString *inserQuery = [NSString stringWithFormat:@"INSERT INTO ChallangeStat (ChStatID,TeamID,ChallangeID,PlayerID,column_name,column_val,Date,Sync) VALUES(%d,%d,%d,%d,'%@','%@','%@',%d)",aScoreState.StatID,aScoreState.chStTeamID,aScoreState.chalStID,aScoreState.chalStPlayerID,aScoreState.chalStColName,aScoreState.chalStColVal,aScoreState.chalModDate,0];
        
        //NSLog(@"Query ==== %@",inserQuery);
        
        BOOL success = [SCSQLite executeSQL:inserQuery];
        
        if(success)
        {
//            NSLog(@"SuccessFully Inserted ScoreStat ID = %d", aScoreState.StatID);
        }
    }
    return allScoreStates;
}


+(NSArray*)getAllJournalDataFromDict:(NSDictionary*)recieveDataDict
{
    NSMutableArray *allJournalData = [[NSMutableArray alloc]init];
    
    [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
    
    for(NSDictionary *oneScoreStat in recieveDataDict)
    {

        
        Journal *aJournal = [[Journal alloc]init];
        
        aJournal.journalId = (int)[[oneScoreStat objectForKey:@"id"]integerValue];
        aJournal.teamId = (int)[[oneScoreStat objectForKey:@"TeamID"]integerValue];
        aJournal.playerId = (int)[[oneScoreStat objectForKey:@"PlayerID"]integerValue];
        aJournal.add_date = [oneScoreStat objectForKey:@"add_date"];
        aJournal.notes = [oneScoreStat objectForKey:@"notes"];
        
        [allJournalData addObject:aJournal];
        
        //CREATE TABLE ChallangeStat (ChStatID integer,TeamID integer,ChallangeID integer,PlayerID integer,column_name varchar,column_val varchar,Date varchar,Sync integer)
        
        NSString *inserQuery = [NSString stringWithFormat:@"INSERT INTO JournalData (id,TeamID,PlayerID,notes,add_date,Sync) VALUES(%d,%d,%d,'%@','%@',%d)",aJournal.journalId,aJournal.teamId,aJournal.playerId,aJournal.notes,aJournal.add_date,0];
        
//        NSLog(@"Query ==== %@",inserQuery);
        
        BOOL success = [SCSQLite executeSQL:inserQuery];
        
        if(success)
        {
//            NSLog(@"SuccessFully Inserted ScoreStat ID = %d", aJournal.journalId);
        }
    }
    return allJournalData;
}


+(NSArray*)getAllRankingDataFromDict:(NSDictionary*)recieveDataDict
{
    NSMutableArray *allJournalData = [[NSMutableArray alloc]init];
    
//    [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
    
    for (NSDictionary *oneScoreStat in recieveDataDict)
    {
        
//        NSLog(@"rank data %@:", oneScoreStat);
        
        Ranking *aRanking= [[Ranking alloc]init];
        
        aRanking.rankID=(int)[[oneScoreStat objectForKey:@"ID"]integerValue];
        aRanking.teamId = (int)[[oneScoreStat objectForKey:@"TeamID"]integerValue];
        aRanking.playerId = (int)[[oneScoreStat objectForKey:@"PlayerID"]integerValue];
        aRanking.chanllangeId =(int) [[oneScoreStat objectForKey:@"ChallengeID"] integerValue];
        aRanking.rank=(int)[[oneScoreStat objectForKey:@"rank"] integerValue];
        aRanking.avg1= [oneScoreStat objectForKey:@"average"];
        aRanking.playerName=[oneScoreStat objectForKey:@"Player_Name"];
        
        NSMutableDictionary *graphData = [oneScoreStat objectForKey:@"graph"];
        aRanking.graphArray = graphData;
//        NSLog(@"graphData data %@:", aRanking.graphArray);
        
        
        [allJournalData addObject:aRanking];
        
        
        
        
        //create table query
        /*
        CREATE TABLE ChallangeStat (ChStatID integer,TeamID integer,ChallangeID integer,PlayerID integer,column_name varchar,column_val varchar,Date varchar,Sync integer)
         (id integer primary key autoincrement,TeamID integer,PlayerID integer,Player_Name varchar,ChallengeID integer,average integer,rank integer)
        */
        
        //insert ranking data into the db
        /*
        NSString *inserQuery = [NSString stringWithFormat:@"INSERT INTO RankingData (id,TeamID,PlayerID,Player_Name,ChallengeID,average,rank) VALUES(%d,%d,%d,'%@','%d',%@,%d)",aRanking.rankID,aRanking.teamId,aRanking.playerId,aRanking.playerName,aRanking.chanllangeId,aRanking.avg1,aRanking.rank];
        
        
        BOOL success = [SCSQLite executeSQL:inserQuery];
        
        if(success)
        {
          //  NSLog(@"SuccessFully Inserted ScoreStat ID = %d", aRanking.rankID);
        }
         */
    }
    return allJournalData;
}



+ (NSData *)base64DataFromString: (NSString *)string
{
    unsigned long ixtext, lentext;
    unsigned char ch, inbuf[4], outbuf[3];
    short i, ixinbuf;
    Boolean flignore, flendtext = false;
    const unsigned char *tempcstring;
    NSMutableData *theData;
    
    if (string == nil)
    {
        return [NSData data];
    }
    
    ixtext = 0;
    
    tempcstring = (const unsigned char *)[string UTF8String];
    
    lentext = [string length];
    
    theData = [NSMutableData dataWithCapacity: lentext];
    
    ixinbuf = 0;
    
    while (true)
    {
        if (ixtext >= lentext)
        {
            break;
        }
        
        ch = tempcstring [ixtext++];
        
        flignore = false;
        
        if ((ch >= 'A') && (ch <= 'Z'))
        {
            ch = ch - 'A';
        }
        else if ((ch >= 'a') && (ch <= 'z'))
        {
            ch = ch - 'a' + 26;
        }
        else if ((ch >= '0') && (ch <= '9'))
        {
            ch = ch - '0' + 52;
        }
        else if (ch == '+')
        {
            ch = 62;
        }
        else if (ch == '=')
        {
            flendtext = true;
        }
        else if (ch == '/')
        {
            ch = 63;
        }
        else
        {
            flignore = true;
        }
        
        if (!flignore)
        {
            short ctcharsinbuf = 3;
            Boolean flbreak = false;
            
            if (flendtext)
            {
                if (ixinbuf == 0)
                {
                    break;
                }
                
                if ((ixinbuf == 1) || (ixinbuf == 2))
                {
                    ctcharsinbuf = 1;
                }
                else
                {
                    ctcharsinbuf = 2;
                }
                
                ixinbuf = 3;
                
                flbreak = true;
            }
            
            inbuf [ixinbuf++] = ch;
            
            if (ixinbuf == 4)
            {
                ixinbuf = 0;
                
                outbuf[0] = (inbuf[0] << 2) | ((inbuf[1] & 0x30) >> 4);
                outbuf[1] = ((inbuf[1] & 0x0F) << 4) | ((inbuf[2] & 0x3C) >> 2);
                outbuf[2] = ((inbuf[2] & 0x03) << 6) | (inbuf[3] & 0x3F);
                
                for (i = 0; i < ctcharsinbuf; i++)
                {
                    [theData appendBytes: &outbuf[i] length: 1];
                }
            }
            
            if (flbreak)
            {
                break;
            }
        }
    }
    return theData;
}


@end
