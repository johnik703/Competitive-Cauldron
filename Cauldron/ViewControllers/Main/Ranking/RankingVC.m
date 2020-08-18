//
//  RankingVC.m
//  Cauldron
//
//  Created by John Nik on 5/15/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "RankingVC.h"
#import "ChartController.h"
@import Charts;
@import LetterAvatarKit;
@import Toast;

@interface RankingVC () <UITableViewDelegate, UITableViewDataSource, IQDropDownTextFieldDelegate, ChartViewDelegate, IChartAxisValueFormatter>
{
    NSString *startDateStr;
    NSString *endDateStr;
    NSArray *allRanking;
    CGRect startingFrame;
    UIView *blackBackgroundView;
    UILabel *startingLabel;
    
    NSMutableArray<NSString *> *months;
    NSMutableArray<NSNumber *> *averages;
}

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *fromDateDDTF;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *toDateDDTF;

@end

@implementation RankingVC
@synthesize chartView, rankingData, profileView;

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
    
    BOOL checkConnection = [RKCommon checkInternetConnection];
    if (!checkConnection) {
        [Alert showAlert:@"Internet Connection Error" message:@"" viewController:self];
        return;
    }
    
    [self getRankingData];
    
    [self showToastForNotice];
    
    rankingData = [[Ranking alloc] init];
    // get ranking with original method
    /*
    NSString *emptyTableQuery = [NSString stringWithFormat:@"DELETE FROM RankingData"];
    BOOL success = [SCSQLite executeSQL:emptyTableQuery];
    
    if (success) {
        [self getRankingData];
    } else {
        [Alert showAlert:@"Ranking" message:@"Can't download data for ranking." viewController:self complete:nil];
    }
    */
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [self.view hideToast];
}

- (void) showToastForNotice {
    
    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
    style.titleAlignment = NSTextAlignmentCenter;
    style.messageAlignment = NSTextAlignmentCenter;
    [self.view makeToast:@"Tap - To See Player's Graph."
                duration:10.0
                position:CSToastPositionBottom
                   style:style];
    [CSToastManager setSharedStyle:style];
    [CSToastManager setTapToDismissEnabled:YES];
    
    // toggle queueing behavior
    [CSToastManager setQueueEnabled:YES];
}

#pragma mark - IBActions

- (IBAction)didTapSave:(id)sender {
}

#pragma mark - Private Methods
- (IBAction)didTapTodayButton:(id)sender {
    
    BOOL checkConnection = [RKCommon checkInternetConnection];
    if (!checkConnection) {
        [Alert showAlert:@"Internet Connection Error" message:@"" viewController:self];
        return;
    }
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MM-dd-yyyy"];
    // or @"yyyy-MM-dd hh:mm:ss a" if you prefer the time with AM/PM
    NSLog(@"%@",[dateFormatter stringFromDate:[NSDate date]]);
    
    startDateStr = [dateFormatter stringFromDate:[NSDate date]];
    endDateStr = [dateFormatter stringFromDate:[NSDate date]];
    self.fromDateDDTF.date = [startDateStr dateWithFormat:@"MM-dd-yyyy"];
    self.toDateDDTF.date = [endDateStr dateWithFormat:@"MM-dd-yyyy"];
    
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
    
    [self.tableView reloadData];

    
}

- (void)getRankingData {
    NSDictionary *dictionary;
    NSString *userLevel = [[NSUserDefaults standardUserDefaults] stringForKey:@"USERLEVEL"];
    
    startDateStr = [self.fromDateDDTF.date stringWithFormat:@"MM-dd-yyyy"];
    endDateStr = [self.toDateDDTF.date stringWithFormat:@"MM-dd-yyyy"];
    if ([userLevel isEqualToString:@"3"]) {
        NSString *url = [NSString stringWithFormat:rankingEntryPlayer,Global.currntTeam.TeamID, [self.dicRanking objectForKey:@"ID"], [Global.playerIDFinal intValue], startDateStr, endDateStr];
        dictionary = [JSONHelper loadJSONDataFromURL:url];
    } else {
        NSString *url = [NSString stringWithFormat:rankingEntryTeam, Global.currntTeam.TeamID, [self.dicRanking objectForKey:@"ID"], startDateStr, endDateStr];
        dictionary = [JSONHelper loadJSONDataFromURL:url];
    }
    
    allRanking = [DataFetcherHelper getAllRankingDataFromDict:dictionary];
    [self.tableView reloadData];
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
    
//    Ranking *rankingData = [allRanking objectAtIndex: indexPath.row];
//
//    ChartController *chartController = [[ChartController alloc] init];
//    chartController.rankingData = rankingData;
//    [self.navigationController pushViewController:chartController animated:YES];
    
    [self.view hideToast];
    
    rankingData = [allRanking objectAtIndex: indexPath.row];
    RankingCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [self performZoominForStartingView:cell.lblAverage];
}

- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (void) performZoominForStartingView: (UILabel *) label {
    
    startingLabel = label;
    [startingLabel setHidden:YES];
    
    startingFrame = [startingLabel.superview convertRect:startingLabel.frame toView:nil];
    
    UIView *graphView = [[UIView alloc] initWithFrame:startingFrame];
    graphView.backgroundColor = [UIColor whiteColor];
    [graphView setUserInteractionEnabled:YES];
    
    
    [graphView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleZoomOut:)]];
    
    UIView *keyWindow = [[UIApplication sharedApplication] keyWindow];
    
    blackBackgroundView = [[UIView alloc] initWithFrame:keyWindow.frame];
    blackBackgroundView.backgroundColor = [UIColor blackColor];
    blackBackgroundView.alpha = 0;
    [keyWindow addSubview:blackBackgroundView];
    [keyWindow addSubview:graphView];
    
    
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        blackBackgroundView.alpha = 0.7;
        CGFloat width = keyWindow.frame.size.width * 0.9;
        CGFloat height = keyWindow.frame.size.width * 0.8;
        graphView.frame = CGRectMake(0, 0, width, height);
        
        graphView.center = keyWindow.center;
    } completion:^(BOOL finished) {
        [self setupChartData];
        [self setupProfileView:graphView];
        [self setupCharts:graphView];
    }];
}

- (void) handleZoomOut: (UITapGestureRecognizer *) tapGesture {
    
    UIView *zoomOutView = tapGesture.view;
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        zoomOutView.frame = startingFrame;
        blackBackgroundView.alpha = 0;
        [profileView removeFromSuperview];
    } completion:^(BOOL finished) {
        [zoomOutView removeFromSuperview];
        [startingLabel setHidden:NO];
    }];
}

