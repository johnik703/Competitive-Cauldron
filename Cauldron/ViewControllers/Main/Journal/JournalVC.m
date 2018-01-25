//
//  JournalVC.m
//  Cauldron
//
//  Created by John Nik on 5/15/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "JournalVC.h"


@interface JournalVC () <UITableViewDelegate, UITableViewDataSource, AddJournalVCDelegate, IQDropDownTextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation JournalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNavigationItems];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Initialize UI
    _fromDDTF.dropDownMode = IQDropDownModeDatePicker;
    _fromDDTF.dateFormatter = [NSDateFormatter formatterFromFormatString:@"MM-dd-yyyy"];
    _fromDDTF.date = [Global.currntTeam.SeasonStart dateWithFormat:@"MM-dd-yyyy"];
    _fromDDTF.delegate = self;
    _toDDTF.dropDownMode = IQDropDownModeDatePicker;
    _toDDTF.dateFormatter = [NSDateFormatter formatterFromFormatString:@"MM-dd-yyyy"];
    _toDDTF.date = [Global.currntTeam.SeasonEnd dateWithFormat:@"MM-dd-yyyy"];
    _toDDTF.delegate = self;
    
    arrJournalData = [[NSMutableArray alloc] init];
    NSString *getUserLevel = UDGetString(@"USERLEVEL");
    playerID = Global.playerIDFinal;
    
//    if ([getUserLevel isEqualToString:@"3"]) {
//        arrJournalData = [self getJournalDataFromServer:[NSString stringWithFormat:journalDataURL, Global.currntTeam.TeamID, [playerID intValue]]];
//        
//        for (int m = 0; m < arrJournalData.count; m++) {
//            NSString *notesQuery = [NSString stringWithFormat:@"SELECT notes FROM JournalData WHERE  id ='%@'" ,[NSString stringWithFormat:@"%@",[[arrJournalData objectAtIndex:m] valueForKey:@"id"]]];
//            NSArray *tempArray = [SCSQLite selectRowSQL:notesQuery];
//            if ([tempArray count] == 0) {
//                [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
//                NSString *inserQuery = [NSString stringWithFormat:@"INSERT INTO JournalData (id,TeamID,PlayerID,notes,add_date,sync) VALUES(%d,%d,%d,'%@','%@',%d)",[[[arrJournalData objectAtIndex:m]valueForKey:@"id"] intValue], Global.currntTeam.TeamID,[[[arrJournalData objectAtIndex:m]valueForKey:@"PlayerID"] intValue],[[arrJournalData objectAtIndex:m]valueForKey:@"notes"],[[arrJournalData objectAtIndex:m]valueForKey:@"add_date"],0];
//                [SCSQLite executeSQL:inserQuery];
//            }
//        }
//    } else {
//        arrJournalData = [self getJournalDataFromServer:[NSString stringWithFormat:journalTeamDataURL, Global.currntTeam.TeamID]];
//        
//        for (int m = 0; m < arrJournalData.count; m++) {
//            NSString *notesQuery = [NSString stringWithFormat:@"SELECT notes FROM JournalData WHERE  id ='%@' And notes = '%@' " ,[NSString stringWithFormat:@"%@",[[arrJournalData objectAtIndex:m] valueForKey:@"id"]],[NSString stringWithFormat:@"%@",[[arrJournalData objectAtIndex:m] valueForKey:@"notes"]]];
//            NSArray *tempArray = [SCSQLite selectRowSQL:notesQuery];
//            if (tempArray.count == 0) {
//                [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
//                NSString *inserQuery = [NSString stringWithFormat:@"INSERT INTO JournalData (id,TeamID,PlayerID,notes,add_date,sync) VALUES(%d,%d,%d,'%@','%@',%d)",[[[arrJournalData objectAtIndex:m]valueForKey:@"id"] intValue],Global.currntTeam.TeamID,[[[arrJournalData objectAtIndex:m]valueForKey:@"PlayerID"] intValue],[[arrJournalData objectAtIndex:m]valueForKey:@"notes"],[[arrJournalData objectAtIndex:m]valueForKey:@"add_date"],0];
//                [SCSQLite executeSQL:inserQuery];
//            }
//        }
//    }
}

- (void)setupNavigationItems {
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    NSString *teamName = Global.currntTeam.Team_Name;
//    if (Global.mode == USER_MODE_PLAYER) {
//        self.navigationItem.rightBarButtonItem = nil;
//    }
    self.navigationItem.title = [NSString stringWithFormat:@"%@-%@", teamName, @"Journals"];
    
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self fetchDataFromLocalDB];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - AddJournalVCDelegate

- (void) didDisappear {
//    [self fetchDataFromLocalDB];
}

#pragma mark - IQDropDownTextFieldDelegate

