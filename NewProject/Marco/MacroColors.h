//
//  MacroColors.h
//  QSRuler
//
//  Created by qws on 2018/7/4.
//  Copyright © 2018年 qws. All rights reserved.
//

#ifndef MacroColors_h
#define MacroColors_h

#define kGameColorTime          0xFF7F00
#define kGameColorRemaind       0xFF7F00
#define kGameColorNaviTitleBg   0x000000
#define kGameColorWinBg         0x000000
//0xDB4709
#define kGameColorWinText       0xFF7F00
#define kGameColorLoseBg        0x000000
//0x1469FF
#define kGameColorLoseText      0xe9e9e9


/*************************************************/
/*************************************************/
/*************************************************/
#define RGBColor(rgbValue, alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]

//随机颜色
#define colorRandom             [UIColor colorWithRed:arc4random_uniform(256) / 255.0 green:arc4random_uniform(256) / 255.0 blue:arc4random_uniform(256) / 255.0 alpha:0.6]
//透明色
#define colorClear              [UIColor clearColor]

//白色
#define colorWhite              RGBColor(0xFFFFFF, 1)
#define colorWhiteF6F6F6        RGBColor(0xF6F6F6, 1)
//黑色
#define colorBlack              RGBColor(0x000000, 1)
#define colorBlack444444        RGBColor(0x444444, 1)
#define colorBlack131211        RGBColor(0x131211, 1)
#define colorBlack242322        RGBColor(0x242322, 1)
#define colorBlack3D3C3C        RGBColor(0x3D3C3C, 1)
#define colorBlack2F2F2F        RGBColor(0x2F2F2F, 1)
#define colorBlack3F3F3F        RGBColor(0x3F3F3F, 1)
//灰色
#define colorGray333333         RGBColor(0x333333, 1)
#define colorGray444444         RGBColor(0x444444, 1)
#define colorGray666666         RGBColor(0x666666, 1)
#define colorGray999999         RGBColor(0x999999, 1)
#define colorGrayCCCCCC         RGBColor(0xCCCCCC, 1)
#define colorGrayEEEEEE         RGBColor(0xEEEEEE, 1)
#define colorGray929292         RGBColor(0x929292, 1)
#define colorGratB2B2B2         RGBColor(0xB2B2B2, 1)
#define colorGrayE6E6E6         RGBColor(0xE6E6E6, 1) //薄灰
#define colorGrayE9E9E9         RGBColor(0xE9E9E9, 1) //白灰
#define colorGrayF9F9F9         RGBColor(0xF9F9F9, 1) //白灰

//红色
#define colorRedE02727          RGBColor(0xE02727, 1)
#define colorRedFF3701          RGBColor(0xFF3701, 1)
//橙色
#define colorOragne             RGBColor(0xFF7F00, 1)
//粉色
#define colorLink               RGBColor(0x131211, 1)
#define colorAlert              RGBColor(0xE74B57, 1)
//金色
#define colorGold               RGBColor(0xae995a, 1)
//绿色
#define colorGreen09BB07        RGBColor(0x09BB07, 1)
#define colorGreen53AA53        RGBColor(0x53AA53, 1)
#define colorGreen6aae58        RGBColor(0x6aae58, 1)
//蓝色
#define colorBlue66a7df         RGBColor(0x66a7df, 1)
#define colorBlue5887ae         RGBColor(0x5887ae, 1)

#endif /* MacroColors_h */
