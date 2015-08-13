//
//  DuiDuiPengGameScene.m
//  HappyStudy
//
//  Created by Quan on 14/10/22.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "DuiDuiPengGameScene.h"
#import "GameSelectScene.h"
#import "HSButtonSprite.h"
#import "DDPPinYin.h"
#import "DDPHanZi.h"
#import "DDPMgr.h"
#import "AccountMgr.h"
#import "DDPGroupModel.h"
#import "PinYinModel.h"
#import "HanZiModel.h"
#import "GlobalUtil.h"
#import "DDPHttpReqMgr.h"
#import "AppDelegate.h"
#import "HSError.h"
#import "GlobalUtil.h"

#define kLeftButton @"leftButton"
#define kRightButton @"rightButton"
#define kBackButton @"backButton"

@interface DuiDuiPengGameScene ()

@property (strong, nonatomic) NSMutableArray *cards;
@property (strong, nonatomic) NSMutableArray *toDestroyCards;
@property (strong, nonatomic) NSMutableArray *selectCharacters;
@property (strong, nonatomic) NSMutableArray *cardPosistions;

@property (strong, nonatomic) SKTexture *bubbleTexture;
@property (strong, nonatomic) NSDate *timingDate;
@property (nonatomic) NSInteger count;

@end

@implementation DuiDuiPengGameScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        _cards = [[NSMutableArray alloc] init];
        _toDestroyCards = [[NSMutableArray alloc] init];
        _selectCharacters = [[NSMutableArray alloc] init];
        _cardPosistions = [@[@(1), @(2), @(3), @(4), @(5), @(6), @(7), @(8)] mutableCopy];
        self.scrollWorld = YES;
        
        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"Environment"];
        self.bubbleTexture = [atlas textureNamed:@"bubble"];
    }
    
    return self;
}

- (void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    
    self.pageCount = [DDPMgr sharedInstance].ddpModels.count;
    [self buildWorld];
    [self playBackgroundMusic];
    [self spawnStars];
}

- (void)willMoveFromView:(SKView *)view {
    [super willMoveFromView:view];
}

- (void)addBackground {
    SKSpriteNode *bgNode = [SKSpriteNode spriteNodeWithImageNamed:@"duiduipent_game_bg"];
    bgNode.anchorPoint = CGPointZero;
    bgNode.position = CGPointZero;
    bgNode.size = self.size;
    [self addNode:bgNode atWorldLayer:HSSWorldLayerGround];
}

- (void)addEnvironment {
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"DDPFlower"];
    SKSpriteNode *flower = [SKSpriteNode spriteNodeWithTexture:[atlas textureNamed:@"ddpflower_0001"]];
    flower.anchorPoint = CGPointZero;
    flower.position = CGPointMake(0, 0);
    flower.zPosition = 100;
    [self addNode:flower atWorldLayer:HSSWorldLayerGround];
    
    SKAction *action = [SKAction animateWithTextures:flowerAnimationFrames
                                        timePerFrame:1 / 5.
                                              resize:NO
                                             restore:NO];
    [flower runAction:[SKAction repeatActionForever:action]];
}

- (void)addControllers {
    HSButtonSprite *leftNode = [[HSButtonSprite alloc] initWithTitle:nil
                                                            norImage:@"pre_page_nor"
                                                            selImage:@"pre_page_sel"];
    leftNode.position = CGPointMake(815, 102);
    leftNode.name = kLeftButton;
    [self addNode:leftNode atWorldLayer:HSSWorldLayerControl];
    [self.buttons addObject:leftNode];
    
    HSButtonSprite *rightNode = [[HSButtonSprite alloc] initWithTitle:nil
                                                             norImage:@"next_page_nor"
                                                             selImage:@"next_page_sel"];
    rightNode.position = CGPointMake(946, 102);
    rightNode.name = kRightButton;
    [self addNode:rightNode atWorldLayer:HSSWorldLayerControl];
    [self.buttons addObject:rightNode];
    
    HSButtonSprite *backNode = [[HSButtonSprite alloc] initWithTitle:nil
                                                            norImage:@"back_nor"
                                                            selImage:@"back_sel"];
    backNode.position = CGPointMake(280, 102);
    backNode.name = kBackButton;
    [self addNode:backNode atWorldLayer:HSSWorldLayerControl];
    [self.buttons addObject:backNode];
}