- (void)textField:(nonnull IQDropDownTextField*)textField didSelectDate:(nullable NSDate*)date {
    [self fetchDataFromLocalDB];
}

#pragma mark - UITableViewDelegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return arrJournalData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *journalCellIdentifier = @"JournalCell";
    JournalCell *cell = (JournalCell *)[_tableView dequeueReusableCellWithIdentifier:journalCellIdentifier];
    if (cell == nil) {
        NSArray *nib= [[NSBundle mainBundle] loadNibNamed:@"JournalCell" owner:self options:nil];;
        cell = [nib objectAtIndex:0];
    }
    
    NSString *query1 = [NSString stringWithFormat:@"SELECT FirstName,LastName FROM PlayersInfo WHERE TeamID=%d AND PlayerID=%@ ", Global.currntTeam.TeamID, [[arrJournalData objectAtIndex:indexPath.row]valueForKey:@"PlayerID"]];
    NSArray *PlayersInfoArray12 = [SCSQLite selectRowSQL:query1];
    
    NSString *playerLastName = [NSString stringWithFormat:@"%@",[[PlayersInfoArray12 objectAtIndex:0]valueForKey:@"LastName"]];
    NSString *playerFirstName = [NSString stringWithFormat:@"%@",[[PlayersInfoArray12 objectAtIndex:0]valueForKey:@"FirstName"]];
    NSString *playerFullName = [NSString stringWithFormat:@"%@ %@",playerLastName,playerFirstName];
    
    cell.playNameLabel.text = playerFullName;
//    cell.playNameLabel.text = @"TEst";
    cell.journalLabel.text = [[arrJournalData objectAtIndex:indexPath.row]valueForKey:@"notes"];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[UIDevice currentDevice]userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return 50;
    } else {
        return 50;
    }
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AddJournalVC *viewController = (AddJournalVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"AddJournalVC"];
    NSDictionary *dicJournal=[arrJournalData objectAtIndex:indexPath.row];
    viewController.delegate = self;
    viewController.jornalData = [dicJournal objectForKey:@"notes"];
    viewController.date = [dicJournal objectForKey:@"add_date"];
    viewController.playerName = [dicJournal objectForKey:@"PlayerID"];
    viewController.isUpdate = TRUE;
    viewController.journalId = [[dicJournal objectForKey:@"id"] intValue];
    
    [self.navigationController pushViewController:viewController animated:true];
    
    
    //    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    //    MZFormSheetPresentationViewController *formSheetController = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:navigationController];
    
    // Set size
//    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
//        formSheetController.presentationController.contentViewSize = CGSizeMake(ScreenWidth * 0.8, ScreenHeight * 0.8);
//    } else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
//        formSheetController.presentationController.contentViewSize = CGSizeMake(ScreenWidth * 0.7, ScreenHeight * 0.7);
//    }
//    
//    formSheetController.presentationController.shouldDismissOnBackgroundViewTap = YES;
//    formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyleFade;
//    
//    __weak MZFormSheetPresentationViewController *weakController = formSheetController;
//    formSheetController.willPresentContentViewControllerHandler = ^(UIViewController *a) {
//        weakController.contentViewCornerRadius = 5.0;
//        weakController.shadowRadius = 6.0;
//    };
    
//    [self presentViewController:formSheetController animated:YES completion:nil];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

#pragma mark - IBActions

- (IBAction)didTapAddJournal:(id)sender {
    
    AddJournalVC *viewController = (AddJournalVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"AddJournalVC"];
    viewController.isUpdate = false;
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:true];
    
//    MZFormSheetPresentationViewController *formSheetController = [[MZFormSheetPresentationViewController alloc] initWithContentViewController:navigationController];
    
    // Set size
//    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPhone) {
//        formSheetController.presentationController.contentViewSize = CGSizeMake(ScreenWidth * 0.8, ScreenHeight * 0.8);
//    } else if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
//        formSheetController.presentationController.contentViewSize = CGSizeMake(ScreenWidth * 0.7, ScreenHeight * 0.7);
//    }
//    
//    formSheetController.presentationController.shouldDismissOnBackgroundViewTap = YES;
//    formSheetController.contentViewControllerTransitionStyle = MZFormSheetPresentationTransitionStyleFade;
//    
//    __weak MZFormSheetPresentationViewController *weakController = formSheetController;
//    formSheetController.willPresentContentViewControllerHandler = ^(UIViewController *a) {
//        weakController.contentViewCornerRadius = 5.0;
//        weakController.shadowRadius = 6.0;
//    };
//    
//    [self presentViewController:formSheetController animated:YES completion:nil];
}

#pragma mark - DB Methods

