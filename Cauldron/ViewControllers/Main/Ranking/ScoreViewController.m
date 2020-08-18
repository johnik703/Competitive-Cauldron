//
//  ScoreViewController.m
//  Cauldron
//
//  Created by John Nik on 5/15/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "ScoreViewController.h"
@import SVProgressHUD;
@import Toast;


@interface ScoreViewController () <UITableViewDelegate, UITableViewDataSource, IQDropDownTextFieldDelegate, ScoreTextFieldDelegate, BEMCheckBoxDelegate, ScoreTableViewCellDelegate>
{
    NSString *stringForDate;
    NSString *stringDateForServer;
    BOOL isWinLossChanllenge;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
static NSString *simpleTableIdentifier = @"ScoreTableViewCell";
@implementation ScoreViewController
@synthesize deleteButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate setShouldRotate:YES];
    
    [self setupNavBar];
    [self setupTableView];
    [self setupDateTextField];
    [self setupDeleteButton];
    [self loadColumns];
    [self setupContainerView];
//    [self setupLongPressGestureRecognizer];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchTeamDataFromLocalDB];
    [self fetchChanllangeStatDataFromLocalDB];
    [self fetchScoreData];
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate setShouldRotate:NO];
}

- (void)setupContainerView {
    
    nameContainerView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 50)];
    [nameContainerView setTextAlignment: NSTextAlignmentCenter];
    [nameContainerView setBackgroundColor:[UIColor darkGrayColor]];
    [nameContainerView setTextColor:[UIColor whiteColor]];
    [nameContainerView setFont:[UIFont systemFontOfSize:20 weight:UIFontWeightBold]];
    [nameContainerView.layer setCornerRadius:10];
    [nameContainerView.layer setMasksToBounds:YES];
}

- (void)setupLongPressGestureRecognizer {
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGesture:)];
    
    [self.view addGestureRecognizer:longPressGestureRecognizer];
}

- (void)handleLongPressGesture:(UILongPressGestureRecognizer *)gesture atCell:(id)cell {
    
    ScoreTableViewCell *scoreTableViewCell = (ScoreTableViewCell *)cell;
    NSString *fullname = scoreTableViewCell.titleLbl.text;
    [nameContainerView setText:fullname];
    
    [self handleLongPressGesture:gesture];
}

- (void)handleLongPressGesture: (UILongPressGestureRecognizer*) gesture {
    
    CGPoint pressedLocation = [gesture locationInView:self.view];
    CGFloat centeredX = (self.view.frame.size.width - nameContainerView.frame.size.width) / 2;
    
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
        [self handleLongPressGestureBegan:gesture];
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        
        [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
            nameContainerView.transform = CGAffineTransformMakeTranslation(centeredX, pressedLocation.y);
            [nameContainerView setAlpha:0];
        } completion:^(BOOL finished) {
            [nameContainerView removeFromSuperview];
        }];
    }
}

- (void)handleLongPressGestureBegan: (UILongPressGestureRecognizer *) gesture {
    [self.view addSubview:nameContainerView];
    
    CGPoint pressedLocation = [gesture locationInView:self.view];
    CGFloat centeredX = (self.view.frame.size.width - nameContainerView.frame.size.width) / 2;
    
    
    [nameContainerView setAlpha:0];
    nameContainerView.transform = CGAffineTransformMakeTranslation(centeredX, pressedLocation.y);
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [nameContainerView setAlpha:1];
        nameContainerView.transform = CGAffineTransformMakeTranslation(centeredX, pressedLocation.y - nameContainerView.size.height - 40);
    } completion:nil];
}

- (void)setupDateTextField {
    self.dateDDTF.delegate = self;
    self.dateDDTF.dropDownMode = IQDropDownModeDatePicker;
    self.dateDDTF.date = [NSDate new];
    self.dateDDTF.dateFormatter = [NSDateFormatter formatterFromFormatString:@"MM-dd-yyyy"];
    stringForDate = [self.dateDDTF.date stringWithFormat:@"yyyy-MM-dd"];
    stringDateForServer = [self.dateDDTF.date stringWithFormat:@"MM-dd-yyyy"];
}

