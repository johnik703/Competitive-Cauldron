//
//  EditCategoryViewController.m
//  Cauldron
//
//  Created by John Nik on 5/15/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "EditCategoryViewController.h"
#import "UITextView+Placeholder.h"
#import "ChallengeCatgry.h"
@interface EditCategoryViewController () <UITextFieldDelegate, UITextViewDelegate> {
//    NSMutableArray *playNameArr;
   
}

@end

@implementation EditCategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    categoryDictionary = [[NSMutableDictionary alloc] init];
    category = [[ChallengeCatgry alloc] init];

    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
}

- (void)goingBack {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void) viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self setupAllUIViews];
}

- (void) setupAllUIViews {
    
    self.categoryNameTF.delegate = self;
    self.shortNameTF.delegate = self;
    self.orderTF.delegate = self;

    if (self.navigationCategoryStatus == CategoryState_Add) {
        
    } else {
        
        self.categoryNameTF.text = str_categoryName;
        self.shortNameTF.text = str_shortName;
        self.orderTF.text = String(str_order);
        
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)didTapSave:(id)sender {
    [self save];
}

- (void)save {
    
    if (![self checkValidation]) {
        return;
    }
    
    BOOL checkConnection = [RKCommon checkInternetConnection];
    if (!checkConnection) {
        [Alert showAlert:@"Internet Connection Error" message:@"" viewController:self];
        return;
    }
    
    [self fetchCategories];
    [self createCategories];
    
}


- (IBAction)didTapClose:(id)sender {
    [self dismissViewController];
}

#pragma mark - Private Methods

- (void) fetchCategories {
    
    category.categoryname = self.categoryNameTF.text;
    category.shortname = self.shortNameTF.text;
    category.catOrder = (int)[self.orderTF.text intValue];
    
    [categoryDictionary setValue:category.categoryname                  forKey:@"CategoryName"];
    [categoryDictionary setValue:category.shortname                      forKey:@"ShortName"];
    [categoryDictionary setValue:String(category.catOrder)                forKey:@"CatOrder"];
//    [categoryDictionary setValue:String(catId)                            forKey:@"CatID"];
    
}

- (void) createCategories {
    
    int categoryId;
    NSString *action;
    if (self.navigationCategoryStatus == CategoryState_Add) {
        action = @"ADD_CATEGORY";
        categoryId = 0;
    } else {
        categoryId = catId;
        action = @"EDIT_CATEGORY";
    }
    NSDictionary* params = @{@"action": action,
                             @"CategoryName": category.categoryname,
                             @"ShortName": category.shortname,
                             @"CatOrder": String(category.catOrder),
                             @"CatID": String(categoryId),
                             @"Sports": Global.currntTeam.Sport,
                             @"TeamID": String(Global.currntTeam.TeamID)
                             };
    
    [API executeHTTPRequest:Post url:syncToServerServiceURLManageChallenge parameters:params CompletionHandler:^(NSDictionary *responseDict) {
        [ProgressHudHelper hideLoadingHud];
        [self parseResponse:responseDict params:params];
    } ErrorHandler:^(NSString *errorStr) {
        
        NSLog(@"errorStr ---%@", errorStr);
        [ProgressHudHelper hideLoadingHud];
        [Alert showAlert:@"Something went wrong" message:nil viewController:self];
    }];

    
}


- (void) parseResponse: (NSDictionary *)dic params:(NSDictionary *)paramsDic {
    
    NSString *successResult = [dic valueForKey:@"status"];
    NSString *categoryId = [dic valueForKey:@"catID"];
    
    NSLog(@"success or fail if recieve data from server-----%@", successResult);
    NSLog(@"categoryId if recieve data from server-----%@", categoryId);
    
    if ([successResult isEqualToString:@"Success"]) {
        
        if (self.navigationCategoryStatus == CategoryState_Add) {
            
            NSMutableDictionary *createCategoryDictionary = [NSMutableDictionary dictionaryWithDictionary:categoryDictionary];

            [createCategoryDictionary setValue:String(Global.currntTeam.TeamID)     forKey:@"TeamID"];
            [createCategoryDictionary setValue:String(0)    forKey:@"Sync"];
            [createCategoryDictionary setValue:categoryId    forKey:@"CatID"];
            NSLog(@"created team dictionary---%@", createCategoryDictionary);
            
            BOOL success = [SQLiteHelper insertInTable:@"ChallengeCategory" params:createCategoryDictionary];
            if (success) {
 
                [Alert showAlert:@"Category added successfully!" message:nil viewController:self complete:^{
                    [self dismissViewController];
                }];
                        
            } else {
                [Alert showAlert:@"Error" message:@"Failed to add Category in local" viewController:self];
            }
            
        } else {
            NSDictionary *whereDic = @{@"TeamID": String(Global.currentTeamId), @"CatID": String(catId)};

            NSLog(@"updated team dictionary---%@", categoryDictionary);
            
            BOOL success = [SQLiteHelper updateInTable:@"ChallengeCategory" params:categoryDictionary where:whereDic];
            if (success) {
                
                [Alert showAlert:@"Team successfully updated" message:nil viewController:self complete:^{
                    [self dismissViewController];
                }];
            } else {
                [Alert showAlert:@"Error" message:@"Failed to update Category in local" viewController:self];
            }
        }
    } else {
        
        if (self.navigationCategoryStatus == CategoryState_Add) {
            [Alert showAlert:@"Failed to Add Category" message:nil viewController:self];
            return;
            
        } else if (self.navigationCategoryStatus == CategoryState_Edit) {
            [Alert showAlert:@"Failed to Edit Category" message:nil viewController:self];
            return;
        }
    }
}


- (BOOL)checkValidation {
    
    if ([self.categoryNameTF.text isZeroLengthWithoutTrimWhiteSpace]) {
        [Alert showAlert:@"Please enter the categoryName." message:nil viewController:self];
        return false;
    }
    
    if ([self.shortNameTF.text isZeroLengthWithoutTrimWhiteSpace]) {
        [Alert showAlert:@"Please enter the shortName." message:nil viewController:self];
        return false;
    }
    
    if ([self.orderTF.text isZeroLengthWithoutTrimWhiteSpace]) {
        [Alert showAlert:@"Please enter the order." message:nil viewController:self];
        return false;
    }
    
    return true;
}

//// don't use in this class

- (void)dismissViewController {
//    [self dismissViewControllerAnimated:true completion:nil];
    [self.navigationController popViewControllerAnimated:true];
    [self.delegate didDisappear];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
