//
//  Ranking.h
//  Cauldron
//
//  Created by John Nik on 6/1/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Ranking : NSObject
@property(nonatomic,assign)int rankID;
@property(nonatomic,assign)int rank;
@property(nonatomic,assign)int chanllangeId;
@property(nonatomic,assign)int teamId;
@property(nonatomic,assign)int playerId;
@property(nonatomic,retain) NSString *playerName;
@property(nonatomic,retain)NSString *avg1;

@end
