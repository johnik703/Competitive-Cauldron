//
//  CreateTeamViewController.m
//  Cauldron
//
//  Created by John Nik on 4/10/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "CreateTeamViewController.h"
#import "SWRevealViewController.h"
#import "TeamProfileTableViewController.h"
#import "Enums.h"
#import "LoginViewController.h"
#import "MainController.h"
#import "AppDelegate.h"
@import SVProgressHUD;
@import Toast;

@interface CreateTeamViewController () <TeamProfileDelegate>{
    
    float cellHeight;
    float fontSize;
    
    
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@end

static NSString *simpleTableIdentifier = @"AddTeams";

@implementation CreateTeamViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    arrTeamsDetail = [[NSMutableArray alloc] init];
    
    if (Global.mode == USER_MODE_CLUB || Global.mode == USER_MODE_COACH || Global.mode == USER_MODE_DEMO) {
        [self addMenuLeftBarButtomItem];
    }
    
    
    
    [self setupUIWithMode];
    
    [self setupiPhoneAndiPadUI];
    
    
    if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        [self.tableView registerNib:[UINib nibWithNibName:@"AddTeamCell" bundle:nil] forCellReuseIdentifier:simpleTableIdentifier];
    } else {
        [self.tableView registerNib:[UINib nibWithNibName:@"AddTeamCell_iPad" bundle:nil] forCellReuseIdentifier:simpleTableIdentifier];
    }
    
    if (Global.mode == USER_MODE_CLUB) {
        [self fetchCoachesListFromServer];
    }
}

- (void) showToastForNotice {
    
    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
    style.titleAlignment = NSTextAlignmentCenter;
    style.messageAlignment = NSTextAlignmentCenter;
    [self.view makeToast:@"* is Primary Team."
                duration:10.0
                position:CSToastPositionBottom
                   style:style];
    [CSToastManager setSharedStyle:style];
    [CSToastManager setTapToDismissEnabled:YES];
    
    // toggle queueing behavior
    [CSToastManager setQueueEnabled:YES];
}

- (NSString *)whereCaluseString:(NSDictionary *)dic {
    NSMutableArray *whereArr = [[NSMutableArray alloc] init];
    
    for (NSString * key in dic.allKeys) {
        [whereArr addObject:[NSString stringWithFormat:@"%@ = '%@'", key, dic[key]]];
    }
    NSString *whereStr = [whereArr componentsJoinedByString:@" AND "];
    
    return whereStr;
}

