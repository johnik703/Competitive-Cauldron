//
//  RankingVC.m
//  Cauldron
//
//  Created by John Nik on 5/15/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "RankingVC.h"

@interface RankingVC () <UITableViewDelegate, UITableViewDataSource, IQDropDownTextFieldDelegate>
{
    NSArray *allRanking;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *fromDateDDTF;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *toDateDDTF;

@end

@implementation RankingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
    // Do any additional setup after loading the view.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.fromDateDDTF.dropDownMode = IQDropDownModeDatePicker;
    self.fromDateDDTF.dateFormatter = [NSDateFormatter formatterFromFormatString:@"MM-dd-yyyy"];
    self.fromDateDDTF.date = [Global.currntTeam.SeasonStart dateWithFormat:@"MM-dd-yyyy"];
    self.fromDateDDTF.delegate = self;
    self.toDateDDTF.dropDownMode = IQDropDownModeDatePicker;
    self.toDateDDTF.dateFormatter = [NSDateFormatter formatterFromFormatString:@"MM-dd-yyyy"];
    self.toDateDDTF.date = [Global.currntTeam.SeasonEnd dateWithFormat:@"MM-dd-yyyy"];
    self.toDateDDTF.delegate = self;
    
    NSString *emptyTableQuery = [NSString stringWithFormat:@"DELETE FROM RankingData"];
    BOOL success = [SCSQLite executeSQL:emptyTableQuery];
    
    if (success) {
        [self getRankingData];
    } else {
        [Alert showAlert:@"Ranking" message:@"Can't download data for ranking." viewController:self complete:nil];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)didTapSave:(id)sender {
}

#pragma mark - Private Methods
- (IBAction)didTapTodayButton:(id)sender {
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    
    NSString *startDateStr = [dateFormatter stringFromDate:[NSDate date]];
    NSString *endDateStr = [dateFormatter stringFromDate:[NSDate date]];
    
    self.fromDateDDTF.date = [startDateStr dateWithFormat:@"MM-dd-yyyy"];
    self.toDateDDTF.date = [endDateStr dateWithFormat:@"MM-dd-yyyy"];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *dictionary;
        NSString *userLevel = [[NSUserDefaults standardUserDefaults] stringForKey:@"USERLEVEL"];
        
        
        
        
        if ([userLevel isEqualToString:@"3"]) {
            NSString *url = [NSString stringWithFormat:rankingEntryPlayer,Global.currntTeam.TeamID, [self.dicRanking objectForKey:@"ID"], [Global.playerIDFinal intValue], startDateStr, endDateStr];
            dictionary = [JSONHelper loadJSONDataFromURL:url];
        } else {
            NSString *url = [NSString stringWithFormat:rankingEntryTeam, Global.currntTeam.TeamID, [self.dicRanking objectForKey:@"ID"], startDateStr, endDateStr];
            dictionary = [JSONHelper loadJSONDataFromURL:url];
        }
        
        allRanking = [DataFetcherHelper getAllRankingDataFromDict:dictionary];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });

    
}

- (void)getRankingData {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSDictionary *dictionary;
        NSString *userLevel = [[NSUserDefaults standardUserDefaults] stringForKey:@"USERLEVEL"];
        NSString *startDateStr = [self.fromDateDDTF.date stringWithFormat:@"MM-dd-yyyy"];
        NSString *endDateStr = [self.toDateDDTF.date stringWithFormat:@"MM-dd-yyyy"];
        
        

        
        if ([userLevel isEqualToString:@"3"]) {
            NSString *url = [NSString stringWithFormat:rankingEntryPlayer,Global.currntTeam.TeamID, [self.dicRanking objectForKey:@"ID"], [Global.playerIDFinal intValue], startDateStr, endDateStr];
            dictionary = [JSONHelper loadJSONDataFromURL:url];
        } else {
            NSString *url = [NSString stringWithFormat:rankingEntryTeam, Global.currntTeam.TeamID, [self.dicRanking objectForKey:@"ID"], startDateStr, endDateStr];
            dictionary = [JSONHelper loadJSONDataFromURL:url];
        }
        
        allRanking = [DataFetcherHelper getAllRankingDataFromDict:dictionary];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
}


#pragma mark - UITableViewDelegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return allRanking.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *simpleTableIdentifier = @"RankingCell";
    RankingCell *cell = (RankingCell *)[_tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil) {
        NSArray *nib= [[NSBundle mainBundle] loadNibNamed:@"RankingCell" owner:self options:nil];;
        cell = [nib objectAtIndex:0];
    }
    
    Ranking *dic = [allRanking objectAtIndex: indexPath.row];
    cell.lblName.text=dic.playerName;
    cell.lblAverage.text= dic.avg1;
    cell.lblRank.text=[NSString stringWithFormat:@"%d",dic.rank];
    
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

#pragma mark - IQDropDownTextFieldDelegate

- (void)textField:(nonnull IQDropDownTextField*)textField didSelectDate:(nullable NSDate*)date {
    [self getRankingData];
}

@end
