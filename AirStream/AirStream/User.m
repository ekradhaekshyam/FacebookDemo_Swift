//
//  User.m
//  FacebookTutorial
//
//  Created by Shyam Gosavi on 01/06/15.
//  Copyright (c) 2015 Brian Coleman. All rights reserved.
//

#import "User.h"

@implementation User
+(User *)sharedInstance{

    static User *userInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
           userInstance =  [[self alloc] init];
    });
    return userInstance;
}
-(id)init{
    
    if (self = [super init]) {
        self.userDict = [NSMutableDictionary dictionary];
    }
    return self;
}
+(void)cleareData{
    
}

@end
