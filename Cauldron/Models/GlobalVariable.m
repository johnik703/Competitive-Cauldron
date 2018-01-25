//
//  GlobalVariable.m
//  Cauldron
//
//  Created by John Nik on 6/1/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "GlobalVariable.h"

@implementation GlobalVariable
@synthesize objSignUp, teamSportID, currntTeam, currentTeamId, currentChallenge, currendCategoryArr, masterTeamId, syncCount, attendenceSyncCount, attendenceDateArr;

static GlobalVariable *singleton = nil;

+ (GlobalVariable *) sharedInstance {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        singleton = [[self alloc] init];
    });
    
    return singleton;
}

-(id)init {
    if ( self = [super init] ) {
        self.globalInfoArr = [[NSMutableArray alloc] init];
        self.journalReportArr = [[NSMutableArray alloc] init];
//        self.arrTeamsDetail = [[NSMutableArray alloc] init];
        self.currntTeam = [[Team alloc] init];
        self.currentChallenge = [[NSMutableDictionary alloc] init];
        self.currendCategoryArr = [[NSArray alloc] init];
        self.attendenceDateArr = [[NSMutableArray alloc] init];
    }
    return self;
}

-(void)loadUserProfileDataInLocal {
    objSignUp = [[Signup alloc] init];
    
    NSString *sprtsTypeQuery = [NSString stringWithFormat:@"SELECT * FROM TeamInfo WHERE TeamID=%d",teamSportID];
    NSArray *records = [SCSQLite selectRowSQL:sprtsTypeQuery];
    
    if (records.count > 0) {
        NSLog(@"records  %@",records);
        
        objSignUp.userlevel = [[records objectAtIndex:0]valueForKey:@"userLevel"];
        objSignUp.sports = [[records objectAtIndex:0]valueForKey:@"Sports"];
        objSignUp.statsYear = [[records objectAtIndex:0]valueForKey:@"Stats_Year"];
        objSignUp.teamName = [[records objectAtIndex:0]valueForKey:@"Team_Name"];
        objSignUp.base64Pic = [[records objectAtIndex:0]valueForKey:@"Team_Picture"];
        NSLog(@"records  %@",[[records objectAtIndex:0]valueForKey:@"SubscriptionEnd"]);
        
        objSignUp.subscriptionEnds = [[records objectAtIndex:0]valueForKey:@"SubscriptionEnd"];
        objSignUp.isDisplayPic = [[[records objectAtIndex:0]valueForKey:@"Display_Picture"] boolValue];
        objSignUp.isActivate = [[[records objectAtIndex:0]valueForKey:@"Activated"] boolValue];
        
        objSignUp.adminLoginName = [[records objectAtIndex:0]valueForKey:@"admin_name"];
        objSignUp.adminPassword = [[records objectAtIndex:0]valueForKey:@"admin_pw"];
        objSignUp.adminEmail = [[records objectAtIndex:0]valueForKey:@"admin_email"];
        objSignUp.mgrLoginName = [[records objectAtIndex:0]valueForKey:@"mgr_name"];
        objSignUp.mgrPassword = [[records objectAtIndex:0]valueForKey:@"mgr_pw"];
        objSignUp.mgrEmail = [[records objectAtIndex:0]valueForKey:@"mgr_email"];
        
        objSignUp.bdayBefor = [[records objectAtIndex:0]valueForKey:@"birthdayAlert"];
        objSignUp.position = [[records objectAtIndex:0]valueForKey:@"team_position"];
        objSignUp.isIncludeFitness = [[[records objectAtIndex:0]valueForKey:@"ReprtFitness"] boolValue];
        objSignUp.isBulckReport = [[[records objectAtIndex:0]valueForKey:@"Bulk_Import"] boolValue];
        objSignUp.isBdayBefore = [[[records objectAtIndex:0]valueForKey:@"sendBirthday"] boolValue];
        objSignUp.sessionStarts = [[records objectAtIndex:0]valueForKey:@"SeasonStart"];
        objSignUp.sessionEnds = [[records objectAtIndex:0]valueForKey:@"SeasonEnd"];
        
        NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[NSDate date]];
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *dateComponents = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:[NSDate date]];
        
        //set date components
        [dateComponents setDay:[components day]];
        [dateComponents setMonth:[components month] + 1];
        [dateComponents setYear:[components year]];
        
        objSignUp.contactName = [[records objectAtIndex:0]valueForKey:@"contact_name"];
        objSignUp.address = [[records objectAtIndex:0]valueForKey:@"contact_address"];
        objSignUp.state = [[records objectAtIndex:0]valueForKey:@"contact_state"];
        objSignUp.city = [[records objectAtIndex:0]valueForKey:@"contact_city"];
        objSignUp.zip = [[records objectAtIndex:0]valueForKey:@"contact_zip"];
        objSignUp.contactEmail = [[records objectAtIndex:0]valueForKey:@"contact_email"];
        objSignUp.contactPhone = [[records objectAtIndex:0]valueForKey:@"contact_phone"];
        
        NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
        [formatter2 setDateFormat:@"hh:mm:ss"];
        [formatter2 setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
        
        objSignUp.timeOfDay = [[records objectAtIndex:0]valueForKey:@"time_of_day"];
        objSignUp.dayOfWeek = [[records objectAtIndex:0]valueForKey:@"day_of_week"];
        objSignUp.timeInterval = [[records objectAtIndex:0]valueForKey:@"selected_option"];
        objSignUp.isRunSchedual = [[[records objectAtIndex:0]valueForKey:@"run_only_once"] boolValue];
        objSignUp.isEnable = [[[records objectAtIndex:0]valueForKey:@"currently_running"] boolValue];
        
        objSignUp.isHighlightBest = [[[records objectAtIndex:0]valueForKey:@"showbest"] boolValue];
        objSignUp.isHighlightDrop = [[[records objectAtIndex:0]valueForKey:@"showworst"] boolValue];
        objSignUp.isDisplayLegend = [[[records objectAtIndex:0]valueForKey:@"showlegend"] boolValue];
        objSignUp.isEmailJournal = [[[records objectAtIndex:0]valueForKey:@"email_journal"] boolValue];
        objSignUp.isEmailPlayer = [[[records objectAtIndex:0]valueForKey:@"email_login"] boolValue];
    }
}

@end
