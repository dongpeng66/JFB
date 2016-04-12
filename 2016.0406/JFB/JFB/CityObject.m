//
//  CityObject.m
//  JFB
//
//  Created by JY on 15/8/27.
//  Copyright (c) 2015年 JY. All rights reserved.
//

#import "CityObject.h"
#import "CountysObject.h"

@implementation CityObject

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.areaId forKey:@"areaId"];
    [aCoder encodeObject:self.areaName forKey:@"areaName"];
    [aCoder encodeObject:self.pyName forKey:@"pyName"];
    [aCoder encodeObject:self.countysArray forKey:@"countysArray"];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    self.areaId = [aDecoder decodeObjectForKey:@"areaId"];
    self.areaName = [aDecoder decodeObjectForKey:@"areaName"];
    self.pyName = [aDecoder decodeObjectForKey:@"pyName"];
    self.countysArray = [aDecoder decodeObjectForKey:@"countysArray"];
    
    return self;
}


@end
