//
//  CategoryViewController.m
//  Cauldron
//
//  Created by John Nik on 5/15/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "CategoryViewController.h"
#import "EditCategoryViewController.h"

static NSString *SectionHeaderViewIdentifier = @"ChallengeHeader";

static NSString *simpleTableIdentifier = @"LeftMenuTableViewCell";

@interface CategoryViewController ()<UITableViewDelegate, UITableViewDataSource, MGSwipeTableCellDelegate, AddCategoryVCDelegate>{
    UIBarButtonItem * addButton;
}

@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
   
//    self.navigationItem.title = @"Category";
    
    if (Global.currntTeam.TeamID != Global.masterTeamId) {
//        addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonClick)];
//        [self.navigationItem setRightBarButtonItem:addButton];
        
        self.navigationItem.rightBarButtonItem = nil;
        
    }
    
    
    
//    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(goingBack)];
//    [self.navigationItem setLeftBarButtonItem:leftButton];
    
    
    // Register TableView Header
    UINib *sectionHeaderNib = [UINib nibWithNibName:@"ChallengeHeader" bundle:nil];
    [self.tableview registerNib:sectionHeaderNib forHeaderFooterViewReuseIdentifier:SectionHeaderViewIdentifier];
    
//    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self fetchCategoryInfoFromDb];
    
}

- (void)goingBack {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated{
}

- (void)didDisappear {
    [self fetchCategoryInfoFromDb];
}

- (void)fetchCategoryInfoFromDb {
    
    [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM TeamInfo WHERE admin_name='%@' AND admin_pw='%@'",[[NSUserDefaults standardUserDefaults] stringForKey:@"SAVEDUSERID"],[[NSUserDefaults standardUserDefaults] stringForKey:@"SAVEDUSERPASS"]];
    NSArray *recordsFound = [SCSQLite selectRowSQL:query];
    NSLog(@"Found Record Details : %@",recordsFound);
    
    int userLevel;
    
    if (recordsFound.count > 0) {
        userLevel = (int)[[[recordsFound objectAtIndex:0]valueForKey:@"userLevel"]integerValue];
    }
    
    if (recordsFound.count > 0 && userLevel != 0 ) {
        self.userTeamID = Global.currntTeam.TeamID;
    } else {
//        [Alert showAlert:@"No Data" message:@"You Don't have any data in Local Storage" viewController:self];
    }
    
    query = [NSString stringWithFormat:@"SELECT * FROM ChallengeCategory WHERE TeamID=%d ORDER BY catOrder",Global.currntTeam.TeamID];
    chalCatArray = [SCSQLite selectRowSQL:query];
    
    NSLog(@"chalCatArray---%@", chalCatArray);
    
    if ([chalCatArray count] == 0) {
        return;
    }

    [self.tableview reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


///Add Category
-(void)addButtonClick{
    EditCategoryViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EditCategoryVC"];
    NSString *teamName = Global.currntTeam.Team_Name;
    viewController.navigationItem.title = [NSString stringWithFormat:@"%@-%@", teamName, @"ADd Category"];
    viewController->str_categoryName = @"";
    viewController->str_shortName = @"";
    viewController->str_order = 0;
    viewController->catId = 0;
    viewController.navigationCategoryStatus = CategoryState_Add;
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (IBAction)didTapAddButton:(UIBarButtonItem *)sender {
    
    EditCategoryViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EditCategoryVC"];
    viewController.navigationItem.title = @"Add Category";
    viewController->str_categoryName = @"";
    viewController->str_shortName = @"";
    viewController->str_order = 0;
    viewController->catId = 0;
    viewController.navigationCategoryStatus = CategoryState_Add;
    viewController.delegate = self;
    [self.navigationController pushViewController:viewController animated:YES];

    
}


/// Tableview delegate
- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return chalCatArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    cell.textLabel.text = chalCatArray[indexPath.row][@"CategoryName"];
    /////
    ////   Shortname and category order
    /////
    /////
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    // edit the category
    
    [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
    EditCategoryViewController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"EditCategoryVC"];
    NSString *teamName = Global.currntTeam.Team_Name;
    viewController.navigationItem.title = [NSString stringWithFormat:@"%@-%@", teamName, @"Edit Categlory"];
    
    viewController->str_categoryName = chalCatArray[indexPath.row][@"CategoryName"];
    viewController->str_shortName = chalCatArray[indexPath.row][@"ShortName"] == nil ? @"" : chalCatArray[indexPath.row][@"ShortName"];
    viewController->str_order = chalCatArray[indexPath.row][@"CatOrder"] == nil ? 0 : (int)[chalCatArray[indexPath.row][@"CatOrder"] intValue];
    viewController->catId = chalCatArray[indexPath.row][@"CatID"] == nil ? 0 : (int)[chalCatArray[indexPath.row][@"CatID"] intValue];
    viewController.delegate = self;
    
    NSLog(@"viewController->str_categoryName----%@", viewController->str_categoryName);
    NSLog(@"viewController->str_shortName----%@", viewController->str_shortName);
    NSLog(@"viewController->str_order----%d", viewController->str_order);
    
    viewController.navigationCategoryStatus = CategoryState_Edit;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return true;
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (Global.currntTeam.TeamID == Global.masterTeamId) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            
            [self deleteCategory:indexPath.row];
            
            
            
            //    [self.dataArray removeObjectAtIndex:indexPath.row];
            //    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
            //                         withRowAnimation:UITableViewRowAnimationFade];
            //        [self.tableview reloadData]; // tell table to refresh now
        }

    } else {
        [Alert showAlert:@"Forbidden!" message:@"You can't delete Category" viewController:self];
    }
}

- (void) deleteCategory:(NSInteger)categoryIndex {
    int catId = (int)[chalCatArray[categoryIndex][@"CatID"] integerValue];
    NSString *action = @"DELETE_CATEGORY";
    
    NSDictionary* params = @{@"action": action,
                             @"CatID": String(catId),
                             @"TeamID": String(Global.currntTeam.TeamID)
                             };
    
    [API executeHTTPRequest:Post url:syncToServerServiceURLManageChallenge parameters:params CompletionHandler:^(NSDictionary *responseDict) {
        [ProgressHudHelper hideLoadingHud];
        [self parseResponse:responseDict params:params categoryId:catId];
    } ErrorHandler:^(NSString *errorStr) {
        
        NSLog(@"errorStr ---%@", errorStr);
        [ProgressHudHelper hideLoadingHud];
        [Alert showAlert:@"Something went wrong" message:nil viewController:self];
    }];

}

- (void) parseResponse: (NSDictionary *)dic params:(NSDictionary *)paramsDic categoryId:(int)catId {

    NSString *successResult = [dic valueForKey:@"status"];

    NSLog(@"success or fail if recieve data from server-----%@", successResult);
         
    if ([successResult isEqualToString:@"Success"]) {
        
        NSDictionary *whereDic = @{@"TeamID": String(Global.currentTeamId), @"CatID": String(catId)};
        
        BOOL success = [SQLiteHelper deleteInTable:@"ChallengeCategory" where:whereDic];
        
        if (success) {
            
            [Alert showAlert:@"Category successfully deleted" message:nil viewController:self complete:^{
                
                [self fetchCategoryInfoFromDb];
                
            }];
        } else {
            [Alert showAlert:@"Error" message:@"Failed to delete Category in local" viewController:self];
        }
    } else {
        
        [Alert showAlert:@"Failed to Delete Category" message:nil viewController:self];
        return;
    }
}



@end
