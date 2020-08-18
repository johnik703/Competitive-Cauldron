//
//  MainViewController.m
//  Cauldron
//
//  Created by John Nik on 5/18/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "MainViewController.h"
#import "TeamProfileTableViewController.h"
#import "ChallengeListViewController.h"
#import "CategoryViewController.h"

@interface MainViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *listItem;

@end


@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//    [self hideNavigationBarShawdow];
    if (self.revealViewController) {
        self.listItem.target = self.revealViewController;
        self.listItem.action = @selector(revealToggle:);
    }

    NSString *query = [NSString stringWithFormat:@"SELECT * FROM TeamInfo WHERE TeamID = %d", Global.currentTeamId];
    NSArray *records = [SCSQLite selectRowSQL:query];
    if ([records count] != 0)
        Global.currntTeam = [DataFetcherHelper getCurrentTeamDataFromDict: [records objectAtIndex:0]];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationItem.title = Global.currntTeam.Team_Name;
    if ([self.selectedLeftMenuItem isEqualToString:@"update"]) {
        [self update];
    } else if ([self.selectedLeftMenuItem isEqualToString:@"sync"]) {
        [self sync];
    }
    
    self.selectedLeftMenuItem = @"";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}

#pragma mark - IBActions

- (IBAction)didTapEdit:(id)sender {
    
//    UINavigationController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"showCreateAndEditTeam"];
    
    TeamProfileTableViewController *teamProfileTableViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"TeamProfileTableViewController"];
    teamProfileTableViewController.navigationTeamStatus = TeamState_Update;
    UINavigationController *viewController = [[UINavigationController alloc] initWithRootViewController:teamProfileTableViewController];
    [self presentViewController:viewController animated:true completion:nil];
}

- (IBAction)didTapAttendance:(id)sender {
    AttendanceVC *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"AttendanceVC"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)didTapJournal:(id)sender {
    JournalVC *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"JournalVC"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)didTapAddStatus:(id)sender {
    [self showChallangesOrRanking:NavigationStateChallenge];
}

- (IBAction)didTapReport:(id)sender {
    ReportVC *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ReportVC"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)didTapRoster:(id)sender {
    RosterVC *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"RosterVC"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)didTapRanking:(id)sender {
    [self showChallangesOrRanking:NavigationStateRanking];
}

#pragma mark - Private Methods


