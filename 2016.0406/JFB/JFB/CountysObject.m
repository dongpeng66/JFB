//
//  CountysObject.m
//  JFB
//
//  Created by JY on 15/8/27.
//  Copyright (c) 2015年 JY. All rights reserved.
//

#import "CountysObject.h"

@implementation CountysObject

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.countId forKey:@"countId"];
    [aCoder encodeObject:self.countName forKey:@"countName"];
    [aCoder encodeObject:self.countPyName forKey:@"countPyName"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    self.countId = [aDecoder decodeObjectForKey:@"countId"];
    self.countName = [aDecoder decodeObjectForKey:@"countName"];
    self.countPyName = [aDecoder decodeObjectForKey:@"countPyName"];
    
    return self;
}

@end