- (void)setupTableView {
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ScoreTableViewCell" bundle:nil] forCellReuseIdentifier:simpleTableIdentifier];
}

- (void)setupDeleteButton {
    [deleteButton setHidden:YES];
    
    selectedRowsArray = [[NSMutableArray alloc] init];
}

- (void)setupNavBar {
    
    self.title = self.scChallengeName;
    
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    
}

#pragma mark - checkbox delegate
- (void)didTapCheckBox:(BEMCheckBox*)checkBox {
    if ([selectedRowsArray containsObject:PlayersInfoArray[checkBox.tag][@"PlayerID"]]) {
        [selectedRowsArray removeObject:PlayersInfoArray[checkBox.tag][@"PlayerID"]];
    } else {
        [selectedRowsArray addObject:PlayersInfoArray[checkBox.tag][@"PlayerID"]];
    }
    
    if ([selectedRowsArray count] == 0) {
        [deleteButton setHidden:YES];
    } else {
        [deleteButton setHidden:NO];
    }
}

#pragma mark - handle delete stats from local
- (void) handleDeleteStatsInLocal: (NSMutableArray *)playerIDs syncCount:(int)sycnCount {
    
    BOOL success = NO;
    
    for (int i = 0; i < playerIDs.count; i++) {
        NSDictionary *whereDic = @{@"PlayerID": playerIDs[i], @"Date": stringDateForServer};
        
        success = [SQLiteHelper deleteInTable:@"ChallangeStat" where:whereDic];
    }
    
    if (success) {
        
        Global.syncCount = Global.syncCount - sycnCount;
        [[NSUserDefaults standardUserDefaults] setInteger:Global.syncCount forKey:@"SYNCCOUNT"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [selectedRowsArray removeAllObjects];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self fetchTeamDataFromLocalDB];
            [self fetchChanllangeStatDataFromLocalDB];
            [self fetchScoreData];
            
            [deleteButton setHidden:YES];
            [self.tableView reloadData];
        });
        
        [self.view makeToast:@"Stats deleted successfully."];
        
    } else {
        [self.view makeToast:@"Failed to delete stats.Try again later."];
    }
}

#pragma mark - handle delete stats from server
- (void) handleDeleteStatsFromServer: (NSString *)playerIDs: (NSMutableArray *) statIDsArray {
    
    NSDictionary* params = @{@"ChallengeID": String(self.scChallengeID),
                             @"ChallengeType": challengeType,
                             @"playerIDs": playerIDs,
                             @"date": stringDateForServer
                             };
    
    NSLog(@"statsId: %@", playerIDs);
    
    [SVProgressHUD show];
    [API executeHTTPRequest:Post url:deleteStatsURL parameters:params CompletionHandler:^(NSDictionary *responseDict) {
        [SVProgressHUD dismiss];
        [self parseResponseCategory:responseDict params:params statIDs:statIDsArray];
    } ErrorHandler:^(NSString *errorStr) {
        [SVProgressHUD dismiss];
        [Alert showAlert:@"Fail!" message:@"Something went wrong.\nTry again later." viewController:self];
        NSLog(@"Category create error ---%@", errorStr);
        return;
    }];
    
    
}

- (void) parseResponseCategory: (NSDictionary *)dic params:(NSDictionary *)paramsDic statIDs:(NSMutableArray *)statIDs {
    
    NSString *successResult = [dic valueForKey:@"status"];
    
    if ([successResult isEqualToString:@"SUCCESS"]) {
        [self handleDeleteStatsInLocal:statIDs syncCount:0];
        
        NSLog(@"deleted successfully");
        return;
        
    } else {
        [self.view makeToast:@"Failed to delete stats.Try again later."];
        NSLog(@"Failed to delete");
        return;
    }
}