- (void)addStar {
    // 随即大小
    CGFloat standardSize = 20.;
    int minScale = 1.0 * standardSize;
    int maxScale = 2.0 * standardSize;
    int randomScale = (arc4random() % (maxScale - minScale)) + minScale;
    // 随即位置
    int minX = randomScale / 2;
    int maxX = self.size.width - randomScale / 2;
    int randomX = (arc4random() % (maxX - minX)) + minX;
    // 随即时间
    int minDuration = 3;
    int maxDuration = 6;
    int randomDuration = (arc4random() % (maxDuration - minDuration)) + minDuration;
    
    SKSpriteNode *star = [SKSpriteNode spriteNodeWithTexture:self.bubbleTexture
                                                        size:CGSizeMake(randomScale, randomScale)];
    star.position = CGPointMake(randomX, -(randomScale + 50));
    star.zPosition = 200;
    [self addNode:star atWorldLayer:HSSWorldLayerGround];
    
    SKAction *rotateOnceAction = [SKAction rotateByAngle:2 * M_PI duration:1.];
    SKAction *rotateAction = [SKAction repeatActionForever:rotateOnceAction];
    [star runAction:rotateAction];
    SKAction *moveAction = [SKAction moveByX:0. y:self.size.height + 50 + randomScale duration:randomDuration];
    SKAction *doneAction = [SKAction runBlock:^{
        [star removeFromParent];
    }];
    
    [star runAction:[SKAction sequence:@[moveAction, doneAction]]];
}

- (void)buildWorld {
    [self addBackground];
    [self addEnvironment];
    [self addControllers];
    [self addCharacters:0];
}

- (void)checkMatch {
    if (self.selectCharacters.count < 2) {
        return;
    }
    
    DDPCharacter *character1 = self.selectCharacters[0];
    DDPCharacter *character2 = self.selectCharacters[1];
    if ([character1.matchKey isEqualToString:character2.matchKey]) {
        // Match
        [self playSoundCorrect];
        character1.requestedAnimation = HSAnimationStateDeath;
        character2.requestedAnimation = HSAnimationStateDeath;
        [self.selectCharacters removeAllObjects];
    }
    else {
        // Not match
        [self playSoundWrong];
        character1.selected = NO;
        character2.selected = NO;
        [self.selectCharacters removeAllObjects];
    }
}

- (void)playBackgroundMusic {
    [[SettingMgr sharedInstance] startBackgroundMusicWithName:@"duiduipeng_game_bg.mp3"];
}

- (void)playSound:(NSString *)soundName {
    if (!soundName || ![GlobalUtil soundFileExist:soundName]) {
        return;
    }
    
    [self runAction:[SKAction playSoundFileNamed:soundName waitForCompletion:YES]];
}

- (CGPoint)positionWithIndex:(NSInteger)index {
    if (index >= self.cardPosistions.count) {
        return CGPointZero;
    }
    NSInteger pos = [self.cardPosistions[index] integerValue];
    NSInteger row = (pos - 1) / 4;
    NSInteger column = (pos - 1) % 4;
    
    return CGPointMake(226 + column * 194, 272 + row * 214);
}

