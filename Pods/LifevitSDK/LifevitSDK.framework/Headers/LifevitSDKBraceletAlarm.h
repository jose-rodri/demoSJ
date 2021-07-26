//
//  LifevitBraceletAlarm.h
//  LifevitSDK
//
//  Created by David Casas on 5/9/17.
//  Copyright © 2017 LifeVit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LifevitSDKBraceletAlarm : NSObject

@property BOOL secondaryAlarm;
@property BOOL monday;
@property BOOL tuesday;
@property BOOL wednesday;
@property BOOL thursday;
@property BOOL friday;
@property BOOL saturday;
@property BOOL sunday;
@property (strong, nonatomic) NSNumber* hour;
@property (strong, nonatomic) NSNumber* minute;
@end
