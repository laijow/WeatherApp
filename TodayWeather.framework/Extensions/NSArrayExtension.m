//
//  NSArrayExtension.m
//  weatherApp
//
//  Created by User on 18.12.2019.
//  Copyright © 2019 Yem Anatoly. All rights reserved.
//

#import "NSArrayExtension.h"

@implementation NSArray(WeatherApp)

- (BOOL)isEmpty {
    
    if(!self || self.count < 1) {
        return true;
    }
    return false;
    
}

@end