- (IBAction)didTapChanllenge:(id)sender {
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction *editChallengeAction = [UIAlertAction actionWithTitle:@"ChallengeList" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        ChallengeListViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EditChallengeViewController"];
        [self.navigationController pushViewController:viewController animated:YES];
        
    }];
    UIAlertAction *categoryAction = [UIAlertAction actionWithTitle:@"Category" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        CategoryViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CategoryVC"];
        [self.navigationController pushViewController:viewController animated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    [actionSheet addAction:editChallengeAction];
    [actionSheet addAction:categoryAction];
    [actionSheet addAction:cancelAction];
    
    [actionSheet setModalPresentationStyle:UIModalPresentationPopover];
    
    UIPopoverPresentationController *popPresenter = [actionSheet popoverPresentationController];
    popPresenter.sourceView = (UIButton *)sender;
    popPresenter.sourceRect = ((UIButton *)sender).bounds;
    
    [self presentViewController:actionSheet animated:true completion:nil];
    
    
    NSLog(@"======>>>>You selected the Chanllenge Button!");
}
- (IBAction)didTapOther:(id)sender {
    NSLog(@"======>>>>You selected the Other Button!");
}


- (void)showChallangesOrRanking:(NavigationStatus)status {
    
    [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
    //???
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM TeamInfo WHERE admin_name='%@' AND admin_pw='%@'",[[NSUserDefaults standardUserDefaults] stringForKey:@"SAVEDUSERID"],[[NSUserDefaults standardUserDefaults] stringForKey:@"SAVEDUSERPASS"]];
    NSArray *recordsFound = [SCSQLite selectRowSQL:query];
    NSLog(@"Found Record Details : %@",recordsFound);
    int userLevel;
    
    if (recordsFound.count > 0) {
        userLevel = (int)[[[recordsFound objectAtIndex:0]valueForKey:@"userLevel"]integerValue];
    }
    
    if (recordsFound.count > 0 && userLevel != 0 ) {
        ChallangesVC *viewController = (ChallangesVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"ChallangesVC"];
        viewController.status = status;
// mm        viewController.userTeamID = (int)[[[recordsFound objectAtIndex:0]valueForKey:@"TeamID"]integerValue];
        
        viewController.userTeamID = Global.currntTeam.TeamID;
        
// mm       NSString *sprtsTypeQuery = [NSString stringWithFormat:@"SELECT Sports,Team_Name FROM TeamInfo WHERE TeamID=%d", viewController.userTeamID];
// mm       NSArray *records = [SCSQLite selectRowSQL:sprtsTypeQuery];
        
// mm       int teamSportID = (int)[[[records objectAtIndex:0]valueForKey:@"Sports"]integerValue];
        
        int teamSportID = (int)[Global.currntTeam.Sport intValue];
        
// mm       Global.teamName = [[records objectAtIndex:0]objectForKey:@"Team_Name"];
        
        viewController.soportsID = teamSportID;
        
        [self.navigationController pushViewController:viewController animated:YES];
    } else {
        [Alert showAlert:@"No Data" message:@"You Don't have any data in Local Storage" viewController:self];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

static int syncMode = 0;

- (void) sync {
    syncMode = 0;
    
    // check internet connection
    BOOL checkConnection = [RKCommon checkInternetConnection];
    if (!checkConnection) {
        [Alert showAlert:@"Internet Connection Error" message:@"" viewController:self];
        return;
    }
    
    [ProgressHudHelper showLoadingHudWithText:@"Synchronizing..."];
    SyncToServer  *syncToServer = [[SyncToServer alloc]init];
    syncToServer.delegate = self;
    [syncToServer startSyncDataToServer];
}

- (void) update {
    syncMode = 1;
    
    // check internet connection
    BOOL checkConnection = [RKCommon checkInternetConnection];
    if (!checkConnection) {
        [Alert showAlert:@"Internet Connection Error" message:@"" viewController:self];
        return;
    }
    
    // check more data available for sync
    [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM ChallangeStat WHERE Sync=%d",1];
    NSArray *teamPlayersStats = [SCSQLite selectRowSQL:query];
    
    [ProgressHudHelper showLoadingHudWithText:@"Updating...."];
    
    if (teamPlayersStats.count > 0) {
        SyncToServer  *syncToServer = [[SyncToServer alloc] init];
        [syncToServer startSyncDataToServer];
        syncToServer.delegate = self;
    } else {
        SyncFromServer *syncFromServer = [[SyncFromServer alloc] init];
//        [syncFromServer startSyncFromServerWithDataDict:nil serviceType:@"startSync" WithTeamID: [self getTeamId]];
        syncFromServer.delegate = self;
    }
}

#pragma Delegate Sync To Server

- (void) SyncToServerProcessCompleted {
    if (syncMode == 0) {
        NSLog(@"Now Start Sync From Server For Update Data");
        SyncFromServer *syncFromServer = [[SyncFromServer alloc] init];
//        [syncFromServer startSyncFromServerWithDataDict:nil serviceType:@"startSync" WithTeamID:[self getTeamId]];
        syncFromServer.delegate = self;
    } else {
        [ProgressHudHelper hideLoadingHud];
        [Alert showAlert:@"Sync Completed!" message:@"All Data Sync Successfully" viewController:self];
    }
}


#pragma Selegate Sync From Server

- (void) syncFromServerProcessCompleted {
    [ProgressHudHelper hideLoadingHud];
    
    if (syncMode == 0) {
        NSLog(@"All Sync Process Complete From SERVER For UPDATE");
        // Save updated date to UserDefault
        NSString *lastSyncDate = [NSString stringWithFormat:@"Last Updated:%@",[RKCommon getSyncDateInString]];
        [UserDefaults setObject:lastSyncDate forKey:@"LASTSYNCDATE"];
        [UserDefaults synchronize];
    } else {
        NSLog(@"All Sync Process Complete From SERVER");
    }
    
    [Alert showAlert:@"Sync Completed!" message:@"All Data Sync Successfully" viewController:self];
}

- (int) getTeamId {
    
    [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
    //???
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM TeamInfo WHERE admin_name ='%@' AND admin_pw ='%@'",[[NSUserDefaults standardUserDefaults] stringForKey:@"SAVEDUSERID"],[[NSUserDefaults standardUserDefaults] stringForKey:@"SAVEDUSERPASS"]];
    NSArray *recordsFound = [SCSQLite selectRowSQL:query];
    
    if (recordsFound.count > 0) {
        NSLog(@"Found Record Details : %@",recordsFound);
        
        if ([[recordsFound objectAtIndex:0]valueForKey:@"Teams"]) {
            NSString *totalTeam=[[recordsFound objectAtIndex:0]valueForKey:@"Teams"];
            if (![totalTeam isEqualToString:@""]) {
                NSError *error = nil;
                NSDictionary *dict = [XMLReader dictionaryForXMLString:totalTeam options:XMLReaderOptionsProcessNamespaces error:&error];
                
//                if ([[[dict objectForKey:@"data"] objectForKey:@"team"] isKindOfClass:[NSArray class]]) {
//                    arrDictOfTeam=[[dict valueForKey:@"data"] valueForKey:@"team"];
//                } else {
//                    arrDictOfTeam=[[NSMutableArray alloc]init];
//                    [arrDictOfTeam addObject:[[dict valueForKey:@"data"] valueForKey:@"team"]];
//                }
            }
        }
        
        return [recordsFound[0][@"TeamID"] intValue];
    }
    
    return 0;
}

@end
