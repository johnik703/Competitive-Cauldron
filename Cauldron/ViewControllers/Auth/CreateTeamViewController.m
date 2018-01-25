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
    
    [self fectchUsersTeams];
    [self.tableView reloadData];
    
    if (Global.mode == USER_MODE_CLUB) {
        [self fetchCoachesListFromServer];
    }
    
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
        [ProgressHudHelper hideLoadingHud];
        [self parseResponse:responseDict params:params ];
    } ErrorHandler:^(NSString *errorStr) {
        
        NSLog(@"errorStr ---%@", errorStr);
        [ProgressHudHelper hideLoadingHud];
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
    
        
    NSString *query = [NSString stringWithFormat:@"SELECT Sports,Team_Name,Team_Picture,TeamID FROM TeamInfo WHERE TeamID %@ order by Team_Name asc", strWhere];
    NSArray *records = [SCSQLite selectRowSQL:query];
    
    cnt = (int)records.count;
    for (int i = 0; i < cnt; i++) {
        Team* tempTeam = [[Team alloc] init];
        tempTeam.Team_Name = [[records objectAtIndex:i] valueForKey:@"Team_Name"];
        tempTeam.Sport = [[records objectAtIndex:i] valueForKey:@"Sports"];
        tempTeam.Team_Picture = [[records objectAtIndex:i] valueForKey:@"Team_Picture"];
        tempTeam.TeamID = (int)[[[records objectAtIndex:i] valueForKey:@"TeamID"] intValue];
        [arrTeamsDetail addObject:tempTeam];
        
        NSLog(@"test picture---%d, %@, %@", i,tempTeam.Team_Name, tempTeam.Team_Picture);
        
    }
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self fectchUsersTeams];
    [self.tableView reloadData];
}

- (void)didDisappear {
    [self fectchUsersTeams];
    [self.tableView reloadData];
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
    cell.lblTeamName.text=  tempTeam.Team_Name;
    
    cell.lblTeamName.font = [UIFont boldSystemFontOfSize:fontSize];
    
    NSData *decodedData = [tempTeam.Team_Picture base64Data];
    if (decodedData) {
        UIImage* image = [UIImage imageWithData:decodedData];
        cell.imgTeam.image = image;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Team *tempTeam = [[Team alloc] init];
    tempTeam = [arrTeamsDetail objectAtIndex:indexPath.row];
    Global.currentTeamId =  tempTeam.TeamID;    NSLog(@"changed team id----%d", Global.currentTeamId);
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM TeamInfo WHERE TeamID = %d", Global.currentTeamId];
    NSArray *records = [SCSQLite selectRowSQL:query];
    
    NSLog(@"teamrecords, %@", records);
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
    
    [API executeHTTPRequest:Post url:syncToServerServiceURLManageTeam parameters:params CompletionHandler:^(NSDictionary *responseDict) {
        [ProgressHudHelper hideLoadingHud];
        [self parseResponse:responseDict params:params teamId:teamId];
    } ErrorHandler:^(NSString *errorStr) {
        
        NSLog(@"errorStr ---%@", errorStr);
        [ProgressHudHelper hideLoadingHud];
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

- (void)logout {
    [Alert showOKCancelAlert:@"Are you sure you want to logoff?" message:@"" viewController:self complete:^{
        UINavigationController *nav = [self.storyboard instantiateInitialViewController];
        [UserDefaults removeObjectForKey:@"ISLOGIN"];
        
        [[NSUserDefaults standardUserDefaults] setObject:[[NSUserDefaults standardUserDefaults] stringForKey:@"SAVEDUSERID"] forKey:@"ONLINE_PREVIOUS_LOG_USERNAME"];
        [[NSUserDefaults standardUserDefaults] setObject:[[NSUserDefaults standardUserDefaults] stringForKey:@"SAVEDUSERPASS"] forKey:@"ONLINE_PREVIOUS_LOG_PASSWORD"];
        
        [[NSUserDefaults standardUserDefaults] setObject:[[NSUserDefaults standardUserDefaults] stringForKey:@"SAVEDUSERID"] forKey:@"finalID"];
        [[NSUserDefaults standardUserDefaults] setObject:[[NSUserDefaults standardUserDefaults] stringForKey:@"SAVEDUSERPASS"] forKey:@"finalPass"];
        
        
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SAVEDUSERID"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SAVEDUSERPASS"];
        //    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"CHECKBOXSTAT"];
        //    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"finalID"];
        //    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"finalPass"];
        
        //    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"CHECKBOXSTATSTR"];
        Global.syncCount = 0;
        [[NSUserDefaults standardUserDefaults] setInteger:Global.syncCount forKey:@"SYNCCOUNT"];
        
        [Global.attendenceDateArr removeAllObjects];
        [[NSUserDefaults standardUserDefaults] setObject:Global.attendenceDateArr forKey:@"ATTENDENCEDATEARR"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        ApplicationDelegate.window.rootViewController = nav;
    } canceled:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
