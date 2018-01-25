//
//  CustomTypeController.m
//  Cauldron
//
//  Created by John Nik on 4/12/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "CustomTypeController.h"
#import "AddCustomTypeCell.h"
#import "CustomCalcuController.h"

@interface CustomTypeController () <IQDropDownTextFieldDelegate, UITextFieldDelegate> {
    
    int count;
    NSMutableArray *updateFieldsArr;
    NSMutableArray *createFieldsArr;
    
    NSString *rankFormulaString;
    
    int isAvg;
    NSString *rOrder;
    NSString *fieldsString;
    
    
    
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

static NSString *simpleTableIdentifier_iPhone = @"AddCustomTypeCell";

@implementation CustomTypeController

@synthesize averageSwitch, rankingFormulaButtonContainer, orderDropdownField;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupNavigationItems];
    
    [self setup];
    
    
    
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    count = 0;
}

- (void)setupNavigationItems {
    UIBarButtonItem *rightButton1 = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStylePlain target:self action:@selector(didTapAdd:)];
    
    UIBarButtonItem *rightButton2 = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(didTapSave)];
    
    self.navigationItem.rightBarButtonItems = @[rightButton2, rightButton1];
    
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    
}

- (void)didTapSave {
    int fieldsCounts = (int)[updateFieldsArr count];
    
    if (fieldsCounts > 0) {
        if (![self checkValidation]) {
            return;
        }
    }
    
    isAvg = self.averageSwitch.isOn ? 1 : 0;
    if ([self.orderDropdownField.selectedItem isEqualToString:@"Ascending(lower to larger)"]) {
        rOrder = @"asc";
    } else if ([self.orderDropdownField.selectedItem isEqualToString:@"Desending(larger to lower)"]) {
        rOrder = @"dsc";
    } else {
        rOrder = @"";
    }
    
    if (fieldsCounts > 0) {
        
        for (int i = 0; i < fieldsCounts ; i++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            AddCustomTypeCell *cell = (AddCustomTypeCell *)[self.tableView cellForRowAtIndexPath:indexPath];
            
            NSString *fieldName = cell.addCustomTypeField.text;
            
            if (fieldsString == nil) {
                fieldsString = fieldName;
            } else {
                fieldsString = [NSString stringWithFormat:@"%@,%@", fieldsString, fieldName];
            }
            
            
        }
        
    } else {
        fieldsString = @"";
    }
    
    if (rankFormulaString == nil) {
        if (fieldsCounts > 0) {
            
            NSString *plusFieldsString;
            
            for (int i = 0; i < fieldsCounts ; i++) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                AddCustomTypeCell *cell = (AddCustomTypeCell *)[self.tableView cellForRowAtIndexPath:indexPath];
                
                NSString *fieldName = cell.addCustomTypeField.text;
                
                if (plusFieldsString == nil) {
                    plusFieldsString = fieldName;
                } else {
                    plusFieldsString = [NSString stringWithFormat:@"%@+%@", plusFieldsString, fieldName];
                }
            }
            
            rankFormulaString = [NSString stringWithFormat:@"AVG(%@)", plusFieldsString];
            
        } else {
            rankFormulaString = @"";
        }
    }
    
    NSLog(@"testCustomChallenge, %d, %@, %@, %@", isAvg, rOrder, fieldsString, rankFormulaString);
    [editChaListController recieveCustomDataFromCustomTypeController:isAvg castOrder:rOrder fieldsName:fieldsString rankFormula:rankFormulaString];
    [self.navigationController popViewControllerAnimated:true];
    
}

- (void)recieveRankFormulaFromCustomCalcu:(NSString *)rankFormula {
    rankFormulaString = rankFormula;
    
    NSLog(@"TestRank, %@", rankFormulaString);
}

