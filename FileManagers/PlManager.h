//
//  PlManager.h
//  ProgSettingsManager
//
//  Created by svp on 01.04.10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/** Класс для работы с plist файлами **/
@interface CPlManager : NSObject {
@public
	/** Объект отвечающий за загрузку и сохранение настроек **/
	NSUserDefaults* m_pDictionary;
}

/** Инициализирует объект
 @return Возвращает указатель на созданный объект если считывание удачно и nil в противоположном случае
 **/
-(id) Init;

/** Устанавливает значение типа NSString для ключа, если ключа нет, то создает его
 @param sKey название ключа  
 @param sValue значение ключа  
 **/
-(void) SetKeyStrValue: (NSString*)sKey withValue:(NSString*) sValue;

/** Возвращает значение типа NSString для ключа
 @param sKey название ключа  
 @return Возвращает значение для ключа
 **/
-(NSString*) GetKeyStrValue: (NSString*) sKey;

/** Устанавливает значение типа int для ключа, если ключа нет, то создает его
 @param sKey название ключа  
 @param iValue значение ключа  
 **/
-(void) SetKeyIntValue: (NSString*)sKey withValue:(int) iValue;

/** Возвращает значение типа int для ключа
 @param sKey название ключа  
 @return Возвращает значение для ключа
 **/
-(int) GetKeyIntValue: (NSString*) sKey;

/** Устанавливает значение типа float для ключа, если ключа нет, то создает его
 @param sKey название ключа  
 @param fValue значение ключа  
 **/
-(void) SetKeyFloatValue: (NSString*)sKey withValue:(float) iValue;

/** Возвращает значение типа float для ключа
 @param sKey название ключа  
 @return Возвращает значение для ключа
 **/
-(float) GetKeyFloatValue: (NSString*) sKey;

/** Устанавливает значение типа double для ключа, если ключа нет, то создает его
 @param sKey название ключа  
 @param dValue значение ключа  
 **/
-(void) SetKeyDoubleValue: (NSString*)sKey withValue:(double) iValue;

/** Возвращает значение типа double для ключа
 @param sKey название ключа  
 @return Возвращает значение для ключа
 **/
-(double) GetKeyDoubleValue: (NSString*) sKey;

/** Устанавливает значение типа BOOL для ключа, если ключа нет, то создает его
 @param sKey название ключа  
 @param bValue значение ключа  
 **/
-(void) SetKeyBoolValue: (NSString*)sKey withValue:(BOOL) bValue;

/** Возвращает значение типа BOOL для ключа
 @param sKey название ключа  
 @return Возвращает значение для ключа
 **/
-(BOOL) GetKeyBoolValue: (NSString*) sKey;


@end
