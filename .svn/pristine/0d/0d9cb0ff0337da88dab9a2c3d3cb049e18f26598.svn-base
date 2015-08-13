//
//  GameSelectScene.m
//  HappyStudy
//
//  Created by Q on 14/10/23.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "GameSelectScene.h"
#import "SignInScene.h"
#import "AboutScene.h"
#import "HSLabelSprite.h"
#import "HSButtonSprite.h"
#import "HSAnimal.h"
#import "HSCrab.h"
#import "GameMgr.h"
#import "AccountMgr.h"
#import "AppDelegate.h"

#define kAboutBtn @"AboutBtn"
#define kBackBtn @"BackBtn"
#define kBackgroundMusicBtn @"BackgroundMusicBtn"

typedef enum {
    GSWorldLayerGround = 0,
    GSWorldLayerSkyFar,
    GSWorldLayerSkyNear,
    GSWorldLayerEnvironment,
    GSWorldLayerTop,
    GSWorldLayerCount
}GSWorldLayer;

@interface GameSelectScene ()

@property (strong, nonatomic) NSMutableArray *layers;
@property (strong, nonatomic) NSMutableArray *animals;
@property (strong, nonatomic) NSMutableArray *options;
@property (strong, nonatomic) SKSpriteNode *nearCloud;
@property (strong, nonatomic) SKSpriteNode *farCloud;
@property (strong, nonatomic) NSMutableArray *buttons;
@property (nonatomic) CGSize bgSize;
@property (nonatomic) CGPoint lastLoc;
@property (nonatomic) BOOL worldMoved;

@end

@implementation GameSelectScene

- (id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        _animals = [[NSMutableArray alloc] init];
        _buttons = [[NSMutableArray alloc] init];
        _options = [[NSMutableArray alloc] initWithCapacity:10];
        
        _layers = [NSMutableArray arrayWithCapacity:GSWorldLayerCount];
        for (int i = 0; i < GSWorldLayerCount; i++) {
            SKNode *layer = [[SKNode alloc] init];
            layer.zPosition = i - GSWorldLayerCount;
            layer.userInteractionEnabled = NO;
            [self addChild:layer];
            [_layers addObject:layer];
        }
        [self buildWorld];
        [GameSelectScene loadAssets];
    }
    
    return self;
}

- (void)didMoveToView:(SKView *)view {
    [super didMoveToView:view];
    
    [self playBackgroundMusic];
    [self startAnimations];
}

- (void)addNode:(SKNode *)node atWorldLayer:(GSWorldLayer)layer {
    SKNode *layerNode = self.layers[layer];
    [layerNode addChild:node];
}

- (void)addGameOptions {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"GameSelect" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    for (int i = 0; i < array.count; i++) {
        NSDictionary *dict = array[i];
        [self addAnimalSprite:dict[@"animal"]
                     position:CGPointMake([dict[@"animalX"] floatValue], [dict[@"animalY"] floatValue])];
        UIColor *norColor = colorRGB(96, 48, 24, 1);
        if (i + 1 > StudyGameDuiDuiPeng) {
            norColor = colorRGB(235, 200, 145, 1);
        }
        [self addGameOptionString:dict[@"title"]
                         position:CGPointMake([dict[@"x"] floatValue], [dict[@"y"] floatValue])
                        textColor:norColor
                             game:(StudyGame)(i + 1)];
    }
}

- (void)addHUD {
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"Environment"];
    NSInteger score = [AccountMgr sharedInstance].user.score;
    HSLabelSprite *scoreNode = [[HSLabelSprite alloc] initWithTexture:[atlas textureNamed:@"heart"]
                                                                title:[NSString stringWithFormat:@"%@", @(score)]];
    scoreNode.size = CGSizeMake(135, 115);
    scoreNode.position = CGPointMake(102, 693);
    scoreNode.label.fontName = FONT_NAME_HP;
    scoreNode.label.fontSize = 60.;
    scoreNode.label.position = CGPointMake(scoreNode.label.position.x, scoreNode.label.position.y - 8);
    [self addNode:scoreNode atWorldLayer:GSWorldLayerTop];
    
    HSButtonSprite *aboutNode = [[HSButtonSprite alloc] initWithTitle:@"About"
                                                             norImage:@"about_btn_nor"
                                                             selImage:@"about_btn_sel"];
    aboutNode.name = kAboutBtn;
    aboutNode.position = CGPointMake(248, 693);
    aboutNode.label.fontSize = 23.;
    aboutNode.label.fontName = FONT_NAME_HP;
    [self addNode:aboutNode atWorldLayer:GSWorldLayerTop];
    [self.buttons addObject:aboutNode];
    
    HSButtonSprite *backNode = [[HSButtonSprite alloc] initWithTitle:nil
                                                            norImage:@"back_nor"
                                                            selImage:@"back_sel"];
    backNode.position = CGPointMake(381, 693);
    backNode.name = kBackBtn;
    [self addNode:backNode atWorldLayer:GSWorldLayerTop];
    [self.buttons addObject:backNode];
    
    HSButtonSprite *bgMusicSwitch = [[HSButtonSprite alloc] initWithTitle:nil
                                                                 norImage:@"music_on"
                                                                 selImage:@"music_off"];
    bgMusicSwitch.position = CGPointMake(self.size.width - 113, 20);
    bgMusicSwitch.anchorPoint = CGPointZero;
    bgMusicSwitch.name = kBackgroundMusicBtn;
    bgMusicSwitch.selected = [SettingMgr sharedInstance].bgMusicOff;
    [self addNode:bgMusicSwitch atWorldLayer:GSWorldLayerTop];
}