- (void)removeCharacter:(DDPCharacter *)character {
    if ([self.cards containsObject:character]) {
        [self.cards removeObject:character];
    }
    
    if (self.cards.count == 0) {
        [self animationCorrect:nil];
        
        DDPGroupModel *gModel = [DDPMgr sharedInstance].ddpModels[self.curIndex];
        NSInteger spendTime = [[NSDate date] timeIntervalSinceDate:self.timingDate];
        [HttpReqMgr requestSubmit:[AccountMgr sharedInstance].user.name
                             game:StudyGameDuiDuiPeng
                            theID:gModel.modelID
                        spendTime:spendTime
                         clickNum:self.clickCount
                       completion:nil
                          failure:nil];
        
        if (self.curIndex == [DDPMgr sharedInstance].ddpModels.count - 1) {
            if ([DDPMgr sharedInstance].curGroupCount > 0) {
                [self clickRight:nil];
            }
            else {
                [self finishAll];
            }
            
            return;
        }
        self.curIndex++;
    }
}

- (void)spawnStars {
    SKAction *addAction = [SKAction runBlock:^{
        [self addStar];
    }];
    SKAction *waitAction = [SKAction waitForDuration:1.5];
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[addAction, waitAction]]]];
}

+ (void)loadEnvironmentAssets {
    flowerAnimationFrames = [GlobalUtil loadFramesFromAtlas:@"DDPFlower"
                                               baseFileName:@"ddpflower_"
                                                   frameNum:3];
}

#pragma mark - Override
+ (void)loadSceneAssets {
    [DDPPinYin loadAssets];
    [DDPHanZi loadAssets];
    [self loadEnvironmentAssets];
}

+ (void)releaseSceneAssets {
    flowerAnimationFrames = nil;
}

+ (void)loadGameDataFrom:(NSInteger)fromPos count:(NSInteger)count Complete:(void (^)(void))complete failure:(void (^)(NSDictionary *))failure {
    if (fromPos == 0) {
        [[DDPMgr sharedInstance].ddpModels removeAllObjects];
    }
    
    [DDPHttpReqMgr requestGetGameData:[AccountMgr sharedInstance].user.name
                                 from:fromPos
                                count:count
                           completion:^(NSDictionary *info) {
                               if ([DDPMgr sharedInstance].ddpModels.count == 0) {
                                   if (failure) {
                                       HSError *error = [HSError errorWith:HSHttpErrorCodeNoData];
                                       failure(@{@"error": error});
                                   }
                               }
                               else {
                                   if (complete) {
                                       complete();
                                   }
                               }
                           } failure:^(HSError *error) {
                               if (failure) {
                                   NSDictionary *dict;
                                   if (error.message) {
                                       dict = @{@"code": @(error.code), @"message": error.message};
                                   }
                                   failure(dict);
                               }
                           }];
}

- (void)addCharacters:(NSInteger)index {
    [self.selectCharacters removeAllObjects];
    
    if (self.cards.count > 0) {
        [self.toDestroyCards addObjectsFromArray:self.cards];
        [self.cards removeAllObjects];
    }
    
    if ([DDPMgr sharedInstance].ddpModels.count == 0 ||
        [DDPMgr sharedInstance].ddpModels.count <= index) {
        return;
    }
    
    [GlobalUtil randomArray:self.cardPosistions];
    NSInteger posIndex = 0;
    DDPGroupModel *groupModel = [DDPMgr sharedInstance].ddpModels[index];
    for (PinYinModel *pinyin in groupModel.pyModels) {
        CGPoint pos = [self positionWithIndex:posIndex];
        DDPPinYin *pinyinNode = [[DDPPinYin alloc] initWithString:pinyin.title
                                                        soundName:pinyin.soundName
                                                         matchKey:pinyin.matchKey
                                                         position:CGPointMake(pos.x + index * self.size.width,
                                                                              pos.y)];
        pinyinNode.label.fontName = FONT_NAME_AM;
        [self addNode:pinyinNode atWorldLayer:HSSWorldLayerCharacter];
        [self.cards addObject:pinyinNode];
        posIndex++;
    }
    for (HanZiModel *hanzi in groupModel.hzModels) {
        CGPoint pos = [self positionWithIndex:posIndex];
        DDPHanZi *hanziNode = [[DDPHanZi alloc] initWithString:hanzi.title
                                                      matchKey:hanzi.matchKey
                                                      position:CGPointMake(pos.x + index * self.size.width,
                                                                           pos.y)];
        hanziNode.label.fontName = FONT_NAME_CUTOON;
        [self addNode:hanziNode atWorldLayer:HSSWorldLayerCharacter];
        [self.cards addObject:hanziNode];
        posIndex++;
    }
}