- (void)fetchCoachesListFromServer {
    
    [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
    
    NSDictionary *whereDic = @{@"PlayerID": Global.playerIDFinal};
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM %@ WHERE %@", @"CoachesInfo", [self whereCaluseString:whereDic]];
    BOOL result = [SCSQLite executeSQL: sql];
    
    if(result)
    {
        NSLog( @"Succsefully Deleted selected Table : %@",@"CoachesInfo");
    }

    
    NSString *action = @"COACH_LIST";
    
    NSDictionary* params = @{@"action": action,
                             @"PlayerID": Global.playerIDFinal
                             };
    
    [API executeHTTPRequest:Post url:syncToServerServiceURLManageCoach parameters:params CompletionHandler:^(NSDictionary *responseDict) {
       
        [self parseResponse:responseDict params:params ];
    } ErrorHandler:^(NSString *errorStr) {
        
        NSLog(@"errorStr ---%@", errorStr);
    }];
    
}

- (void) parseResponse: (NSDictionary *)dic params:(NSDictionary *)paramsDic {
    
    NSLog(@"coachesList, %@", dic);
    
    NSDictionary *coachesDictionary = [dic valueForKey:@"coach_list"];
    
    [DataFetcherHelper getAllCoachesDataFromDict:coachesDictionary];
    
}


- (void)fectchUsersTeams {
    
    [arrTeamsDetail removeAllObjects];
    
    [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
    //???
    
    int cnt = (int)Global.arrTeamsId.count;
    
    NSLog(@"teamscount------%d", (int)Global.arrTeamsId.count);
    NSString* strWhere = @" in (";
    if (cnt == 0){
        strWhere = [NSString stringWithFormat:@"%@ )", strWhere];
    }
    else{
        for (int i = 0; i < cnt; i++) {
            if (i != cnt - 1)
                strWhere = [NSString stringWithFormat:@"%@ %d,", strWhere,  (int)[[Global.arrTeamsId objectAtIndex:i] integerValue]];
            else
                strWhere = [NSString stringWithFormat:@"%@ %d)", strWhere,  (int)[[Global.arrTeamsId objectAtIndex:i] integerValue]];
        }
    }
    
    Global.teamIdsForWhere = strWhere;
        
    NSString *query = [NSString stringWithFormat:@"SELECT Sports,Team_Name,Team_Picture,TeamID, Display_Picture FROM TeamInfo WHERE TeamID %@ order by Team_Name asc", strWhere];
    NSArray *records = [SCSQLite selectRowSQL:query];
    
    cnt = (int)records.count;
    for (int i = 0; i < cnt; i++) {
        Team* tempTeam = [[Team alloc] init];
        tempTeam.Team_Name = [[records objectAtIndex:i] valueForKey:@"Team_Name"];
        tempTeam.Sport = [[records objectAtIndex:i] valueForKey:@"Sports"];
        tempTeam.Team_Picture = [[records objectAtIndex:i] valueForKey:@"Team_Picture"];
        tempTeam.TeamID = (int)[[[records objectAtIndex:i] valueForKey:@"TeamID"] intValue];
        tempTeam.Display_Picture = (int)[[[records objectAtIndex:i] valueForKey:@"Display_Picture"] intValue];
        [arrTeamsDetail addObject:tempTeam];
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self fectchUsersTeams];
    [self.tableView reloadData];
    if (Global.mode == USER_MODE_CLUB || Global.mode == USER_MODE_COACH || Global.mode == USER_MODE_DEMO) {
        [self showToastForNotice];
    }
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.view hideToast];
}

- (void)setupUIWithMode {
    
    if (_navigationCreateControllerStatus == CreateControllerState_Signup) {
        
        self.navigationItem.title = @"Create Team";
        
    } else {
        self.navigationItem.title = @"My Teams";
        
        if (Global.mode == USER_MODE_COACH) {
            self.navigationItem.rightBarButtonItem = nil;
        }
    }

    
}

- (void)setupiPhoneAndiPadUI {
    
    if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        
        cellHeight = 50;
        fontSize = 15;
        
    } else {
        
        cellHeight = 100;
        fontSize = 40;
        
    }
    
}

- (IBAction)didTapAdd:(id)sender {
    
    TeamProfileTableViewController *teamProfileTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TeamProfileTableViewController"];;
    teamProfileTableViewController.navigationTeamStatus = TeamState_Add;
    teamProfileTableViewController->createTeamViewController = self;
    
    [self.navigationController pushViewController:teamProfileTableViewController animated:true];
    
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrTeamsDetail count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    AddTeamCell *cell = (AddTeamCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    Team *tempTeam = [[Team alloc] init];
    tempTeam = [arrTeamsDetail objectAtIndex:indexPath.row];
    
    NSString *teamName = tempTeam.Team_Name;
    
    if (tempTeam.TeamID == Global.masterTeamId) {
        teamName = [NSString stringWithFormat:@"%@*", teamName];
    }
    cell.lblTeamName.text= teamName;
    
    cell.lblTeamName.font = [UIFont boldSystemFontOfSize:fontSize];
    
    if (tempTeam.Display_Picture == 1) {
        
        [cell.imgTeam setHidden:false];
        
        NSData *decodedData = [tempTeam.Team_Picture base64Data];
        if (decodedData) {
            UIImage* image = [UIImage imageWithData:decodedData];
            cell.imgTeam.image = image;
        }
    } else {
        [cell.imgTeam setHidden:true];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Team *tempTeam = [[Team alloc] init];
    tempTeam = [arrTeamsDetail objectAtIndex:indexPath.row];
    Global.currentTeamId =  tempTeam.TeamID;
    NSLog(@"changed team id----%d", Global.currentTeamId);
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM TeamInfo WHERE TeamID = %d", Global.currentTeamId];
    NSArray *records = [SCSQLite selectRowSQL:query];
    
//    NSLog(@"teamrecords, %@", records);
    if ([records count] != 0)
        Global.currntTeam = [DataFetcherHelper getCurrentTeamDataFromDict: [records objectAtIndex:0]];
    
    NSLog(@"currentTeamSubscribe, %d", Global.currntTeam.isSubscribe);
    
    if (Global.currntTeam.isSubscribe == 1) {
        MainController *mainController = [self.storyboard instantiateViewControllerWithIdentifier:@"MainController"];
        [self.navigationController pushViewController:mainController animated:YES];
    } else {
        [self showAlertSubsciptionEnd];
    }
}

- (void)showAlertSubsciptionEnd {
    [Alert showOKCancelAlert:@"Subscription Expired" message:@"Do you want to renew subscription?" viewController:self complete:^{
        
        NSLog(@"Navigating to website--http://competitive-cauldron.com/stats");
        
        NSString *urlStr = @"http://competitive-cauldron.com/stats";
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: urlStr]];

        
        
    } canceled:^{
        NSLog(@"Canceled Subsciption end");
    }];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self deleteTeam:indexPath.row];
    }
}

