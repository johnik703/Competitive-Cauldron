//
//  ReportsController.m
//  Cauldron
//
//  Created by John Nik on 5/18/17.
//  Copyright © 2017 johnik703. All rights reserved.
//
#import "ReportsController.h"
#import "ReportVC.h"
#import "PassFailFitnessReportController.h"
#import "LoginReportController.h"

@interface ReportsController () {
    NSMutableArray *reportTitleArr;
}

@end

@implementation ReportsController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self setupNavigationItems];
    [self setupReportTitles];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
}

- (void)setupNavigationItems {
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    NSString *teamName = Global.currntTeam.Team_Name;
    self.navigationItem.title = [NSString stringWithFormat:@"%@-%@", teamName, @"Reports"];
    
    
}

- (void) setupReportTitles {
    
    reportTitleArr = [[NSMutableArray alloc] initWithArray:@[@"Attendance Report"]];
    
    if (Global.currntTeam.rptFitness == 1) {
        [reportTitleArr addObject:@"Pass/Fail Fitness Report"];
    }
    
    if (Global.mode != USER_MODE_PLAYER) {
        [reportTitleArr addObject:@"Login Report"];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [reportTitleArr count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = reportTitleArr[indexPath.row];
    
    // Configure the cell...
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *item = reportTitleArr[indexPath.row];
    
    if ([item isEqualToString:@"Attendance Report"]) {
        
        ReportVC *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ReportVC"];
        [self.navigationController pushViewController:viewController animated:YES];
    } else if ([item isEqualToString:@"Pass/Fail Fitness Report"]) {
        
        PassFailFitnessReportController *viewController = [self.storyboard instantiateViewControllerWithIdentifier:@"PassFailFitnessReportController"];
        [self.navigationController pushViewController:viewController animated:YES];
        
    } else if ([item isEqualToString:@"Login Report"]) {
        
        LoginReportController *reportController = [[LoginReportController alloc] init];
        [self.navigationController pushViewController:reportController animated:true];
    }
    
}

@end
