// @strict-types

#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область СлужебныеПроцедурыИФункции

// Ищет доверенность-владельца правила проверки МЧД.
// 
// Параметры:
//  Правило - СправочникСсылка.ПравилаПроверкиПолномочийМЧД
// 
// Возвращаемое значение:
//  - СправочникСсылка.МашиночитаемыеДоверенностиКонтрагентов
//  - СправочникСсылка.МашиночитаемыеДоверенностиОрганизаций
//  - Неопределено
//  
Функция Доверенность(Правило) Экспорт
	
	Если НЕ ЗначениеЗаполнено(Правило) Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПравилаПроверкиПолномочийПоМЧД.Доверенность КАК Доверенность
		|ИЗ
		|	РегистрСведений.ПравилаПроверкиПолномочийПоМЧД КАК ПравилаПроверкиПолномочийПоМЧД
		|ГДЕ
		|	ПравилаПроверкиПолномочийПоМЧД.ПравилоПроверки = &Правило";
	
	Запрос.УстановитьПараметр("Правило", Правило);
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.Доверенность;
	КонецЕсли;
	
	Возврат Неопределено;
	
КонецФункции

// Ищет правило проверки МЧД.
// 
// Параметры:
//  МЧД - СправочникСсылка.МашиночитаемыеДоверенностиОрганизаций
//  	- СправочникСсылка.МашиночитаемыеДоверенностиКонтрагентов
// 
// Возвращаемое значение:
//  СправочникСсылка.ПравилаПроверкиПолномочийМЧД
//  
Функция ПравилоПроверки(МЧД) Экспорт
	
	Если НЕ ЗначениеЗаполнено(МЧД) Тогда
		Возврат Справочники.ПравилаПроверкиПолномочийМЧД.ПустаяСсылка();
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.Текст =
		"ВЫБРАТЬ
		|	ПравилаПроверкиПолномочийПоМЧД.ПравилоПроверки
		|ИЗ
		|	РегистрСведений.ПравилаПроверкиПолномочийПоМЧД КАК ПравилаПроверкиПолномочийПоМЧД
		|ГДЕ
		|	ПравилаПроверкиПолномочийПоМЧД.Доверенность = &МЧД";
	
	Запрос.УстановитьПараметр("МЧД", МЧД);
	РезультатЗапроса = Запрос.Выполнить();
	Выборка = РезультатЗапроса.Выбрать();
	
	Если Выборка.Следующий() Тогда
		Возврат Выборка.ПравилоПроверки;
	КонецЕсли;
	
	Возврат Справочники.ПравилаПроверкиПолномочийМЧД.ПустаяСсылка();
	
КонецФункции

#КонецОбласти

#КонецЕсли