- (void) handleDeleteStats {
    BOOL checkConnection = [RKCommon checkInternetConnection];
    if (!checkConnection) {
        [Alert showAlert:@"Internet Connection Error" message:@"" viewController:self];
        return;
    }
    
    [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
    
    NSMutableArray *syncedPlayerIDArray = [[NSMutableArray alloc] init];
    NSMutableArray *unsyncedplayerIDArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < selectedRowsArray.count; i++) {
        
        int playerID = [[selectedRowsArray objectAtIndex:i] intValue];
        NSString *findQuery = [NSString stringWithFormat:@"SELECT Date, ChStatID, Sync FROM ChallangeStat WHERE TeamID=%d AND ChallangeID=%d AND PlayerID=%d AND column_name='%@' AND Date='%@'", self.scTeamID, self.scChallengeID, playerID, allColumnName, stringDateForServer];
        NSArray *record = [SCSQLite selectRowSQL:findQuery];
        
        if (record.count > 0) {
            int syncStatus = (int)[record.lastObject[@"Sync"] intValue];
            
            if (syncStatus == 0) {
                [syncedPlayerIDArray addObject:String(playerID)];
            } else {
                [unsyncedplayerIDArray addObject:String(playerID)];
            }
        }
        
        
        // delete with stat id
        /*
         NSString *findQuery = [NSString stringWithFormat:@"SELECT Date, ChStatID, Sync FROM ChallangeStat WHERE TeamID=%d AND ChallangeID=%d AND PlayerID=%d AND column_name='%@' AND Date='%@'", self.scTeamID, self.scChallengeID, playerID, allColumnName, stringDateForServer];
         NSArray *record = [SCSQLite selectRowSQL:findQuery];
         
         if (record.count > 0) {
         int challengeStatID = (int)[record.lastObject[@"ChStatID"] intValue];
         int syncStatus = (int)[record.lastObject[@"Sync"] intValue];
         
         if (syncStatus == 0) {
         [syncedStatsIDArray addObject:String(challengeStatID)];
         } else {
         [unsyncedStatsIDArray addObject:String(challengeStatID)];
         }
         }
         */
    }
    
    if ([syncedPlayerIDArray count] == 0 && [unsyncedplayerIDArray count] == 0) {
        [self.view makeToast:@"There are no stats to delete."];
        [selectedRowsArray removeAllObjects];
        [self.tableView reloadData];
    }
    
    if ([syncedPlayerIDArray count] > 0) {
        NSString *statIDs = [syncedPlayerIDArray componentsJoinedByString:@","];
        [self handleDeleteStatsFromServer:statIDs :syncedPlayerIDArray];
    }
    
    if ([unsyncedplayerIDArray count] > 0) {
        
        int unsyncCount = 0;
        for (int i = 0; i < PlayersInfoArray.count; i++) {
            int playerID = [((NSString *)PlayersInfoArray[i][@"PlayerID"]) intValue];
            NSString *findQuery = [NSString stringWithFormat:@"SELECT Date, ChStatID FROM ChallangeStat WHERE TeamID=%d AND ChallangeID=%d AND PlayerID=%d AND column_name='%@' AND Date='%@' AND Sync=%d", self.scTeamID, self.scChallengeID, playerID, allColumnName, stringDateForServer, 1];
            NSArray *record = [SCSQLite selectRowSQL:findQuery];
            
            if (record.count > 0) {
                unsyncCount++;
            }
        }
        
        if (unsyncCount == [unsyncedplayerIDArray count]) {
            [self handleDeleteStatsInLocal:unsyncedplayerIDArray syncCount:1];
        } else {
            [self handleDeleteStatsInLocal:unsyncedplayerIDArray syncCount:0];
        }
        
    }
}

#pragma mark - Actions

- (IBAction)handleDeleteStats:(id)sender {
    
    [Alert showOKCancelAlert:@"Warning!" message:@"Are you sure you want to delete these stats?" viewController:self complete:^{

        
       [self handleDeleteStats];
    } canceled:nil];
}
- (NSString *)getValues: (int)index {
    
    return [tempScoreArr[index] componentsJoinedByString:@","];
}

- (NSString *)getOldValues: (int)index {
    
    return [oldScoreArr[index] componentsJoinedByString:@","];
}

