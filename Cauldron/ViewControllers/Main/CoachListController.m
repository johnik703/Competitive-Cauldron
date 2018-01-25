//
//  CoachListController.m
//  Cauldron
//
//  Created by John Nik on 6/1/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "CoachListController.h"
#import "CoachListCell.h"
#import "EditCoachController.h"

@interface CoachListController () <UIGestureRecognizerDelegate, SHMultipleSelectDelegate, MGSwipeTableCellDelegate> {
    
    NSMutableArray *teamArr;
    NSArray *coachArr;
    float cellHeight;
    
    NSMutableArray *selectedTeamArr;
    NSString *selectedTeamStr;
    NSString *selectedTeamsStr;
    NSIndexPath *mIndexPath;
    
}
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

static NSString *simpleCoachTableIdentifier = @"CoachListCell";

@implementation CoachListController

- (void)viewDidLoad {
    [super viewDidLoad];
    teamArr = [[NSMutableArray alloc] init];
    selectedTeamArr = [[NSMutableArray alloc] init];
    coachDictionary = [[NSMutableDictionary alloc] init];
    
    if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        [self.tableView registerNib:[UINib nibWithNibName:@"CoachListCell" bundle:nil] forCellReuseIdentifier:simpleCoachTableIdentifier];
    } else {
        [self.tableView registerNib:[UINib nibWithNibName:@"CoachListCell" bundle:nil] forCellReuseIdentifier:simpleCoachTableIdentifier];
    }
    
    UILongPressGestureRecognizer *longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
    longPressGr.minimumPressDuration = 0.5;
    longPressGr.delaysTouchesBegan = true;
    longPressGr.delegate = self;
    [self.tableView addGestureRecognizer:longPressGr];
    
    
    
}






- (void)fetchCoachesFromLocalDB {
    
    coachArr = [[NSArray alloc] init];
    
    [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
    
    
    NSString *query = [NSString stringWithFormat:@"SELECT contactName, coachID, teams FROM CoachesInfo WHERE PlayerID=%@ ORDER BY contactName asc",Global.playerIDFinal];
    coachArr = [SCSQLite selectRowSQL:query];

    NSLog(@"coachArray, %@", coachArr);
}

- (void)setupteams {
    
    [teamArr removeAllObjects];
    
    [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
    
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
    
    
    NSString *query = [NSString stringWithFormat:@"SELECT Team_Name,TeamID FROM TeamInfo WHERE TeamID %@ order by Team_Name asc", strWhere];
    NSArray *records = [SCSQLite selectRowSQL:query];
    
    cnt = (int)records.count;
    for (int i = 0; i < cnt; i++) {
        Team* tempTeam = [[Team alloc] init];
        tempTeam.Team_Name = [[records objectAtIndex:i] valueForKey:@"Team_Name"];
        tempTeam.TeamID = (int)[[[records objectAtIndex:i] valueForKey:@"TeamID"] intValue];
        [teamArr addObject:tempTeam];
        
        NSLog(@"test coachteams---%d, %@, %d", i,tempTeam.Team_Name, tempTeam.TeamID);
        
    }

}

- (void) handleLongPress:(UILongPressGestureRecognizer *)longPressGesture {
    
    NSLog(@"pressed longpress");
    
//    if (longPressGesture.state != UIGestureRecognizerStateEnded) {
//        return;
//    }
//    
//    CGPoint point = [longPressGesture locationInView:self.tableView];
//    mIndexPath = [self.tableView indexPathForRowAtPoint:point];
//    
//    if (mIndexPath == nil) {
//        NSLog(@"Long press on table view but not on a row");
//    } else {
//        NSLog(@"rowid, %ld", mIndexPath.row);
//        [self handleAssignTeams];
//    }
    
}

- (void)handleAssignTeams {
    
    if (teamArr.count == 0) {
        [Alert showAlert:@"Have no team." message:@"" viewController:self];
        return;
    }
    
    SHMultipleSelect *multipleSelect = [[SHMultipleSelect alloc] init];
    multipleSelect.delegate = self;
    multipleSelect.rowsCount = teamArr.count;
    [multipleSelect show];
}

- (void)multipleSelectView:(SHMultipleSelect*)multipleSelectView clickedBtnAtIndex:(NSInteger)clickedBtnIndex withSelectedIndexPaths:(NSArray *)selectedIndexPaths {
    if (clickedBtnIndex == 1) { // Done btn
        
        [selectedTeamArr removeAllObjects];
        for (NSIndexPath *indexPath in selectedIndexPaths) {
            
            Team *tempTeam = [[Team alloc] init];
            tempTeam = [teamArr objectAtIndex:indexPath.row];
            
            [selectedTeamArr addObject:tempTeam.Team_Name];
        }
        NSLog(@"%@", selectedTeamArr);
        selectedTeamStr = [selectedTeamArr componentsJoinedByString:@","];
        selectedTeamsStr = selectedTeamStr;
        NSLog(@"selected teams, %@", selectedTeamsStr);
        
        [self handleAssignTeams:selectedTeamStr indexPath: mIndexPath];
        
        
    }
}

- (NSString*)multipleSelectView:(SHMultipleSelect*)multipleSelectView titleForRowAtIndexPath:(NSIndexPath*)indexPath {
    Team *tempTeam = [[Team alloc] init];
    tempTeam = [teamArr objectAtIndex:indexPath.row];
    return tempTeam.Team_Name;
}

- (BOOL)multipleSelectView:(SHMultipleSelect*)multipleSelectView setSelectedForRowAtIndexPath:(NSIndexPath*)indexPath {
    
    Team *tempTeam = [[Team alloc] init];
    tempTeam = [teamArr objectAtIndex:indexPath.row];
    NSString *str = tempTeam.Team_Name;
    
    NSString *teamIdString = coachArr[mIndexPath.row][@"teams"];
    NSString *teamNameString = [self returnTeamsNameWithTeamsIdString:teamIdString action:0];
    
    NSArray *arrayOfStrings = [teamNameString componentsSeparatedByString:@","];
    
    for (NSString *temp in arrayOfStrings) {
        if ([temp.lowercaseString isEqualToString:str.lowercaseString]) {
            return true;
        }
    }
    return false;
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self setupteams];
    [self fetchCoachesFromLocalDB];
    [self.tableView reloadData];
    
    [self addMenuBarButtomItem];
    [self setiPhoneAndiPadUI];
}

- (void)setiPhoneAndiPadUI {
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        
        cellHeight = 40;
        
    } else {
        
        cellHeight = 76;
        
    }
    
}

