//
//  User.h
//  FacebookTutorial
//
//  Created by Shyam Gosavi on 01/06/15.
//  Copyright (c) 2015 Brian Coleman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject
@property (nonatomic,strong) NSMutableDictionary *userDict;
+(User *)sharedInstance;
+(void)cleareData;
@end
