//
//  NSDateExtension.m
//  weatherApp
//
//  Created by User on 18.12.2019.
//  Copyright © 2019 Yem Anatoly. All rights reserved.
//

#import "NSDateExtension.h"

@implementation NSDate(TodayWeather)

+ (NSString*)todayDateString {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy/MM/dd"];
    NSString *result = [formatter stringFromDate:[NSDate date]];
    
    return result;
    
}

@end
