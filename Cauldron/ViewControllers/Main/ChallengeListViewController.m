//
//  ChallengeListViewController.m
//  Cauldron
//
//  Created by John Nik on 4/12/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "ChallengeListViewController.h"
#import "EditChaListTabViewController.h"

static NSString *SectionHeaderViewIdentifier = @"ChallengeHeader";

@interface ChallengeListViewController ()<UITableViewDelegate, UITableViewDataSource, AddChallengeVCDelegate>

{
    @public
    UIBarButtonItem *addButton;
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ChallengeListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavigationItems];
    
    // Register TableView Header
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"ChallengeHeader" bundle:nil];
    [self.tableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self fetchChallengeList];

}

- (void)didDisappear {
    [self fetchChallengeList];
    [self.tableView reloadData];
}

- (void)fetchChallengeList {
    [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM TeamInfo WHERE admin_name='%@' AND admin_pw='%@'",[[NSUserDefaults standardUserDefaults] stringForKey:@"SAVEDUSERID"],[[NSUserDefaults standardUserDefaults] stringForKey:@"SAVEDUSERPASS"]];
    NSArray *recordsFound = [SCSQLite selectRowSQL:query];
//    NSLog(@"Found Record Details : %@",recordsFound);
    
    int userLevel;
    
    if (recordsFound.count > 0) {
        userLevel = (int)[[[recordsFound objectAtIndex:0]valueForKey:@"userLevel"]integerValue];
    }
    
    if (recordsFound.count > 0 && userLevel != 0 ) {
        self.userTeamID = Global.currntTeam.TeamID;
    } else {
//        [Alert showAlert:@"No Data" message:@"You Don't have any data in Local Storage" viewController:self];
    }
    
    
    query = [NSString stringWithFormat:@"SELECT CatID, categoryname FROM ChallengeCategory WHERE TeamID=%d ORDER BY catOrder",Global.currntTeam.TeamID];
    chalCatArray = [SCSQLite selectRowSQL:query];
    
    if ([chalCatArray count] == 0) {
        //show no category view
        return;
    }
    
    allChallengesArray  = [[NSMutableArray alloc] init];
    challengesArray     = [[NSMutableArray alloc] init];
    secIndexArray       = [[NSMutableArray alloc] init];
    
    NSString *selectQuery;
    for(int i = 0; i < [chalCatArray count]; i++) {
        NSString *secStr = [NSString stringWithFormat:@"%d",i];
        [secIndexArray addObject:secStr];
        Global.currendCategoryArr = chalCatArray;
        
        int categID = (int)[[[chalCatArray objectAtIndex:i]valueForKey:@"CatID"]integerValue];
        
        
        selectQuery = [NSString stringWithFormat:@"SELECT * FROM Challanges WHERE TeamID=%d AND Challenge_Category=%d ORDER BY Challenge_Category,Challenge_Menu",Global.currntTeam.TeamID,categID];
        
        ChallengesList   = [SCSQLite selectRowSQL:selectQuery];
        NSString *strNum = [NSString stringWithFormat:@"%d",(int)ChallengesList.count];
        [allChallengesArray addObject:strNum];
        [challengesArray addObject:ChallengesList];
    }
    NSLog(@"challengesArray ======>>>>> %@", challengesArray);
}

- (void)setupNavigationItems {
    
    NSString *teamName = Global.currntTeam.Team_Name;
    self.navigationItem.title = [NSString stringWithFormat:@"%@-%@", teamName, @"Challenges"];
    
    if (Global.currntTeam.TeamID == Global.masterTeamId) {
        addButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonClick)];
        [self.navigationItem setRightBarButtonItem:addButton];

    }
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(goingBack)];
//    [self.navigationItem setLeftBarButtonItem:leftButton];
}

- (void)goingBack {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)addButtonClick {
    EditChaListTabViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EditChaListTVC"];
    viewController.navigationItem.title = @"Add Challenge";
    NSString *teamName = Global.currntTeam.Team_Name;
    viewController.navigationItem.title = [NSString stringWithFormat:@"%@-%@", teamName, @"Add Challenge"];
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:true];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableViewDelegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return [chalCatArray count];
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    int rows = [allChallengesArray[section] intValue];
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"CommonTableViewCell";
    CommonTableViewCell *cell = (CommonTableViewCell *)[_tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        NSArray *nib= [[NSBundle mainBundle] loadNibNamed:@"CommonTableViewCell" owner:self options:nil];;
        cell = [nib objectAtIndex:0];
    }
    
    int mySection = (int)[[secIndexArray objectAtIndex:indexPath.section] integerValue];
    
    if (indexPath.section == mySection) {
        cell.titleLbl.text = [[[challengesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]valueForKey:@"Challenge_Menu"];
    }
    
    return cell;
}

