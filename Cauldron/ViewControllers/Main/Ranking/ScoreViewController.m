//
//  ScoreViewController.m
//  Cauldron
//
//  Created by John Nik on 5/15/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "ScoreViewController.h"

@interface ScoreViewController () <UITableViewDelegate, UITableViewDataSource, IQDropDownTextFieldDelegate, ScoreTextFieldDelegate>
{
    NSString *stringForDate;
    NSString *stringDateForServer;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
static NSString *simpleTableIdentifier = @"ScoreTableViewCell";
@implementation ScoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    [appDelegate setShouldRotate:YES];
    
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ScoreTableViewCell" bundle:nil] forCellReuseIdentifier:simpleTableIdentifier];
    
    self.title = self.scChallengeName;
    
    self.dateDDTF.delegate = self;
    self.dateDDTF.dropDownMode = IQDropDownModeDatePicker;
    self.dateDDTF.date = [NSDate new];
    self.dateDDTF.dateFormatter = [NSDateFormatter formatterFromFormatString:@"MM-dd-yyyy"];
    stringForDate = [self.dateDDTF.date stringWithFormat:@"yyyy-MM-dd"];
    stringDateForServer = [self.dateDDTF.date stringWithFormat:@"MM-dd-yyyy"];
    [self loadColumns];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Actions

- (NSString *)getValues: (int)index {
    
    return [tempScoreArr[index] componentsJoinedByString:@","];
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
        
        if (value) {
            [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
            NSString *query = [NSString stringWithFormat:@"SELECT ChStatID FROM ChallangeStat ORDER BY ChStatID DESC LIMIT 0,1"];
            NSArray *totalStateCount = [SCSQLite selectRowSQL:query];
            int lastStatID = [totalStateCount.firstObject[@"ChStatID"] intValue];
            
            int playerID = [((NSString *)PlayersInfoArray[i][@"PlayerID"]) intValue];
            [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
            
            NSLog(@"testvalue, %d---%@", i, value);
            
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
    NSString *query = [NSString stringWithFormat:@"SELECT a.ChStatID, a.ChallangeID, a.Date, a.PlayerID, a.Sync, a.TeamID, a.column_name, a.column_val, a.email_reportAdded, b.isDecimal FROM ChallangeStat a INNER JOIN Challanges b ON a.ChallangeID = b.ID AND a.TeamID = b.TeamID WHERE a.TeamID=%d AND a.ChallangeID=%d", self.scTeamID, self.scChallengeID];
    teamPlayersStats = [SCSQLite selectRowSQL:query];
    
    NSLog(@"teamplayerStats, %@", teamPlayersStats);
    
    if (teamPlayersStats.count > 0) {
        // get all column from seprated by comma
        allColumnName = teamPlayersStats.lastObject[@"column_name"];
        arrComumnName = [allColumnName componentsSeparatedByString:@","];
        isDecimal = [teamPlayersStats.lastObject[@"isDecimal"] intValue];
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
    
    PlayersInfoArray = [SCSQLite selectRowSQL:query1];
    
    NSLog(@"players, %@", PlayersInfoArray);
    NSDate *startDate = [Global.currntTeam.SeasonStart dateWithFormat:@"MM-dd-yyyy"];
    NSDate *endDate = [Global.currntTeam.SeasonEnd dateWithFormat:@"MM-dd-yyyy"];
    NSMutableArray *tempArr = [NSMutableArray arrayWithArray:PlayersInfoArray];
    for (int i = 0; i < tempArr.count; i++) {
        
        NSString *dateStr = tempArr[i][@"GraduationDate"];
        
        NSDate *graduateDate = [dateStr dateWithFormat:@"MM-dd-yyyy"];
        
        BOOL isGraduate = [self isDate:graduateDate inRangeFirstDate:startDate lastDate:endDate];
        
        if (isGraduate == true) {
            [tempArr removeObjectAtIndex:i];
            
        }
    }
    NSLog(@"player count1, %lu", (unsigned long)PlayersInfoArray.count);
    NSLog(@"player count2, %lu", (unsigned long)tempArr.count);
    PlayersInfoArray = [NSArray new];
    PlayersInfoArray = [NSArray arrayWithArray:tempArr];
    
    NSLog(@"player count, %lu", (unsigned long)self.scTeamID);
    
}

//- (BOOL)isDate:(NSDate *)date inRangeFirstDate:(NSDate *)firstDate lastDate:(NSDate *)lastDate {
//    return [date compare:firstDate] == NSOrderedDescending &&
//    [date compare:lastDate]  == NSOrderedAscending;
//}

- (BOOL)isDate:(NSDate *)date inRangeFirstDate:(NSDate *)firstDate lastDate:(NSDate *)lastDate {
    return [date compare:firstDate] == NSOrderedAscending;
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
