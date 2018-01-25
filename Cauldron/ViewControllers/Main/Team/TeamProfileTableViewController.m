//
//  TeamProfileTableViewController.m
//  Cauldron
//
//  Created by John Nik on 5/15/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "TeamProfileTableViewController.h"
#import "WebServicesLinks.h"
#import "LoginViewController.h"
#import "LoginUser.h"
#import "CreateTeamViewController.h"
#import "MainController.h"
#import "PercentProgressCustomView.h"

@interface TeamProfileTableViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate>
{
    PercentProgressCustomView *percentProgressView;
    BOOL isSelectedPhoto;
    NSString *base64;
//    NSDictionary *teamDictionary;
    
    @public
    
    
}
@end
#define KEYVALUE                @"serverSyncProgressValue"
#define PROGRESS_VALUE          @"ProgressValue"
#define TOTAL_VALUE             @"totalValue"

typedef void(^myCompletion)(BOOL);

@implementation TeamProfileTableViewController

@synthesize timeIntervalSC;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    [self setUpAllUIViews];
    self.navigationController.navigationBar.hidden = NO;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.subscriptionDateDDTF setUserInteractionEnabled:NO];
    
    if (_navigationTeamStatus == TeamState_Add) {
        
    } else if (_navigationTeamStatus == TeamState_Update) {
        [self fetchTeamDataWithGlobalCurrentTeam];
    } else if (self.navigationTeamStatus == TeamState_Create) {
        
        [self.navigationController setNavigationBarHidden:NO];
        self.navigationItem.title = @"Create Team";

    }
    
    [self getTeamPositionList];
    
    percentProgressView = [[PercentProgressCustomView alloc] initWithFrame:self.view.frame];
    
    UIView *keywindow = [UIApplication sharedApplication].keyWindow;
    [keywindow addSubview:percentProgressView];
    
    [percentProgressView setHidden:YES];
}

- (void)getTeamPositionList {
    
    _positionArr = [[NSMutableArray alloc] init];
    
    NSString *url = [NSString stringWithFormat:demoPostionList, (int)[Global.currntTeam.Sport integerValue]];
    
    
    [API executeHTTPRequest:Get url:url parameters:nil CompletionHandler:^(NSDictionary *responseDict) {
        [self parseResponsePosition:responseDict params:nil];
    } ErrorHandler:^(NSString *errorStr) {
        
        NSLog(@"request ---%@", errorStr);
        [Alert showAlert:@"Something went wrong" message:nil viewController:self];
    }];
    
}

- (void) parseResponsePosition: (NSDictionary *)dic params:(NSDictionary *)paramsDic {
    
    NSLog(@"position, %@", dic);
    
    NSString *successResult = [dic valueForKey:@"position"];
    NSLog(@"positiontext, %@", successResult);
    self.positionTF.text = successResult;
    
}


- (IBAction)goingBackLoginController:(id)sender {
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"SAVEDUSERID"];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"SAVEDUSERPASS"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ISLOGIN"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.navigationController popViewControllerAnimated:YES];
}




- (void) setUpAllUIViews {
    
    teamDictionary = [[NSMutableDictionary alloc] init];
    team = [[Team alloc] init];
    
    self.yearTF.delegate = self;
    self.teamNameTF.delegate = self;
    self.emailTF.delegate = self;
    self.positionTF.delegate = self;
    self.birthdayReportBeforeTF.delegate = self;
    self.seasonStartsDDTF.dropDownMode = IQDropDownModeDatePicker;
    self.seasonStartsDDTF.dateFormatter = [NSDateFormatter formatterFromFormatString:@"MM-dd-yyyy"];
    self.seasonEndsDDTF.dropDownMode = IQDropDownModeDatePicker;
    self.seasonEndsDDTF.dateFormatter = [NSDateFormatter formatterFromFormatString:@"MM-dd-yyyy"];
    self.timeDDTF.dropDownMode = IQDropDownModeTimePicker;
    self.timeDDTF.dateFormatter = [NSDateFormatter formatterFromFormatString:@"hh:mm:ss"];


    
}

