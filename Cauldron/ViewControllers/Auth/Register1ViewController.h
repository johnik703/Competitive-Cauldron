//
//  Register1ViewController.h
//  Cauldron
//
//  Created by John Nik on 5/18/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Register1ViewController : BaseTableViewController

@property (weak, nonatomic) IBOutlet UIImageView *photoImgView;
@property (weak, nonatomic) IBOutlet UITextField *yearTF;
@property (weak, nonatomic) IBOutlet UITextField *teamNameTF;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *seasonStartsDDTF;
@property (weak, nonatomic) IBOutlet IQDropDownTextField *seasonEndsDDTF;
@property (weak, nonatomic) IBOutlet UITextField *subscriptionDateDDTF;

- (BOOL) checkValidation;

@end
