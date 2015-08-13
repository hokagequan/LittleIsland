//
//  Defines.h
//  HappyStudy
//
//  Created by Q on 14-10-11.
//  Copyright (c) 2014年 LittleIsland. All rights reserved.
//

#ifndef HappyStudy_Defines_h
#define HappyStudy_Defines_h

typedef enum {
    StudyGameNon = 0,
    StudyGameChoose,
    StudyGameDuiDuiPeng,
    StudyGameMax
}StudyGame;

#define colorRGB(r,g,b,a) [UIColor colorWithRed:r/255. green:g/255. blue:b/255. alpha:a]

#define kNOTIFICATION_LOADING_COMPLETE @"NOTIFICATION_LOADING_COMPLETE"

// Server 1
#define HSURL @"http://54.169.15.85/EzDev/"

// Server 2
//#define HSURL @"http://54.169.15.85/KEG/"

#define FONT_NAME_CUTOON @"FZKaTong-M19S"
#define FONT_NAME_HP @"FZHuPo-M04S"
#define FONT_NAME_C @"calibri"
#define FONT_NAME_JCY @"迷你简超圆"
#define FONT_NAME_AM @"ArialMT"

#define GAME_NUM 10

#endif
