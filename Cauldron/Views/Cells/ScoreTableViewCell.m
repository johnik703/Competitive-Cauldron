//
//  ScoreTableViewCell.m
//  Cauldron
//
//  Created by John Nik on 5/18/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "ScoreTableViewCell.h"

@implementation ScoreTableViewCell
@synthesize scoreDelegate;


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.subViewsArr = [[NSMutableArray alloc] init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark: - Public Methods

- (void)initUIWithItems:(NSArray *)items values:(NSArray *)values isDecimal:(int ) isDecimal index:(NSInteger)index {
    for (int i = 0; i < items.count; i++) {
        NSString *item = items[i];
        NSString *value;
        if (values.count > i) {
            value = values[i];
            
            if ([value isEqualToString:@"NULL"]) {
                value = @"";
            }
            
        } 
        
        ScoreItemView *view;
        if (self.stackView.arrangedSubviews.count == items.count) {
            view = self.stackView.arrangedSubviews[i];
        } else {
            NSArray *nib= [[NSBundle mainBundle] loadNibNamed:@"ScoreItemView" owner:self options:nil];;
            view = [nib objectAtIndex:0];
            [self.subViewsArr addObject:view];
            [self.stackView addArrangedSubview:view];
        }
        
        view.titleLbl.text = item;
        
        view.titleLbl.tag = (index + 1) * 1000 + i;
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTextFieldCursor:)];
        [view.titleLbl setUserInteractionEnabled:YES];
        [view.titleLbl addGestureRecognizer:recognizer];
        
        
        view.valueTF.text = value;
        
        view.valueTF.tag = (index + 1) * 100 + i;
        view.valueTF.delegate = self;
        
        if (isDecimal == 1) {
            view.valueTF.keyboardType = UIKeyboardTypeDecimalPad;
        } else {
            view.valueTF.keyboardType = UIKeyboardTypeNumberPad;
        }
        
        
    }
}

- (void)handleTextFieldCursor:(UITapGestureRecognizer *)sender {
    
    
    UIView *label = sender.view;
    
    NSLog(@"%d", label.tag);
    
    int index = label.tag / 1000;
    int i = label.tag % 1000;
    int textFieldTag = index * 100 + i;
    
    for (ScoreItemView *view in self.subViewsArr) {
        
        UITextField *textField = (UITextField *)[view viewWithTag:textFieldTag];
        [textField becomeFirstResponder];
        
    }

}

- (NSString *)getValues {
    NSMutableArray *arr = [NSMutableArray new];
    BOOL isAdd = false;
    for (ScoreItemView *view in self.subViewsArr) {
        if (view.valueTF.text) {
            [arr addObject:view.valueTF.text];
            isAdd = true;
        } else {
            [arr addObject:@""];
        }
    }
    
    if (isAdd) {
        return [arr componentsJoinedByString:@","];
    }
    
    return nil;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    [self.scoreDelegate scoreTextFieldDidEndEditing:textField];
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSCharacterSet *numbersOnly = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    
    for (int i = 0; i < [string length]; i++) {
        unichar c = [string characterAtIndex:i];
        if (![numbersOnly characterIsMember:c]) {
            return NO;
        }
    }
    
    return YES;
}

@end
