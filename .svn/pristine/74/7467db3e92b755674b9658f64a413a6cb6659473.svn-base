//
//  ChooseGameScene.m
//  HappyStudy
//
//  Created by Q on 14-10-14.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "ChooseGameScene.h"
#import "GameSelectScene.h"
#import "HSButtonSprite.h"
#import "CGQuestion.h"
#import "CGBallonBlue.h"
#import "CGBallonYellow.h"
#import "CGBallonGreen.h"
#import "CGBallonRed.h"
#import "CGMgr.h"
#import "AccountMgr.h"
#import "CGHttpReqMgr.h"
#import "AppDelegate.h"

#define kLeftButton @"leftButton"
#define kRightButton @"rightButton"
#define kSoundButton @"soundButton"
#define kBackButton @"backButton"

@interface ChooseGameScene ()

//@property (strong, nonatomic) NSMutableArray *questionCharacters;
@property (strong, nonatomic) CGQuestion *question;
@property (strong, nonatomic) NSMutableArray *optionCharacters;
//@property (strong, nonatomic) NSMutableArray *toDestroyQuestions;
//@property (strong, nonatomic) NSMutableArray *toDestroyOptions;
@property (strong, nonatomic) NSArray *optionPositions;

@property (strong, nonatomic) SKSpriteNode *nearCloud;
@property (strong, nonatomic) SKSpriteNode *farCloud;
@property (strong, nonatomic) SKTexture *bubbleTexture;

@end

@implementation ChooseGameScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        //        _questionCharacters = [[NSMutableArray alloc] init];
        _optionCharacters = [[NSMutableArray alloc] init];
        //        _toDestroyQuestions = [[NSMutableArray alloc] init];
        //        _toDestroyOptions = [[NSMutableArray alloc] init];
        
        SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"Environment"];
        self.bubbleTexture = [atlas textureNamed:@"bubble"];
        
        NSValue *ballonPos1 = [NSValue valueWithCGPoint:CGPointMake(426, 230)];
        NSValue *ballonPos2 = [NSValue valueWithCGPoint:CGPointMake(592, 230)];
        NSValue *ballonPos3 = [NSValue valueWithCGPoint:CGPointMake(796, 230)];
        NSValue *ballonPos4 = [NSValue valueWithCGPoint:CGPointMake(898, 230)];
        _optionPositions = [[NSArray alloc] initWithObjects:
                            ballonPos1,
                            ballonPos2,
                            ballonPos3,
                            ballonPos4, nil];
    }
    
    return self;
}

- (void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    self.pageCount = [CGMgr sharedInstance].chooseModels.count;
    
    [self buildWorld];
    [self playBackgroundMusic];
    [self startAnimations];
    [self spawnStars];
}

- (void)willMoveFromView:(SKView *)view {
    [super willMoveFromView:view];
}

- (void)addBackground {
    SKSpriteNode *bgNode = [SKSpriteNode spriteNodeWithImageNamed:@"choose_game_bg"];
    bgNode.anchorPoint = CGPointZero;
    bgNode.position = CGPointZero;
    bgNode.size = self.size;
    [self addNode:bgNode atWorldLayer:HSSWorldLayerGround];
}

- (void)addEnvironment {
    _farCloud = [SKSpriteNode spriteNodeWithImageNamed:@"game_sel_cloud_far"];
    _farCloud.position = CGPointMake(self.size.width / 2 + 380, 700);
    [self addNode:_farCloud atWorldLayer:HSSWorldLayerSky];
    
    _nearCloud = [SKSpriteNode spriteNodeWithImageNamed:@"game_sel_cloud_near"];
    _nearCloud.position = CGPointMake(self.size.width / 2, 680);
    [self addNode:_nearCloud atWorldLayer:HSSWorldLayerSky];
}

