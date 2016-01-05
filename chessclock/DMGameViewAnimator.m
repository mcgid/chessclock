//
//  DMGameViewAnimator.m
//  chessclock
//
//  Created by Dan on 2016-01-05.
//
//

#import "DMGameViewAnimator.h"

@implementation DMGameViewAnimator

#pragma mark Initialization

- (instancetype)init
{
    return [self initWithView:nil];
}

- (instancetype)initWithView:(DMGameView *)view
{
    self = [super init];

    if (self) {
        _view = view;
    }

    return self;
}

#pragma mark From Loading state

- (void)transitionFromLoadingToNewGame
{
}

- (void)transitionFromLoadingToSettings
{
}

- (void)transitionFromLoadingToPaused
{
}

- (void)transitionFromLoadingToConfirmReset
{
}

- (void)transitionFromLoadingToWhiteLost
{
}

- (void)transitionFromLoadingToBlackLost
{
}


#pragma mark From NewGame state

- (void)transitionFromNewGameToSettings
{
}

- (void)transitionFromNewGameToWhiteTurn
{
}


#pragma mark From Settings state

- (void)transitionFromSettingsToNewGame
{
}


#pragma mark From WhiteTurn state

- (void)transitionFromWhiteTurnToWhiteLost
{
}

- (void)transitionFromWhiteTurnToPaused
{
}

- (void)transitionFromWhiteTurnToBlackTurn
{
}


#pragma mark From BlackTurn state

- (void)transitionFromBlackTurnToBlackLost
{
}

- (void)transitionFromBlackTurnToPaused
{
}

- (void)transitionFromBlackTurnToWhiteTurn
{
}


#pragma mark From Paused state

- (void)transitionFromPausedToWhiteTurn
{
}

- (void)transitionFromPausedToBlackTurn
{
}

- (void)transitionFromPausedToConfirmReset
{
}


#pragma mark From WhiteLost state

- (void)transitionFromWhiteLostToConfirmReset
{
}


#pragma mark From WhiteLost state

- (void)transitionFromBlackLostToConfirmReset
{
}


#pragma mark From ConfirmReset state

- (void)transitionFromConfirmResetToWhiteLost
{
}

- (void)transitionFromConfirmResetToBlackLost
{
}

- (void)transitionFromConfirmResetToPaused
{
}

- (void)transitionFromConfirmResetToNewGame
{
}


@end
