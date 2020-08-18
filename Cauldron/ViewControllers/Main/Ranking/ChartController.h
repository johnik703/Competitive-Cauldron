//
//  ChartController.h
//  Cauldron
//
//  Created by John Nik on 09/03/2018.
//  Copyright © 2018 Logic express. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Charts;

@interface ChartController : UIViewController

@property (nonatomic, strong) Ranking *rankingData;
@property (nonatomic, strong) UIImageView *profileImageView;
@property (nonatomic, strong) UILabel *playerNameLabel;
@property (nonatomic, strong) UILabel *averageLabel;
@property (nonatomic, strong) UILabel *rankLabel;
@property (nonatomic, strong) UIView *graphView;

@property (nonatomic, strong) CombinedChartView *chartView;
@end
