//
//  LocationModel.m
//  weatherApp
//
//  Created by User on 17.12.2019.
//  Copyright © 2019 Yem Anatoly. All rights reserved.
//

#import "LocationModel.h"

@implementation LocationModel

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    
    self = [super init];
    
    if(self != nil) {
        self.city = dict[@"title"];
        self.woeid = [dict[@"woeid"] longValue];
    }
    
    return self;
    
}

@end