- (void) deleteTeam:(NSInteger)teamIndex {
    
    Team *tempTeam = [[Team alloc] init];
    tempTeam = [arrTeamsDetail objectAtIndex:teamIndex];
    
    NSString *action = @"DELETE_TEAM";
    NSString *teamName = tempTeam.Team_Name;
    int teamId = tempTeam.TeamID;

    
    NSLog(@"delete challenge Name, %@, %d", teamName, teamId);
    
    NSDictionary* params = @{@"action": action,
                             @"PlayerID": Global.playerIDFinal,
                             @"Team_Name": teamName,
                             @"TeamID": String(teamId)
                             };
    
    [SVProgressHUD show];
    [API executeHTTPRequest:Post url:syncToServerServiceURLManageTeam parameters:params CompletionHandler:^(NSDictionary *responseDict) {
        [SVProgressHUD dismiss];
        [self parseResponse:responseDict params:params teamId:teamId];
    } ErrorHandler:^(NSString *errorStr) {
        
        NSLog(@"errorStr ---%@", errorStr);
        [SVProgressHUD dismiss];
        [Alert showAlert:@"Something went wrong" message:nil viewController:self];
    }];
    
}

- (void) parseResponse: (NSDictionary *)dic params:(NSDictionary *)paramsDic teamId:(int)teamId {
    
    NSString *successResult = [dic valueForKey:@"status"];
    int masterTeamId = (int)[[dic valueForKey:@"master_team"] intValue];
    
    NSLog(@"success or fail if recieve data from server-----%@, %d", successResult, masterTeamId);
    
    if ([successResult isEqualToString:@"Success"]) {
        
        NSDictionary *whereDic = @{@"TeamID": String(teamId)};
        
        BOOL success = [SQLiteHelper deleteInTable:@"TeamInfo" where:whereDic];
        
        if (success) {
            
            [Alert showAlert:@"Team successfully deleted" message:nil viewController:self complete:^{
                
                if (masterTeamId) {
                    Global.masterTeamId = masterTeamId;
                }
                
                [self fectchUsersTeams];
                [self.tableView reloadData];
                
            }];
        } else {
            [Alert showAlert:@"Error" message:@"Failed to delete Team in local" viewController:self];
        }
    } else {
        
        [Alert showAlert:@"Failed to Delete Team" message:nil viewController:self];
        return;
    }
}



- (void)addMenuLeftBarButtomItem {
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Logoff" style:UIBarButtonItemStylePlain target:self action:@selector(logout)];
    self.navigationItem.leftBarButtonItem = leftButton;
}

