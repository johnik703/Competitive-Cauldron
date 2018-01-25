//
//  CoachListCell.h
//  Cauldron
//
//  Created by John Nik on 6/1/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <UIKit/UIKit.h>
@import MGSwipeTableCell;

@interface CoachListCell : MGSwipeTableCell
@property (strong, nonatomic) IBOutlet UILabel *coachName;
@property (weak, nonatomic) IBOutlet UILabel *teamsLabel;

@end
