//
//  DMConfirmResetState.m
//  chessclock
//
//  Created by Dan on 2015-12-24.
//
//

#import "DMStates.h"

#import "DMGame.h"
#import "DMGameView.h"

@implementation DMConfirmResetState

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    [self.game.view showConfirmResetArea];
}

- (void)willExitWithNextState:(GKState *)nextState
{
    if ([nextState isKindOfClass:[DMNewGameState class]]) {
        [self.game.view resetPlayerButtonColors];
        [self.game.view disableBlackButton];
        [self.game.view hideResetButton];
    }

    [self.game.view hideConfirmResetArea];
}

@end