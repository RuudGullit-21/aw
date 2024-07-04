///////////////////////////////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2021, ООО 1С-Софт
// Все права защищены. Эта программа и сопроводительные материалы предоставляются 
// в соответствии с условиями лицензии Attribution 4.0 International (CC BY 4.0)
// Текст лицензии доступен по ссылке:
// https://creativecommons.org/licenses/by/4.0/legalcode
///////////////////////////////////////////////////////////////////////////////////////////////////////

#Область ПрограммныйИнтерфейс

// Позволяет изменить работу интерфейса при встраивании.
//
// Параметры:
//  НастройкиРаботыИнтерфейса - Структура:
//   * ИспользоватьВнешнихПользователей - Булево - начальное значение Ложь,
//     если установить Истина, тогда даты запрета можно будет настраивать для внешних пользователей.
//
Процедура НастройкаИнтерфейса(НастройкиРаботыИнтерфейса) Экспорт
	
	// {УАТ}
	уатДатыЗапретаИзменения.НастройкаИнтерфейса(НастройкиРаботыИнтерфейса);
	// {/УАТ}
	
КонецПроцедуры

// Заполняет разделы дат запрета изменения, используемые при настройке дат запрета.
// Если не указать ни одного раздела, тогда будет доступна только настройка общей даты запрета.
//
// Параметры:
//  Разделы - ТаблицаЗначений:
//   * Имя - Строка - имя, используемое в описании источников данных в
//       процедуре ЗаполнитьИсточникиДанныхДляПроверкиЗапретаИзменения.
//
//   * Идентификатор - УникальныйИдентификатор - идентификатор ссылки элемента плана видов характеристик.
//       Чтобы получить идентификатор, нужно в режиме 1С:Предприятие выполнить метод платформы:
//       "ПланыВидовХарактеристик.РазделыДатЗапретаИзменения.ПолучитьСсылку().УникальныйИдентификатор()".
//       Не следует указывать идентификаторы, полученные любым другим способом,
//       так как это может нарушить их уникальность.
//
//   * Представление - Строка - представляет раздел в форме настройки дат запрета.
//
//   * ТипыОбъектов  - Массив - типы ссылок объектов, в разрезе которых можно настроить даты запрета,
//       например Тип("СправочникСсылка.Организации"); если не указано ни одного типа,
//       то даты запрета будут настраиваться только с точностью до раздела.
//
Процедура ПриЗаполненииРазделовДатЗапретаИзменения(Разделы) Экспорт
	
	// {УАТ}
	Раздел = Разделы.Добавить();
	Раздел.Имя  = "УправлениеАвтотранспортом";
	Раздел.Идентификатор = Новый УникальныйИдентификатор("da660a2e-5cbf-4482-93c4-7b12139145fb");
	Раздел.Представление = НСтр("en='Trasportation management';ru='Управление автотранспортом'");
	Раздел.ТипыОбъектов.Добавить(Тип("СправочникСсылка.Организации"));
	// {/УАТ}
	
КонецПроцедуры

// Позволяет задать таблицы и поля объектов для проверки запрета изменения данных.
// Для добавления нового источника в ИсточникиДанных см. ДатыЗапретаИзменения.ДобавитьСтроку.
//
// Вызывается из процедуры ИзменениеЗапрещено общего модуля ДатыЗапретаИзменения,
// используемой в подписке на событие ПередЗаписью объекта для проверки наличия
// запретов и отказа от изменений запрещенного объекта.
//
// Параметры:
//  ИсточникиДанных - ТаблицаЗначений:
//   * Таблица     - Строка - полное имя объекта метаданных,
//                   например Метаданные.Документы.ПриходнаяНакладная.ПолноеИмя().
//   * ПолеДаты    - Строка - имя реквизита объекта или табличной части,
//                   например: "Дата", "Товары.ДатаОтгрузки".
//   * Раздел      - Строка - имя раздела дат запрета, указанного в
//                   процедуре ПриЗаполненииРазделовДатЗапретаИзменения (см. выше).
//   * ПолеОбъекта - Строка - имя реквизита объекта или реквизита табличной части,
//                   например: "Организация", "Товары.Склад".
//
Процедура ЗаполнитьИсточникиДанныхДляПроверкиЗапретаИзменения(ИсточникиДанных) Экспорт
	
	// {УАТ}
	уатДатыЗапретаИзменения.ЗаполнитьИсточникиДанныхДляПроверкиЗапретаИзменения(ИсточникиДанных);
	//ИсточникиДанных.ЗаполнитьЗначения("УправлениеАвтотранспортом", "Раздел");
	// {/УАТ}
	
КонецПроцедуры