- (void)fetchTeamDataWithGlobalCurrentTeam {
    
    NSLog(@"currentTeam, %@", Global.currntTeam);
    
    NSLog(@"subscription, %@", Global.currntTeam.subscription_end);
    
    self.yearTF.text = Global.currntTeam.Stats_Year;
    self.teamNameTF.text = Global.currntTeam.Team_Name;
    
    NSLog(@"seasonstart, %@", Global.currntTeam.SeasonStart);
    
    self.seasonStartsDDTF.date = [Global.currntTeam.SeasonStart dateWithFormat:@"MM-dd-yyyy"];
    self.seasonEndsDDTF.date = [Global.currntTeam.SeasonEnd dateWithFormat:@"MM-dd-yyyy"];
    self.subscriptionDateDDTF.text = Global.currntTeam.subscription_end;
    
    self.photoImgView.image = [UIImage imageWithData:[Global.currntTeam.Team_Picture base64Data]];
    if (self.photoImgView.image == nil) {
        self.photoImgView.image = [UIImage imageNamed:@"default_team_image.jpeg"];
    }
    [self.fitnessPassFailReportSC setOn:Global.currntTeam.rptFitness == 1 ? true : false];
    [self.bulkDataEntrySC setOn:Global.currntTeam.Bulk_Import == 1 ? true : false];
    [self.hightlightBestRankingSC setOn:Global.currntTeam.showbest == 1 ? true : false];
    [self.highlightDropSC setOn:Global.currntTeam.showworst == 1 ? true : false];
    [self.finalRankingReportSC setOn:Global.currntTeam.showlegend == 1 ? true : false];
    [self.emailCoachForPlayerLoginSC setOn:Global.currntTeam.email_login == 1 ? true : false];
    [self.emailCoachForJournalSC setOn:Global.currntTeam.email_journal == 1 ? true : false];
    [self.finalRankingReportSC setOn:Global.currntTeam.showlegend == 1 ? true : false];
    [self.activateSC setOn:Global.currntTeam.Activated == 1 ? true : false];
        
    self.birthdayReportBeforeTF.text = [NSString stringWithFormat:@"%d", Global.currntTeam.birthdayAlert];
    self.positionTF.text = Global.currntTeam.team_position;
    
    if ([Global.currntTeam.selected_option isEqualToString:@"Daily"]) {
        self.timeIntervalSC.selectedSegmentIndex = 0;
    } else if([Global.currntTeam.selected_option isEqualToString:@"Weekly"]) {
        self.timeIntervalSC.selectedSegmentIndex = 1;
    } else if([Global.currntTeam.selected_option isEqualToString:@"Monthly"]) {
        self.timeIntervalSC.selectedSegmentIndex = 2;
    }

    self.timeDDTF.dropDownMode = IQDropDownModeTimePicker;
    self.timeDDTF.dateFormatter = [NSDateFormatter formatterFromFormatString:@"hh:mm:ss"];
    self.timeDDTF.date = [Global.currntTeam.time_of_day dateWithFormat:@"hh:mm:ss"];
    
    [self.scheduleSwitch setOn:Global.currntTeam.run_only_once == 1 ? true : false];
    
    if ([Global.currntTeam.currently_running isEqual: @"1"])
        [self.enableSwitch setOn:true];
    else
        [self.enableSwitch setOn:false];
    
    self.emailTF.text = Global.currntTeam.EmailDesc1Rpt;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)fetchCurrentTeamDataOnGlobalTeamAfterSuccess {
    
    Global.currntTeam.Stats_Year = team.Stats_Year;
    Global.currntTeam.Team_Name = team.Team_Name;
    Global.currntTeam.SeasonStart = team.SeasonStart;
    Global.currntTeam.SeasonEnd = team.SeasonEnd;
    Global.currntTeam.subscription_end = team.subscription_end;
    Global.currntTeam.Team_Picture = team.Team_Picture;
    Global.currntTeam.rptFitness = team.rptFitness;
    Global.currntTeam.Bulk_Import = team.Bulk_Import;
    Global.currntTeam.showbest = team.showbest;
    Global.currntTeam.showworst = team.showworst;
    Global.currntTeam.showlegend = team.showlegend;
    Global.currntTeam.email_login = team.email_login;
    Global.currntTeam.Activated = team.Activated;
    Global.currntTeam.birthdayAlert = team.birthdayAlert;
    Global.currntTeam.team_position = team.team_position;
    Global.currntTeam.selected_option = team.selected_option;
    Global.currntTeam.time_of_day = team.time_of_day;
    Global.currntTeam.run_only_once = team.run_only_once;
    Global.currntTeam.currently_running = team.currently_running;
    Global.currntTeam.EmailDesc1Rpt = team.EmailDesc1Rpt;
    
}

