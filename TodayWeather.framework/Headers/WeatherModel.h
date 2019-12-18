//
//  WeatherModel.h
//  weatherApp
//
//  Created by User on 17.12.2019.
//  Copyright © 2019 Yem Anatoly. All rights reserved.
//

#import "RootModel.h"

@interface WeatherModel : RootModel

/**
Temperature
 */
@property (assign, nonatomic) float minTemp;
@property (assign, nonatomic) float maxTemp;

/**
 Date
 */
@property (strong, nonatomic) NSString * stringDate;

@end

