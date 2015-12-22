//
//  DMStates.m
//  chessclock
//
//  Created by Dan on 2015-12-20.
//
//

#import "DMState.h"

@interface DMLoadingState : DMState
@end

@interface DMNewGameState : DMState
@end

@interface DMSettingsState : DMState
@end


@interface DMWhiteFirstTurnState : DMState
@end

@interface DMBlackFirstTurnState : DMState
@end


@interface DMWhiteTurnState : DMState
@end

@interface DMBlackTurnState : DMState
@end


@interface DMWhitePausedState : DMState
@end

@interface DMBlackPausedState : DMState
@end


@interface DMBlackLostState : DMState
@end

@interface DMWhiteLostState : DMState
@end
