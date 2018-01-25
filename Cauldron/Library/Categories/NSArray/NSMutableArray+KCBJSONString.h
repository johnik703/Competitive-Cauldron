//
//  NSMutableArray+KCBJSONString.h
//  SWP
//
//  Created by John Nik on 5/7/17.
//  Copyright © 2017 johnik703. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (KCBJSONString)

-(NSString*) jsonStringWithPrettyPrint:(BOOL) prettyPrint;
-(NSString *) commaStringFromArray:(NSArray *)array;
-(id) objectOfType:(NSString *)name array:(NSArray *)array;

@end