// Позволяет переопределить выполнение проверки запрета изменения произвольным образом.
//
// Если проверка выполняется в процессе записи документа, то в свойстве ДополнительныеСвойства документа Объект
// имеется свойство РежимЗаписи.
//  
// Параметры:
//  Объект       - СправочникОбъект
//               - ДокументОбъект
//               - ПланВидовХарактеристикОбъект
//               - ПланСчетовОбъект
//               - ПланВидовРасчетаОбъект
//               - БизнесПроцессОбъект
//               - ЗадачаОбъект
//               - ПланОбменаОбъект
//               - РегистрСведенийНаборЗаписей
//               - РегистрНакопленияНаборЗаписей
//               - РегистрБухгалтерииНаборЗаписей
//               - РегистрРасчетаНаборЗаписей - проверяемый элемент данных или набор записей 
//                 (который передается из обработчиков ПередЗаписью и ПриЧтенииНаСервере).
//
//  ПроверкаЗапретаИзменения    - Булево - установить в Ложь, чтобы пропустить проверку запрета изменения данных.
//  УзелПроверкиЗапретаЗагрузки - ПланОбменаСсылка
//                              - Неопределено - установить в Неопределено, чтобы 
//                                пропустить проверку запрета загрузки данных.
//  ВерсияОбъекта               - Строка - установить "СтараяВерсия" или "НоваяВерсия", чтобы
//                                выполнить проверку только старой (в базе данных) 
//                                или только новой версии объекта (в параметре Объект).
//                                По умолчанию содержит значение "" - проверяются обе версии объекта сразу.
//
Процедура ПередПроверкойЗапретаИзменения(Объект,
                                         ПроверкаЗапретаИзменения,
                                         УзелПроверкиЗапретаЗагрузки,
                                         ВерсияОбъекта) Экспорт
	
	
	
КонецПроцедуры

// Позволяет переопределить получение данных для проверки даты запрета старой (существующей) версии данных.
//
// Параметры:
//  ОбъектМетаданных - ОбъектМетаданных - объект метаданных получаемых данных.
//  ИдентификаторДанных - СправочникСсылка
//                      - ДокументСсылка
//                      - ПланВидовХарактеристикСсылка
//                      - ПланСчетовСсылка
//                      - ПланВидовРасчетаСсылка
//                      - БизнесПроцессСсылка
//                      - ЗадачаСсылка
//                      - ПланОбменаСсылка
//                      - Отбор - ссылка на элемент данных или отбор набора записей, который нужно проверить.
//                                При этом значение для проверки будет получено из базы данных.
//
//  УзелПроверкиЗапретаЗагрузки - Неопределено
//                              - ПланОбменаСсылка - если Неопределено, то проверить запрет 
//                                изменения данных; иначе - загрузку данных из указанного узла плана обмена.
//
//  ДанныеДляПроверки - см. ДатыЗапретаИзменения.ШаблонДанныхДляПроверки.
//
//  Пример:
//  Если ТипЗнч(ИдентификаторДанных) = Тип("ДокументСсылка.Заказ") Тогда
//  	Данные = ОбщегоНазначения.ЗначенияРеквизитовОбъекта(ИдентификаторДанных, "Организация, ДатаОкончанияРабот, ЗаказНаряд");
//  	Если Данные.ЗаказНаряд Тогда
//  		Проверка = ДанныеДляПроверки.Добавить();
//  		Проверка.Раздел = "ЗаказНаряды";
//  		Проверка.Объект =  Данные.Организация;
//  		Проверка.Дата   = Данные.ДатаОкончанияРабот;
//  	КонецЕсли;
//  КонецЕсли;
//
Процедура ПередПроверкойСтаройВерсииДанных(ОбъектМетаданных, ИдентификаторДанных, УзелПроверкиЗапретаЗагрузки, ДанныеДляПроверки) Экспорт
	
КонецПроцедуры

// Позволяет переопределить получение данных для проверки даты запрета новой (будущей) версии данных.
//
// Параметры:
//  ОбъектМетаданных - ОбъектМетаданных - объект метаданных получаемых данных.
//  Данные  - СправочникОбъект
//          - ДокументОбъект
//          - ПланВидовХарактеристикОбъект
//          - ПланСчетовОбъект
//          - ПланВидовРасчетаОбъект
//          - БизнесПроцессОбъект
//          - ЗадачаОбъект
//          - ПланОбменаОбъект
//          - РегистрСведенийНаборЗаписей
//          - РегистрНакопленияНаборЗаписей
//          - РегистрБухгалтерииНаборЗаписей
//          - РегистрРасчетаНаборЗаписей - проверяемый элемент данных или набор записей.
//
//  УзелПроверкиЗапретаЗагрузки - Неопределено
//                              - ПланОбменаСсылка - если Неопределено, то проверить запрет 
//                                изменения данных; иначе - загрузку данных из указанного узла плана обмена.
//
//  ДанныеДляПроверки - см. ДатыЗапретаИзменения.ШаблонДанныхДляПроверки.
//
//  Пример:
//  Если ТипЗнч(Данные) = Тип("ДокументОбъект.Заказ") И Данные.ЗаказНаряд Тогда
//  	
//  	Проверка = ДанныеДляПроверки.Добавить();
//  	Проверка.Раздел = "ЗаказНаряды";
//  	Проверка.Объект =  Данные.Организация;
//  	Проверка.Дата   = Данные.ДатаОкончанияРабот;
//  	
//  КонецЕсли;
//
Процедура ПередПроверкойНовойВерсииДанных(ОбъектМетаданных, Данные, УзелПроверкиЗапретаЗагрузки, ДанныеДляПроверки) Экспорт
	
КонецПроцедуры

#КонецОбласти
