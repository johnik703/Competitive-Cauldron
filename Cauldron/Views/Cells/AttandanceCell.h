//
//  AttandaceCell.h
//  Cauldron
//
//  Created by John Nik on 5/18/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AttandanceCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet BEMCheckBox *checkBox;
@property (weak, nonatomic) IBOutlet UIImageView *photoImgView;

@end