- (void)fetchCurrentTeamDataOnGlobalTeam {
    team.Stats_Year = self.yearTF.text;
    team.Team_Name = self.teamNameTF.text;
    team.SeasonStart = [self.seasonStartsDDTF.date stringWithFormat:@"MM-dd-yyyy"];
    team.SeasonEnd = [self.seasonEndsDDTF.date stringWithFormat:@"MM-dd-yyyy"];
    team.subscription_end = self.subscriptionDateDDTF.text;
    
    if (isSelectedPhoto) {
//        NSString *base64;
        base64 = [UIImagePNGRepresentation(self.photoImgView.image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
        team.Team_Picture = base64;
    } else {
        
        if (self.navigationTeamStatus == TeamState_Update) {
            team.Team_Picture = Global.currntTeam.Team_Picture;
        } else if (self.navigationTeamStatus == TeamState_Add || self.navigationTeamStatus == TeamState_Create) {
            UIImage *image = [UIImage imageNamed:@"default_team_image.jpeg"];
            _photoImgView.image = image;
            base64 = [UIImagePNGRepresentation(_photoImgView.image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
            team.Team_Picture = base64;
        }
    }
    
    team.rptFitness = self.finalRankingReportSC.isOn == true ? 1 : 0;
    team.Bulk_Import = self.bulkDataEntrySC.isOn == true ? 1 : 0;
    team.showbest = self.hightlightBestRankingSC.isOn == true ? 1 : 0;
    team.showworst = self.highlightDropSC.isOn == true ? 1 : 0;
    team.showlegend = self.finalRankingReportSC.isOn == true ? 1 : 0;
    team.email_login = self.emailCoachForPlayerLoginSC.isOn == true ? 1 : 0;
    team.Activated = self.activateSC.isOn == true ? 1 : 0;
    team.birthdayAlert = self.birthdayReportBeforeTF.text == nil ? 0 : [self.birthdayReportBeforeTF.text intValue];
    team.team_position = self.positionTF.text == nil ? @"" : self.positionTF.text;
    
    if (self.timeIntervalSC.selectedSegmentIndex == 0) {
        team.selected_option = @"Daily";
    } else if(self.timeIntervalSC.selectedSegmentIndex == 1) {
        team.selected_option = @"Weekly";
    } else if(self.timeIntervalSC.selectedSegmentIndex == 2) {
        team.selected_option = @"Monthly";
    }
    
    team.time_of_day = self.timeDDTF.selected ? [self.timeDDTF.date stringWithFormat:@"hh:mm:ss"] : @"00:00:00";
    team.run_only_once = self.scheduleSwitch.isOn == true ? 1 : 0;
    team.currently_running = self.enableSwitch.isOn == true ? String(1) : String(0);
    team.EmailDesc1Rpt = self.emailTF.text == nil ? @"" : self.emailTF.text;
    
    [teamDictionary setValue:team.Stats_Year                        forKey:@"Stats_Year"];
    [teamDictionary setValue:team.Team_Name                         forKey:@"Team_Name"];
    [teamDictionary setValue:team.SeasonStart                       forKey:@"SeasonStart"];
    [teamDictionary setValue:team.SeasonEnd                         forKey:@"SeasonEnd"];
    [teamDictionary setValue:team.subscription_end                  forKey:@"SubscriptionEnd"];
    [teamDictionary setValue:team.Team_Picture                      forKey:@"Team_Picture"];
    [teamDictionary setValue:String(team.rptFitness)                forKey:@"ReprtFitness"];
    [teamDictionary setValue:String(team.Bulk_Import)               forKey:@"Bulk_Import"];
    [teamDictionary setValue:String(team.showbest)                  forKey:@"showbest"];
    [teamDictionary setValue:String(team.showworst)                 forKey:@"showworst"];
    [teamDictionary setValue:String(team.showlegend)                forKey:@"showlegend"];
    [teamDictionary setValue:String(team.email_login)               forKey:@"email_login"];
    [teamDictionary setValue:String(team.email_journal)             forKey:@"email_journal"];
    [teamDictionary setValue:String(team.Activated)                 forKey:@"Activated"];
    [teamDictionary setValue:String(team.birthdayAlert)             forKey:@"birthdayAlert"];
    [teamDictionary setValue:team.team_position                     forKey:@"team_position"];
    [teamDictionary setValue:team.selected_option                   forKey:@"selected_option"];
    [teamDictionary setValue:team.time_of_day                       forKey:@"time_of_day"];
    [teamDictionary setValue:String(team.run_only_once)             forKey:@"run_only_once"];
    [teamDictionary setValue:team.currently_running     forKey:@"currently_running"];
    [teamDictionary setValue:team.EmailDesc1Rpt                     forKey:@"EmailDesc1Rpt"];
}

-(void) createTeam {
    
    
    if (isSelectedPhoto) {
        base64 = [UIImagePNGRepresentation(_photoImgView.image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    } else {
        UIImage *image = [UIImage imageNamed:@"default_team_image.jpeg"];
        _photoImgView.image = image;
        base64 = [UIImagePNGRepresentation(_photoImgView.image) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }
    
    NSLog(@"image, %@", base64);
    
    NSString *selectedOption;
    NSString *selected_week;
    NSString *selected_month;
    if (self.timeIntervalSC.selectedSegmentIndex == 0) {
        selectedOption = @"Daily";
        selected_week = @"";
        selected_month = @"";
    } else if(self.timeIntervalSC.selectedSegmentIndex == 1) {
        selectedOption = @"Weekly";
        selected_week = @"Sunday";
        selected_month = @"";
    } else if(self.timeIntervalSC.selectedSegmentIndex == 2) {
        selectedOption = @"Monthly";
        selected_week = @"";
        selected_month = @"03/30/2017";
    }
    
    NSString *action;
    int teamId;
    if (self.navigationTeamStatus == TeamState_Add || self.navigationTeamStatus == TeamState_Create) {
        action = @"ADD_TEAM";
        teamId = 0;
        
        
        
    } else {
        action = @"EDIT_TEAM";
        teamId = Global.currentTeamId;
    }
    
    int Display_Picture = 1;
    int show_Final_RankingReport = 1;
    
    NSDictionary* params = @{@"PlayerID": Global.playerIDFinal,
                             @"Sports": Global.currntTeam.Sport,
                             @"action": action,
                             @"TeamID": String(teamId),
                             @"Stats_Year": self.yearTF.text,
                             @"Team_Name": self.teamNameTF.text,
                             @"SeasonStart": [self.seasonStartsDDTF.date stringWithFormat:@"MM-dd-yyyy"],
                             @"SeasonEnd": [self.seasonEndsDDTF.date stringWithFormat:@"MM-dd-yyyy"],
                             @"SubscriptionEnd": @"00-00-0000",
                             @"Team_Picture": base64,
                             @"ReprtFitness": String(_finalRankingReportSC.on == true ? 1 : 0),
                             @"Bulk_Import": String(_bulkDataEntrySC.on == true ? 1 : 0),
                             @"showbest": String(_hightlightBestRankingSC.on == true ? 1 : 0),
                             @"showworst": String(_highlightDropSC.on == true ? 1 : 0),
                             @"showlegend": String(_finalRankingReportSC.on == true ? 1 : 0),
                             @"email_login": String(_emailCoachForPlayerLoginSC.on == true ? 1 : 0),
                             @"email_journal": String(_emailCoachForJournalSC.on == true ? 1 : 0),
                             @"Activated": String(_activateSC.on == true ? 1 : 0),
                             @"birthdayAlert": _birthdayReportBeforeTF.text == nil? @"" : _birthdayReportBeforeTF.text,
                             @"team_position": _positionTF.text == nil? @"" : _positionTF.text,
                             @"selected_option": selectedOption,
                             @"time_of_day": _timeDDTF.selected ? [self.timeDDTF.date stringWithFormat:@"hh:mm:a"] : @"00:00:00",
                             @"run_only_once": String(_scheduleSwitch.on == true ? 1 : 0),
                             @"currently_running": String(_enableSwitch.on == true ? 1 : 0),
                             @"EmailDesc1Rpt": _emailTF.text == nil? @"" : _emailTF.text,
                             @"Display_Picture": String(Display_Picture),
                             @"selected_week": selected_week,
                             @"selected_month": selected_month,
                             @"show_Final_RankingReport": String(show_Final_RankingReport)
                             };
    
    
    NSLog(@"PlayerId-----%@", Global.playerIDFinal);
    [API executeHTTPRequest:Post url:syncToServerServiceURLManageTeam parameters:params CompletionHandler:^(NSDictionary *responseDict) {
        [ProgressHudHelper hideLoadingHud];
        [self parseResponse:responseDict params:params];
    } ErrorHandler:^(NSString *errorStr) {
        
        NSLog(@"request ---%@", Post);
        [ProgressHudHelper hideLoadingHud];
        [Alert showAlert:@"Something went wrong" message:nil viewController:self];
    }];
    
}

- (void) parseResponse: (NSDictionary *)dic params:(NSDictionary *)paramsDic {
    
    NSString *successResult = [dic valueForKey:@"status"];
    NSString *teamId = [dic valueForKey:@"TeamID"];
    int parentId = (int)[[dic valueForKey:@"parentID"] intValue];
    
    NSLog(@"success or fail if recieve data from server-----%@", successResult);
    NSLog(@"teamId if recieve data from server-----%@", teamId);
    NSLog(@"parentId if recieve data from server-----%d", parentId);
    
    if ([successResult isEqualToString:@"Success"]) {
        
        if (self.navigationTeamStatus == TeamState_Add || self.navigationTeamStatus == TeamState_Create) {

            
            NSMutableDictionary *createTeamDictionary = [NSMutableDictionary dictionaryWithDictionary:teamDictionary];
            NSLog(@"created team dictionary---%@", createTeamDictionary);
            [createTeamDictionary setValue:teamId                     forKey:@"TeamID"];
            [createTeamDictionary setValue:Global.currntTeam.Sport    forKey:@"Sports"];
            [createTeamDictionary setValue:Global.currntTeam.contact_name    forKey:@"contact_name"];
            NSLog(@"created team dictionary---%@", createTeamDictionary);
            
            BOOL success = [SQLiteHelper insertInTable:@"TeamInfo" params:createTeamDictionary];
            if (success) {
                
                if (parentId == 0) {
                    
                    [Alert showAlert:@"Team Created successfully!" message:nil viewController:self complete:^{
                        
                        [self goingHomepageAfterSignUp:teamId];
                        
                    }];
                    
                } else {
                    
                    [Alert showAlert:@"Team added successfully!" message:nil viewController:self complete:^{
                        NSLog(@"test temid, arrteam count-----%@, %lu", teamId, (unsigned long)Global.arrTeamsId.count);
                        
                        if (Global.arrTeamsId == nil) {
                            Global.arrTeamsId = [[NSMutableArray alloc] init];
                        }
                        
                        [Global.arrTeamsId addObject:teamId];
                        NSLog(@"test temid, arrteam count-----%@, %lu", teamId, (unsigned long)Global.arrTeamsId.count);
                        NSLog(@"global teams arrid---%lu", (unsigned long)Global.arrTeamsId.count);
                        
                        Team* tempTeam = [[Team alloc] init];
                        tempTeam.Team_Name = self.teamNameTF.text;
                        tempTeam.Sport = Global.currntTeam.Sport;
                        tempTeam.Team_Picture = base64;
                        NSLog(@"tempteamid--%@", teamId);
                        tempTeam.TeamID = (int)[teamId intValue];
                        
                        
                        [self syncFromServerForCategoryAndChallenge:teamId];
                    }];
                }
            } else {
                [Alert showAlert:@"Error" message:@"Failed to add Team in local" viewController:self];
            }
            
        } else {
            NSDictionary *whereDic = @{@"TeamID": String(Global.currentTeamId)};
            NSLog(@"current team id----%d, ---%d", Global.currentTeamId, Global.currntTeam.TeamID);
            BOOL success = [SQLiteHelper updateInTable:@"TeamInfo" params:teamDictionary where:whereDic];
            if (success) {
                [self fetchCurrentTeamDataOnGlobalTeamAfterSuccess];
                
                [Alert showAlert:@"Team successfully updated" message:nil viewController:self complete:^{
                    
                    
                    NSLog(@"test update");
                    [self.navigationController popViewControllerAnimated:true];
                    
                }];
            } else {
                [Alert showAlert:@"Error" message:@"Failed to update team in local" viewController:self];
            }
        }
    } else {
        
        if (_navigationTeamStatus == TeamState_Add) {
            [Alert showAlert:@"Failed to Add Team" message:nil viewController:self];
            return;
            
        } else if (_navigationTeamStatus == TeamState_Update) {
            [Alert showAlert:@"Failed to Update Team" message:nil viewController:self];
            return;
        } else if (self.navigationTeamStatus == TeamState_Create) {
            [Alert showAlert:@"Failed to Create Team" message:nil viewController:self];
            return;
        }
    }
}

- (void) syncFromServerForCategoryAndChallenge: (NSString *)teamId {
    
//    [ProgressHudHelper showLoadingHudWithText:@"UpdatingChallengeData...."];
    
    [percentProgressView showProgress];
    
    SyncFromServer *syncFromServer = [[SyncFromServer alloc] init];
    syncFromServer.delegate = self;
    
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2 * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
//        [syncFromServer startSyncFromServerWithDataDict:nil serviceType:@"startSync" WithTeamID:(int)teamId syncCount:2];
//    });
    
    
    
    int cnt = (int)Global.arrTeamsId.count;
    for (int i = 0; i < cnt; i++) {
        NSInteger teamId = [[Global.arrTeamsId objectAtIndex:i] integerValue];
        [syncFromServer startSyncFromServerWithDataDict:nil serviceType:@"startSync" WithTeamID:(int)teamId syncCount:cnt playerID:(int)[Global.playerIDFinal intValue] mode:Global.mode];
        
    }
    

    
    
}



- (void) goingHomepageAfterSignUp: (NSString *)teamId {
    
    NSString *userID = [[NSUserDefaults standardUserDefaults] stringForKey:@"SAVEDUSERID"];
    NSString *userPassword = [[NSUserDefaults standardUserDefaults] stringForKey:@"SAVEDUSERPASS"];

    NSData *plainData = [userPassword dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64String];
    
    
    BOOL checkConn = [RKCommon checkInternetConnection];
    
    if (!checkConn) {
        [ProgressHudHelper hideLoadingHud];
        [Alert showAlert:@"Connection Error" message:@"No Active Connection Found" viewController:self];
        return;
    }
    
    [ProgressHudHelper showLoadingHudWithText:@"Authenticating..."];
    [self performSelector:@selector(dismissGlobalHUDByDelay) withObject:nil afterDelay:30];
    
    NSDictionary *dictionary = [JSONHelper loadJSONDataFromURL:[NSString stringWithFormat:loginServiceURL, userID.stringByReplacingWhiteSpace, base64String.stringByReplacingWhiteSpace]];
    NSLog(@"Authentication Detail : %@",[NSString stringWithFormat:loginServiceURL,userID,base64String]);
    LoginUser *aUser = [DataFetcherHelper getloginDataFromDict:dictionary];
    
    NSLog(@"login dictionary---%@", dictionary);
    NSLog(@"login aUser---%@", aUser.userState);
    
    
    Global.playerIDFinal=[NSString stringWithFormat:@"%d",aUser.PlayerID];
    [[NSUserDefaults standardUserDefaults] setInteger:aUser.PlayerID forKey:@"playerIDFinal"];
    [[NSUserDefaults standardUserDefaults] setInteger:aUser.UserLevel forKey:@"USERLEVEL"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",aUser.teams] forKey:@"teams"];
    NSString *teams = [[NSUserDefaults standardUserDefaults] stringForKey:@"teams"];
    NSLog(@"user lvl %@",teams);
    NSLog(@"user lvl %d",aUser.UserLevel);
    
    [Global.globalInfoArr addObject:dictionary];
    
    [[NSUserDefaults standardUserDefaults] setObject:aUser.UserName forKey:@"ONLINE_PREVIOUS_LOG_USERNAME"];
    [[NSUserDefaults standardUserDefaults] setObject:aUser.Password forKey:@"ONLINE_PREVIOUS_LOG_PASSWORD"];
    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",aUser.UserLevel ] forKey:@"ONLINE_PREVIOUS_LOG_USERLEVEL"];
    
    // got sync data from server
    [ProgressHudHelper hideLoadingHud];
    
    [percentProgressView showProgress];
    
    [self performSelector:@selector(dismissGlobalHUDByDelay) withObject:nil afterDelay:30];
    SyncFromServer *syncData = [[SyncFromServer alloc]init];
    syncData.delegate = self;
    
    Global.mode = (int)aUser.Mode;
    Global.arrTeamsId = aUser.arrTeams;
    Global.currentTeamId = aUser.TeamID;
    Global.masterTeamId = aUser.TeamID;
    
    [[NSUserDefaults standardUserDefaults] setInteger:Global.mode forKey:@"USER_MODE"];
    [[NSUserDefaults standardUserDefaults] setObject:aUser.arrTeams forKey:@"ARRTEAMS"];
    [[NSUserDefaults standardUserDefaults] setObject:String(aUser.PlayerID) forKey:@"PLAYERID"];
    [[NSUserDefaults standardUserDefaults] setObject:aUser.Sport forKey:@"SPORT"];
    [[NSUserDefaults standardUserDefaults] setInteger:Global.masterTeamId forKey:@"MASTERTEAMID"];
    
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM TeamInfo WHERE admin_name ='%@' AND admin_pw ='%@'",userID,userPassword];
    NSArray *recordsFound = [SCSQLite selectRowSQL:query];
    
    NSLog(@"Found Record Details : %@",recordsFound);
    
    NSLog(@"User_Mode, %d", Global.mode);
    
    if (aUser.Mode == USER_MODE_CLUB) {
        int cnt = (int)aUser.arrTeams.count;
        
        for (int i = 0; i < cnt; i++) {
            NSInteger teamId = [[aUser.arrTeams objectAtIndex:i] integerValue];
            [syncData startSyncFromServerWithDataDict:nil serviceType:@"startSync" WithTeamID:(int)teamId syncCount:cnt playerID:(int)[Global.playerIDFinal intValue] mode:Global.mode];
        }
        
    } else {
        [syncData startSyncFromServerWithDataDict:nil serviceType:@"startSync" WithTeamID:aUser.TeamID syncCount:1 playerID:(int)[Global.playerIDFinal intValue] mode:Global.mode];
    }
}

- (void)syncFromServerProcessCompleted {
    
    if (self.navigationTeamStatus == TeamState_Create) {
        NSString *userID = [[NSUserDefaults standardUserDefaults] stringForKey:@"SAVEDUSERID"];
        NSString *userPassword = [[NSUserDefaults standardUserDefaults] stringForKey:@"SAVEDUSERPASS"];
        
        
        [self checkAuthenticationOfflineWithUserID:userID andPassword:userPassword];
        
        [percentProgressView hideProgressBar];
        [percentProgressView setHidden:YES];
    } else if (self.navigationTeamStatus == TeamState_Add) {
        
        [self myMethod:^(BOOL finished) {
            if(finished){
                NSLog(@"success");
                [self showAlert];
            }
        }];
        
    }
    
    
}

-(void) myMethod:(myCompletion) compblock{
    //do stuff
    
    [percentProgressView setHidden:true];
    [percentProgressView->percentLabel setHidden:YES];
    [percentProgressView->progressView setHidden:YES];
    [percentProgressView hideProgressBar];
    
    compblock(YES);
}


-(void)showAlert {
    [Alert showAlert:@"Sync Completed!" message:nil viewController:self complete:^{
        [self.navigationController popViewControllerAnimated:true];
    }];
}

- (void)checkAuthenticationOfflineWithUserID:(NSString*)userID andPassword:(NSString*)UserPass {
    
    [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
    //???
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM TeamInfo WHERE admin_name ='%@' AND admin_pw ='%@'",userID,UserPass];
    NSArray *recordsFound = [SCSQLite selectRowSQL:query];
    
    NSLog(@"Found Record Details : %@",recordsFound);
    int userLevel;
    
    if (recordsFound.count > 0) {
        [Global.globalInfoArr addObjectsFromArray:recordsFound];
        userLevel = (int)[[[recordsFound objectAtIndex:0]valueForKey:@"userLevel"]integerValue];
    }

    if (recordsFound.count > 0 && userLevel != 0 )
    {
        ChallangesVC *allChallanges=[[ChallangesVC alloc]init];
        
        // Goto Menu View
//        SWRevealViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SWRevealViewController"];
        
        allChallanges.userTeamID = (int)[[[recordsFound objectAtIndex:0]valueForKey:@"TeamID"]integerValue];
        Global.teamSportID=(int)[[[recordsFound objectAtIndex:0]valueForKey:@"TeamID"]integerValue];
        Global.startDate=[[recordsFound objectAtIndex:0]valueForKey:@"TeamID"];
        Global.endDate=[[recordsFound objectAtIndex:0]valueForKey:@"TeamID"];
        NSString *sprtsTypeQuery = [NSString stringWithFormat:@"SELECT Sports,Team_Name,SeasonStart,SeasonEnd FROM TeamInfo WHERE TeamID=%d", allChallanges.userTeamID];
        NSArray *records = [SCSQLite selectRowSQL:sprtsTypeQuery];
        
        int teamSportID = (int)[[[records objectAtIndex:0]valueForKey:@"Sports"]integerValue];
        Global.teamName=[[records objectAtIndex:0]objectForKey:@"Team_Name"];
        Global.startDate=[[records objectAtIndex:0] objectForKey:@"SeasonStart"];
        Global.endDate=[[records objectAtIndex:0] objectForKey:@"SeasonEnd"];
        
        Global.arrTeamsId = [[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:@"ARRTEAMS"];
        Global.playerIDFinal = [[NSUserDefaults standardUserDefaults] stringForKey:@"PLAYERID"];
        Global.currntTeam.Sport = [[NSUserDefaults standardUserDefaults] stringForKey:@"SPORT"];
//        Global.mode = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"USER_MODE"];
        
        NSLog(@"Type OF Sport Details : %@",Global.teamName);
        allChallanges.soportsID = teamSportID;
        
        // Save Username and Password For Next Login
        [[NSUserDefaults standardUserDefaults] setObject:userID forKey:@"SAVEDUSERID"];
        [[NSUserDefaults standardUserDefaults] setObject:UserPass forKey:@"SAVEDUSERPASS"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ISLOGIN"];
        [[NSUserDefaults standardUserDefaults] setObject:Global.teamName forKey:@"Team_Name"];
//        [[NSUserDefaults standardUserDefaults] setObject:Global.arrTeamsId forKey:@"ARRTEAMS"];
//        [[NSUserDefaults standardUserDefaults] setObject:Global.playerIDFinal forKey:@"PLAYERID"];
        [[NSUserDefaults standardUserDefaults] setObject:Global.currntTeam.Sport forKey:@"SPORT"];
//        [[NSUserDefaults standardUserDefaults] setInteger:Global.mode forKey:@"USER_MODE"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSLog(@"User_Mode, %d", Global.mode);
        
        //        Global.mode = 2;
        
        if (Global.mode  == USER_MODE_CLUB || Global.mode == USER_MODE_COACH) {
           CreateTeamViewController *newCreateTeamViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateTeamViewController"];
            newCreateTeamViewController.navigationCreateControllerStatus = CreateControllerState_Signup;
            
            UINavigationController *viewController = [[UINavigationController alloc] initWithRootViewController:newCreateTeamViewController];
            ApplicationDelegate.window.rootViewController = viewController;
        } else if (Global.mode == USER_MODE_INDIVIDUAL || Global.mode == USER_MODE_PLAYER) {
            MainController *mainController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainController"];
            
            UINavigationController *viewController = [[UINavigationController alloc] initWithRootViewController:mainController];
            ApplicationDelegate.window.rootViewController = viewController;
        }
        
    } else {
        
        [Alert showAlert:@"Internal Error" message:@"Invalid Username or Password" viewController:self];
    }
}


- (void)dismissGlobalHUDByDelay {
    //if no connection hide hude after 15 second
    BOOL activeConn = [RKCommon checkInternetConnection];
    
    if (activeConn == NO) {
        [ProgressHudHelper hideLoadingHud];
        [Alert showAlert:@"Connection Error" message:@"No Active Connection Found" viewController:self];
    }
}

- (void) setCategoryAfterAddTeam: (NSString *)teamId {
    
    NSDictionary* params = @{@"mode": @"ADD_TEAM",
                             @"Sports": Global.currntTeam.Sport,
                             @"TeamID": teamId
                             };

    [API executeHTTPRequest:Post url:syncToServerServiceURLManageChallenge parameters:params CompletionHandler:^(NSDictionary *responseDict) {
        [ProgressHudHelper hideLoadingHud];
        [self parseResponseCategory:responseDict params:params];
    } ErrorHandler:^(NSString *errorStr) {
        
        NSLog(@"Category create error ---%@", errorStr);
        return;
    }];

    
}

- (void) parseResponseCategory: (NSDictionary *)dic params:(NSDictionary *)paramsDic {
    
    NSLog(@"testCategory---%@", dic);
    
    NSString *successResult = [dic valueForKey:@"mode"];
    NSString *teamId = [dic valueForKey:@"TeamID"];
    
    NSLog(@"success or fail if recieve data from server-----%@", successResult);
    NSLog(@"teamId if recieve data from server-----%@", teamId);
    
    if ([successResult isEqualToString:@"Success"]) {
        
        NSLog(@"Category created successfully");
        return;
        
    } else {
        NSLog(@"Failed to create Category");
        return;
    }
}


#pragma mark - IBActions

- (IBAction)didTapSave:(id)sender {
    
    if (![self checkValidation]) {
        return;
    }
    
    BOOL checkConnection = [RKCommon checkInternetConnection];
    if (!checkConnection) {
        [Alert showAlert:@"Internet Connection Error" message:@"" viewController:self];
        return;
    }
    
    if (self.navigationTeamStatus == TeamState_Add || self.navigationTeamStatus == TeamState_Create) {
//        [Alert showAlert:@"Create Team?" message:@"Are you sure?" viewController:self complete:^{
//            [ProgressHudHelper showLoadingHudWithText:@"Wait..."];
//            [self fetchCurrentTeamDataOnGlobalTeam];
//            [self createTeam];
//        }];
        
        [Alert showOKCancelAlert:@"Create Team?" message:@"Are you sure?" viewController:self complete:^{
            [ProgressHudHelper showLoadingHudWithText:@"Wait..."];
            [self fetchCurrentTeamDataOnGlobalTeam];
            [self createTeam];
        } canceled:^{
            NSLog(@"canceled");
        }];
        
    } else if (self.navigationTeamStatus == TeamState_Update) {
//        [Alert showAlert:@"Edit Team?" message:@"Are you sure?" viewController:self complete:^{
//            [ProgressHudHelper showLoadingHudWithText:@"Wait..."];
//            [self fetchCurrentTeamDataOnGlobalTeam];
//            [self createTeam];
//        }];
        [Alert showOKCancelAlert:@"Edit Team?" message:@"Are you sure?" viewController:self complete:^{
            [ProgressHudHelper showLoadingHudWithText:@"Wait..."];
            [self fetchCurrentTeamDataOnGlobalTeam];
            [self createTeam];
        } canceled:^{
            NSLog(@"canceled");
        }];

    }
    
    
    
    
    
}

- (IBAction)didTapSegment:(id)sender {
    
    if (timeIntervalSC.selectedSegmentIndex == 0) {
        NSLog(@"selected daily--%ld", (long)timeIntervalSC.selectedSegmentIndex);
    } else if(timeIntervalSC.selectedSegmentIndex == 1) {
        NSLog(@"selected daily--%ld", (long)timeIntervalSC.selectedSegmentIndex);
    } else if(timeIntervalSC.selectedSegmentIndex == 2) {
        NSLog(@"selected daily--%ld", (long)timeIntervalSC.selectedSegmentIndex);
    }
    
}

- (IBAction)didTapBack:(id)sender {
    [self dismissViewControllerAnimated:true completion:nil];
}

- (IBAction)didTapPhoto:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        [imagePickerController setAllowsEditing:YES];
        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:YES completion:nil];
        
    }];
    UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"Choose Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIImagePickerController* imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [imagePickerController setAllowsEditing:YES];
        imagePickerController.delegate = self;
        [self presentViewController:imagePickerController animated:YES completion:nil];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [actionSheet addAction:cameraAction];
    [actionSheet addAction:libraryAction];
    [actionSheet addAction:cancelAction];
    
    [actionSheet setModalPresentationStyle:UIModalPresentationPopover];
    
    UIPopoverPresentationController *popPresenter = [actionSheet popoverPresentationController];
    popPresenter.sourceView = (UIButton *)sender;
    popPresenter.sourceRect = ((UIButton *)sender).bounds;
    
    [self presentViewController:actionSheet animated:true completion:nil];
    
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 0) {
        return 180;
    }
    
    if (indexPath.section == 2 && indexPath.row == 1) {
        return 0;
    }
    
    if (indexPath.section == 2 && indexPath.row == 8) {
        return 0;
    }
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return @"Season";
    } else if (section == 2) {
        return @"Contact";
    } else if (section == 3) {
        return @"Schedule";
    }
    return @"";
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    _photoImgView.image = image;
    isSelectedPhoto = true;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Public Methods

- (BOOL) checkValidation {
    if ([self.teamNameTF.text isEqualToString:@""]) {
        [Alert showAlert:@"Team name is required" message:@"" viewController:self];
        return false;
    }
    if ([self.yearTF.text isEqualToString:@""]) {
        [Alert showAlert:@"State Year is required" message:@"" viewController:self];
        return false;
    }
    if ([self.seasonStartsDDTF.text isEqualToString:@""]) {
        [Alert showAlert:@"Season Starts is required" message:@"" viewController:self];
        return false;
    }
    if ([self.seasonEndsDDTF.text isEqualToString:@""]) {
        [Alert showAlert:@"Season Ends is required" message:@"" viewController:self];
        return false;
    }
    return true;
}

@end
