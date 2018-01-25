//
//  RosterVC.m
//  Cauldron
//
//  Created by John Nik on 5/18/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "RosterVC.h"
#import "RosterHeaderCell.h"

@interface RosterVC () <UIGestureRecognizerDelegate, AddPlayerDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

static NSString *simpleTableIdentifier_iPhone = @"AddPlayerCell_iPhone";
static NSString *simpleTableIdentifier_iPad = @"AddPlayerCell_iPad";
static NSString *RosterHeaderViewIdentifier = @"RosterHeaderCell";
static NSString *RosterHeaderViewIdentifier_iPad = @"RosterHeaderCell_iPad";


@implementation RosterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavigationItems];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    // Register NIB to tableview
    if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        [self.tableView registerNib:[UINib nibWithNibName:@"AddPlayerCell" bundle:nil] forCellReuseIdentifier:simpleTableIdentifier_iPhone];
        
        UINib *sectionHeaderNib = [UINib nibWithNibName:@"RosterHeaderCell" bundle:nil];
        [self.tableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:RosterHeaderViewIdentifier];
        
    } else {
        [self.tableView registerNib:[UINib nibWithNibName:@"AddPlayerCell_iPad" bundle:nil] forCellReuseIdentifier:simpleTableIdentifier_iPad];
        UINib *sectionHeaderNib = [UINib nibWithNibName:@"RosterHeaderCell_iPad" bundle:nil];
        [self.tableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:RosterHeaderViewIdentifier_iPad];
    }
    
    arrPlayerDetail = [[NSMutableArray alloc] init];
    [self createJsonStringsArrayPlayer];
    [_tableView reloadData];
    
    UILongPressGestureRecognizer *longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPressGr.minimumPressDuration = 0.5;
    longPressGr.delaysTouchesBegan = true;
    longPressGr.delegate = self;
    [self.tableView addGestureRecognizer:longPressGr];
    
}

- (void)setupNavigationItems {
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    NSString *teamName = Global.currntTeam.Team_Name;
    self.navigationItem.title = [NSString stringWithFormat:@"%@-%@", teamName, @"Roster"];
    
}

- (void) handleLongPress:(UILongPressGestureRecognizer *)longPressGesture {
    
    NSLog(@"pressed longpress");
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    
}

- (void)didDisappear {
    
    [self createJsonStringsArrayPlayer];
    [_tableView reloadData];
    
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
    return [arrPlayerDetail count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AddPlayerCell *cell;
    
    if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        cell = (AddPlayerCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier_iPhone];
    } else {
        cell = (AddPlayerCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier_iPad];
    }
    
    Player *tempObj = [[Player alloc] init];
    tempObj = [arrPlayerDetail objectAtIndex:indexPath.row];
    
    NSString *birthDate = [NSString stringWithFormat:@"%@",tempObj.BirthDate];
    if ([birthDate isEqualToString:@"11-30--0001"]) {
        cell.lblBirthDate.text = @"";
    } else {
        cell.lblBirthDate.text= birthDate;
    }
    
    cell.lblJourcyNo.text=[NSString stringWithFormat:@"%@",tempObj.jercyNo];
    cell.lblName.text=[NSString stringWithFormat:@"%@ %@",tempObj.FirstName,tempObj.LastName];
    
    NSData *decodedData = [tempObj.Photo base64Data];
    if ([tempObj.Photo isEqualToString:@" "] || tempObj.Photo==Nil) {
        cell.imgPlayer.image = [UIImage imageNamed:@"avatar"];
    } else {
        UIImage* image = [UIImage imageWithData:decodedData];
        cell.imgPlayer.image = image;
    }
    
    if (cell.imgPlayer.image == nil) {
        cell.imgPlayer.image = [UIImage imageNamed:@"avatar"];
    }
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([[UIDevice currentDevice]userInterfaceIdiom]!=UIUserInterfaceIdiomPhone) {
        return 60;
    }
    
    return 50;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AddPlayerVC *viewController = (AddPlayerVC *) [self.storyboard instantiateViewControllerWithIdentifier:@"AddPlayerVC"];
    
    Player *tempObj = [[Player alloc] init];
    tempObj = [arrPlayerDetail objectAtIndex:indexPath.row];
    
    NSLog(@"array, %@", arrPlayerDetail);
    
    viewController.playerID = (int)[[tempObj valueForKey:@"PlayerID"] integerValue];
    viewController.isUpdate = true;
    viewController.navigationRosterStatus = RosterState_Update;
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:true];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self deletePlayer:indexPath.row];
    }
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    RosterHeaderCell *header;
    
    if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        header = (RosterHeaderCell *)[self.tableView dequeueReusableHeaderFooterViewWithIdentifier:RosterHeaderViewIdentifier];
        
        
    } else {
        header = (RosterHeaderCell *)[self.tableView dequeueReusableHeaderFooterViewWithIdentifier:RosterHeaderViewIdentifier_iPad];
    }
    
    return header;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if ([[UIDevice currentDevice]userInterfaceIdiom]!=UIUserInterfaceIdiomPhone) {
        return 60;
    }
    
    return 50;
}

- (void) deletePlayer:(NSInteger)playerIndex {
    
    Player *tempPlayer = [[Player alloc] init];
    tempPlayer = [arrPlayerDetail objectAtIndex:playerIndex];
    
    NSString *action = @"DELETE_ROSTER";
    NSString *playeryName = tempPlayer.UserName;
    int playerId = tempPlayer.PlayerID;
    
    NSLog(@"delete challenge Name, %@, %d", playeryName, playerId);
    
    NSDictionary* params = @{@"action": action,
                             @"PlayerID": String(playerId),
                             @"TeamID": String(Global.currntTeam.TeamID)
                             };
    
    [API executeHTTPRequest:Post url:syncToServerServiceURLPlayer parameters:params CompletionHandler:^(NSDictionary *responseDict) {
        [ProgressHudHelper hideLoadingHud];
        [self parseResponse:responseDict params:params playerId:playerId];
    } ErrorHandler:^(NSString *errorStr) {
        
        NSLog(@"errorStr ---%@", errorStr);
        [ProgressHudHelper hideLoadingHud];
        [Alert showAlert:@"Something went wrong" message:nil viewController:self];
    }];
    
}

