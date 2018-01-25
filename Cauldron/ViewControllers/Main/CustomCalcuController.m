//
//  CustomCalcuController.m
//  Cauldron
//
//  Created by John Nik on 5/15/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import "CustomCalcuController.h"
#import "CustomTypeController.h"

@interface CustomCalcuController () <UITextViewDelegate> {
    
    NSString *rankFormulaString;
    
    
    
}
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

static NSString *CustomCalcuTableIdentifier = @"CustomCalcuTable";

@implementation CustomCalcuController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setup];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:CustomCalcuTableIdentifier];
    
    [self.tableView reloadData];
    
}

- (void)setup {
    
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStylePlain target:self action:@selector(didTapSaveRankFormula)];
    [self.navigationItem setRightBarButtonItem:rightButton];
    
    self.addNumberDropTextfield.itemList = @[@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9"];
    
    if (self.navigationCustomCalcuStatus == CustomChallengeState_Edit) {
        rankFormulaString = [Global.currentChallenge objectForKey:@"RankFormula"];
        self.rankFormulaTextView.text = rankFormulaString;
    }
    
}

- (void)didTapSaveRankFormula {
    [customTypeController recieveRankFormulaFromCustomCalcu:rankFormulaString];
    
    [self.navigationController popViewControllerAnimated:true];
    
}


- (IBAction)didTapSumButton:(UIButton *)sender {
    if (rankFormulaString != nil) {
        rankFormulaString = [NSString stringWithFormat:@"%@SUM(", rankFormulaString];
    } else {
        rankFormulaString = @"SUM(";
    }
    self.rankFormulaTextView.text = rankFormulaString;
    
}
- (IBAction)didTapAvgButton:(id)sender {
    if (rankFormulaString != nil) {
        rankFormulaString = [NSString stringWithFormat:@"%@AVG(", rankFormulaString];
    } else {
        rankFormulaString = @"AVG(";
    }
    
    self.rankFormulaTextView.text = rankFormulaString;
}
- (IBAction)didTapPlusButton:(id)sender {
    if (rankFormulaString != nil) {
        rankFormulaString = [NSString stringWithFormat:@"%@+", rankFormulaString];
    } else {
        rankFormulaString = @"+";
    }
    self.rankFormulaTextView.text = rankFormulaString;
}
- (IBAction)didTapMinusButton:(id)sender {
    if (rankFormulaString != nil) {
        rankFormulaString = [NSString stringWithFormat:@"%@-", rankFormulaString];
    } else {
        rankFormulaString = @"-";
    }
    self.rankFormulaTextView.text = rankFormulaString;
}
- (IBAction)didTapAddButton:(id)sender {
    if (rankFormulaString != nil) {
        rankFormulaString = [NSString stringWithFormat:@"%@*", rankFormulaString];
    } else {
        rankFormulaString = @"*";
    }
    self.rankFormulaTextView.text = rankFormulaString;
}
- (IBAction)didTapDividedButton:(id)sender {
    if (rankFormulaString != nil) {
        rankFormulaString = [NSString stringWithFormat:@"%@/", rankFormulaString];
    } else {
        rankFormulaString = @"/";
    }
    self.rankFormulaTextView.text = rankFormulaString;
}
- (IBAction)didTapLeftParenthesisButton:(id)sender {
    if (rankFormulaString != nil) {
        rankFormulaString = [NSString stringWithFormat:@"%@(", rankFormulaString];
    } else {
        rankFormulaString = @"(";
    }
    self.rankFormulaTextView.text = rankFormulaString;
}
- (IBAction)didTapRightParenthesis:(id)sender {
    if (rankFormulaString != nil) {
        rankFormulaString = [NSString stringWithFormat:@"%@)", rankFormulaString];
    } else {
        rankFormulaString = @")";
    }
    self.rankFormulaTextView.text = rankFormulaString;
}
- (IBAction)didTapNumberButton:(id)sender {
    NSString *number = self.addNumberDropTextfield.selectedItem;
    
    if (number == nil) {
        rankFormulaString = @"";
    }
    
    if (rankFormulaString != nil) {
        rankFormulaString = [NSString stringWithFormat:@"%@%@", rankFormulaString, number];
    } else {
        rankFormulaString = [NSString stringWithFormat:@"%@", number];
    }
    self.rankFormulaTextView.text = rankFormulaString;
}
- (IBAction)didTapClearAllButton:(id)sender {
    self.rankFormulaTextView.text = @"";
    rankFormulaString = @"";
}
- (IBAction)didTapDeleteButton:(id)sender {
    
    NSUInteger characterCount = [rankFormulaString length];
    
    NSMutableString *data = [NSMutableString stringWithString:rankFormulaString];
    [data deleteCharactersInRange:NSMakeRange(characterCount - 1, 1)];
    rankFormulaString = data;
    self.rankFormulaTextView.text = rankFormulaString;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return fieldsArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *fieldName = fieldsArray[indexPath.row];
    
    if (rankFormulaString != nil) {
        rankFormulaString = [NSString stringWithFormat:@"%@%@", rankFormulaString, fieldName];
    } else {
        rankFormulaString = [NSString stringWithFormat:@"%@", fieldName];
    }
    self.rankFormulaTextView.text = rankFormulaString;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = (UITableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CustomCalcuTableIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = fieldsArray[indexPath.row];
    
    
    return cell;
    
    
}

@end
