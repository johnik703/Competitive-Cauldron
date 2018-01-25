//
//  ReportVC.m
//  Cauldron
//
//  Created by John Nik on 5/15/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "ReportVC.h"

@interface ReportVC () <IQDropDownTextFieldDelegate>
{
    NSArray *arrAttandaceReport;
}
@end


@implementation ReportVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationItems];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//    [self hideNavigationBarShawdow];
    
    _fromDDTF.dropDownMode = IQDropDownModeDatePicker;
    _fromDDTF.dateFormatter = [NSDateFormatter formatterFromFormatString:@"MM-dd-yyyy"];
    _fromDDTF.date = [Global.currntTeam.SeasonStart dateWithFormat:@"MM-dd-yyyy"];
    _fromDDTF.delegate = self;
    _toDDTF.dropDownMode = IQDropDownModeDatePicker;
    _toDDTF.dateFormatter = [NSDateFormatter formatterFromFormatString:@"MM-dd-yyyy"];
    _toDDTF.date = [Global.currntTeam.SeasonEnd dateWithFormat:@"MM-dd-yyyy"];
    _toDDTF.delegate = self;
    [self getAttendaceReportData];
}

- (void)setupNavigationItems {
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    NSString *teamName = Global.currntTeam.Team_Name;
    self.navigationItem.title = [NSString stringWithFormat:@"%@-%@", teamName, @"Reports"];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrAttandaceReport count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *simpleTableIdentifier = @"AttandanceReportTableViewCell";
    AttandanceReportTableViewCell *cell = (AttandanceReportTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"AttandanceReportTableViewCell" owner:self options:nil] objectAtIndex:0];
    }
    
    cell.lblPlayerNmae.text=[[arrAttandaceReport objectAtIndex:indexPath.row] valueForKey:@"name"];
    cell.lblTrainingDays.text=[[arrAttandaceReport objectAtIndex:indexPath.row] valueForKey:@"attended_days"];
    cell.lblTotalDays.text=[[arrAttandaceReport objectAtIndex:indexPath.row] valueForKey:@"total_training_days"];
    cell.lblPercentage.text=[[arrAttandaceReport objectAtIndex:indexPath.row] valueForKey:@"attended_days_perc"];

    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

#pragma mark - Private Methods

- (NSArray *)getDataFromServer:(NSString *)urlString {
    NSError *error;
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    // Call the web service, and (if it's successful) store the raw data that it returns
    NSData *data = [ NSURLConnection sendSynchronousRequest:request returningResponse: nil error:&error ];
    
    if (!data) {
        NSLog(@"Download Error: %@", error.localizedDescription);
        return nil;
    }
    
    // Parse the (binary) JSON data from the web service into an NSDictionary object
    NSArray *dictionary = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    return dictionary;
}

- (void)getAttendaceReportData {
    
    NSString *userLevel = [[NSUserDefaults standardUserDefaults] stringForKey:@"USERLEVEL"];
    
    NSString *startDateStr = [self.fromDDTF.date stringWithFormat:@"MM-dd-yyyy"];
    NSString *toDateStr = [self.toDDTF.date stringWithFormat:@"MM-dd-yyyy"];
    
    if ([userLevel isEqualToString:@"3"]) {
        arrAttandaceReport = [self getDataFromServer:[NSString stringWithFormat:attendanceReportPlayer, Global.currntTeam.TeamID, startDateStr, toDateStr, Global.playerIDFinal]];
    } else {
        arrAttandaceReport=[self getDataFromServer:[NSString stringWithFormat:attendanceReportTeam, Global.currntTeam.TeamID, startDateStr, toDateStr]];
    }
    
    NSLog(@"dic %@",arrAttandaceReport);
    

    [self.tableView reloadData];
}

#pragma mark - IQDropDownTextFieldDelegate

- (void)textField:(nonnull IQDropDownTextField*)textField didSelectDate:(nullable NSDate*)date {
    [self getAttendaceReportData];
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
