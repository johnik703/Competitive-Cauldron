//
//  SQLManager.h
//  Cauldron
//
//  Created by John Nik on 6/1/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol SQLManagerDelegate <NSObject>
-(void)processCompletedForServiceType:(NSString*)webServiceType TotalInsertedData:(int)totalRecords;
@end


@interface SQLManager : NSObject
{
    id <SQLManagerDelegate> delegate;
}
@property (nonatomic,strong) id delegate;

-(void)insertData:(NSArray*)wsDataArray serviceType:(NSString*)calledWebservice;

@end
