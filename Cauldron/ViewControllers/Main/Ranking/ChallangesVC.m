//
//  ChallangesVCViewController.m
//  Cauldron
//
//  Created by John Nik on 5/15/17.
//  Copyright © 2017 johnik703. All rights reserved.
//s

#import "ChallangesVC.h"

static NSString *SectionHeaderViewIdentifier = @"ChallengeHeader";

@interface ChallangesVC () <UITableViewDelegate, UITableViewDataSource, MGSwipeTableCellDelegate>
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rankingBarButtonItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ChallangesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationItems];
    
    // Register TableView Header
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"ChallengeHeader" bundle:nil];
    [self.tableView registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
    
    [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
    NSString *query = [NSString stringWithFormat:@"SELECT CatID, categoryname FROM ChallengeCategory WHERE TeamID=%d ORDER BY catOrder",Global.currntTeam.TeamID];
    chalCatArray = [SCSQLite selectRowSQL:query];
    
    if ([chalCatArray count] == 0) {
        //show no category view
        return;
    }
    
    allChallengesArray = [[NSMutableArray alloc]init];
    challengesArray = [[NSMutableArray alloc]init];
    secIndexArray = [[NSMutableArray alloc]init];
    
    /* NSString *selectQuery;
    for(int i = 0; i < [chalCatArray count]; i++) {
        NSString *secStr = [NSString stringWithFormat:@"%d",i];
        [secIndexArray addObject:secStr];
        
        int categID = (int)[[[chalCatArray objectAtIndex:i]valueForKey:@"CatID"]integerValue];
        selectQuery = [NSString stringWithFormat:@"SELECT ID, Challenge_Category, Challenge_Menu, Challenge_Desc, Challenge_Type,isDecimal FROM Challanges WHERE TeamID=%d AND Challenge_Category=%d ORDER BY Challenge_Category,Challenge_Menu",Global.currntTeam.TeamID,categID];
        
        ChallengesList = [SCSQLite selectRowSQL:selectQuery];
        NSString *strNum = [NSString stringWithFormat:@"%d",(int)ChallengesList.count];
        [allChallengesArray addObject:strNum];
        [challengesArray addObject:ChallengesList];
    } */

    
    if (_status == NavigationStateRanking) {
        NSString *selectQuery;
        for(int i = 0; i < [chalCatArray count]; i++) {
            NSString *secStr = [NSString stringWithFormat:@"%d",i];
            [secIndexArray addObject:secStr];
            
            int categID = (int)[[[chalCatArray objectAtIndex:i]valueForKey:@"CatID"]integerValue];
            selectQuery = [NSString stringWithFormat:@"SELECT a.ID, a.Challenge_Category, a.Challenge_Menu, a.Challenge_Desc, a.Challenge_Type,a.isDecimal, b.column_val FROM Challanges a INNER JOIN ChallangeStat b ON a.ID = b.ChallangeID AND a.TeamID = b.TeamID WHERE b.column_val!=' ' AND a.TeamID=%d AND a.Challenge_Category=%d GROUP BY a.ID ORDER BY Challenge_Category,Challenge_Menu",Global.currntTeam.TeamID,categID];
            
            ChallengesList = [SCSQLite selectRowSQL:selectQuery];
            NSString *strNum = [NSString stringWithFormat:@"%d",(int)ChallengesList.count];
            [allChallengesArray addObject:strNum];
            [challengesArray addObject:ChallengesList];
        }

        
    } else if (_status == NavigationStateChallenge) {
        NSString *selectQuery;
        for(int i = 0; i < [chalCatArray count]; i++) {
            NSString *secStr = [NSString stringWithFormat:@"%d",i];
            [secIndexArray addObject:secStr];
            
            int categID = (int)[[[chalCatArray objectAtIndex:i]valueForKey:@"CatID"]integerValue];
            selectQuery = [NSString stringWithFormat:@"SELECT ID, Challenge_Category, Challenge_Menu, Challenge_Desc, Challenge_Type,isDecimal FROM Challanges WHERE TeamID=%d AND Challenge_Category=%d ORDER BY Challenge_Category,Challenge_Menu",Global.currntTeam.TeamID,categID];
            
            ChallengesList = [SCSQLite selectRowSQL:selectQuery];
            NSString *strNum = [NSString stringWithFormat:@"%d",(int)ChallengesList.count];
            [allChallengesArray addObject:strNum];
            [challengesArray addObject:ChallengesList];
        }
        
    }

    
    
    NSLog(@"secIndexArray------%@", secIndexArray);
    NSLog(@"challengesArray----%@", challengesArray);
    NSLog(@"allChallengesArray-----%@", allChallengesArray);
    NSLog(@"ChallengesList-----%@", ChallengesList);
    
}

- (void)setupNavigationItems {
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    NSString *teamName = Global.currntTeam.Team_Name;
    
    if (_status == NavigationStateRanking) {
        self.title = [NSString stringWithFormat:@"%@-%@", teamName, @"Rankings"];
        [_rankingBarButtonItem hide];
        self.navigationItem.rightBarButtonItem = nil;
    } else if (_status == NavigationStateChallenge) {
        self.title = [NSString stringWithFormat:@"%@-%@", teamName, @"Add Stats"];
//        [_rankingBarButtonItem hide];
        self.navigationItem.rightBarButtonItem = nil;
    }
    
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
    
    cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"Detail" backgroundColor:[UIColor lightGrayColor]]];
    cell.tag = indexPath.row;
    cell.delegate = self;
    
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
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (_status == NavigationStateRanking) {
        
        BOOL activeConn = [RKCommon checkInternetConnection];
        
        if (activeConn == NO) {
            [Alert showAlert:@"Connection Error" message:@"No Active Connection Found" viewController:self];
        } else {
            RankingVC *viewController = (RankingVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"RankingVC"];
            viewController.dicRanking = challengesArray[indexPath.section][indexPath.row];
            viewController.navigationItem.title = [NSString stringWithFormat:@"%@-Ranking Details", [viewController.dicRanking objectForKey:@"Challenge_Menu"]];
            [self.navigationController pushViewController:viewController animated:true];
        }
        
        
    } else if (_status == NavigationStateChallenge) {
        ScoreViewController *viewController = (ScoreViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"ScoreViewController"];
        viewController.scChallengeID = (int)[[[[challengesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]valueForKey:@"ID"]integerValue];
        viewController.scChallengeName = [[[challengesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]valueForKey:@"Challenge_Menu"];
        viewController.scChallengeType = [[[challengesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]valueForKey:@"Challenge_Type"];
        viewController.isdecimal = [[[challengesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]valueForKey:@"isDecimal"];
        viewController.scTeamID = Global.currntTeam.TeamID;
        viewController.sportsID = self.soportsID;
        
        [self.navigationController pushViewController:viewController animated:true];
    }
}

#pragma mark - MGSwipeTableCellDelegate

- (BOOL) swipeTableCell:(nonnull MGSwipeTableCell*) cell tappedButtonAtIndex:(NSInteger) index direction:(MGSwipeDirection)direction fromExpansion:(BOOL) fromExpansion {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cell.tag inSection:0];
    
    ChallengeDetailVC *viewController = (ChallengeDetailVC *)[self.storyboard instantiateViewControllerWithIdentifier:@"ChallengeDetailVC"];
    viewController.challangeID = (int)[[[[challengesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]valueForKey:@"ID"]integerValue];
    viewController.challangeTitle = [[[challengesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]valueForKey:@"Challenge_Menu"];
    viewController.challengeDetails = [[[challengesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]valueForKey:@"Challenge_Desc"];
    viewController.challengeType = [[[challengesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]valueForKey:@"Challenge_Type"];
    viewController.isDecimal=[[[challengesArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]valueForKey:@"isDecimal"];
    viewController.challengeTeamID = Global.currntTeam.TeamID;
    viewController.soportsID = self.soportsID;
    
    [self.navigationController pushViewController:viewController animated:YES];

    return true;
}

#pragma mark - IBActions

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
