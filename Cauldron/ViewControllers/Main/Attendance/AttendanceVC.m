//
//  AttendanceVC.m
//  Cauldron
//
//  Created by John Nik on 5/15/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "AttendanceVC.h"

@interface AttendanceVC () <UITableViewDelegate, UITableViewDataSource, IQDropDownTextFieldDelegate, BEMCheckBoxDelegate> {
    
    BOOL deselectAll;
    BOOL selectButtonToggled;
    int emailReportAdded;
    
}

@end

@implementation AttendanceVC

@synthesize selectAllButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    deselectAll = YES;
    
    [self setupNavigationItems];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.dateDDTF.dropDownMode = IQDropDownModeDatePicker;
    self.dateDDTF.date = [NSDate new];
    self.dateDDTF.dateFormatter = [NSDateFormatter formatterFromFormatString:@"MM-dd-yyyy"];
    self.dateDDTF.selectedItem = [self.dateDDTF.date stringWithFormat:@"MM-dd-yyyy"];
    self.dateDDTF.delegate = self;
    
    [self.emailReportSwitch addTarget:self action:@selector(emailSwitchToggled:) forControlEvents:UIControlEventValueChanged];
    emailReportAdded = 1;
    
    [self fetchTeamData];
    [self fetchDataFromLocalDB];
    [self getAttandaceFromDate:[[NSDate new] stringWithFormat:@"MM-dd-yyyy"]];
}

