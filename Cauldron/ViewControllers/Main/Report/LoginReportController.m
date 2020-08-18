//
//  LoginReportController.m
//  Cauldron
//
//  Created by John Nik on 09/03/2018.
//  Copyright © 2018 Logic express. All rights reserved.
//

#import "LoginReportController.h"
#import "LoginReportCell.h"
#import "LoginReportUser.h"
#import "LoginReportHeader.h"
@import SVProgressHUD;

@interface LoginReportController ()

@end

static NSString *loginReportCellId = @"loginReportCellId";
static NSString *loginReportHearderId = @"loginReportHearderId";

@implementation LoginReportController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    
    [self fetchData];
}


#pragma fetch data
- (void)fetchData {
    
    BOOL activeConn = [RKCommon checkInternetConnection];
    
    if (activeConn == NO) {
        [Alert showAlert:@"Connection Error" message:@"No Active Connection Found" viewController:self];
        return;
    }
    
    loginReportUsers = [[NSMutableArray alloc] init];
    sortedLoginReportUsers = [[NSArray alloc] init];
    
    NSLog(@"teamId, %d, %d, %@", Global.currentTeamId, Global.mode, Global.playerIDFinal);
    
    NSDictionary* params = @{@"Mode": String(Global.mode),
                             @"TeamID": String(Global.currentTeamId),
                             @"PlayerID": Global.playerIDFinal};
    
    [SVProgressHUD show];
    
    [API executeHTTPRequest:Post url:getLoginReport parameters:params CompletionHandler:^(NSDictionary *responseDict) {
        [SVProgressHUD dismiss];
        [self parseResponse:responseDict params:params];
    } ErrorHandler:^(NSString *errorStr) {
        [SVProgressHUD dismiss];
        [Alert showAlert:@"Something went wrong" message:@"Try again later!" viewController:self];
    }];
}

- (void)parseResponse:(NSDictionary *)dic params:(NSDictionary *)paramsDic {
    
    NSLog(@"%@", dic);
    
    NSString *successReult = [dic valueForKey:@"status"];
    NSArray *users = [dic valueForKey:@"data"];
    
    if ([successReult isEqualToString:@"SUCCESS"]) {
        
        for (NSDictionary *userDictionary in users) {
            
            LoginReportUser *loginReportUser = [[LoginReportUser alloc] init];
            
            NSString *firstname = [userDictionary valueForKey:@"First_Name"];
            NSString *lastname = [userDictionary valueForKey:@"Last_Name"];
            NSString *username = [userDictionary valueForKey:@"admin_name"];
            NSString *playerName = [userDictionary valueForKey:@"contact_name"];
            NSString *password = [userDictionary valueForKey:@"password_text"];
            
            loginReportUser.firstName = firstname;
            loginReportUser.lastName = lastname;
            loginReportUser.username = username;
            loginReportUser.playerName = playerName;
            loginReportUser.password = password;
            
            [loginReportUsers addObject:loginReportUser];
            
        }
        
        sortedLoginReportUsers = [loginReportUsers sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            NSString *first = [(LoginReportUser *) obj1 playerName];
            NSString *second = [(LoginReportUser *) obj2 playerName];
            return [first compare:second];
        }];
        
        [self.tableView reloadData];
        
    } else {
        [Alert showAlert:@"Something went wrong." message:@"Try again later!" viewController:self];
    }
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return sortedLoginReportUsers.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LoginReportCell *cell = (LoginReportCell *)[tableView dequeueReusableCellWithIdentifier:loginReportCellId forIndexPath:indexPath];
    
    LoginReportUser *loginReportUser = [sortedLoginReportUsers objectAtIndex:[indexPath row]];
    
    cell.playerNameLabel.text = loginReportUser.playerName;
    cell.userNameLabel.text = loginReportUser.username;
    cell.passwordLabel.text = loginReportUser.password;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    LoginReportHeader *header = (LoginReportHeader *)[tableView dequeueReusableHeaderFooterViewWithIdentifier:loginReportHearderId];
    
    header.frame = CGRectMake(0, 0, self.view.frame.size.width, 50);
    
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}


- (void)setupViews {
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupNavigationBar];
    [self setupTableView];
}

- (void)setupTableView {
    
    [self.tableView registerClass:[LoginReportCell class] forCellReuseIdentifier:loginReportCellId];
    [self.tableView registerClass:[LoginReportHeader class] forHeaderFooterViewReuseIdentifier:loginReportHearderId];
}

- (void)setupNavigationBar {
    self.navigationItem.title = @"Login Report";
}

@end
