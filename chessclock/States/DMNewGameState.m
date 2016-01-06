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

- (void)willExitWithNextState:(GKState *)nextState
{
    if ([nextState isKindOfClass:[DMSettingsState class]]) {
        [self.game.interface interfaceShouldTransitionFromNewGameToSettings:self];
    } else if ([nextState isKindOfClass:[DMWhiteTurnState class]]) {
        [self.game.interface interfaceShouldTransitionFromNewGameToWhiteTurn:self];
    }
}

@end