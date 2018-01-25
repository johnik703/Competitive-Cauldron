//
//  Attandance.h
//  Cauldron
//
//  Created by John Nik on 6/1/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Attandance : NSObject
@property (nonatomic,assign) int atdId;
@property (nonatomic,assign) int teamId;
@property (nonatomic,assign) int playerId;
@property (nonatomic,copy) NSString *attendanceDate;
@property (nonatomic,assign) int attandance;
@property (nonatomic,copy) NSString *add_date;
@property (nonatomic, assign) int email_reportAdded;

@end
