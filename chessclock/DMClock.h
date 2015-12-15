//
//  Clock.h
//  chessclock
//
//  Created by Dan McGinnis on 12-03-15.
//  Copyright (c) 2012 Dan McGinnis. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DMClock;

typedef struct {
    int minutes;
    int seconds;
    int milliseconds;
    NSTimeInterval totalSeconds;
} DMClockTime;

@interface DMClock : NSObject

@property (nonatomic) NSTimeInterval timeLimit;

- (void)reset;

- (void)start;
- (void)pause;
- (void)resume;
- (void)stop;

- (DMClockTime) remainingTime;

@end
