///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2022, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область СлужебныеПроцедурыИФункции

// Для внутреннего использования.
//
// Параметры:
//   ПараметрыПолучателей - Структура
//
// Возвращаемое значение:
//   Структура:
//     * Получатели - Соответствие
//     * БылиКритичныеОшибки - Булево
//     * Текст - Строка
//     * Подробно - Строка
//
Функция СформироватьСписокПолучателейРассылки(Знач ПараметрыПолучателей) Экспорт
	ПараметрыЖурнала = Новый Структура("ИмяСобытия, Метаданные, Данные, МассивОшибок, БылиОшибки");
	ПараметрыЖурнала.ИмяСобытия   = НСтр("ru = 'Рассылка отчетов. Формирование списка получателей'; en = 'Report mailing. Generate recipient list'", ОбщегоНазначения.КодОсновногоЯзыка());
	ПараметрыЖурнала.МассивОшибок = Новый Массив;
	ПараметрыЖурнала.БылиОшибки   = Ложь;
	ПараметрыЖурнала.Данные       = ПараметрыПолучателей.Ссылка;
	ПараметрыЖурнала.Метаданные   = Метаданные.Справочники.РассылкиОтчетов;
	
	РезультатВыполнения = Новый Структура("Получатели, БылиКритичныеОшибки, Текст, Подробно");
	РезультатВыполнения.Получатели = РассылкаОтчетов.СформироватьСписокПолучателейРассылки(ПараметрыПолучателей, ПараметрыЖурнала);
	РезультатВыполнения.БылиКритичныеОшибки = РезультатВыполнения.Получатели.Количество() = 0;
	
	Если РезультатВыполнения.БылиКритичныеОшибки Тогда
		РезультатВыполнения.Текст = РассылкаОтчетов.СтрокаСообщенийПользователю(ПараметрыЖурнала.МассивОшибок, Ложь);
	КонецЕсли;
	
	Возврат РезультатВыполнения;
КонецФункции

// Запускает фоновое задание.
Функция ЗапуститьФоновоеЗадание(Знач ПараметрыМетода, Знач УникальныйИдентификатор) Экспорт
	ИмяМетода = "РассылкаОтчетов.ВыполнитьРассылкиВФоновомЗадании";
	
	НастройкиЗапуска = ДлительныеОперации.ПараметрыВыполненияВФоне(УникальныйИдентификатор);
	НастройкиЗапуска.НаименованиеФоновогоЗадания = НСтр("ru = 'Рассылки отчетов: Выполнение рассылок в фоне'; en = 'Report mailings: Running in the background'");
	
	Возврат ДлительныеОперации.ВыполнитьВФоне(ИмяМетода, ПараметрыМетода, НастройкиЗапуска);
КонецФункции

#КонецОбласти
