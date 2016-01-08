//
//  DMNewGameState.m
//  chessclock
//
//  Created by Dan on 2015-12-20.
//
//

#import "DMStates.h"

#import "DMGame.h"
#import "DMGameView.h"

@implementation DMNewGameState

- (void)didEnterWithPreviousState:(GKState *)previousState
{
    [self.game.white reset];
    [self.game.black reset];

    [self.game.interface interfaceShouldUpdateWithWhiteTime:[self.game.white remainingTime]];
    [self.game.interface interfaceShouldUpdateWithBlackTime:[self.game.black remainingTime]];
}

- (void)willExitWithNextState:(GKState *)nextState
{
    if ([nextState isKindOfClass:[DMSettingsState class]]) {
        [self.game.interface interfaceShouldTransitionFromNewGameToSettings:self];
    } else if ([nextState isKindOfClass:[DMWhiteTurnState class]]) {
        [self.game.interface interfaceShouldTransitionFromNewGameToWhiteTurn:self];
    }
}

@end