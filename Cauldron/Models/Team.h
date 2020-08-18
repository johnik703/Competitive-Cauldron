//
//  Team.h
//  Cauldron
//
//  Created by John Nik on 6/1/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Team : NSObject

@property (nonatomic, assign)int TeamID;
@property (nonatomic, copy) NSString *Sport;
@property (nonatomic, copy) NSString *Stats_Year;
@property (nonatomic, copy) NSString *Team_Name;
@property (nonatomic, copy) NSString *Website_Logo;
@property (nonatomic, copy) NSString *Team_Desc1;
@property (nonatomic, copy) NSString *Team_Desc2;
@property (nonatomic, copy) NSString *Team_Desc3;
@property (nonatomic, copy) NSString *admin_name;
@property (nonatomic, copy) NSString *admin_pw;
@property (nonatomic, copy) NSString *admin_email;
@property (nonatomic, copy) NSString *EmailAdminRpt;
@property (nonatomic, assign) int emailCoachRanking;

@property (nonatomic, copy) NSString *mgr_name;
@property (nonatomic, copy) NSString *mgr_pw;
@property (nonatomic, copy) NSString *mgr_email;
@property (nonatomic, copy) NSString *EmailMgrRpt;
@property (nonatomic, copy) NSString *contact_name;
@property (nonatomic, copy) NSString *contact_address;
@property (nonatomic, copy) NSString *contact_city;
@property (nonatomic, copy) NSString *contact_state;
@property (nonatomic, copy) NSString *contact_zip;
@property (nonatomic, copy) NSString *contact_email;
@property (nonatomic, copy) NSString *contact_phone;
@property (nonatomic, copy) NSString *trial;
@property (nonatomic, copy) NSString *subscription_end;
@property (nonatomic, assign) int Activated;
@property (nonatomic, copy) NSString *Notes;
@property (nonatomic, copy) NSString *Desc1;
@property (nonatomic, copy) NSString *Email1;
@property (nonatomic, copy) NSString *EmailDesc1Rpt;
@property (nonatomic, copy) NSString *Desc2;
@property (nonatomic, copy) NSString *Email2;
@property (nonatomic, copy) NSString *EmailDesc2Rpt;
@property (nonatomic, copy) NSString *Desc3;
@property (nonatomic, copy) NSString *Email3;
@property (nonatomic, copy) NSString *EmailDesc3Rpt;
@property (nonatomic, assign) int rptFitness;
@property (nonatomic, copy) NSString *SeasonStart;
@property (nonatomic, copy) NSString *SeasonEnd;
@property (nonatomic, assign) int Bulk_Import;
@property (nonatomic, copy) NSString *Team_Picture;
@property (nonatomic, assign) int Display_Picture;
@property (nonatomic, assign) int demoTeam;
@property (nonatomic, copy) NSString *modified;
@property (nonatomic, copy) NSString *quote;
@property (nonatomic, copy) NSString *noofmonth;
@property (nonatomic, copy) NSString *team_position;
@property (nonatomic, copy) NSString *selected_week;
@property (nonatomic, copy) NSString *selected_month;

@property (nonatomic, assign) int birthdayAlert;
@property (nonatomic, assign) int sendBirthdayAlert;
@property (nonatomic, copy) NSString *currently_running;
@property (nonatomic, assign) int run_only_once;
@property (nonatomic, copy) NSString *time_of_day;
@property (nonatomic, copy) NSString *selected_option;
@property (nonatomic, copy) NSString *day_of_week;
@property (nonatomic, copy) NSString *userLevel;

@property (nonatomic, copy) NSString *signupas;
@property (nonatomic, copy) NSString *teams;

@property (nonatomic, assign) int showbest;
@property (nonatomic, assign) int showworst;
@property (nonatomic, assign) int showlegend;
@property (nonatomic, assign) int email_login;
@property (nonatomic, assign) int email_journal;
@property (nonatomic, assign) int show_report_to_player;
@property (nonatomic, assign) int isSubscribe;

@end
