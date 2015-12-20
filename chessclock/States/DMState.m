//
//  DMState.m
//  chessclock
//
//  Created by Dan on 2015-12-20.
//
//

#import "DMState.h"

@implementation DMState

- (instancetype)initWithGameView:(DMGameView *)gameView whiteClock:(DMClock *)whiteClock blackClock:(DMClock *)blackClock
{
    if (self = [super init]) {
        self.gameView = gameView;
        self.whiteClock = whiteClock;
        self.blackClock = blackClock;
    }

    return self;
}

- (instancetype) init
{
    return [self initWithGameView:nil whiteClock:nil blackClock:nil];
}

@end