- (void)addControllers {
    HSButtonSprite *leftNode = [[HSButtonSprite alloc] initWithTitle:nil
                                                            norImage:@"pre_page_nor"
                                                            selImage:@"pre_page_sel"];
    leftNode.position = CGPointMake(765, 102);
    leftNode.name = kLeftButton;
    [self addNode:leftNode atWorldLayer:HSSWorldLayerControl];
    [self.buttons addObject:leftNode];
    
    HSButtonSprite *rightNode = [[HSButtonSprite alloc] initWithTitle:nil
                                                             norImage:@"next_page_nor"
                                                             selImage:@"next_page_sel"];
    rightNode.position = CGPointMake(896, 102);
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
    
    HSButtonSprite *soundNode = [[HSButtonSprite alloc] initWithTitle:nil
                                                             norImage:@"sound_nor"
                                                             selImage:@"sound_sel"];
    soundNode.position = CGPointMake(98, 308);
    soundNode.name = kSoundButton;
    [self addNode:soundNode atWorldLayer:HSSWorldLayerControl];
    [self.buttons addObject:soundNode];
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

- (Class)ballonClass:(NSInteger)index {
    switch (index) {
        case 0:
            return [CGBallonBlue class];
        case 1:
            return [CGBallonYellow class];
        case 2:
            return [CGBallonGreen class];
        case 3:
            return [CGBallonRed class];
            
        default:
            break;
    }
    
    return [CGOption class];
}

- (void)buildWorld {
    [self addBackground];
    [self addEnvironment];
    [self addCharacters:0];
    [self addControllers];
}

- (void)chooseCorrect:(CGOption *)optionSp {
    CGChooseModel *cModel = [CGMgr sharedInstance].chooseModels[self.curIndex];
    NSInteger spendTime = [[NSDate date] timeIntervalSinceDate:self.timingDate];
    [HttpReqMgr requestSubmit:[AccountMgr sharedInstance].user.name
                         game:StudyGameChoose
                        theID:cModel.modelID
                    spendTime:spendTime
                     clickNum:self.clickCount
                   completion:nil
                      failure:nil];
    
    [AccountMgr sharedInstance].user.score++;
    if ([self.optionCharacters containsObject:optionSp]) {
        [self.optionCharacters removeObject:optionSp];
    }
    [self playSoundCorrect];
    [self animationCorrect:optionSp];
}

- (void)chooseWrong:(CGOption *)option {
    [self playSoundWrong];
    [option animationWrong];
}

- (void)playBackgroundMusic {
    [[SettingMgr sharedInstance] startBackgroundMusicWithName:@"choose_game_bg.mp3"];
}

- (void)playSound:(CGQuestion *)questionSp {
    [questionSp playSound];
}

- (void)startAnimations {
    [self startEnvironmentAnimations];
}

- (void)startEnvironmentAnimations {
    SKAction *nearMove = [SKAction moveByX:-(self.size.width + 2 * self.nearCloud.size.width) y:0 duration:15];
    SKAction *nearDone = [SKAction runBlock:^{
        self.nearCloud.position = CGPointMake(self.size.width + self.nearCloud.size.width,
                                              self.nearCloud.position.y);
    }];
    SKAction *nearAction = [SKAction sequence:@[nearMove, nearDone]];
    [self.nearCloud runAction:[SKAction repeatActionForever:nearAction]];
    
    SKAction *farMove = [SKAction moveByX:-(self.size.width + 2 * self.farCloud.size.width) y:0 duration:20];
    SKAction *farDone = [SKAction runBlock:^{
        self.farCloud.position = CGPointMake(self.size.width + self.farCloud.size.width,
                                             self.farCloud.position.y);
    }];
    SKAction *farAction = [SKAction sequence:@[farMove, farDone]];
    [self.farCloud runAction:[SKAction repeatActionForever:farAction]];
}

- (void)spawnStars {
    SKAction *addAction = [SKAction runBlock:^{
        [self addStar];
    }];
    SKAction *waitAction = [SKAction waitForDuration:1.5];
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[addAction, waitAction]]]];
}

#pragma mark - Override
+ (void)loadSceneAssets {
    [CGBallonBlue loadAssets];
    [CGBallonYellow loadAssets];
    [CGBallonGreen loadAssets];
    [CGBallonRed loadAssets];
}

+ (void)releaseSceneAssets {
    [CGBallonBlue releaseAssets];
    [CGBallonYellow releaseAssets];
    [CGBallonGreen releaseAssets];
    [CGBallonRed releaseAssets];
}

+ (void)loadGameDataFrom:(NSInteger)fromPos count:(NSInteger)count Complete:(void (^)(void))complete failure:(void (^)(NSDictionary *))failure {
    if (fromPos == 0) {
        [[CGMgr sharedInstance].chooseModels removeAllObjects];
    }
    
    [CGHttpReqMgr requestGetGameData:[AccountMgr sharedInstance].user.name
                                from:fromPos
                               count:count
                          completion:^(NSDictionary *info) {
                              if ([CGMgr sharedInstance].chooseModels.count == 0) {
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
                                  failure(@{@"error": error});
                              }
                          }];
}

