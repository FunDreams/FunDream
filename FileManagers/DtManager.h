//
//  DtManager.h
//  ProgSettingsManager
//
//  Created by Konstantin on 29.05.12.
//  Copyright 2012 FunDreams. All rights reserved.
//

#import <DropboxSDK/DropboxSDK.h>
#import <Foundation/Foundation.h>

/** Класс для работы записи и ситывание данных из файлов **/
@interface CDataManager : NSObject {
@public
    DBRestClient* restClient;//клиент для загрузки
	/** Хранит полный путь к файлу**/
	NSMutableString* m_sFullFileName;
	NSMutableString* m_sFullFileNameDropBox;
	/** Объект-буфер отвечающий за загрузку и сохранение данных **/
	NSMutableData* m_pDataDmp;
	/** Отвечает за текущую позицию считывания**/
	int m_iCurReadingPos;
    
    NSString *relinkUserId;//user id
    DBMetadata *m_pMetaData;
    NSObject *m_pParent;
}

/** Инициализирует объект и загружает данные из файла который находится в ресурсах приложения
 @param sFileName  Определяет название файла
 @return Возвращает созданный объект если считывание удачно и nil в противоположном случае
 **/
-(CDataManager*) InitWithFileFromCash: (NSString*) sFileName;
-(CDataManager*) InitWithFileFromRes:(NSString*) sFileName;

/** Сохраняет данные миз буфера в файл
 @return Возвращает TRUE если запись удачно и FALSE в противоположном случае
 **/
-(bool) Save;

/** Загружает данные миз файла в буфер
 @return Возвращает TRUE если загрузка удачно и FALSE в противоположном случае
 **/
-(bool) Load;

/** Очищает буфер данных и обнуляет позицию для считывания
 **/
-(void) Clear;

/** Обнуляет позицию для считывания для повторного считывания
 **/
-(void) ResetReading;

/** устанавливаем позицию для чтения файла
 **/
-(void) SetPosReading:(int)iPos;


/** Добавляет данные в буфер из строки
 @param sValue строка значение которой будет добавлено в буфер 
 **/
-(void) AddStrValue: (NSString*) sValue;

/** Возвращает значение типа NSString из буфера
 @param iSize размер строки  
 @return Возвращает  строку из буфера заданной длинны согласно текущей позиции для считывания
 **/
-(NSString*) GetStrValue: (int) iSize;

/** Добавляет данные типа int в буфер
 @param iValue значение добавляемых данных   
 **/
-(void) AddIntValue: (int) iValue;

/** Возвращает данных типа int из буфера согласно текущей позиции для считывания
 @return Возвращает значение типа int 
 **/
-(int) GetIntValue;

/** Добавляет данные типа float в буфер
 @param fValue значение добавляемых данных   
 **/
-(void) AddFloatValue:(float) iValue;

/** Возвращает данных типа float из буфера согласно текущей позиции для считывания
 @return Возвращает значение типа float 
 **/
-(float) GetFloatValue;

/** Добавляет данные типа double в буфер
 @param dValue значение добавляемых данных   
 **/
-(void) AddDoubleValue:(double) dValue;

/** Возвращает данных типа double из буфера согласно текущей позиции для считывания
 @return Возвращает значение типа double 
 **/
-(double) GetDoubleValue;

/** Добавляет данные типа char в буфер
 @param cValue значение добавляемых данных   
 **/
-(void) AddCharValue:(char) cValue;

/** Возвращает данных типа char из буфера согласно текущей позиции для считывания
 @return Возвращает значение типа char 
 **/
-(char) GetCharValue;

/** Загружает метаданные из директории **/
-(void)LoadMetadata:(NSString *)Paht;

/** Добавляет данные типа BOOL в буфер
 @param bValue значение добавляемых данных   
 **/
-(void) AddBoolValue:(BOOL) bValue;

/** Возвращает данных типа BOOL из буфера согласно текущей позиции для считывания
 @return Возвращает значение типа BOOL 
 **/
-(BOOL) GetBoolValue;

//-(void)initDropBox;//инициализация dropBox
-(void)UpLoad;//Загрузка файла на сервер
-(void)UpLoadWithName:(NSString *)NameUpload;//загрузка со специальным именем
-(void)DownLoad;//Загрузка файла с сервера
-(void)DelFileFromDropBox:(NSString*)destPath;//удаления файла с хранилища
//-(void)Link;//подключение акка

/** пересоздание клиента для манипуляции данных в DropBox'e **/
-(void)relinkResClient;

@end
