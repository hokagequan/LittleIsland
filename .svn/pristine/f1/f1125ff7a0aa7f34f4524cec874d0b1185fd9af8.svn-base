//
//  HSScrollGameScene.h
//  HappyStudy
//
//  Created by Q on 14/10/28.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "HSGameScene.h"

typedef enum {
    HSSWorldLayerGround = 0,
    HSSWorldLayerSky = 100,
    HSSWorldLayerCharacter = 200,
    HSSWorldLayerControl = 300,
    HSSWorldLayerCount
}HSSWorldLayer;

@interface HSScrollGameScene : HSGameScene

// 统计
@property (strong, nonatomic) NSDate *timingDate;
@property (nonatomic) NSInteger clickCount;

@property (nonatomic) NSInteger pageCount;
@property (nonatomic) NSInteger curIndex;
@property (nonatomic) BOOL scrollWorld;

- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)interval;

- (void)addNode:(SKNode *)node atWorldLayer:(HSSWorldLayer)layer;
- (SKNode *)layerWith:(HSSWorldLayer)layerID;
- (void)animationCorrect:(SKNode *)node;
- (void)playSoundWrong;
- (void)playSoundCorrect;
- (void)expandIndexController;
- (void)startFromBegain;
- (void)finishAll;

- (void)clickBack:(id)sender;
- (void)addCharacters:(NSInteger)index;
- (void)destroyCharacters;
- (NSString *)indexStringWith:(NSInteger)index;
- (void)refreshScore;
- (void)resetAnalyze;
- (NSInteger)currentTotalCount;
- (void)loadMore;

@end
