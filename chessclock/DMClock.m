//
//  Clock.m
//  chessclock
//
//  Created by Dan McGinnis on 12-03-15.
//  Copyright (c) 2012 Dan McGinnis. All rights reserved.
//

#import "DMClock.h"

const NSTimeInterval DEFAULT_TOTAL_TIME = 60 * 10;

@interface DMClock ()

@property (strong) NSDate *turnStartDate;
@property (nonatomic) NSTimeInterval accumulatedTime;
@property (nonatomic) NSTimeInterval turnTimeAtPause;

- (DMClockTime) clockTimeFromInterval:(NSTimeInterval)interval;

@end


@implementation DMClock

#pragma mark -
#pragma mark State modification

- (DMClock *) init
{
    if ( self = [super init] ) {
        self.timeLimit = DEFAULT_TOTAL_TIME;
    }

    return self;
}


- (void)reset
{
    self.turnStartDate = nil;
    self.turnTimeAtPause = 0;
    self.accumulatedTime = 0;
}


#pragma mark -
#pragma mark Turn logic

- (void)start
{    
    self.turnStartDate = [NSDate date];
}


// Store the time interval that has elapsed since the start of this turn
- (void)pause
{
    // this will be negative since turnStartDate is in the past
    self.turnTimeAtPause = [self.turnStartDate timeIntervalSinceNow];

    self.turnStartDate = nil;
}


// Use the stored elapsed time interval to create a new 'fake' turn start date
- (void)resume
{
    // since turnTimeAtPause is negative, this will create a date in the past
    self.turnStartDate = [NSDate dateWithTimeIntervalSinceNow:self.turnTimeAtPause];

    self.turnTimeAtPause = 0;
}


- (void)stop
{
    // timeIntervalSinceNow will be negative since the receiver is in the past,
    // but we want the elapsed time -- i.e. a positive number
    self.accumulatedTime += fabs([self.turnStartDate timeIntervalSinceNow]);
    
    self.turnStartDate = nil;
    self.turnTimeAtPause = 0;
}


- (DMClockTime)remainingTime
{
    // turnTimeAtPause is negative because it's set from a timestamp in the past
    NSTimeInterval elapsedTurnTime = fabs([self.turnStartDate timeIntervalSinceNow]) + fabs(self.turnTimeAtPause);

    NSTimeInterval remainingTime = self.timeLimit - (self.accumulatedTime + elapsedTurnTime);

    return [self clockTimeFromInterval:remainingTime];
}


- (DMClockTime) clockTimeFromInterval:(NSTimeInterval)interval
{
    // XXX: should the clock be allowed to go below 0? this is lying right now
    if (interval < 0) {
        interval = 0;
    }

    DMClockTime time;

    time.minutes = (int)floor(interval / 60);

    time.seconds = (int)floor(interval - (60 * time.minutes));

    time.milliseconds = (int)floor(1000 * (interval - (60 * time.minutes + time.seconds)));

    time.totalSeconds = interval;

    return time;
}

@end
