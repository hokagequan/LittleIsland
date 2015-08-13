//
//  DDPHanZi.m
//  HappyStudy
//
//  Created by Quan on 14/10/22.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "DDPHanZi.h"

@implementation DDPHanZi

- (id)initWithString:(NSString *)string matchKey:(NSString *)matchKey position:(CGPoint)position {
    SKTextureAtlas *atlas = [SKTextureAtlas atlasNamed:@"Card_Blue_Idle"];
    SKTexture *texture = [atlas textureNamed:@"card_blue_idle_0001"];
    SKTexture *selTexture = [atlas textureNamed:@"card_blue_idle_0002"];
    if (self = [super initWithTitle:string norTexture:texture selTexture:selTexture]) {
        self.position = position;
        self.matchKey = matchKey;
    }
    
    return self;
}

#pragma mark - Override
- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        SKAction *scale = [SKAction scaleTo:1.2 duration:0.2];
        [self runAction:scale];
        self.label.fontColor = [self selectedColor];
    }
    else {
        SKAction *scale = [SKAction scaleTo:1.0 duration:0.2];
        [self runAction:scale];
        self.label.fontColor = [self normalColor];
    }
}

- (UIColor *)normalColor {
    return [UIColor whiteColor];
}

- (UIColor *)selectedColor {
    return colorRGB(195, 240, 255, 1);
}

#pragma mark - Touch
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    if (self.requestedAnimation == HSAnimationStateDeath) {
        return;
    }
    
    DuiDuiPengGameScene *scene = [self characterScene];
    if (scene) {
        [scene clickCharacter:self];
    }
}

@end
