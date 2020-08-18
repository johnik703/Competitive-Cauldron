//
//  LeftMenuViewController.m
//  Cauldron
//
//  Created by John Nik on 5/18/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "LeftMenuViewController.h"
#import "LoginViewController.h"
#import "CreateTeamViewController.h"
#import "Enums.h"

@interface LeftMenuViewController () <UITableViewDelegate, UITableViewDataSource> {
    NSArray *itemArr;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation LeftMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    NSLog(@"userlevel--->%@", Global.objSignUp.userlevel);
//    if ([Global.objSignUp.userlevel isEqualToString:@"1"] || [Global.objSignUp.userlevel isEqualToString:@"90"]) {
//        itemArr = @[@"Home", @"Edit Profile", @"Update Data", @"Synchronize", @"Logout"];
//    }
//    else if ([Global.objSignUp.userlevel isEqualToString:@"1"]) {
//        itemArr = @[@"Home", @"Edit Profile", @"Update Data", @"Synchronize", @"Logout"];
//    }
//    else {
//        itemArr = @[@"Home", @"Edit Profile", @"My Teams", @"Update Data", @"Synchronize", @"Logout"];
//    }
    
    if (Global.mode == USER_MODE_CLUB) {
        itemArr = @[@"Home", @"Edit Profile", @"My Teams", @"Update Data", @"Synchronize", @"Logout"];
    } else {
        itemArr = @[@"Home", @"Edit Profile", @"Update Data", @"Synchronize", @"Logout"];
    }
    
    NSLog(@"currentTeamInfo--->%@, %@, %@", Global.currntTeam.Team_Name, Global.currntTeam.contact_name, Global.currntTeam.Team_Picture);
    
    [self setupCurrentTeamInfo];

}

- (void)setupCurrentTeamInfo {
    self.teamLbl.text = Global.currntTeam.Team_Name;
    self.userNameLbl.text = Global.currntTeam.contact_name;
    
    //    self.avatarImgView.image = [UIImage imageWithData:[Global.objSignUp.base64Pic base64Data]];
    
    if (Global.currntTeam.Team_Picture) {
        self.avatarImgView.image = [UIImage imageWithData:[Global.currntTeam.Team_Picture base64Data]];
    } else {
        self.avatarImgView.image = [UIImage imageNamed:@"default_team_image.jpeg"];
    }
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
    return itemArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"LeftMenuTableViewCell";
    UITableViewCell *cell = (UITableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = itemArr[indexPath.row];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 44;
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *item = itemArr[indexPath.row];
    
    if ([item isEqualToString:@"Home"]) {
        [self performSegueWithIdentifier:@"showHome" sender:@"home"];
    } else if ([item isEqualToString:@"Edit Profile"]) {
        [self performSegueWithIdentifier:@"showProfile" sender:nil];
    } else if ([item isEqualToString:@"My Teams"]) {
        [self performSegueWithIdentifier:@"editTeam" sender:nil];
    } else if ([item isEqualToString:@"Update Data"]) {
        [self update];
    } else if ([item isEqualToString:@"Synchronize"]) {
        [self sync];
    } else if ([item isEqualToString:@"Logout"]) {
        [self logout];
    }
}

#pragma mark - Private Methods

- (void)sync {
    // Check more data available for sync
    [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM ChallangeStat WHERE Sync=%d",1];
    NSArray *teamPlayersStats = [SCSQLite selectRowSQL:query];
    
    
    NSString *queryAttandance = [NSString stringWithFormat:@"SELECT * FROM playerattendance WHERE sync=%d",1];
    NSArray *playersAttandace = [SCSQLite selectRowSQL:queryAttandance];
    
    NSString *queryJournal = [NSString stringWithFormat:@"SELECT * FROM JournalData WHERE sync=%d",1];
    NSArray *playersJournal = [SCSQLite selectRowSQL:queryJournal];
    
    NSString *queryPlayer = [NSString stringWithFormat:@"SELECT * FROM PlayersInfo WHERE Sync=%d",1];
    NSArray *playersData = [SCSQLite selectRowSQL:queryPlayer];
    
    if (teamPlayersStats.count > 0 || playersAttandace.count > 0 || playersJournal.count > 0 || playersData.count> 0) {
        NSString *message = @"Are You Sure Want To Sync All Data To Server, Require High Speed Internet Connection" ;
        [Alert showOKCancelAlert:@"Sync Data!" message:message viewController:self complete:^{
            [self performSegueWithIdentifier:@"showHome" sender:@"sync"];
        } canceled:^{
        }];
    } else {
        [Alert showAlert:@"No Data" message:@"There is no more data to sync." viewController:self];
    }
}

- (void) update {
    NSString *message = @"Are You Sure Want To Update All Data?, This May Take Few Minutes And Require High Speed Internet Connection";
    [Alert showOKCancelAlert:@"Update Data!" message:message viewController:self complete:^{
        [self performSegueWithIdentifier:@"showHome" sender:@"update"];
    } canceled:^{
    }];
}

- (void)logout {
    UINavigationController *nav = [self.storyboard instantiateInitialViewController];
    [UserDefaults removeObjectForKey:@"ISLOGIN"];
    [UserDefaults synchronize];
    ApplicationDelegate.window.rootViewController = nav;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:@"showProfile"]) {
        UINavigationController *navController = segue.destinationViewController;
        RegisterViewController *viewController = (RegisterViewController *) [navController childViewControllers].firstObject;
        viewController.navigationStatus = RegisterState_Update;
    } else if ([segue.identifier isEqualToString:@"editTeam"]) {
        
        UINavigationController *navController = segue.destinationViewController;
        CreateTeamViewController *createTeamController = (CreateTeamViewController *) [navController childViewControllers].firstObject;
        createTeamController.navigationCreateControllerStatus = CreateControllerState_Logedin;
        
    } else if ([segue.identifier isEqualToString:@"showHome"]) {
        UINavigationController* rearNavigationController = segue.destinationViewController;
        if ([rearNavigationController.topViewController isKindOfClass:[MainViewController class]]) {
            MainViewController* viewController = (MainViewController *)rearNavigationController.topViewController;
            viewController.selectedLeftMenuItem = (NSString *)sender;
        }
    }
}
@end
