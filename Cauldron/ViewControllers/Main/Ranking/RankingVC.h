//
//  RankingVC.h
//  Cauldron
//
//  Created by John Nik on 5/15/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "RankingCell.h"
@import Charts;

@interface RankingVC : UIViewController

@property (nonatomic, strong) NSDictionary *dicRanking;
@property (nonatomic, strong) CombinedChartView *chartView;

@property (nonatomic, strong) Ranking *rankingData;
@property (nonatomic, strong) UIView *profileView;
@end