- (void)setup {
    
    self.orderDropdownField.itemList = @[@"Ascending(lower to larger)", @"Desending(larger to lower)"];
    
    [averageSwitch addTarget:self action:@selector(switchToggled:) forControlEvents:UIControlEventValueChanged];
    
    if (self.navigationCustomStatus == CustomChallengeState_Add ) {
        
        updateFieldsArr = [[NSMutableArray alloc] init];
        
        [averageSwitch setOn:NO];
        
    } else {
        
        [averageSwitch setOn:(int)[[Global.currentChallenge objectForKey:@"isAvg"] integerValue] == 1 ? YES : NO];
        
        if ([averageSwitch isOn]) {
            
            [rankingFormulaButtonContainer setHidden:YES];
            
        } else {
            
            [rankingFormulaButtonContainer setHidden:NO];
            
        }
        
        if ([[Global.currentChallenge objectForKey:@"Rorder"] isEqualToString:@"asc"]) {
            self.orderDropdownField.selectedItem = @"Ascending(lower to larger)";
        } else if ([[Global.currentChallenge objectForKey:@"Rorder"] isEqualToString:@"dsc"]) {
            self.orderDropdownField.selectedItem = @"Desending(larger to lower)";
        }

        
        NSString *fields = [Global.currentChallenge objectForKey:@"fields"];
        NSArray *updateFieldsNSArr = [fields componentsSeparatedByString:@","];
        NSLog(@"fields, %@", updateFieldsNSArr);
        
        updateFieldsArr = [NSMutableArray arrayWithArray:updateFieldsNSArr];

    }
    
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    if ([[UIDevice currentDevice]userInterfaceIdiom]==UIUserInterfaceIdiomPhone) {
        [self.tableView registerNib:[UINib nibWithNibName:@"AddCustomTypeCell" bundle:nil] forCellReuseIdentifier:simpleTableIdentifier_iPhone];
    } else {
        [self.tableView registerNib:[UINib nibWithNibName:@"AddCustomTypeCell" bundle:nil] forCellReuseIdentifier:simpleTableIdentifier_iPhone];
    }
    
    [self.tableView reloadData];
}



- (IBAction)didTapAdd:(id)sender {
    
    [updateFieldsArr addObject:@""];
    
    
    [self.tableView reloadData];
    
}

- (void)switchToggled:(id)sender {
    
    
    UISwitch *mySwitch = (UISwitch *)sender;
    if ([mySwitch isOn]) {
        [rankingFormulaButtonContainer setHidden:YES];
    } else {
        [rankingFormulaButtonContainer setHidden:NO];
    }
    
}


- (IBAction)didTapRankingFormulaButton:(UIButton *)sender {
    
    if (![self checkValidation]) {
        return;
    }
    
    NSMutableArray *fieldsArray = [[NSMutableArray alloc] init];
    
    for (int i = 0 ; i < (int)[updateFieldsArr count] ; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        AddCustomTypeCell *cell = (AddCustomTypeCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        
        [fieldsArray addObject:cell.addCustomTypeField.text];
        
    }

    NSLog(@"fieldsArray1, %@", fieldsArray);
    
    CustomCalcuController *customCalcuController = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomCalcuController"];
    
    customCalcuController->fieldsArray = fieldsArray;
    
    if (self.navigationCustomStatus == CustomChallengeState_Edit) {
        customCalcuController.navigationCustomCalcuStatus = CustomChallengeState_Edit;
    }
    
    customCalcuController->customTypeController = self;
    
    [self.navigationController pushViewController:customCalcuController animated:true];
    
}

- (void)textFieldDidChange:(NSNotificationCenter *)notification {
    
    int fieldsCounts = (int)[updateFieldsArr count];
    
    for (int i = 0 ; i < fieldsCounts ; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        AddCustomTypeCell *cell = (AddCustomTypeCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        
        [updateFieldsArr replaceObjectAtIndex:i withObject:cell.addCustomTypeField.text];
        
    }

    
    NSLog(@"test array, %@, %d", updateFieldsArr, (int)[updateFieldsArr count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    AddCustomTypeCell *cell = (AddCustomTypeCell *)[self.tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier_iPhone forIndexPath:indexPath];
    
    cell.addCustomTypeField.text = updateFieldsArr[indexPath.row];
    cell.addCustomTypeField.tag = indexPath.row;
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    [notificationCenter addObserver:self selector:@selector(textFieldDidChange:) name:UITextFieldTextDidChangeNotification object:cell.addCustomTypeField];
    [cell.addCustomTypeField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventValueChanged];
    cell.addCustomTypeField.delegate = self;
    return cell;

}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [updateFieldsArr removeObjectAtIndex:indexPath.row];
        
        [self.tableView reloadData];
    }
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [updateFieldsArr count];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Fields";
}

- (BOOL)checkValidation {
    
    int fieldsCounts = (int)[updateFieldsArr count];
    
    for (int i = 0 ; i < fieldsCounts ; i++) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
        AddCustomTypeCell *cell = (AddCustomTypeCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        
        if ([cell.addCustomTypeField.text isEqualToString:@""]) {

            NSString *alertString = [NSString stringWithFormat:@"Please enter the field(%d) name.", i];

            [Alert showAlert:alertString message:nil viewController:self];
            return false;
        }
        
    }
    
    return true;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
