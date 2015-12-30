//
//  DMState.m
//  chessclock
//
//  Created by Dan on 2015-12-20.
//
//

#import "DMState.h"

@implementation DMState

- (instancetype)initWithGame:(DMGame *)game
{
    if (self = [super init]) {
        _game = game;
    }

    return self;
}

- (instancetype) init
{
    return [self initWithGame:nil];
}

@end
