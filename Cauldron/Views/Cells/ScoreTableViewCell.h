//
//  ScoreTableViewCell.h
//  Cauldron
//
//  Created by John Nik on 5/18/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ScoreItemView.h"
#import "ScoreViewController.h"

@class ScoreViewController;

@protocol ScoreTextFieldDelegate <UITextFieldDelegate>

@optional
- (void)scoreTextFieldDidEndEditing:(UITextField *)textField;
@end

@protocol ScoreTableViewCellDelegate
- (void)handleLongPressGesture: (UILongPressGestureRecognizer *) gesture atCell: (UITableViewCell *) cell;
@end

@interface ScoreTableViewCell : UITableViewCell <UITextFieldDelegate> {
    
    @public
    ScoreViewController *scoreViewController;
}

@property (strong, nonatomic) NSMutableArray *subViewsArr;

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet BEMCheckBox *deleteCheckBox;
@property (strong, nonatomic) IBOutlet UIStackView *stackView;

- (void) initUIWithItems:(NSArray *)items values:(NSArray *)values isDecimal:(int )isDecimal index:(NSInteger)index;
- (NSString *) getValues;

@property (weak, nonatomic) id<ScoreTextFieldDelegate> scoreDelegate;
@property (weak, nonatomic) id<ScoreTableViewCellDelegate> delegate;

@end
