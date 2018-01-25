//
//  MenuCell.h
//  Cauldron
//
//  Created by John Nik on 5/18/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuCell : UITableViewCell

@property (nonatomic, retain) IBOutlet UILabel *menuLabel;
@property (nonatomic, retain) IBOutlet UIImageView *menuImageView;
@property (strong, nonatomic) IBOutlet UILabel *syncCountLabel;


@end