- (NSString *)getEmptyValues {
    
    NSString *emptyValue = @"NULL";
    
    for (int i = 0; i < arrComumnName.count - 1; i++) {
        emptyValue = [emptyValue stringByAppendingString:@",NULL"];
    }

    
    return emptyValue;
}


- (IBAction)didTapSave:(id)sender {
    BOOL bInsert = false;
    [self.view endEditing:true];
    
    for (int i = 0; i < PlayersInfoArray.count; i++) {
        
        NSString *value = [self getValues:i];
        NSString *oldValue = [self getOldValues:i];
        
        if ([value isEqualToString:oldValue]) {
            continue;
        }
        
        if (value) {
            [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
            NSString *query = [NSString stringWithFormat:@"SELECT ChStatID FROM ChallangeStat ORDER BY ChStatID DESC LIMIT 0,1"];
            NSArray *totalStateCount = [SCSQLite selectRowSQL:query];
            int lastStatID = [totalStateCount.firstObject[@"ChStatID"] intValue];
            
            int playerID = [((NSString *)PlayersInfoArray[i][@"PlayerID"]) intValue];
            [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
            
            NSLog(@"testvalue, %d---%@", i, value);
            
            if (isWinLossChanllenge) {
                
                if (![value isEqualToString: [self getEmptyValues]]) {
                    value = [value stringByReplacingOccurrencesOfString:@"NULL" withString:@"0"];
                }
            }
            
            if ([value isEqualToString: [self getEmptyValues]]) {
                
            } else {
                
                if ([value containsString:@"a"]) {
                    value = [value stringByReplacingOccurrencesOfString:@"a" withString:@"NULL"];
                }
                
                NSString *findQuery = [NSString stringWithFormat:@"SELECT Date, ChStatID FROM ChallangeStat WHERE TeamID=%d AND ChallangeID=%d AND PlayerID=%d AND column_name='%@' AND Date='%@'", self.scTeamID, self.scChallengeID, playerID, allColumnName, stringDateForServer];
                NSArray *record = [SCSQLite selectRowSQL:findQuery];
                
                if (record.count > 0) {
                    
                    int challengeStatID = (int)[record.lastObject[@"ChStatID"] intValue];
                    
                    NSString *updateQuery = [NSString stringWithFormat:@"UPDATE ChallangeStat SET column_val='%@', Sync=%d, email_reportAdded=%d WHERE ChStatID=%d",value, 1, self.emailReportSwitch.isOn == true ? 1 : 0, challengeStatID];
                    [SCSQLite executeSQL:updateQuery];
                    
                    NSLog(@"updated value---%lu", (unsigned long)record.count);
                    
                } else {
                    NSString *inserQuery = [NSString stringWithFormat:@"INSERT INTO ChallangeStat (ChStatID, TeamID, ChallangeID, PlayerID,column_name,column_val,Date,email_reportAdded,Sync) VALUES(%d, %d, %d, %d,'%@','%@','%@',%d,%d)", lastStatID + 1, self.scTeamID, self.scChallengeID, playerID, allColumnName, value, stringDateForServer, self.emailReportSwitch.isOn == true ? 1 : 0,1];
                    [SCSQLite executeSQL:inserQuery];
                }
                
                bInsert = true;
            }
            
        }
    }
    
    if (bInsert) {
        
        Global.syncCount++;
        [[NSUserDefaults standardUserDefaults] setInteger:Global.syncCount forKey:@"SYNCCOUNT"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [Alert showAlert:@"All player's data are saved" message:@"You can sync later" viewController:self complete:^{
            [self.navigationController popViewControllerAnimated:true];
            
        }];
        
    } else {
        [Alert showAlert:@"No data to save!" message:@"" viewController:self complete:^{
            [self.navigationController popViewControllerAnimated:true];
        }];
    }
}

- (void) SyncToServerProcessCompleted {
    [ProgressHudHelper hideLoadingHud];
    [Alert showAlert:@"Success!" message:@"All player's data are saved" viewController:self complete:^{
        [self.navigationController popViewControllerAnimated:true];
    }];

}


#pragma mark - Private Methods

- (void) loadColumns {
    [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
    NSString *query = [NSString stringWithFormat:@"SELECT a.ChStatID, a.ChallangeID, a.Date, a.PlayerID, a.Sync, a.TeamID, a.column_name, a.column_val, a.email_reportAdded, b.isDecimal, b.Challenge_Type FROM ChallangeStat a INNER JOIN Challanges b ON a.ChallangeID = b.ID AND a.TeamID = b.TeamID WHERE a.TeamID=%d AND a.ChallangeID=%d", self.scTeamID, self.scChallengeID];
    teamPlayersStats = [SCSQLite selectRowSQL:query];
    
    NSLog(@"teamplayerStats, %@", teamPlayersStats);
    
    if (teamPlayersStats.count > 0) {
        // get all column from seprated by comma
        allColumnName = teamPlayersStats.lastObject[@"column_name"];
        
        if ([allColumnName containsString:@"Made"] || [allColumnName containsString:@"Win"]) {
            isWinLossChanllenge = true;
        } else {
            isWinLossChanllenge = false;
        }
        
        arrComumnName = [allColumnName componentsSeparatedByString:@","];
        isDecimal = [teamPlayersStats.lastObject[@"isDecimal"] intValue];
        challengeType = teamPlayersStats.lastObject[@"Challenge_Type"];
    }
}

- (void) fetchChanllangeStatDataFromLocalDB {
    [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM ChallangeStat WHERE TeamID=%d AND ChallangeID=%d AND Date='%@'", self.scTeamID, self.scChallengeID, stringDateForServer];
    
    NSLog(@"date, %@", query);
    
    teamPlayersStats = [SCSQLite selectRowSQL:query];
    
    
    
    NSLog(@"fetchChallengeStatFromLocalDB, %@", teamPlayersStats);
}

- (void) fetchTeamDataFromLocalDB {
    NSString *query1 = [NSString stringWithFormat:@"SELECT * FROM PlayersInfo WHERE TeamID=%d AND UserLevel=%d ORDER BY LastName, FirstName ASC", self.scTeamID, 3];
    NSArray *tempArr = [[NSArray alloc] init];
    tempArr = [SCSQLite selectRowSQL:query1];
    
    NSLog(@"players, %@", PlayersInfoArray);
    NSDate *startDate = [Global.currntTeam.SeasonStart dateWithFormat:@"MM-dd-yyyy"];
    NSDate *endDate = [Global.currntTeam.SeasonEnd dateWithFormat:@"MM-dd-yyyy"];
    NSMutableArray *filteredArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < tempArr.count; i++) {
        
        NSString *dateStr = tempArr[i][@"GraduationDate"];
        NSDate *graduateDate = nil;
        if (![dateStr isEqual:[NSNull null]]) {
            graduateDate = [dateStr dateWithFormat:@"MM-dd-yyyy"];
        }
        
        BOOL isGraduate = [self isDate:graduateDate inRangeFirstDate:startDate lastDate:endDate];
        
        if (!isGraduate) {
            [filteredArr addObject:tempArr[i]];
        }
    }
    
    PlayersInfoArray = [NSArray new];
    PlayersInfoArray = [NSArray arrayWithArray:filteredArr];
}

//- (BOOL)isDate:(NSDate *)date inRangeFirstDate:(NSDate *)firstDate lastDate:(NSDate *)lastDate {
//    return [date compare:firstDate] == NSOrderedDescending &&
//    [date compare:lastDate]  == NSOrderedAscending;
//}

- (BOOL)isDate:(NSDate *)date inRangeFirstDate:(NSDate *)firstDate lastDate:(NSDate *)lastDate {
    if (date == nil) {
        return NO;
    }
//    return [date compare:firstDate] == NSOrderedAscending;
    if ([date compare:lastDate] == NSOrderedDescending) {
        return NO;
    }
    return YES;
}

- (void) fetchScoreData {
    tempScoreArr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < PlayersInfoArray.count; i++) {
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.PlayerID = %@", PlayersInfoArray[i][@"PlayerID"]];
        NSArray *arr = [teamPlayersStats filteredArrayUsingPredicate:predicate];
        NSArray *scoreArr = [NSArray new];
        if (arr.count > 0) {
            NSString *score = arr.lastObject[@"column_val"];
            if ([score isEqualToString: @""]) {
                NSMutableArray *tempArr = [NSMutableArray new];
                for (int i = 0; i < arrComumnName.count; i++) {
                    [tempArr addObject:@"NULL"];
                }
                scoreArr = tempArr;
            } else {
                scoreArr = [score componentsSeparatedByString:@","];
                NSMutableArray *tempArr = [NSMutableArray new];
                for (int i = 0; i < scoreArr.count; i++) {
                    
                    tempArr[i] = scoreArr[i];
                    
                    if ([scoreArr[i] isEqualToString:@""] || [scoreArr[i] isEqualToString:@" "]) {
                        tempArr[i] = @"NULL";
                    }
                }
                scoreArr = tempArr;
            }
        } else {
            NSMutableArray *tempArr = [NSMutableArray new];
            for (int i = 0; i < arrComumnName.count; i++) {
                [tempArr addObject:@"NULL"];
            }
            scoreArr = tempArr;
        }
        
        [tempScoreArr addObject:scoreArr];
        
    }
    oldScoreArr = [[NSMutableArray alloc] initWithArray:tempScoreArr copyItems:YES];
    
    NSLog(@"scoreArr, %@", oldScoreArr);
}

#pragma mark - UITableViewDelegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return PlayersInfoArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ScoreTableViewCell *cell = (ScoreTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        NSArray *nib= [[NSBundle mainBundle] loadNibNamed:@"ScoreTableViewCell" owner:self options:nil];;
        cell = [nib objectAtIndex:0];
    }
    
    cell.titleLbl.text = [NSString stringWithFormat:@"%@ %@", PlayersInfoArray[indexPath.row][@"LastName"], PlayersInfoArray[indexPath.row][@"FirstName"]];
    NSLog(@"cellforindex, %ld---%@", (long)indexPath.row, tempScoreArr);
    [cell initUIWithItems:arrComumnName values:tempScoreArr[indexPath.row] isDecimal:isDecimal index:indexPath.row];
    
    cell.scoreDelegate = self;
    cell.delegate = self;
    
    // Set CheckBox
    cell.deleteCheckBox.tag = indexPath.row;
    cell.deleteCheckBox.delegate = self;
    if ([selectedRowsArray containsObject:[[PlayersInfoArray objectAtIndex:indexPath.row] valueForKey:@"PlayerID"]]) {
        [cell.deleteCheckBox setOn:true animated:false];
    } else {
        [cell.deleteCheckBox setOn:false animated:false];
    }
    
    cell->scoreViewController = self;
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 45;// * arrComumnName.count;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (void)scoreTextFieldDidEndEditing:(UITextField *)textField {
    
    NSLog(@"textfield1, %ld", (long)textField.tag);
    
    int i = (int)textField.tag / 100 - 1;
    int j = textField.tag % 100;
    
    tempScoreArr[i][j] = textField.text;
    
    if ([textField hasText]) {
        NSLog(@"textfielddelegate, %d---%@,  %@", i, tempScoreArr[i][j], textField.text);
        if ([textField.text isEqualToString:@" "]) {
            tempScoreArr[i][j] = @"a";
        }
        
    } else {
        
        if ([oldScoreArr[i][j] isEqualToString:@"NULL"]) {
            tempScoreArr[i][j] = @"NULL";
        } else {
            tempScoreArr[i][j] = @"a";
        }
    }
}





#pragma mark - IQDropDownTextFieldDelegate

- (void) textField:(nonnull IQDropDownTextField*)textField didSelectDate:(nullable NSDate*)date {
    if (date) {
        stringForDate = [date stringWithFormat:@"yyyy-MM-dd"];
        stringDateForServer = [self.dateDDTF.date stringWithFormat:@"MM-dd-yyyy"];
        [self fetchChanllangeStatDataFromLocalDB];
        [self fetchScoreData];
        [self.tableView reloadData];
    }
}

@end
