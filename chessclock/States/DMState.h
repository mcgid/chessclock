//
//  DMState.h
//  chessclock
//
//  Created by Dan on 2015-12-20.
//
//

@import UIKit;
@import GameplayKit;

#import "DMGameView.h"
#import "DMClock.h"

@interface DMState : GKState

@property (weak) DMGameView *gameView;
@property (weak) DMClock *whiteClock;
@property (weak) DMClock *blackClock;

// Designated initializer
- (instancetype)initWithGameView:(DMGameView *)gameView whiteClock:(DMClock *)whiteClock blackClock:(DMClock *)blackClock;

@end
