
//
//  LoginViewController.m
//  Cauldron
//
//  Created by John Nik on 5/18/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "WebServicesLinks.h"
#import "JSONHelper.h"
#import "Player.h"
#import "DataFetcherHelper.h"
#import "LoginUser.h"
#import "SCSQLite.h"
#import "RKCommon.h"
#import "SSCheckBoxView.h"
#import "CreateTeamViewController.h"
#import "TeamProfileTableViewController.h"
#import "MainController.h"
#import "PercentProgressView.h"
#import "PercentProgressCustomView.h"
#import "UIApplication+AppVersion.h"


@interface LoginViewController() {
    PercentProgressCustomView *percentProgressView;
}

@end

#define KEYVALUE                @"serverSyncProgressValue"
#define PROGRESS_VALUE          @"ProgressValue"
#define TOTAL_VALUE             @"totalValue"

@implementation LoginViewController

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController setNavigationBarHidden:YES];
    
    self.facebookBtn.hidden = YES;
    
    
    percentProgressView = [[PercentProgressCustomView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    UIView *keywindow = [UIApplication sharedApplication].keyWindow;
    [keywindow addSubview:percentProgressView];
    
    [percentProgressView setHidden:YES];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
    if (UDGetBool(@"ISLOGIN")) {
        NSString *userID = [[NSUserDefaults standardUserDefaults] stringForKey:@"SAVEDUSERID"];
        NSString *userPassword = [[NSUserDefaults standardUserDefaults] stringForKey:@"SAVEDUSERPASS"];
        [self checkAuthenticationOfflineWithUserID:userID andPassword:userPassword];
    }
    
    
    [self createCheckBox];
    
    [self setiPhoneAndiPadUI];
}

- (void)setiPhoneAndiPadUI {
    
    if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        
        [[self.authView.heightAnchor constraintEqualToConstant:100] setActive:true];
        
        [self.emailTF setFont:[UIFont systemFontOfSize:15]];
        [self.passwordTF setFont:[UIFont systemFontOfSize:15]];
        [self.forgotBtn.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [self.loginBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.facebookBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        
    } else {
        
        [[self.authView.heightAnchor constraintEqualToConstant:120] setActive:true];
        
        [self.emailTF setFont:[UIFont systemFontOfSize:30]];
        [self.passwordTF setFont:[UIFont systemFontOfSize:30]];
        [self.forgotBtn.titleLabel setFont:[UIFont systemFontOfSize:24]];
        [self.loginBtn.titleLabel setFont:[UIFont systemFontOfSize:28]];
        [self.facebookBtn.titleLabel setFont:[UIFont systemFontOfSize:28]];
        
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - IBActions

- (IBAction)loginBtnTapped:(id)sender {
    
    if (![self checkValidation]) {
        return;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:_emailTF.text forKey:@"SAVEDUSERID"];
    [[NSUserDefaults standardUserDefaults] setObject:_passwordTF.text forKey:@"SAVEDUSERPASS"];
    
    [[NSUserDefaults standardUserDefaults] setObject:Global.teamName forKey:@"Team_Name"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *prevUserName = [[NSUserDefaults standardUserDefaults] stringForKey:@"ONLINE_PREVIOUS_LOG_USERNAME"];
    NSString *prevPass = [[NSUserDefaults standardUserDefaults] stringForKey:@"ONLINE_PREVIOUS_LOG_PASSWOR"];
    NSString *prevLevel = [[NSUserDefaults standardUserDefaults] stringForKey:@"ONLINE_PREVIOUS_LOG_USERLEVEL"];
    [_emailTF resignFirstResponder];
    [_passwordTF resignFirstResponder];
    
    // Load Data
    [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
    
    NSData *plainData = [_passwordTF.text dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [plainData base64String];
    
    //???
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM TeamInfo WHERE admin_name='%@' AND admin_pw='%@'", _emailTF.text, _passwordTF.text];
    NSArray *records = [SCSQLite selectRowSQL:query];
    
    if (records.count > 0 && [prevUserName isEqualToString:_emailTF.text] && [prevPass isEqualToString:_passwordTF.text]) {
        [self checkAuthenticationOfflineWithUserID:_emailTF.text andPassword:_passwordTF.text];
    } else {
        [self checkAuthenticationOnlineWithUserID:_emailTF.text andPassword:base64String];
    }
}

- (IBAction)facebookBtnTapped:(id)sender {
}

- (IBAction)didTapRegister:(id)sender {
    RegisterViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RegisterViewController"];
    viewController.navigationStatus = RegisterState_Singup;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:nav animated:true completion:nil];
}

- (IBAction)didTapForgotPassword:(id)sender {
    ForgotPasswordViewController *viewController = (ForgotPasswordViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"ForgotPasswordViewController"];
    [self presentViewController:viewController animated:true completion:nil];
}

#pragma mark - SyncFromServerDelegate

- (void)syncFromServerProcessCompleted {
    [self checkAuthenticationOfflineWithUserID:_emailTF.text andPassword:_passwordTF.text];
    
    [percentProgressView hideProgressBar];
}

#pragma mark - Private Methods

- (void) setupUI {
    self.authView.layer.borderWidth = 1.0f;
}

- (BOOL) checkValidation {
    if ([_emailTF.text isEqualToString:@""]) {
        [Alert showAlert:@"Username is required" message:@"" viewController:self];
        return false;
    }
    
    if ([_passwordTF.text isEqualToString:@""]) {
        [Alert showAlert:@"Password is required" message:nil viewController:self];
        return false;
    }
    
    return true;
}

- (void) checkCurrentAppVersion {
    NSString *currentAppVersion = [UIApplication versionBuild];
    if ([currentAppVersion  isEqual: FINAL_APP_VERSION]) {
        [Alert showAlert:@"Thank you for your update!" message:@"You should log in again because our database was updated." viewController:self];
        return;
    }
}

- (BOOL) isFinalDatabase {
    
    int appDatabaseVersion = (int)[UserDefaults integerForKey:@"FINAL_DATABASE_VERSION"];
    
    if (appDatabaseVersion < FINAL_DATABASE_VERSION) {
        return NO;
    }
    return YES;
}



- (void)checkAuthenticationOfflineWithUserID:(NSString*)userID andPassword:(NSString*)UserPass {
    
    // we need this logic if the database was updated in the new versioin
//    [self checkCurrentAppVersion];
    
    if (UDGetBool(@"ISLOGIN")) {
        if (![self isFinalDatabase]) {
            [Alert showAlert:@"Thank you for your update!" message:@"You should login again because our database updated." viewController:self];
            return;
        }
    }
 
    [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM TeamInfo WHERE upper(admin_name) ='%@' AND admin_pw ='%@'",userID.uppercaseString,UserPass];
    NSArray *recordsFound = [SCSQLite selectRowSQL:query];
    int userLevel;
    
    if (recordsFound.count > 0) {
        [Global.globalInfoArr addObjectsFromArray:recordsFound];
        userLevel = (int)[[[recordsFound objectAtIndex:0]valueForKey:@"userLevel"]integerValue];
    }
    
    if (recordsFound.count > 0 && userLevel != 0 )
    {
        ChallangesVC *allChallanges=[[ChallangesVC alloc]init];
        
        
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
        Global.mode = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"USER_MODE"];
        Global.syncCount = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"SYNCCOUNT"];
        Global.masterTeamId = (int)[[NSUserDefaults standardUserDefaults] integerForKey:@"MASTERTEAMID"];
        
        Global.attendenceDateArr = [[[NSUserDefaults standardUserDefaults] objectForKey:@"ATTENDENCEDATEARR"] mutableCopy];
        
        NSLog(@"Type OF Sport Details : %@",Global.teamName);
        NSLog(@"globalSync count : %d",Global.syncCount);
        allChallanges.soportsID = teamSportID;
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        NSLog(@"User_Mode, %d", Global.mode);
        NSLog(@"User_arrTeamsid, %@", Global.arrTeamsId);
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ISLOGIN"];
        if(isRememberLogin)
        {
            [[NSUserDefaults standardUserDefaults] setObject:_emailTF.text forKey:@"SAVEDUSERID"];
            [[NSUserDefaults standardUserDefaults] setObject:_passwordTF.text forKey:@"SAVEDUSERPASS"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"CHECKBOXSTAT"];
            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"CHECKBOXSTATSTR"];
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            //save user id And Password
        }
        
        if (Global.mode  == USER_MODE_CLUB || Global.mode == USER_MODE_COACH || Global.mode == USER_MODE_DEMO) {
            CreateTeamViewController *createTeamViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateTeamViewController"];
            createTeamViewController.navigationCreateControllerStatus = CreateControllerState_Logedin;
            
            UINavigationController *viewController = [[UINavigationController alloc] initWithRootViewController:createTeamViewController];
            ApplicationDelegate.window.rootViewController = viewController;
        } else if (Global.mode == USER_MODE_INDIVIDUAL || Global.mode == USER_MODE_PLAYER) {
            MainController *mainController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainController"];
            
            UINavigationController *viewController = [[UINavigationController alloc] initWithRootViewController:mainController];
            ApplicationDelegate.window.rootViewController = viewController;
        }
        
    } else {
        if (![_emailTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] && ![_passwordTF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]]) {
            [ProgressHudHelper hideLoadingHud];
            [Alert showAlert:@"Internal Error" message:@"Invalid Username or Password" viewController:self];
            
            _emailTF.text = @"";
            _passwordTF.text = @"";
        } 
    }
}

- (void) checkAuthenticationOnlineWithUserID:(NSString*)userID andPassword:(NSString*)UserPass {
    
    BOOL checkConn = [RKCommon checkInternetConnection];
    
    if (!checkConn) {
        [ProgressHudHelper hideLoadingHud];
        [Alert showAlert:@"Connection Error" message:@"No Active Connection Found" viewController:self];
        return;
    }
    
    [ProgressHudHelper showLoadingHudWithText:@"Authenticating..."];
    [self performSelector:@selector(dismissGlobalHUDByDelay) withObject:nil afterDelay:30];
    
    NSDictionary *dictionary = [JSONHelper loadJSONDataFromURL:[NSString stringWithFormat:loginServiceURL, userID.stringByReplacingWhiteSpace, UserPass.stringByReplacingWhiteSpace]];
    NSLog(@"Authentication Detail : %@",[NSString stringWithFormat:loginServiceURL,userID,UserPass]);
    LoginUser *aUser = [DataFetcherHelper getloginDataFromDict:dictionary];
    
    NSLog(@"login dictionary---%@", dictionary);
    NSLog(@"login aUser---%@", aUser.userState);
    
    if (aUser.userState == nil) {
        [ProgressHudHelper hideLoadingHud];
        [Alert showAlert:@"Something wrong!" message:nil viewController:self];
        return;
    }
    
    if ([aUser.userState isEqualToString:@"Invalid"]) {
        
        [ProgressHudHelper hideLoadingHud];
        [Alert showAlert:@"Invalid Username or Password." message:@"" viewController:self];
        _emailTF.text = @"";
        _passwordTF.text = @"";
        
        return;
    } else if ([aUser.userState isEqualToString:@"UnVerify"]) {
        
        [ProgressHudHelper hideLoadingHud];
        [Alert showAlert:@"Not Verified Username. Please check your email!" message:@"" viewController:self];
        _emailTF.text = @"";
        _passwordTF.text = @"";
        
        return;
    } else if ([aUser.userState isEqualToString:@"NoTeam"]) {
        
        NSLog(@"login dictionary---%@", dictionary);
        
        Global.playerIDFinal = String(aUser.PlayerID);
        Global.currntTeam.Sport = aUser.Sport;
        
        
        [ProgressHudHelper hideLoadingHud];
        [Alert showOKCancelAlert:@"Please create team!" message:@"Have no team" viewController:self complete:^{
            _emailTF.text = @"";
            _passwordTF.text = @"";

            TeamProfileTableViewController *teamProfileController = [self.storyboard instantiateViewControllerWithIdentifier:@"TeamProfileTableViewController"];
            
            teamProfileController.navigationTeamStatus = TeamState_Create;
            [self.navigationController pushViewController:teamProfileController animated:YES];

        } canceled:^{
            _emailTF.text = @"";
            _passwordTF.text = @"";

        }];
        
        return;
    } else if ([aUser.userState isEqualToString:@"Success"]) {
        
        Global.playerIDFinal=[NSString stringWithFormat:@"%d",aUser.PlayerID];
        [[NSUserDefaults standardUserDefaults] setInteger:aUser.PlayerID forKey:@"playerIDFinal"];
        [[NSUserDefaults standardUserDefaults] setInteger:aUser.UserLevel forKey:@"USERLEVEL"];
        [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%@",aUser.teams] forKey:@"teams"];
        NSString *teams = [[NSUserDefaults standardUserDefaults] stringForKey:@"teams"];
        NSLog(@"user lvl %@",teams);
        NSLog(@"user lvl %d",aUser.UserLevel);
        
        if ([teams isEqualToString:@""]) {
            [Alert showAlert:@"You have no team" message:@"Please ask your coach" viewController:self];
        }

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
        
        NSLog(@"User_Mode, %d", Global.mode);
        
        int cnt = (int)aUser.arrTeams.count;
        for (int i = 0; i < cnt; i++) {
            NSInteger teamId = [[aUser.arrTeams objectAtIndex:i] integerValue];
            [syncData startSyncFromServerWithDataDict:nil serviceType:@"startSync" WithTeamID:(int)teamId syncCount:cnt playerID:aUser.PlayerID mode:Global.mode];
        }
        
        return;
    }
    
}

-(void) createCheckBox
{
    BOOL savedCheckedStat = [[NSUserDefaults standardUserDefaults] boolForKey:@"CHECKBOXSTAT"];
    NSString *value = [[NSUserDefaults standardUserDefaults] objectForKey:@"CHECKBOXSTATSTR"];
    
    NSLog(@"Starting State = %d",(int)savedCheckedStat);
    
    CGRect checkBoxFrame;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        checkBoxFrame = CGRectMake(73, 750 , 340, 50);
        
    }
    else
    {
        checkBoxFrame = CGRectMake(32, 500, 240, 30);
    }
    
    SSCheckBoxView *cbv;
    cbv = [[SSCheckBoxView alloc] initWithFrame:checkBoxFrame style:kSSCheckBoxViewStyleGreen checked:savedCheckedStat];
    if([value isEqualToString:@"1"])
    {
        cbv = [[SSCheckBoxView alloc] initWithFrame:checkBoxFrame style:kSSCheckBoxViewStyleGreen checked:TRUE];
        
        NSLog(@"loginUserId, %@", [[NSUserDefaults standardUserDefaults] stringForKey:@"finalID"]);
        
        _emailTF.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"finalID"];
        _passwordTF.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"finalPass"];
        
    }
    else
    {
        cbv = [[SSCheckBoxView alloc] initWithFrame:checkBoxFrame style:kSSCheckBoxViewStyleGreen checked:FALSE];
        _emailTF.text = @"";
        _passwordTF.text = @"";
        
    }
    
    [cbv setText:@"Remember Me"];
    
    [cbv setStateChangedTarget:self selector:@selector(checkBoxViewChangedState:)];
    [self.view addSubview:cbv];
}

- (void)checkBoxViewChangedState:(SSCheckBoxView *)cbv
{
    
    if(cbv.checked)
    {
        isRememberLogin = YES;
        
        [[NSUserDefaults standardUserDefaults] setObject:_emailTF.text forKey:@"SAVEDUSERID"];
        [[NSUserDefaults standardUserDefaults] setObject:_passwordTF.text forKey:@"SAVEDUSERPASS"];
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"CHECKBOXSTAT"];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"CHECKBOXSTATSTR"];
        [[NSUserDefaults standardUserDefaults] setObject:_emailTF.text forKey:@"finalID"];
        [[NSUserDefaults standardUserDefaults] setObject:_passwordTF.text forKey:@"finalPass"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }
    else
    {
        //remove user id and password
        isRememberLogin = NO;
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SAVEDUSERID"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SAVEDUSERPASS"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CHECKBOXSTAT"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"finalID"];
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"finalPass"];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"CHECKBOXSTATSTR"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
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

@end