- (void) parseResponse: (NSDictionary *)dic params:(NSDictionary *)paramsDic playerId:(int)playerId {
    
    NSString *successResult = [dic valueForKey:@"status"];
    
    NSLog(@"success or fail if recieve data from server-----%@", successResult);
    
    if ([successResult isEqualToString:@"Successs"]) {
        
        NSDictionary *whereDic = @{@"TeamID": String(Global.currentTeamId), @"PlayerID": String(playerId)};
        
        BOOL success = [SQLiteHelper deleteInTable:@"PlayersInfo" where:whereDic];
        
        if (success) {
            
            [Alert showAlert:@"Player successfully deleted" message:nil viewController:self complete:^{
                
                [self createJsonStringsArrayPlayer];
                [_tableView reloadData];
                
            }];
        } else {
            [Alert showAlert:@"Error" message:@"Failed to delete Player in local" viewController:self];
        }
    } else {
        
        [Alert showAlert:@"Failed to Delete Player" message:nil viewController:self];
        return;
    }
}



#pragma mark - IBActions

- (IBAction)didTapAddPlayer:(id)sender {
    AddPlayerVC *viewController = (AddPlayerVC *) [self.storyboard instantiateViewControllerWithIdentifier:@"AddPlayerVC"];
    viewController.isUpdate = false;
    viewController.navigationRosterStatus = RosterState_Add;
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:true];
}


#pragma mark - Database Methods

-(void)createJsonStringsArrayPlayer {
    [arrPlayerDetail removeAllObjects];
    [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM PlayersInfo where TeamID=%d",Global.currentTeamId];
    NSArray *teamStats = [SCSQLite selectRowSQL:query];
    
    for (int i = 0; i < [teamStats count]; i++) {
        Player *objPlayer = [[Player alloc]init];
        objPlayer.TeamID=[[[teamStats objectAtIndex:i] valueForKey:@"TeamID"] intValue];
        objPlayer.PlayerID=[[[teamStats objectAtIndex:i] valueForKey:@"PlayerID"] intValue];
        objPlayer.BirthDate=[[teamStats objectAtIndex:i] valueForKey:@"BirthDate"];
        objPlayer.GraduationDate = [[teamStats objectAtIndex:i] valueForKey:@"GraduationDate"];
        objPlayer.DEmail=[[teamStats objectAtIndex:i] valueForKey:@"DEmail"] ;
        objPlayer.Notes=[[teamStats objectAtIndex:i] valueForKey:@"Notes"];
        objPlayer.EmailDRpt=(int)[[[teamStats objectAtIndex:i] valueForKey:@"EmailDRpt"] intValue];
        objPlayer.EmailMRpt=(int)[[[teamStats objectAtIndex:i] valueForKey:@"EmailMRpt"] intValue];
        objPlayer.EmailPRpt=(int)[[[teamStats objectAtIndex:i] valueForKey:@"EmailPRpt"] intValue];
        objPlayer.FirstName=[[teamStats objectAtIndex:i] valueForKey:@"FirstName"] ;
        objPlayer.Grade=[[teamStats objectAtIndex:i] valueForKey:@"Grade"];
        objPlayer.jercyNo=[[teamStats objectAtIndex:i] valueForKey:@"JourcyNo"];
        objPlayer.LastName=[[teamStats objectAtIndex:i] valueForKey:@"LastName"] ;
        objPlayer.MEmail=[[teamStats objectAtIndex:i] valueForKey:@"MEmail"];
        objPlayer.PEmail=[[teamStats objectAtIndex:i] valueForKey:@"PEmail"];
        objPlayer.Password=[[teamStats objectAtIndex:i] valueForKey:@"Password"] ;
        objPlayer.Photo=[[teamStats objectAtIndex:i] valueForKey:@"Photo"];
        objPlayer.Position=[[teamStats objectAtIndex:i] valueForKey:@"Position"];
        objPlayer.UserName=[[teamStats objectAtIndex:i] valueForKey:@"UserName"];
        objPlayer.modified=[[teamStats objectAtIndex:i] valueForKey:@"modified"] ;
        objPlayer.UserLevel=[[[teamStats objectAtIndex:i] valueForKey:@"UserLevel"] intValue];
        objPlayer.Phone=[[teamStats objectAtIndex:i] valueForKey:@"Phone"];
        
        
        NSDate *startDate = [Global.currntTeam.SeasonStart dateWithFormat:@"MM-dd-yyyy"];
        NSDate *endDate = [Global.currntTeam.SeasonEnd dateWithFormat:@"MM-dd-yyyy"];
        NSDate *graduateDate = [objPlayer.GraduationDate dateWithFormat:@"MM-dd-yyyy"];
        
        BOOL isGraduate = [self isDate:graduateDate inRangeFirstDate:startDate lastDate:endDate];
        
        if (isGraduate == false) {
            [arrPlayerDetail addObject:objPlayer];
        }

        
        
    }
}

- (BOOL)isDate:(NSDate *)date inRangeFirstDate:(NSDate *)firstDate lastDate:(NSDate *)lastDate {
    return [date compare:firstDate] == NSOrderedAscending;
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