- (void)setupNavigationItems {
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    NSString *teamName = Global.currntTeam.Team_Name;
    self.navigationItem.title = [NSString stringWithFormat:@"%@-%@", teamName, @"Attendence"];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return teamPlayers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"AttendanceCell";
    AttandanceCell *cell = (AttandanceCell *)[_tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        NSArray *nib= [[NSBundle mainBundle] loadNibNamed:@"AttendanceCell" owner:self options:nil];;
        cell = [nib objectAtIndex:0];
    }
    
    cell.lblName.text = [teamPlayers objectAtIndex:indexPath.row];
    
    // Set Photo
    NSString * str = PlayersInfoArray[indexPath.row][@"Photo"];
    cell.photoImgView.image = [UIImage imageWithData:[str base64Data]];
    if (!cell.photoImgView.image) {
        cell.photoImgView.image = [UIImage imageNamed:@"avatar"];
    }
    
    // Set CheckBox
    cell.checkBox.tag = indexPath.row;
    cell.checkBox.delegate = self;
    if ([selectedRowsArray containsObject:[[PlayersInfoArray objectAtIndex:indexPath.row] valueForKey:@"PlayerID"]]) {
        [cell.checkBox setOn:true animated:false];
    } else {
        [cell.checkBox setOn:false animated:false];
    }
    
    return cell;
}
- (IBAction)didTapSelectAllButton:(UIButton *)sender {
    
    deselectAll = !deselectAll;
    
    int playersCounts = (int)teamPlayers.count;
    
    for (int i = 0 ; i < playersCounts ; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        AttandanceCell *cell = (AttandanceCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        
        if (deselectAll) {
            [cell.checkBox setOn:false animated:false];
            [selectedRowsArray removeObject:PlayersInfoArray[i][@"PlayerID"]];
        } else {
            [cell.checkBox setOn:true animated:false];
            [selectedRowsArray addObject:PlayersInfoArray[i][@"PlayerID"]];
        }
    }
    
    if (!selectButtonToggled) {
        [sender setTitle:@"Deselect All" forState:UIControlStateNormal];
        selectButtonToggled = YES;
    } else {
        [sender setTitle:@"Select All" forState:UIControlStateNormal];
        selectButtonToggled = NO;
    }

}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return 55;
    } else {
        return 55;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    AttandanceCell *cell = (AttandanceCell *)[_tableView cellForRowAtIndexPath:indexPath];
    
    if (cell.checkBox.on) {
        [cell.checkBox setOn:false animated:true];
    } else {
        [cell.checkBox setOn:true animated:true];
    }
    
    if ([selectedRowsArray containsObject:PlayersInfoArray[indexPath.row][@"PlayerID"]]) {
        [selectedRowsArray removeObject:PlayersInfoArray[indexPath.row][@"PlayerID"]];
    } else {
        [selectedRowsArray addObject:PlayersInfoArray[indexPath.row][@"PlayerID"]];
    }
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

#pragma mark - BEMCheckBox Delegate

- (void)didTapCheckBox:(BEMCheckBox*)checkBox {
    if ([selectedRowsArray containsObject:PlayersInfoArray[checkBox.tag][@"PlayerID"]]) {
        [selectedRowsArray removeObject:PlayersInfoArray[checkBox.tag][@"PlayerID"]];
    } else {
        [selectedRowsArray addObject:PlayersInfoArray[checkBox.tag][@"PlayerID"]];
    }
    
    int switchBool = self.emailReportSwitch.isOn ? 1 : 0;
    
    NSLog(@"switchTest, %d", switchBool);
}

#pragma mark - IQDropDownTextFieldDelegate

-(void)textField:(nonnull IQDropDownTextField*)textField didSelectDate:(nullable NSDate*)date {
    
    if  (selectButtonToggled) {
        [selectAllButton setTitle:@"Select All" forState:UIControlStateNormal];
        selectButtonToggled = NO;
        deselectAll = YES;
    }
    
    [self fetchDataFromLocalDB];
    [self.tableView reloadData];
}

- (void) emailSwitchToggled:(id)sender {
    UISwitch *mySwitch = (UISwitch *)sender;
    if ([mySwitch isOn]) {
        NSLog(@"its on!");
        emailReportAdded = 1;
    } else {
        NSLog(@"its off!");
        emailReportAdded = 0;
    }
}

#pragma mark - IBActions

- (IBAction)didTapSave:(id)sender {
    if ([Global.teamName rangeOfString:@"Demo"].location != NSNotFound) {
        [Alert showAlert:@"Demo Team" message:@"Demo Team Can't Save attandance" viewController:self];
    }
    
    NSLog(@"test attendence, %@ ", selectedRowsArray);
    
    BOOL success = [SQLiteHelper deleteInTable:@"playerattendance" where:@{@"attendance_date": self.dateDDTF.selectedItem}];
    BOOL attendenceSuccess = NO;
    
    for (int i = 0; i < selectedRowsArray.count; i++) {
        Attandance *newAttendance = [[Attandance alloc] init];
        newAttendance.attandance = 1;
        newAttendance.attendanceDate = self.dateDDTF.selectedItem;
        newAttendance.add_date = self.dateDDTF.selectedItem;
        newAttendance.email_reportAdded = emailReportAdded;
        
        NSLog(@"test emailreport, %d", emailReportAdded);
        
        NSDictionary *temp = [PlayersInfoArray objectAtIndex:[sender tag]];
        NSString *dateStr = [self.dateDDTF.date stringWithFormat:@"MM-dd-yyyy"];
        NSString *inserQuery = [NSString stringWithFormat:@"INSERT INTO playerattendance (TeamID, PlayerID, attendance_date, attendance, add_date, email_reportAdded, sync) VALUES(%d,%d,'%@','%d','%@',%d, %d)",[[temp valueForKey:@"TeamID"] intValue],[[selectedRowsArray objectAtIndex:i] intValue], dateStr, 1, dateStr, self.emailReportSwitch.isOn ? 1 : 0, 1];
        attendenceSuccess = [SCSQLite executeSQL:inserQuery];
        
        if (i == 0) {
            [Global.attendenceDateArr addObject:self.dateDDTF.date];
            [[NSUserDefaults standardUserDefaults] setObject:Global.attendenceDateArr forKey:@"ATTENDENCEDATEARR"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        NSLog(@"userdefaultsTest");
    }
    if (success) {
        if (attendenceSuccess) {
            
            Global.syncCount++;
            [[NSUserDefaults standardUserDefaults] setInteger:Global.syncCount forKey:@"SYNCCOUNT"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [Alert showAlert:@"Attendance Saved" message:@"Can Sync now!" viewController:self];
        } else {
            
            for (int i = 0; i < [Global.attendenceDateArr count]; i++) {
                if (self.dateDDTF.date == [Global.attendenceDateArr objectAtIndex:i]) {
                    [Global.attendenceDateArr removeObjectAtIndex:i];
                    [[NSUserDefaults standardUserDefaults] setObject:Global.attendenceDateArr forKey:@"ATTENDENCEDATEARR"];
                    Global.syncCount--;
                    [[NSUserDefaults standardUserDefaults] setInteger:Global.syncCount forKey:@"SYNCCOUNT"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                    break;
                }
            }
            
            [Alert showAlert:@"No data to save" message:@"" viewController:self];

        }
    }
}



#pragma mark - Private Methods

- (void) getAttandaceFromDate:(NSString*)date {
//    NSString *selectQuery = [NSString stringWithFormat:@"SELECT PlayerID FROM playerattendance WHERE attendance_date=\"%@\" AND sync=1 ",date];

    NSString *selectQuery = [NSString stringWithFormat:@"SELECT PlayerID FROM playerattendance WHERE attendance_date=\"%@\"",date];
    NSArray *tempArray = [SCSQLite selectRowSQL:selectQuery];
    
    selectedRowsArray = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < tempArray.count; i++) {
        [selectedRowsArray addObject:[[tempArray objectAtIndex:i] valueForKey:@"PlayerID"]];
    }
    [_tableView reloadData];
}

- (void) fetchDataFromLocalDB {
    NSString *dateStr = [self.dateDDTF.date stringWithFormat:@"MM-dd-yyyy"];
//    NSString *selectQuery = [NSString stringWithFormat:@"SELECT PlayerID FROM playerattendance WHERE attendance_date=\"%@\" AND sync=1", dateStr];
    
    NSString *selectQuery = [NSString stringWithFormat:@"SELECT PlayerID FROM playerattendance WHERE attendance_date=\"%@\"", dateStr];
    
    NSArray *tempArray = [SCSQLite selectRowSQL: selectQuery];
    
    selectedRowsArray = [[NSMutableArray alloc] init];
    
    for (int i=0; i < tempArray.count; i++) {
        [selectedRowsArray addObject:[[tempArray objectAtIndex:i] valueForKey:@"PlayerID"]];
    }
}

- (void) fetchTeamData {
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM PlayersInfo WHERE TeamID=%d AND UserLevel=%d ORDER BY LastName, FirstName ASC", Global.currntTeam.TeamID, 3];
    PlayersInfoArray = [SCSQLite selectRowSQL:query];
    NSLog(@"All Team Player Are From DataBase: %@",PlayersInfoArray);
    
    teamPlayers = [[NSMutableArray alloc] init];
    for (int m = 0; m < PlayersInfoArray.count; m++) {
        NSString *playerLastName = [NSString stringWithFormat:@"%@",[[PlayersInfoArray objectAtIndex:m]valueForKey:@"LastName"]];
        NSString *playerFirstName = [NSString stringWithFormat:@"%@",[[PlayersInfoArray objectAtIndex:m]valueForKey:@"FirstName"]];
        NSString *playerFullName = [NSString stringWithFormat:@"%@ %@",playerLastName,playerFirstName];
        
        [teamPlayers addObject:playerFullName];
    }
}

@end
