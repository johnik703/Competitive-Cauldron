//
//  FinalRankingReportVC.h
//  Cauldron
//
//  Created by John Nik on 5/15/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FinalRankingReportVC : UIViewController
{
    NSString *playerID;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