- (void)addEnvironment {
    HSCrab *crab = [[HSCrab alloc] initWithTexture:nil];
    crab.position = CGPointMake(1000, 92);
    [self addNode:crab atWorldLayer:GSWorldLayerEnvironment];
    [self.animals addObject:crab];
    
    SKSpriteNode *treeLeft = [SKSpriteNode spriteNodeWithImageNamed:@"tree_left"];
    treeLeft.position = CGPointMake(treeLeft.size.width / 2, 504);
    [self addNode:treeLeft atWorldLayer:GSWorldLayerEnvironment];
    
    SKSpriteNode *treeMid = [SKSpriteNode spriteNodeWithImageNamed:@"tree_middle"];
    treeMid.position = CGPointMake(920, 600);
    [self addNode:treeMid atWorldLayer:GSWorldLayerEnvironment];
    
    SKSpriteNode *surfboard = [SKSpriteNode spriteNodeWithImageNamed:@"surfboard"];
    surfboard.position = CGPointMake(1800, 570);
    [self addNode:surfboard atWorldLayer:GSWorldLayerEnvironment];
}

- (void)addCloud {
    _nearCloud = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"game_sel_big_cloud_near"]
                                                size:CGSizeMake(260 * 1.3, 83 * 1.3)];
    _nearCloud.position = CGPointMake(self.size.width / 2, 680);
    [self addNode:_nearCloud atWorldLayer:GSWorldLayerSkyNear];
    
    _farCloud = [SKSpriteNode spriteNodeWithTexture:[SKTexture textureWithImageNamed:@"game_sel_big_cloud_far"]
                                               size:CGSizeMake(375 * 1.3, 64 * 1.3)];
    _farCloud.position = CGPointMake(self.size.width / 2 + 380, 700);
    [self addNode:_farCloud atWorldLayer:GSWorldLayerSkyFar];
}

- (void)addGameOptionString:(NSString *)string position:(CGPoint)position textColor:(UIColor *)textColor game:(StudyGame)game {
    NSString *gameStr = [NSString stringWithFormat:@"%@", @(game)];
    
    SKLabelNode *lab = [SKLabelNode labelNodeWithFontNamed:FONT_NAME_CUTOON];
    lab.position = position;
    lab.fontSize = 24.;
    lab.fontColor = textColor;
    lab.text = string;
    lab.name = gameStr;
    lab.zRotation = M_PI / 60;
    lab.zPosition = 10;
    [self addNode:lab atWorldLayer:GSWorldLayerGround];
    [self.options addObject:lab];
    
    SKSpriteNode *optionSp = [SKSpriteNode spriteNodeWithColor:[UIColor clearColor] size:CGSizeMake(120, 90)];
    optionSp.position = position;
    optionSp.name = gameStr;
    [self addNode:optionSp atWorldLayer:GSWorldLayerGround];
}

- (void)addAnimalSprite:(NSString *)className position:(CGPoint)position {
    HSAnimal *animal = [[NSClassFromString(className) alloc] initWithTexture:nil];
    animal.position = position;
    [self.animals addObject:animal];
    [self addNode:animal atWorldLayer:GSWorldLayerGround];
}

- (void)buildWorld {
    SKSpriteNode *bgNode = [SKSpriteNode spriteNodeWithImageNamed:@"game_sel_bg"];
    bgNode.size = CGSizeMake(self.size.width * 2, self.size.height);
    bgNode.anchorPoint = CGPointZero;
    [self addNode:bgNode atWorldLayer:GSWorldLayerGround];
    
    self.bgSize = bgNode.size;
    
    [self addGameOptions];
    [self addHUD];
    [self addEnvironment];
    [self addCloud];
}

