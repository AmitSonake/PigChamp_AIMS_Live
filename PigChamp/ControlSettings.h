//
//  ControlSettings.h
//  Classifields
//
//  Created by Mangesh KArekar on 25/11/14.
//  Copyright (c) 2014 VentureLabour. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "AppDelegate.h"
//#import "LocalizationSystem.h"
//#import "APParser.h"

@interface ControlSettings : NSObject
{
        NSTimer     * idleTimer;
}


+ (ControlSettings *) sharedSettings;


// FUNCTIONS

// check internet connection
-(BOOL)isNetConnected;

// get current date in  MM/DD/YYYY
//-(NSString*)getDateinMMDDYY;
//-(NSString*)getDateinDDMMYY;

// MM DD YY ,DD MM YY,
//-(NSString*)convertDateToSelectedFormat:(NSString*)dateToConvert;


// hex string to UIColor
//- (UIColor *)colorWithHexString:(NSString *)stringToConvert;

// Return Alert View

//-(void)showAlertViewWithMessage:(NSString*)message andTitle:(NSString*)title;

// Return Check internet Alert

//-(void)showCheckInternetAlert;


// Session timer

-(void)resetTimer;
-(void)idleTimerExceeded;


@end
