//
//  User.m
//  SnapchatDesktop
//
//  Created by Chris Mays on 11/24/13.
//  Copyright (c) 2013 Chris Mays. All rights reserved.
//

#import "User.h"

@implementation User
-(id)initWithUSername:(NSString *)usern{
    
    self=[self init];
    username=usern;
    return self;
    
}
-(NSString *)getUSername{
    return username;
}
@end