- (IBAction)didTapAdd:(id)sender {
    
    EditCoachController *editCoachController = [self.storyboard instantiateViewControllerWithIdentifier:@"EditCoachController"];
    editCoachController.navigationCoachState = CoachState_Add;
    [self.navigationController pushViewController:editCoachController animated:true];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return coachArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return cellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CoachListCell *cell = (CoachListCell *)[tableView dequeueReusableCellWithIdentifier:simpleCoachTableIdentifier forIndexPath:indexPath];

    
    cell.coachName.text = coachArr[indexPath.row][@"contactName"] ;
    
    NSString *teamIdString = coachArr[indexPath.row][@"teams"];
    
    cell.teamsLabel.text = [self returnTeamsNameWithTeamsIdString:teamIdString action:0];
    
    cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"Delete" backgroundColor:[UIColor redColor
                                                                                    ]], [MGSwipeButton buttonWithTitle:@"Assign" backgroundColor:[UIColor lightGrayColor]]];
    cell.tag = indexPath.row;
    cell.delegate = self;
    
    
    return cell;
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    EditCoachController *editCoachController = [self.storyboard instantiateViewControllerWithIdentifier:@"EditCoachController"];
    editCoachController.navigationCoachState = CoachState_Edit;
    editCoachController->coachID = (int)[coachArr[indexPath.row][@"coachID"] integerValue];
    [self.navigationController pushViewController:editCoachController animated:true];
    
}

- (BOOL)swipeTableCell:(MGSwipeTableCell *)cell tappedButtonAtIndex:(NSInteger)index direction:(MGSwipeDirection)direction fromExpansion:(BOOL)fromExpansion {
    
    NSIndexPath *indexPath  = [NSIndexPath indexPathForRow:cell.tag inSection:0];
    
    if (index == 0) {
        [self deleteCategory:indexPath.row];
    } else {
        mIndexPath = indexPath;
        [self handleAssignTeams];
    }
    
    return true;
}


