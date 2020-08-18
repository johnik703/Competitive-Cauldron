//
//  ChartController.m
//  Cauldron
//
//  Created by John Nik on 09/03/2018.
//  Copyright © 2018 Logic express. All rights reserved.
//

#import "ChartController.h"
#import "JLChart.h"

@import HMSegmentedControl;
@import LetterAvatarKit;
@import Charts;


@interface ChartController () <ChartViewDelegate, IChartAxisValueFormatter>
{
    NSMutableArray<NSString *> *months;
    NSMutableArray<NSNumber *> *averages;
}
@end

@implementation ChartController
@synthesize rankingData, profileImageView, averageLabel, playerNameLabel, rankLabel, graphView, chartView;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupViews];
    [self fetchData];
//    [self setupGraphView];
    [self setupChartData];
    [self setupCharts];
}

- (void)setupCharts {
    
    chartView = [[CombinedChartView alloc] init];
    [chartView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addSubview:chartView];
    
    [[chartView.topAnchor constraintEqualToAnchor:profileImageView.bottomAnchor constant:30] setActive:YES];
    [[chartView.heightAnchor constraintEqualToConstant:200] setActive:YES];
    [[chartView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-15] setActive:YES];
    [[chartView.leftAnchor constraintEqualToAnchor:profileImageView.leftAnchor constant:-5] setActive:YES];
    
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

- (void)fetchData {
    
    NSLog(@"%@", rankingData.graphArray);
    
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
    rankLabel.text = [NSString stringWithFormat:@"Rank:        %d", rankingData.rank];
    averageLabel.text = [NSString stringWithFormat:@"Average:  %@", rankingData.avg1];
    
}

- (void)setupGraphView {
    
    if (rankingData.graphArray.count == 0 || rankingData.graphArray == nil) {
        return;
    }
    
    CGFloat width = [UIScreen mainScreen].bounds.size.width;
    
    JLLineChart *lineChart = [[JLLineChart alloc] initWithFrame:CGRectMake(0, 0, width - 30, 250)];
    JLLineChartData *data = [[JLLineChartData alloc] init];
    
    data.lineColor = UA_rgba(83, 163, 24, 1);
    data.showSmooth = YES;
    JLChartPointSet *pointSet = [[JLChartPointSet alloc] init];
    
    
    NSArray *keys = [rankingData.graphArray allKeys];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MMM"];
    
    NSArray *sortedKeys = [keys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
        NSDate *date1 = [dateFormatter dateFromString:obj1];
        NSDate *date2 = [dateFormatter dateFromString:obj2];
        return [date1 compare:date2];
    }];
    
    for (int i = 0; i < [sortedKeys count]; i++) {
        NSString *key = [sortedKeys objectAtIndex:i];
        double value = (double)[[rankingData.graphArray valueForKey:key] doubleValue];
        
        JLChartPointItem *point = [JLChartPointItem pointItemWithRawX:key andRowY:[NSString stringWithFormat:@"%f", value]];
        [pointSet.items addObject:point];
    }
    
    [data.sets addObject:pointSet];
    lineChart.chartDatas = [NSMutableArray arrayWithObject:data];
    
    [graphView addSubview:lineChart];
    [lineChart strokeChart];
    
}

- (void)setupViews {
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupNavBar];
    [self setupProfileView];
}

- (void)setupProfileView {
    
    profileImageView = [[UIImageView alloc] init];
    profileImageView.layer.cornerRadius = 5;
    profileImageView.layer.masksToBounds = YES;
    
    [profileImageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addSubview:profileImageView];
    [[profileImageView.widthAnchor constraintEqualToConstant:80] setActive:YES];
    [[profileImageView.heightAnchor constraintEqualToConstant:80] setActive:YES];
    [[profileImageView.topAnchor constraintEqualToAnchor:self.view.topAnchor constant:84] setActive:YES];
    [[profileImageView.leftAnchor constraintEqualToAnchor:self.view.leftAnchor constant:20] setActive:YES];
    
    playerNameLabel = [[UILabel alloc] init];
    playerNameLabel.font = [UIFont systemFontOfSize:20];
    playerNameLabel.textColor = [UIColor darkGrayColor];
    [playerNameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addSubview:playerNameLabel];
    [[playerNameLabel.topAnchor constraintEqualToAnchor:profileImageView.topAnchor constant:0] setActive:YES];
    [[playerNameLabel.heightAnchor constraintEqualToConstant:30] setActive:YES];
    [[playerNameLabel.rightAnchor constraintEqualToAnchor:self.view.rightAnchor] setActive:YES];
    [[playerNameLabel.leftAnchor constraintEqualToAnchor:profileImageView.rightAnchor constant:20] setActive:YES];
    
    rankLabel = [[UILabel alloc] init];
    rankLabel.font = [UIFont systemFontOfSize:17];
    rankLabel.textColor = [UIColor grayColor];
    [rankLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addSubview:rankLabel];
    [[rankLabel.topAnchor constraintEqualToAnchor:playerNameLabel.bottomAnchor constant:0] setActive:YES];
    [[rankLabel.heightAnchor constraintEqualToConstant:25] setActive:YES];
    [[rankLabel.rightAnchor constraintEqualToAnchor:self.view.rightAnchor] setActive:YES];
    [[rankLabel.leftAnchor constraintEqualToAnchor:profileImageView.rightAnchor constant:20] setActive:YES];
    
    averageLabel = [[UILabel alloc] init];
    averageLabel.font = [UIFont systemFontOfSize:17];
    averageLabel.textColor = [UIColor grayColor];
    [averageLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addSubview:averageLabel];
    [[averageLabel.topAnchor constraintEqualToAnchor:rankLabel.bottomAnchor constant:0] setActive:YES];
    [[averageLabel.heightAnchor constraintEqualToConstant:25] setActive:YES];
    [[averageLabel.rightAnchor constraintEqualToAnchor:self.view.rightAnchor] setActive:YES];
    [[averageLabel.leftAnchor constraintEqualToAnchor:profileImageView.rightAnchor constant:20] setActive:YES];
    
    graphView = [[UIView alloc] init];
//    graphView.backgroundColor = [UIColor darkGrayColor];
    [graphView setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.view addSubview:graphView];
    
    [[graphView.topAnchor constraintEqualToAnchor:profileImageView.bottomAnchor constant:20] setActive:YES];
    [[graphView.heightAnchor constraintEqualToConstant:200] setActive:YES];
    [[graphView.rightAnchor constraintEqualToAnchor:self.view.rightAnchor constant:-15] setActive:YES];
    [[graphView.leftAnchor constraintEqualToAnchor:profileImageView.leftAnchor constant:-5] setActive:YES];
    
}

- (void)setupNavBar {
    
    self.navigationItem.title = @"Ranking Detail";
}

@end