- (UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    ChallengeHeader *header = (ChallengeHeader *)[self.tableView dequeueReusableHeaderFooterViewWithIdentifier:SectionHeaderViewIdentifier];
    header.titleLbl.text = chalCatArray[section][@"CategoryName"];
    
    return header;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (Global.currntTeam.TeamID == Global.masterTeamId) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        EditChaListTabViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EditChaListTVC"];
        NSString *teamName = Global.currntTeam.Team_Name;
        viewController.navigationItem.title = [NSString stringWithFormat:@"%@-%@", teamName, @"Edit Challenge"];
        
        if (indexPath.section == 0) {
            viewController.navigationFitnessStatus = ChallengeFitnessState_IS;
        } else {
            viewController.navigationFitnessStatus = ChallengeFitnessState_NOT;
        }
        viewController.navigationChallengeStatus = ChallengeListState_Edit;
        
        NSMutableDictionary *challenge = challengesArray[indexPath.section][indexPath.row];
        Global.currentChallenge = challenge;
        
        viewController.selectedCategory = chalCatArray[indexPath.section][@"CategoryName"];
        viewController.delegate = self;
        NSLog(@"first challenge list, %@", Global.currentChallenge);
        
        [self.navigationController pushViewController:viewController animated:true];
        
    } else {
        [Alert showAlert:@"" message:@"You do not have permission.\nCan only be edited from Master Team account." viewController:self];
    }
    
    
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (Global.currntTeam.TeamID == Global.masterTeamId) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            
            
            [Alert showOKCancelAlert:@"Are you sure you want to delete?" message:@"" viewController:self complete:^{
                
                [self deleteChallenge:indexPath];
                
            } canceled:nil];
            
            
        }
        
    } else {
        
        [Alert showAlert:@"" message:@"You do not have permission.\nCan only be edited from Master Team account." viewController:self];
    }

    
    
}

- (void) deleteChallenge:(NSIndexPath *)challengeIndexPath {
    
    Challenge *deleteChallenge = challengesArray[challengeIndexPath.section][challengeIndexPath.row];
    
    
    NSString *action = @"DELETE_CHALLENGE";
    NSString *challengeName = [deleteChallenge valueForKey:@"Challenge_Menu"];
    int Id = (int)[[deleteChallenge valueForKey:@"ID"] integerValue];
    
    NSLog(@"delete challenge Name, %@, %d", challengeName, Id);
    
    NSDictionary* params = @{@"action": action,
                             @"ID": String(Id),
                             @"TeamID": String(Global.currntTeam.TeamID)
                             };
    
    [API executeHTTPRequest:Post url:syncToServerServiceURLManageChallenge parameters:params CompletionHandler:^(NSDictionary *responseDict) {
        [ProgressHudHelper hideLoadingHud];
        [self parseResponse:responseDict params:params challengeId:Id];
    } ErrorHandler:^(NSString *errorStr) {
        
        NSLog(@"errorStr ---%@", errorStr);
        [ProgressHudHelper hideLoadingHud];
        [Alert showAlert:@"Something went wrong" message:nil viewController:self];
    }];
    
}

- (void) parseResponse: (NSDictionary *)dic params:(NSDictionary *)paramsDic challengeId:(int)Id {
    
    NSString *successResult = [dic valueForKey:@"status"];
    
    NSLog(@"success or fail if recieve data from server-----%@", successResult);
    
    if ([successResult isEqualToString:@"Success"]) {
        
        NSDictionary *whereDic = @{@"TeamID": String(Global.currentTeamId), @"ID": String(Id)};
        
        BOOL success = [SQLiteHelper deleteInTable:@"Challanges" where:whereDic];
        
        if (success) {
            
            [Alert showAlert:@"Challange successfully deleted" message:nil viewController:self complete:^{
                
                [self fetchChallengeList];
                [self.tableView reloadData];
                
            }];
        } else {
            [Alert showAlert:@"Error" message:@"Failed to delete Challange in local" viewController:self];
        }
    } else {
        
        [Alert showAlert:@"Failed to Delete Challange" message:nil viewController:self];
        return;
    }
}






//- (void)fetchChallengeList:(Challenge *)challengeSubcategory {
//    NSLog(@"delegate test");
//}

#pragma mark - MGSwipeTableCellDelegate

//- (BOOL) swipeTableCell:(nonnull MGSwipeTableCell*) cell tappedButtonAtIndex:(NSInteger) index direction:(MGSwipeDirection)direction fromExpansion:(BOOL) fromExpansion {
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cell.tag inSection:0];
//    
//    ChallengeDetailVC *viewController = (ChallengeDetailVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"ChallengeDetailVC"];
//    viewController.challangeID = (int)[[[[challengesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]valueForKey:@"ID"]integerValue];
//    viewController.challangeTitle = [[[challengesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]valueForKey:@"Challenge_Menu"];
//    viewController.challengeDetails = [[[challengesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]valueForKey:@"Challenge_Desc"];
//    viewController.challengeType = [[[challengesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]valueForKey:@"Challenge_Type"];
//    viewController.isDecimal=[[[challengesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]valueForKey:@"isDecimal"];
//    viewController.challengeTeamID = self.userTeamID;
//    viewController.soportsID = self.soportsID;
//    
//    [self.navigationController pushViewController:viewController animated:YES];
//    
//    return true;
//}

#pragma mark - IBActions
//
//- (IBAction)didTapFinalRanking:(id)sender {
//    [self performSegueWithIdentifier:@"showFinalRankingReport" sender:nil];
//}
//
//#pragma mark - Navigation
//
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    if ([segue.identifier isEqualToString:@"showFinalRankingReport"]) {
//        
//    }
//}

@end
