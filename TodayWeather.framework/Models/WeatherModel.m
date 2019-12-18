//
//  WeatherModel.m
//  weatherApp
//
//  Created by User on 17.12.2019.
//  Copyright © 2019 Yem Anatoly. All rights reserved.
//

#import "WeatherModel.h"

@implementation WeatherModel

- (instancetype)initWithDictionary:(NSDictionary *)dict {
    
    self = [super init];
    
    if(self != nil) {
        self.minTemp = [dict[@"min_temp"] floatValue];
        self.maxTemp = [dict[@"max_temp"] floatValue];
        self.stringDate = dict[@"applicable_date"];
    }
    
    return self;
    
}

@end