- (void)addCharacters:(NSInteger)index {
    //    if (self.optionCharacters.count > 0) {
    //        [self.toDestroyOptions addObjectsFromArray:self.optionCharacters];
    //        [self.optionCharacters removeAllObjects];
    //    }
    //    if (self.questionCharacters.count > 0) {
    //        [self.toDestroyQuestions addObjectsFromArray:self.questionCharacters];
    //        [self.questionCharacters removeAllObjects];
    //    }
    //
    //    if ([CGMgr sharedInstance].chooseModels.count == 0 ||
    //        index >= [CGMgr sharedInstance].chooseModels.count) {
    //        return;
    //    }
    //
    //    CGChooseModel *chooseModel = [CGMgr sharedInstance].chooseModels[index];
    //    CGQuestion *questionSp = [[CGQuestion alloc] initWithString:chooseModel.question.title
    //                                                      soundName:chooseModel.question.soundName
    //                                                       position:CGPointMake(190 + index * self.size.width, 459)];
    //    [self addNode:questionSp atWorldLayer:HSSWorldLayerCharacter];
    //    [self.questionCharacters addObject:questionSp];
    //
    //    for (int j = 0; j < chooseModel.options.count; j++) {
    //        CGOptionModel *optionModel = chooseModel.options[j];
    //        CGPoint pos = [self.optionPositions[j] CGPointValue];
    //        CGOption *ballon = [[[self ballonClass:(j % 4)] alloc] initWithString:optionModel.title
    //                                                                     position:CGPointMake(pos.x + index * self.size.width, pos.y)
    //                                                                     isAnswer:optionModel.isAnswer];
    //        ballon.requestedAnimation = HSAnimationStateIdle;
    //        [self addNode:ballon atWorldLayer:HSSWorldLayerCharacter];
    //        [self.optionCharacters addObject:ballon];
    //    }
    
    if ([CGMgr sharedInstance].chooseModels.count == 0 ||
        index >= [CGMgr sharedInstance].chooseModels.count) {
        return;
    }
    
    CGChooseModel *chooseModel = [CGMgr sharedInstance].chooseModels[index];
    
    if (!self.question) {
        self.question = [[CGQuestion alloc] initWithString:chooseModel.question.title
                                                 soundName:chooseModel.question.soundName
                                                  position:CGPointMake(190, 459)];
        [self addNode:self.question atWorldLayer:HSSWorldLayerCharacter];
        
        for (int j = 0; j < chooseModel.options.count; j++) {
            CGOptionModel *optionModel = chooseModel.options[j];
            CGPoint pos = [self.optionPositions[j] CGPointValue];
            CGOption *ballon = [[[self ballonClass:(j % 4)] alloc] initWithString:optionModel.title
                                                                         position:CGPointMake(pos.x, pos.y)
                                                                         isAnswer:optionModel.isAnswer];
            ballon.requestedAnimation = HSAnimationStateIdle;
            [self addNode:ballon atWorldLayer:HSSWorldLayerCharacter];
            [self.optionCharacters addObject:ballon];
        }
        SKAction *wait = [SKAction waitForDuration:1];
        SKAction *done = [SKAction runBlock:^{
            [self.question playSound];
        }];
        
        SKNode *layer = [self layerWith:HSSWorldLayerCharacter];
        [layer runAction:[SKAction sequence:@[wait, done]] withKey:@"ChangeQuestion"];
    }
    else {
        SKNode *layer = [self layerWith:HSSWorldLayerCharacter];
        
        if ([layer actionForKey:@"ChangeQuestion"]) {
            [layer removeActionForKey:@"ChangeQuestion"];
        }
        
        SKAction *fadeIn = [SKAction fadeInWithDuration:0.6];
        SKAction *fadeOut = [SKAction fadeOutWithDuration:0.6];
        SKAction *changeContent = [SKAction runBlock:^{
            self.question.label.text = chooseModel.question.title;
            self.question.soundName = chooseModel.question.soundName;
            
            for (CGOption *ballon in self.optionCharacters) {
                [ballon removeFromParent];
            }
            
            if (self.optionCharacters.count > 0) {
                [self.optionCharacters removeAllObjects];
            }
            
            for (int j = 0; j < chooseModel.options.count; j++) {
                CGOptionModel *optionModel = chooseModel.options[j];
                CGPoint pos = [self.optionPositions[j] CGPointValue];
                CGOption *ballon = [[[self ballonClass:(j % 4)] alloc] initWithString:optionModel.title
                                                                             position:CGPointMake(pos.x, pos.y)
                                                                             isAnswer:optionModel.isAnswer];
                ballon.requestedAnimation = HSAnimationStateIdle;
                [self addNode:ballon atWorldLayer:HSSWorldLayerCharacter];
                [self.optionCharacters addObject:ballon];
            }
        }];
        SKAction *wait = [SKAction waitForDuration:0.25];
        SKAction *done = [SKAction runBlock:^{
            [self.question playSound];
        }];
        
        [layer runAction:[SKAction sequence:@[fadeOut, changeContent, fadeIn, wait, done]] withKey:@"ChangeQuestion"];
    }
}