- (void)destroyCharacters {
    if (self.toDestroyCards.count > 0) {
        for (SKNode *node in self.toDestroyCards) {
            [node removeFromParent];
        }
        [self.toDestroyCards removeAllObjects];
    }
}

- (NSString *)indexStringWith:(NSInteger)index {
    DDPGroupModel *model = [DDPMgr sharedInstance].ddpModels[index];
    return model.indexStr;
}

- (NSInteger)currentTotalCount {
    return [DDPMgr sharedInstance].ddpModels.count;
}

- (void)loadMore {
    if ([DDPMgr sharedInstance].curGroupCount > 0) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        [DuiDuiPengGameScene loadGameDataFrom:[DDPMgr sharedInstance].curGroupCount - 1
                                        count:1000
                                     Complete:^{
                                         [SVProgressHUD dismiss];
                                         [self expandIndexController];
//                                         self.curIndex++;
                                     } failure:^(NSDictionary *info) {
                                         [SVProgressHUD dismiss];
                                     }];
    }
}

#pragma mark - Actions
- (void)clickBack:(id)sender {
    [[DDPMgr sharedInstance].ddpModels removeAllObjects];
    GameSelectScene *scene = [[GameSelectScene alloc] initWithSize:self.size];
    [self.view presentScene:scene];
}

- (void)clickLeft:(id)sender {
    NSInteger index = self.curIndex;
    index--;
    if (index < 0) {
        index = 0;
    }
    
    self.curIndex = index;
}

- (void)clickRight:(id)sender {
    NSInteger index = self.curIndex;
    index++;
    if (index > [DDPMgr sharedInstance].ddpModels.count - 1) {
        if ([DDPMgr sharedInstance].curGroupCount > 0) {
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
            [DuiDuiPengGameScene loadGameDataFrom:[DDPMgr sharedInstance].curGroupCount - 1
                                            count:1000
                                         Complete:^{
                                             [SVProgressHUD dismiss];
                                             [self expandIndexController];
                                             self.curIndex = index;
                                         } failure:^(NSDictionary *info) {
                                             [SVProgressHUD dismiss];
                                         }];
            return;
        }
        else {
            index = [DDPMgr sharedInstance].ddpModels.count - 1;
        }
    }
    
    self.curIndex = index;
}

- (void)clickCharacter:(DDPCharacter *)character {
    [self playSound:@"click_card.wav"];
    
    self.clickCount++;
    character.selected = YES;
    if (![self.selectCharacters containsObject:character]) {
        [self.selectCharacters addObject:character];
        [self checkMatch];
    }
}

#pragma mark - Loop
- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)interval {
    for (DDPCharacter *character in self.cards) {
        [character updateWithTimeSinceLastUpdate:interval];
    }
}

#pragma mark - Touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint loc = [touch locationInNode:self];
    
    SKNode *node = [self nodeAtPoint:loc];
    NSString *buttonName = node.name;
    [self setButtonSelectState:buttonName];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    CGPoint loc = [touch locationInNode:self];
    
    SKNode *node = [self nodeAtPoint:loc];
    if ([node.name isEqualToString:kLeftButton]) {
        [self clickLeft:node];
    }
    else if ([node.name isEqualToString:kRightButton]) {
        [self clickRight:node];
    }
    else if ([node.name isEqualToString:kBackButton]) {
        [self clickBack:node];
    }
    
    [self setButtonSelectState:nil];
}

#pragma mark - Animations
static NSArray *flowerAnimationFrames = nil;
- (NSArray *)flowerAnimationFrames {
    return flowerAnimationFrames;
}

@end