- (void)optionIsSeletedWithName:(StudyGame)studyGame {
    if (studyGame == StudyGameNon ||
        studyGame >= StudyGameMax) {
        return;
    }
    
    for (SKLabelNode *option in self.options) {
        if ([option.name integerValue] == studyGame) {
            SKAction *zoomOut = [SKAction scaleTo:1.25 duration:0.2];
            SKAction *loadGame = [SKAction runBlock:^{
                [GameMgr sharedInstance].selGame = studyGame;
                [[GameMgr sharedInstance] loadGameFrom:self];
            }];
            SKAction *zoomIn = [SKAction scaleTo:1.0 duration:0.2];
            
            [option runAction:[SKAction sequence:@[zoomOut, loadGame, zoomIn]]];
            
            return;
        }
    }
}

- (void)playBackgroundMusic {
    [[SettingMgr sharedInstance] startBackgroundMusicWithName:@"game_select_bg.wav"];
}

- (void)startAnimations {
    [self startAnimalsAnimation];
    [self startCloudAnimation];
}

- (void)startAnimalsAnimation {
    for (HSAnimal *animal in self.animals) {
        animal.requestedAnimation = HSAnimationStateIdle;
    }
}

- (void)startCloudAnimation {
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

- (void)setButtonSelectState:(NSString *)buttonName {
    NSString *name = buttonName;
    if (!name) {
        name = @"non";
    }
    for (HSButtonSprite *button in self.buttons) {
        button.selected = [button.name isEqualToString:name];
    }
}

#pragma mark - Actions
- (void)clickBack:(id)sender {
    SignInScene *scene = [[SignInScene alloc] initWithSize:self.size];
    [self.view presentScene:scene];
}

- (void)showAbout {
    AboutScene *aboutScene = [AboutScene sceneFromNib];
    [aboutScene showInView:self.view];
}

#pragma mark - Class Function
+ (void)loadAssets {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"GameSelect" ofType:@"plist"];
    NSArray *array = [NSArray arrayWithContentsOfFile:path];
    for (NSDictionary *dict in array) {
        NSString *className = dict[@"animal"];
        [NSClassFromString(className) loadAssets];
    }
    
    [HSCrab loadAssets];
}

#pragma mark - Loop
- (void)update:(NSTimeInterval)currentTime {
    for (HSAnimal *animal in self.animals) {
        [animal updateWithTimeSinceLastUpdate:currentTime];
    }
}

#pragma mark - UITouches
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    self.worldMoved = NO;
    UITouch *touch = [touches anyObject];
    self.lastLoc = [touch locationInNode:self];
    
    SKNode *node = [self nodeAtPoint:self.lastLoc];
    [self setButtonSelectState:node.name];
    
    if ([node.name isEqualToString:kBackgroundMusicBtn]) {
        HSButtonSprite *btn = (HSButtonSprite *)node;
        btn.selected = !btn.selected;
        [SettingMgr sharedInstance].bgMusicOff = btn.selected;
        if ([SettingMgr sharedInstance].bgMusicOff) {
            [[SettingMgr sharedInstance] stopBackgroundMusic];
        }
        else {
            [[SettingMgr sharedInstance] startBackgroundMusicWithName:@"game_select_bg.wav"];
        }
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    self.worldMoved = YES;
    UITouch *touch = [touches anyObject];
    CGPoint loc = [touch locationInNode:self];
    
    SKNode *layer = self.layers[GSWorldLayerGround];
    CGFloat x = layer.position.x + loc.x - self.lastLoc.x;
    if (x > 0) {
        x = 0;
    }
    else if (x < -(self.bgSize.width - self.size.width)) {
        x = -(self.bgSize.width - self.size.width);
    }
    layer.position = CGPointMake(x, layer.position.y);
    SKNode *layer2 = self.layers[GSWorldLayerEnvironment];
    layer2.position = layer.position;
    self.lastLoc = loc;
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [self setButtonSelectState:nil];
    
//    if (self.worldMoved) {
//        self.worldMoved = NO;
//        
//        return;
//    }
    
    UITouch *touch = [touches anyObject];
    CGPoint sceneLoc = [touch locationInNode:self];
    SKNode *buttonNode = [self nodeAtPoint:sceneLoc];
    
    if ([buttonNode.name isEqualToString:kAboutBtn]) {
        [self showAbout];
        
        return;
    }
    else if ([buttonNode.name isEqualToString:kBackBtn]) {
        [self clickBack:buttonNode];
        
        return;
    }
    
    SKNode *layer = self.layers[GSWorldLayerGround];
    CGPoint loc = [touch locationInNode:layer];
    SKNode *node = [layer nodeAtPoint:loc];
    [self optionIsSeletedWithName:[node.name intValue]];
}

@end