- (BOOL)checkIfExistDataToSync {
    // Check more data available for sync
    [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM ChallangeStat WHERE Sync=%d",1];
    NSArray *teamPlayersStats = [SCSQLite selectRowSQL:query];
    
    
    NSString *queryAttandance = [NSString stringWithFormat:@"SELECT * FROM playerattendance WHERE sync=%d",1];
    NSArray *playersAttandace = [SCSQLite selectRowSQL:queryAttandance];
    
    NSString *queryJournal = [NSString stringWithFormat:@"SELECT * FROM JournalData WHERE sync=%d",1];
    NSArray *playersJournal = [SCSQLite selectRowSQL:queryJournal];
    
    NSString *queryPlayer = [NSString stringWithFormat:@"SELECT * FROM PlayersInfo WHERE Sync=%d",1];
    NSArray *playersData = [SCSQLite selectRowSQL:queryPlayer];
    
    if (teamPlayersStats.count > 0 || playersAttandace.count > 0 || playersJournal.count > 0 || playersData.count> 0) {
        return YES;
    } else {
        return NO;
    }
}

- (void)logout {
    
    [Alert showOKCancelAlert:@"Are you sure you want to logoff?" message:@"" viewController:self complete:^{
        // Check more data available for sync
        
        if ([self checkIfExistDataToSync]) {
            NSString *message = @"You have some data to sync.\nDo you want to sync before logging off?" ;
            [Alert showYesNoAlert:@"Warning!" message:message viewController:self complete:^{
                [self syncData];
            } canceled:^{
                [self handleLogout];
            }];
        } else {
            [self handleLogout];
        }
    } canceled:nil];
}

- (void)handleLogout {
    UINavigationController *nav = [self.storyboard instantiateInitialViewController];
    [UserDefaults removeObjectForKey:@"ISLOGIN"];
    
    [[NSUserDefaults standardUserDefaults] setObject:[[NSUserDefaults standardUserDefaults] stringForKey:@"SAVEDUSERID"] forKey:@"ONLINE_PREVIOUS_LOG_USERNAME"];
    [[NSUserDefaults standardUserDefaults] setObject:[[NSUserDefaults standardUserDefaults] stringForKey:@"SAVEDUSERPASS"] forKey:@"ONLINE_PREVIOUS_LOG_PASSWORD"];
    
    [[NSUserDefaults standardUserDefaults] setObject:[[NSUserDefaults standardUserDefaults] stringForKey:@"SAVEDUSERID"] forKey:@"finalID"];
    [[NSUserDefaults standardUserDefaults] setObject:[[NSUserDefaults standardUserDefaults] stringForKey:@"SAVEDUSERPASS"] forKey:@"finalPass"];
    
    
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SAVEDUSERID"];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SAVEDUSERPASS"];
    Global.syncCount = 0;
    [[NSUserDefaults standardUserDefaults] setInteger:Global.syncCount forKey:@"SYNCCOUNT"];
    
    [Global.attendenceDateArr removeAllObjects];
    [[NSUserDefaults standardUserDefaults] setObject:Global.attendenceDateArr forKey:@"ATTENDENCEDATEARR"];
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    ApplicationDelegate.window.rootViewController = nav;
}

#pragma Sync To Server

- (void) syncData {
    
    // check internet connection
    BOOL checkConnection = [RKCommon checkInternetConnection];
    if (!checkConnection) {
        [Alert showAlert:@"Internet Connection Error" message:@"" viewController:self];
        return;
    }
    
    [SVProgressHUD showWithStatus:@"Uploading Data..."];
    
    SyncToServer  *syncToServer = [[SyncToServer alloc]init];
    syncToServer.delegate = self;
    [syncToServer startSyncDataToServer];
}

#pragma Delegate Sync To Server

- (void) SyncToServerProcessCompleted {
    
    Global.syncCount = 0;
    [UserDefaults setInteger:Global.syncCount forKey:@"SYNCCOUNT"];
    [self.tableView reloadData];
    
    [Global.attendenceDateArr removeAllObjects];
    [UserDefaults setObject:Global.attendenceDateArr forKey:@"ATTENDENCEDATEARR"];
    [UserDefaults synchronize];
    
    [SVProgressHUD dismiss];
    
    [Alert showAlert:@"Sync Completed!" message:@"" viewController:self complete:^{
        [self handleLogout];
    }];
}

@end