//MARK: profile view for chart
- (void)setupProfileView: (UIView *) graphView {
    
    profileView = [[UIView alloc] init];
    [profileView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [graphView addSubview:profileView];
    [[profileView.topAnchor constraintEqualToAnchor:graphView.topAnchor] setActive:YES];
    [[profileView.heightAnchor constraintEqualToConstant:90] setActive:YES];
    [[profileView.leftAnchor constraintEqualToAnchor:graphView.leftAnchor] setActive:YES];
    [[profileView.rightAnchor constraintEqualToAnchor:graphView.rightAnchor] setActive:YES];
    
    UIImageView *profileImageView = [[UIImageView alloc] init];
    profileImageView.layer.cornerRadius = 5;
    profileImageView.layer.masksToBounds = YES;
    
    [profileImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [profileView addSubview:profileImageView];
    [[profileImageView.widthAnchor constraintEqualToConstant:50] setActive:YES];
    [[profileImageView.heightAnchor constraintEqualToConstant:50] setActive:YES];
    [[profileImageView.topAnchor constraintEqualToAnchor:profileView.topAnchor constant:20] setActive:YES];
    [[profileImageView.leftAnchor constraintEqualToAnchor:profileView.leftAnchor constant:20] setActive:YES];
    
    UILabel *playerNameLabel = [[UILabel alloc] init];
    playerNameLabel.font = [UIFont systemFontOfSize:17];
    playerNameLabel.textColor = [UIColor darkGrayColor];
    [playerNameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [profileView addSubview:playerNameLabel];
    [[playerNameLabel.topAnchor constraintEqualToAnchor:profileImageView.topAnchor constant:0] setActive:YES];
    [[playerNameLabel.heightAnchor constraintEqualToConstant:18] setActive:YES];
    [[playerNameLabel.rightAnchor constraintEqualToAnchor:profileView.rightAnchor] setActive:YES];
    [[playerNameLabel.leftAnchor constraintEqualToAnchor:profileImageView.rightAnchor constant:20] setActive:YES];
    
    UILabel *rankLabel = [[UILabel alloc] init];
    rankLabel.font = [UIFont systemFontOfSize:15];
    rankLabel.textColor = [UIColor grayColor];
    [rankLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [profileView addSubview:rankLabel];
    [[rankLabel.topAnchor constraintEqualToAnchor:playerNameLabel.bottomAnchor constant:0] setActive:YES];
    [[rankLabel.heightAnchor constraintEqualToConstant:16] setActive:YES];
    [[rankLabel.rightAnchor constraintEqualToAnchor:self.view.rightAnchor] setActive:YES];
    [[rankLabel.leftAnchor constraintEqualToAnchor:profileImageView.rightAnchor constant:20] setActive:YES];
    
    UILabel *averageLabel = [[UILabel alloc] init];
    averageLabel.font = [UIFont systemFontOfSize:15];
    averageLabel.textColor = [UIColor grayColor];
    [averageLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [profileView addSubview:averageLabel];
    [[averageLabel.topAnchor constraintEqualToAnchor:rankLabel.bottomAnchor constant:0] setActive:YES];
    [[averageLabel.heightAnchor constraintEqualToConstant:18] setActive:YES];
    [[averageLabel.rightAnchor constraintEqualToAnchor:self.view.rightAnchor] setActive:YES];
    [[averageLabel.leftAnchor constraintEqualToAnchor:profileImageView.rightAnchor constant:20] setActive:YES];
    
    
    
    [SCSQLite initWithDatabase:@"sportsdb.sqlite3"];
    
    NSString *query = [NSString stringWithFormat:@"SELECT * FROM PlayersInfo where UserLevel=3 AND PlayerID= %d", rankingData.playerId];
    NSArray *teamStats = [SCSQLite selectRowSQL:query];
    
    if (teamStats.count > 0) {
        NSDictionary *playerDic = [teamStats objectAtIndex:0];
        
        // Set Photo
        NSString *photoString = [playerDic valueForKey:@"Photo"];
        if ([photoString length] > 0) {
            NSData *decodedData = [photoString base64Data];
            if (decodedData) {
                profileImageView.image = [UIImage imageWithData:decodedData];
            }
        } else {
            profileImageView.image = [UIImage lak_makeLetterAvatarWithUsername:rankingData.playerName];
        }
    }
    
    playerNameLabel.text = [NSString stringWithFormat:@"Name:     %@", rankingData.playerName];
    rankLabel.text = [NSString stringWithFormat:@"Rank:         %d", rankingData.rank];
    averageLabel.text = [NSString stringWithFormat:@"Average:   %@", rankingData.avg1];
}


//MARK: chart

- (void)setupCharts: (UIView *) graphView {
    
    chartView = [[CombinedChartView alloc] init];
    [chartView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [graphView addSubview:chartView];
    
    [[chartView.topAnchor constraintEqualToAnchor:profileView.bottomAnchor constant:0] setActive:YES];
    [[chartView.rightAnchor constraintEqualToAnchor:graphView.rightAnchor constant:-5] setActive:YES];
    [[chartView.leftAnchor constraintEqualToAnchor:graphView.leftAnchor constant:5] setActive:YES];
    [[chartView.bottomAnchor constraintEqualToAnchor:graphView.bottomAnchor constant:-20] setActive:YES];
    
    chartView.chartDescription.enabled = NO;
    
    chartView.drawGridBackgroundEnabled = NO;
    chartView.drawBarShadowEnabled = NO;
    chartView.highlightFullBarEnabled = NO;
    [chartView setUserInteractionEnabled:NO];
    
    chartView.gridBackgroundColor = [UIColor clearColor];
    chartView.drawOrder = @[
                            @(CombinedChartDrawOrderLine)
                            ];
    
    ChartLegend *l = chartView.legend;
    [l setEnabled:NO];
    
    ChartYAxis *rightAxis = chartView.rightAxis;
    rightAxis.drawGridLinesEnabled = NO;
    rightAxis.drawAxisLineEnabled = NO;
    rightAxis.drawLimitLinesBehindDataEnabled = NO;
    rightAxis.drawZeroLineEnabled = NO;
    rightAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
    rightAxis.labelTextColor = [UIColor whiteColor];
    rightAxis.axisLineColor = [UIColor whiteColor];
    rightAxis.gridColor = [UIColor whiteColor];
    
    ChartYAxis *leftAxis = chartView.leftAxis;
    leftAxis.drawGridLinesEnabled = NO;
    leftAxis.drawAxisLineEnabled = NO;
    leftAxis.drawLimitLinesBehindDataEnabled = NO;
    leftAxis.drawZeroLineEnabled = NO;
    leftAxis.axisMinimum = 0.0; // this replaces startAtZero = YES
    leftAxis.axisLineColor = [UIColor whiteColor];
    leftAxis.labelPosition = YAxisLabelPositionOutsideChart;
    leftAxis.yOffset = 0;
    leftAxis.xOffset = 20;
    leftAxis.gridColor = [UIColor whiteColor];
    
    ChartXAxis *xAxis = chartView.xAxis;
    xAxis.labelPosition = XAxisLabelPositionBottom;
    xAxis.axisMinimum = 0.0;
    xAxis.granularity = 1.0;
    xAxis.valueFormatter = self;
    xAxis.drawGridLinesEnabled = NO;
    
    [self setChartData];
}

- (void)setupChartData {
    
    months = [[NSMutableArray alloc] init];
    averages = [[NSMutableArray alloc] init];
    
    NSArray *keys = [rankingData.graphArray allKeys];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MMM"];
    
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSDate *date1 = [dateFormatter dateFromString:obj1];
        NSDate *date2 = [dateFormatter dateFromString:obj2];
        return [date1 compare:date2];
    }];
    NSDateFormatter *monthDateFormatter = [[NSDateFormatter alloc] init];
    [monthDateFormatter setDateFormat:@"MMM"];
    
    for (int i = 0; i < [sortedKeys count]; i++) {
        NSString *key = [sortedKeys objectAtIndex:i];
        NSDate *date = [dateFormatter dateFromString:key];
        NSString *month = [monthDateFormatter stringFromDate:date];
        
        double value = (double)[[rankingData.graphArray valueForKey:key] doubleValue];
        
        [months addObject:month];
        [averages addObject:[NSNumber numberWithDouble:value]];
    }
}

- (void)setChartData
{
    CombinedChartData *data = [[CombinedChartData alloc] init];
    data.lineData = [self generateLineData];
    
    chartView.xAxis.axisMaximum = data.xMax;
    
    
    chartView.data = data;
}

- (LineChartData *)generateLineData
{
    LineChartData *d = [[LineChartData alloc] init];
    
    NSMutableArray *entries = [[NSMutableArray alloc] init];
    
    for (int index = 0; index < months.count; index++) {
        double value = [averages[index] doubleValue];
        ChartDataEntry *data = [[ChartDataEntry alloc] initWithX:index y:value];
        
        [entries addObject:data];
    }
    
    //    LineChartDataSet *set = [[LineChartDataSet alloc] initWithValues:entries label:nil];
    LineChartDataSet *set = [[LineChartDataSet alloc] initWithValues:entries];
    [set setColor:[UIColor colorWithRed:51/255.f green:101/255.f blue:204/255.f alpha:1.f]];
    set.lineWidth = 2.5;
    [set setCircleColor:[UIColor colorWithRed:51/255.f green:101/255.f blue:204/255.f alpha:1.f]];
    set.circleRadius = 4;
    set.circleHoleRadius = 0;
    
    set.fillColor = [UIColor colorWithRed:240/255.f green:238/255.f blue:70/255.f alpha:1.f];
    set.mode = LineChartModeCubicBezier;
    set.drawValuesEnabled = YES;
    set.valueFont = [UIFont systemFontOfSize:10.f];
    set.valueTextColor = [UIColor lightGrayColor];
    
    set.axisDependency = AxisDependencyLeft;
    
    [d addDataSet:set];
    
    return d;
}

#pragma mark - IAxisValueFormatter

- (NSString *)stringForValue:(double)value
                        axis:(ChartAxisBase *)axis
{
    return months[(int)value % months.count];
}

#pragma mark - IQDropDownTextFieldDelegate

- (void)textField:(nonnull IQDropDownTextField*)textField didSelectDate:(nullable NSDate*)date {
    [self getRankingData];
}

@end