- (void) fetchData {
    NSString *selectQuery;
    NSString *getUserLevel = [[NSUserDefaults standardUserDefaults] stringForKey:@"USERLEVEL"];
    
    if ([getUserLevel isEqualToString:@"3"]) {
        selectQuery = [NSString stringWithFormat:@"SELECT PlayerID,notes,id,add_date FROM JournalData WHERE TeamID = '%d' AND  PlayerID ='%@'", Global.currntTeam.TeamID ,Global.playerIDFinal];
    } else {
        selectQuery = [NSString stringWithFormat:@"SELECT PlayerID,notes,id,add_date FROM JournalData WHERE TeamID = '%d'", Global.currntTeam.TeamID ];
    }
    
    NSArray *tempArray = [SCSQLite selectRowSQL:selectQuery];
    if (tempArray.count >= arrJournalData.count) {
        arrJournalData = [[NSMutableArray alloc] initWithArray:tempArray];
        [_tableView reloadData];
    }
}

- (void) fetchDataFromLocalDB {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *selectQuery;
        NSString *getUserLevel = [[NSUserDefaults standardUserDefaults] stringForKey:@"USERLEVEL"];
        
        if ([getUserLevel isEqualToString:@"3"]) {
            selectQuery = [NSString stringWithFormat:@"SELECT PlayerID,notes,id,add_date FROM JournalData WHERE TeamID = '%d' AND  PlayerID ='%@'", Global.currntTeam.TeamID ,Global.playerIDFinal];
        } else {
            selectQuery = [NSString stringWithFormat:@"SELECT PlayerID,notes,id,add_date FROM JournalData WHERE TeamID = '%d'", Global.currntTeam.TeamID ];
        }
        
        NSArray *tempArray = [SCSQLite selectRowSQL:selectQuery];
        NSLog(@"journal data %@",arrJournalData);
        
        if (tempArray.count >= arrJournalData.count) {
            arrJournalData = [[NSMutableArray alloc] initWithArray:tempArray];
//            [_tableView reloadData];
        }
        
        NSMutableArray *arrFilterData=[[NSMutableArray alloc] init];
        for (int i = 0; i < arrJournalData.count; i++) {
            NSDictionary *dic=[arrJournalData objectAtIndex:i];
            if ([self date:[dic valueForKey:@"add_date"] isBetweenDate:[_fromDDTF.date stringWithFormat:@"MM-dd-yyyy"] andDate:[_toDDTF.date stringWithFormat:@"MM-dd-yyyy"]]) {
                [arrFilterData addObject:dic];
            }
            
        }
        arrJournalData = arrFilterData;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}

- (BOOL) date:(NSString*)date isBetweenDate:(NSString*)beginDate andDate:(NSString*)endDate {
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setDateFormat:@"MM-dd-yyyy"];
    [formatter1 setTimeZone:[NSTimeZone timeZoneWithName:@"..."]];
    NSDate *date1 = [formatter1 dateFromString:date];
    NSDate *beginDate1 = [formatter1 dateFromString:beginDate];
    NSDate *endDate1 = [formatter1 dateFromString:endDate];
    
    if ([date1 compare:beginDate1] == NSOrderedAscending) {
        return NO;
    }
    
    if ([date1 compare:endDate1] == NSOrderedDescending) {
        return NO;
    }
    
    return YES;
}

- (void) getJournalData {
    NSString *getUserLevel = [[NSUserDefaults standardUserDefaults] stringForKey:@"USERLEVEL"];
    
    if ([getUserLevel isEqualToString:@"3"]) {
        arrJournalData=[self getJournalDataFromServer:[NSString stringWithFormat:attendanceReportPlayer, Global.currntTeam.TeamID, [_fromDDTF.date stringWithFormat:@"MM-dd-yyyy"] , [_toDDTF.date stringWithFormat:@"MM-dd-yyyy"], Global.playerIDFinal]];
    } else {
        arrJournalData=[self getJournalDataFromServer:[NSString stringWithFormat:attendanceReportTeam, Global.currntTeam.TeamID, [_fromDDTF.date stringWithFormat:@"MM-dd-yyyy"] , [_toDDTF.date stringWithFormat:@"MM-dd-yyyy"]]];
        NSLog(@"dic %@",[NSString stringWithFormat:@"http://competitive-cauldron.com/test/stats/web_service/getAttendanceReport.php?TeamID=%d", Global.currntTeam.TeamID]);
    }
    
    NSLog(@"dic %@",arrJournalData);
    if (arrJournalData.count == 0) {
        [Alert showAlert:@"No Record Found" message:@"" viewController:self];
    }
    
    [_tableView reloadData];
}


- (NSMutableArray*) getJournalDataFromServer:(NSString *)urlString {
    NSError *error;
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Call the web service, and (if it's successful) store the raw data that it returns
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse: nil error:&error];
    
    if (!data) {
        NSLog(@"Download Error: %@", error.localizedDescription);
        return nil;
    }
    
    // Parse the (binary) JSON data from the web service into an NSDictionary object
    NSMutableArray *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    return dictionary;
}

@end
