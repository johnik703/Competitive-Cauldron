//
//  Team.m
//  Cauldron
//
//  Created by John Nik on 6/1/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "Team.h"

@implementation Team

@synthesize TeamID;
@synthesize Sport;
@synthesize Stats_Year;
@synthesize Team_Name;
@synthesize Website_Logo;
@synthesize Team_Desc1;
@synthesize Team_Desc2;
@synthesize Team_Desc3;
@synthesize admin_name;
@synthesize admin_pw;
@synthesize admin_email;
@synthesize EmailAdminRpt;
@synthesize mgr_name;
@synthesize mgr_pw;
@synthesize mgr_email;
@synthesize EmailMgrRpt;
@synthesize emailCoachRanking;
@synthesize contact_name;
@synthesize contact_address;
@synthesize contact_city;
@synthesize contact_state;
@synthesize contact_zip;
@synthesize contact_email;
@synthesize contact_phone;
@synthesize trial;
@synthesize subscription_end;
@synthesize Activated;
@synthesize Notes;
@synthesize Desc1;
@synthesize Email1;
@synthesize EmailDesc1Rpt;
@synthesize Desc2;
@synthesize Email2;
@synthesize EmailDesc2Rpt;
@synthesize Desc3;
@synthesize Email3;
@synthesize EmailDesc3Rpt;
@synthesize rptFitness;
@synthesize SeasonStart;
@synthesize SeasonEnd;
@synthesize Bulk_Import;
@synthesize Team_Picture;
@synthesize Display_Picture;
@synthesize demoTeam;
@synthesize modified;
@synthesize quote;
@synthesize noofmonth;
@synthesize team_position;
@synthesize birthdayAlert;
@synthesize currently_running;
@synthesize day_of_week;
@synthesize run_only_once;
@synthesize selected_option;
@synthesize sendBirthdayAlert;
@synthesize time_of_day;
@synthesize userLevel;
@synthesize signupas;
@synthesize teams;
@synthesize selected_week;
@synthesize selected_month;



@synthesize showbest;
@synthesize showworst;
@synthesize showlegend;
@synthesize email_login;
@synthesize email_journal;
@synthesize show_report_to_player;
@synthesize isSubscribe;


- (instancetype)init {
    
    if ( self = [super init] ) {
        
        self.userLevel = @"";
        self.Website_Logo = @"";
        self.admin_email = @"";
        self.admin_name = @"";
        self.admin_pw = @"";
        self.birthdayAlert = 0;
        self.contact_address = @"";
        self.contact_city = @"";
        self.contact_email = @"";
        self.contact_name = @"";
        self.contact_phone = @"";
        self.contact_state = @"";
        self.contact_zip = @"";
        self.currently_running = @"0";
        
        //missing date_of_month
        
        self.day_of_week = @"";
        self.email_journal = 0;
        self.email_login = 0;
        self.mgr_email = @"";
        self.mgr_name = @"";
        self.modified = @"";
        self.noofmonth = 0;
        self.quote = @"";
        self.rptFitness = 0;
        self.run_only_once = 0;
        self.selected_option = 0;
        self.sendBirthdayAlert = 0;
        self.showbest = 0;
        self.showlegend = 0;
        self.showworst = 0;
        self.subscription_end = @"";
        self.team_position = @"";
        self.time_of_day = @"";
        self.trial = @"";
        self.Activated = 0;
        self.Bulk_Import = 0;
        self.Desc1 = @"";
        self.Desc2 = @"";
        self.Desc3 = @"";
        self.Display_Picture = 0;
        self.Email1 = @"";
        self.Email2 = @"";
        self.Email3 = @"";
        self.EmailAdminRpt = 0;
        self.EmailDesc1Rpt = @"";
        self.EmailDesc2Rpt = @"";
        self.EmailDesc3Rpt = @"";
        self.EmailMgrRpt = @"";
        self.Notes = @"";
        self.SeasonEnd = @"";
        self.SeasonStart = @"";
        self.Stats_Year = @"";
        self.TeamID = 0;
        self.Sport = @"";
        self.Team_Desc1 = @"";
        self.Team_Desc2 = @"";
        self.Team_Desc3 = @"";
        self.Team_Name = @"";
        self.Team_Picture = @"";
        self.isSubscribe = 0;
    }
    return self;
    
}

@end