- (void)animationCorrect:(SKNode *)node {
    SKAction *move = [SKAction moveTo:CGPointMake(70, 700) duration:0.5];
    SKAction *zoomIn = [SKAction scaleTo:0. duration:0.5];
    SKAction *group = [SKAction group:@[move, zoomIn]];
    [node runAction:group completion:^{
        [node removeFromParent];
        [self refreshScore];
        if (self.curIndex == [CGMgr sharedInstance].chooseModels.count - 1) {
            if ([CGMgr sharedInstance].curGroupCount > 0) {
                [self clickRight:nil];
            }
            else {
                [self finishAll];
            }
            
        }
        else {
            self.curIndex++;
        }
    }];
}

- (void)destroyCharacters {
    //    for (CGOption *character in self.toDestroyOptions) {
    //        [character removeFromParent];
    //    }
    //    for (CGOption *character in self.toDestroyQuestions) {
    //        [character removeFromParent];
    //    }
    //
    //    [self.toDestroyQuestions removeAllObjects];
    //    [self.toDestroyOptions removeAllObjects];
}

- (NSString *)indexStringWith:(NSInteger)index {
    CGChooseModel *model = [CGMgr sharedInstance].chooseModels[index];
    return model.indexStr;
}

- (NSInteger)currentTotalCount {
    return [CGMgr sharedInstance].chooseModels.count;
}

- (void)loadMore {
    if ([CGMgr sharedInstance].curGroupCount > 0) {
        [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
        [ChooseGameScene loadGameDataFrom:[CGMgr sharedInstance].curGroupCount - 1
                                    count:1000
                                 Complete:^{
                                     [SVProgressHUD dismiss];
                                     [self expandIndexController];
//                                     self.curIndex++;
                                 } failure:^(NSDictionary *info) {
                                     [SVProgressHUD dismiss];
                                 }];
    }
}

#pragma mark - Actions
- (void)clickBack:(id)sender {
    [[CGMgr sharedInstance].chooseModels removeAllObjects];
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
    if (index > [CGMgr sharedInstance].chooseModels.count - 1) {
        if ([CGMgr sharedInstance].curGroupCount > 0) {
            [SVProgressHUD showWithMaskType:SVProgressHUDMaskTypeBlack];
            [ChooseGameScene loadGameDataFrom:[CGMgr sharedInstance].curGroupCount - 1
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
            index = [CGMgr sharedInstance].chooseModels.count - 1;
        }
    }
    
    self.curIndex = index;
}

- (void)clickQuestion:(CGQuestion *)questionSp {
    [self playSound:questionSp];
}

- (void)clickOption:(CGOption *)optionSp {
    self.clickCount++;
    
    if (optionSp.isAnswer) {
        [self chooseCorrect:optionSp];
    }
    else {
        [self chooseWrong:optionSp];
    }
}

#pragma mark - Loop
- (void)updateWithTimeSinceLastUpdate:(CFTimeInterval)interval {
    for (CGOption *ballon in self.optionCharacters) {
        [ballon updateWithTimeSinceLastUpdate:interval];
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
    else if ([node.name isEqualToString:kSoundButton]) {
        //        CGQuestion *question = self.questionCharacters.firstObject;
        //        [self playSound:question];
        [self playSound:self.question];
    }
    else if ([node.name isEqualToString:kBackButton]) {
        [self clickBack:node];
    }
    else {
        for (int i = self.optionCharacters.count - 1; i >= 0; i--) {
            CGOption *op = self.optionCharacters[i];
            if ([op containsPoint:loc]) {
                if (op.isAnswer) {
                    op.label.hidden = YES;
                    [op playBoomSound];
                    op.requestedAnimation = HSAnimationStateDeath;
                }
                else {
                    [self clickOption:op];
                }
                
                break;
            }
        }
    }
    
    [self setButtonSelectState:nil];
}

@end
