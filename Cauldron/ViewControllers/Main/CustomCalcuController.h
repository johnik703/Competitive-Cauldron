//
//  CustomCalcuController.h
//  Cauldron
//
//  Created by John Nik on 5/15/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTypeController.h"

@interface CustomCalcuController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
@public
    NSMutableArray *fieldsArray;
    
@public
    CustomTypeController *customTypeController;
    
}

@property (assign, nonatomic) CustomChallengeState navigationCustomCalcuStatus;

@property (weak, nonatomic) IBOutlet UITextView *rankFormulaTextView;

@property (weak, nonatomic) IBOutlet IQDropDownTextField *addNumberDropTextfield;
@end
