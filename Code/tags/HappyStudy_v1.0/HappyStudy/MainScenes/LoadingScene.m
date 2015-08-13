//
//  LoadingScene.m
//  HappyStudy
//
//  Created by Q on 14/10/24.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "LoadingScene.h"
#import "GlobalUtil.h"

typedef enum uint8_t {
    zPosWhiteBg = 0,
    zPosEvironment = 100,
    zPosCharacter = 200,
    zPosHead = 300
} zPos;

#define AutoDismissTime 3

@interface LoadingScene ()

@property (strong, nonatomic) SKSpriteNode *head;
@property (strong, nonatomic) SKLabelNode *character;

@end

@implementation LoadingScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(handleNotification:)
                                                     name:kNOTIFICATION_LOADING_COMPLETE
                                                   object:nil];
        
        [self buildWorld];
    }
    
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    
    [self startLoading];
    
    if (self.isFake) {
        [self schedualToDismiss];
    }
}

- (void)willMoveFromView:(SKView *)view {
    [self removeAllActions];
    
    [super willMoveFromView:view];
}

- (void)buildWorld {
    SKSpriteNode *whiteBg = [SKSpriteNode spriteNodeWithColor:[UIColor whiteColor]
                                                         size:self.size];
    whiteBg.anchorPoint = CGPointZero;
    whiteBg.position = CGPointZero;
    whiteBg.zPosition = zPosWhiteBg;
    [self addChild:whiteBg];
    
    _head = [SKSpriteNode spriteNodeWithImageNamed:@"girl_head"];
    _head.position = CGPointMake(555 + 187.5, 455);
    _head.zPosition = zPosHead;
    _head.anchorPoint = CGPointMake(0.448, 0.36);
    [self addChild:_head];
    
    SKSpriteNode *evironment = [SKSpriteNode spriteNodeWithImageNamed:@"loading_page_bg"];
    evironment.anchorPoint = CGPointZero;
    evironment.position = CGPointMake(90, 74.5);
    evironment.zPosition = zPosEvironment;
    [self addChild:evironment];
    
    SKLabelNode *companyName = [SKLabelNode labelNodeWithFontNamed:FONT_NAME_HP];
    companyName.position = CGPointMake(self.size.width / 2 - 66, self.size.height / 2 - 55);
    companyName.text = [GlobalUtil gameInfoWithKey:@"CompanyName"];
    companyName.fontColor = colorRGB(214, 43, 43, 1.);
    companyName.fontSize = 58;
    companyName.zPosition = zPosEvironment + 1;
    [self addChild:companyName];
    
    _character = [SKLabelNode labelNodeWithFontNamed:FONT_NAME_C];
    _character.position = CGPointMake(680, 410);
    _character.fontColor = [UIColor whiteColor];
    _character.fontSize = 80.;
    _character.zPosition = zPosCharacter;
    _character.text = @"a";
    [self addChild:_character];
}

- (void)changeCharacter {
    self.character.text = [GlobalUtil randomCharacter];
}

- (void)startLoading {
    [self startHeadAction];
    [self startCharacterAction];
}

- (void)startHeadAction {
    SKAction *rotateLeft = [SKAction rotateToAngle:-M_PI / 50 duration:1];
    SKAction *rotateRight = [SKAction rotateToAngle:M_PI / 30 duration:1];
    [self.head runAction:[SKAction repeatActionForever:[SKAction sequence:@[rotateLeft, rotateRight]]]];
}

- (void)startCharacterAction {
    SKAction *changeAction = [SKAction runBlock:^{
        [self changeCharacter];
    }];
    SKAction *waitAction = [SKAction waitForDuration:0.7];
    [self runAction:[SKAction repeatActionForever:[SKAction sequence:@[changeAction, waitAction]]]];
}

- (void)schedualToDismiss {
    SKAction *pushAction = [SKAction runBlock:^{
        [LoadingScene dismissTo:self.presentScene];
    }];
    SKAction *waitAction = [SKAction waitForDuration:AutoDismissTime];
    [self runAction:[SKAction sequence:@[waitAction, pushAction]]];
}

#pragma mark - Class Function
+ (void)showFakeFrom:(SKScene *)fScene to:(SKScene *)tScene {
    if (!fScene || tScene) {
        return;
    }
    
    LoadingScene *loadingScene = [[LoadingScene alloc] initWithSize:fScene.size];
    loadingScene.isFake = YES;
    loadingScene.presentScene = tScene;
    [fScene.view presentScene:loadingScene];
}

+ (void)showFrom:(SKScene *)scene {
    if (!scene) {
        return;
    }
    
    LoadingScene *loadingScene = [[LoadingScene alloc] initWithSize:scene.size];
    [scene.view presentScene:loadingScene];
}

+ (void)dismissTo:(SKScene *)scene {
    if (!scene) {
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNOTIFICATION_LOADING_COMPLETE
                                                        object:scene];
}

#pragma mark - Timer
- (void)handleTimer:(NSTimer *)timer {
    SKScene *scene = (SKScene *)timer.userInfo;
    [LoadingScene dismissTo:scene];
}

#pragma mark - NOTIFICATION
- (void)handleNotification:(NSNotification *)notification {
    SKScene *scene = notification.object;
    
    [self.view presentScene:scene];
}

@end
