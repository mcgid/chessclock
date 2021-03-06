//
//  DMBlackLostState.m
//  chessclock
//
//  Created by Dan on 2015-12-20.
//
//

#import "DMStates.h"

#import "DMGame.h"
#import "DMGameView.h"

@implementation DMBlackLostState

- (void)willExitWithNextState:(GKState *)nextState
{
    if ([nextState isKindOfClass:[DMConfirmResetState class]]) {
        [self.game.interface interfaceShouldTransitionFromBlackLostToConfirmReset:self];
    }
}

@end