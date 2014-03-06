//
//  Post.m
//  SnapSave
//
//  Created by Chris Mays on 11/25/13.
//  Copyright (c) 2013 Chris Mays. All rights reserved.
//

#import "Post.h"
#import "User.h"
@implementation Post
-(id)initWithPerson:(User *)pers isSent:(BOOL)sen withStatus:(int)stat withTimeStamp:(NSString *)timeStam{
    
    self=[self init];
    person=pers;
    sent=sen;
    status=stat;
    timeStamp=timeStam;
    
    return self;
}
-(User *)getPerson{
    return person;
}
-(BOOL)wasSent{
    return sent;
}
-(int)getStatus{
    return status;
}
-(NSString *)getTimeStamp{
    return timeStamp;
}
@end
