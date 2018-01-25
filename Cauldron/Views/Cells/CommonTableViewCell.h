//
//  ComonTableViewCell.h
//  Cauldron
//
//  Created by John Nik on 5/18/17.
//  Copyright © 2017 johnik703. All rights reserved.
//s

#import <UIKit/UIKit.h>
@import MGSwipeTableCell;

@interface CommonTableViewCell : MGSwipeTableCell

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@end
