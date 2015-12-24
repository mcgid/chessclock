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


@interface DMPausedState : DMState
@end

@interface DMConfirmResetState : DMState
@end


@interface DMBlackLostState : DMState
@end

@interface DMWhiteLostState : DMState
@end
