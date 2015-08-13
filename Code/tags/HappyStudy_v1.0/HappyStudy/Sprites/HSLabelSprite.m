//
//  HSLabelSprite.m
//  HappyStudy
//
//  Created by Quan on 14/10/26.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#import "HSLabelSprite.h"

@implementation HSLabelSprite
@synthesize name = _name;

- (id)initWithTexture:(SKTexture *)texture title:(NSString *)title {
    if (self = [super initWithTexture:texture]) {
        _label = [[SKLabelNode alloc] initWithFontNamed:FONT_NAME_CUTOON];
        _label.fontSize = 60.;
        _label.text = title;
        _label.position = CGPointMake(_label.position.x, _label.position.y - 10);
        _label.zPosition = self.zPosition + 1;
        [self addChild:_label];
    }
    
    return self;
}

- (void)setName:(NSString *)name {
    self.label.name = name;
    _name = name;
}

- (void)setZPosition:(CGFloat)zPosition {
    self.label.zPosition = zPosition + 1;
}

@end
