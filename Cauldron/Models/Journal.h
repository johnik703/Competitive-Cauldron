//
//  Journal.h
//  Cauldron
//
//  Created by John Nik on 6/1/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Journal : NSObject
@property(nonatomic,assign)int journalId;
@property(nonatomic,assign)int teamId;
@property(nonatomic,assign)int playerId;
@property(nonatomic,copy)NSString *notes;
@property(nonatomic,copy)NSString *add_date;
@end