//-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
//    return true;
//}
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    if (Global.mode == USER_MODE_CLUB) {
//        if (editingStyle == UITableViewCellEditingStyleDelete) {
//            
//            [self deleteCategory:indexPath.row];
//        }
//        
//    } else {
//        [Alert showAlert:@"Forbidden!" message:@"You can't delete Coach" viewController:self];
//    }
//}

- (NSString *)returnTeamsNameWithTeamsIdString:(NSString *)teamsIdString action:(int)action{
    NSString *teamsName;
    
    NSArray * arrayOfStrings = [teamsIdString componentsSeparatedByString:@","];
    NSMutableArray *teamsArr = [[NSMutableArray alloc] init];
    
    for (int i = 0; i < arrayOfStrings.count ; i++) {
        
        NSString *teamId = arrayOfStrings[i];
        
        for (int j = 0 ; j < teamArr.count ; j++) {
            
            Team *tempTeam = [[Team alloc] init];
            tempTeam = [teamArr objectAtIndex:j];
            if (action == 0) {
                if ([teamId isEqualToString:String(tempTeam.TeamID)]) {
                    
                    [teamsArr addObject:tempTeam.Team_Name];
                    
                }
            } else {
                if ([teamId isEqualToString:tempTeam.Team_Name]) {
                    [teamsArr addObject:String(tempTeam.TeamID)];
                }
            }
            
            
        }
    }
    
    teamsName = [teamsArr componentsJoinedByString:@","];
    
    return teamsName;
}



- (void) handleAssignTeams:(NSString *)teamsString indexPath:(NSIndexPath *) indexPath {
    
    int coachId = (int)[coachArr[indexPath.row][@"coachID"] integerValue];
    NSString *action = @"ASSIGN_TEAMS";
    
    [coachDictionary setValue:[self returnTeamsNameWithTeamsIdString:teamsString action:1] forKey:@"teams"];
    
    NSDictionary* params = @{@"action": action,
                             @"coachID": String(coachId),
                             @"teams": [self returnTeamsNameWithTeamsIdString:teamsString action:1]
                             };
    
    [API executeHTTPRequest:Post url:syncToServerServiceURLManageCoach parameters:params CompletionHandler:^(NSDictionary *responseDict) {
        [ProgressHudHelper hideLoadingHud];
        [self parseResponseForAssignTeams:responseDict params:params coachId:coachId];
    } ErrorHandler:^(NSString *errorStr) {
        
        NSLog(@"errorStr ---%@", errorStr);
        [ProgressHudHelper hideLoadingHud];
        [Alert showAlert:@"Something went wrong" message:nil viewController:self];
    }];
    
}

- (void) parseResponseForAssignTeams: (NSDictionary *)dic params:(NSDictionary *)paramsDic coachId:(int)coachId {
    
    NSString *successResult = [dic valueForKey:@"status"];
    
    NSLog(@"success or fail if recieve data from server-----%@", successResult);
    
    if ([successResult isEqualToString:@"Successs"]) {
        
        NSDictionary *whereDic = @{@"PlayerID": Global.playerIDFinal, @"coachID": String(coachId)};
        
        BOOL success = [SQLiteHelper updateInTable:@"CoachesInfo" params:coachDictionary where:whereDic];
        
        if (success) {
            
            [Alert showAlert:@"Teams successfully Assigned" message:nil viewController:self complete:^{
                
                [self fetchCoachesFromLocalDB];
                [self.tableView reloadData];
                
            }];
        } else {
            [Alert showAlert:@"Error" message:@"Failed to Assign Team in local" viewController:self];
        }
    } else {
        
        [Alert showAlert:@"Failed to Delete Coach" message:nil viewController:self];
        return;
    }

    
}

- (void) deleteCategory:(NSInteger)coachIndex {
    int coachId = (int)[coachArr[coachIndex][@"coachID"] integerValue];
    NSString *action = @"DELETE_COACH";
    
    NSDictionary* params = @{@"action": action,
                             @"coachID": String(coachId)
                             };
    
    [API executeHTTPRequest:Post url:syncToServerServiceURLManageCoach parameters:params CompletionHandler:^(NSDictionary *responseDict) {
        [ProgressHudHelper hideLoadingHud];
        [self parseResponse:responseDict params:params coachId:coachId];
    } ErrorHandler:^(NSString *errorStr) {
        
        NSLog(@"errorStr ---%@", errorStr);
        [ProgressHudHelper hideLoadingHud];
        [Alert showAlert:@"Something went wrong" message:nil viewController:self];
    }];
    
}

- (void) parseResponse: (NSDictionary *)dic params:(NSDictionary *)paramsDic coachId:(int)coachId {
    
    NSString *successResult = [dic valueForKey:@"status"];
    
    NSLog(@"success or fail if recieve data from server-----%@", successResult);
    
    if ([successResult isEqualToString:@"Successs"]) {
        
        NSDictionary *whereDic = @{@"PlayerID": Global.playerIDFinal, @"CoachID": String(coachId)};
        
        BOOL success = [SQLiteHelper deleteInTable:@"CoachesInfo" where:whereDic];
        
        if (success) {
            
            [Alert showAlert:@"Coach successfully deleted" message:nil viewController:self complete:^{
                
                [self fetchCoachesFromLocalDB];
                [self.tableView reloadData];
                
            }];
        } else {
            [Alert showAlert:@"Error" message:@"Failed to delete Coach in local" viewController:self];
        }
    } else {
        
        [Alert showAlert:@"Failed to Delete Coach" message:nil viewController:self];
        return;
    }
}



- (void)addMenuBarButtomItem {
    NSString *teamName = Global.currntTeam.Team_Name;
    
    self.navigationItem.title = [NSString stringWithFormat:@"%@-%@", teamName, @"Coach"];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Add Coach" style:UIBarButtonItemStylePlain target:self action:@selector(didTapAdd:)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    if (Global.mode == USER_MODE_INDIVIDUAL || Global.mode == USER_MODE_PLAYER || Global.mode == USER_MODE_COACH) {
        self.navigationItem.leftBarButtonItem = nil;
    }
    
}

@end
