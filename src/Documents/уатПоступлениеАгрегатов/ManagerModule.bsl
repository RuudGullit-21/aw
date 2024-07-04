#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
	Настройки.ПриПолученииСлужебныхРеквизитов = Ложь;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

// СтандартныеПодсистемы.Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Документ.уатПоступлениеАгрегатов";
	КомандаПечати.Идентификатор = "Поступление";
	КомандаПечати.Представление = НСтр("en='Income';ru='Поступление'");
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор  = "Реестр";
	КомандаПечати.Представление  = НСтр("en='Document register';ru='Реестр документов'");
	КомандаПечати.ЗаголовокФормы = НСтр("en='Register of documents ""Receipt of car parts""';ru='Реестр документов ""Поступление агрегатов""'");
	КомандаПечати.Обработчик     = "уатОбщегоНазначенияТиповыеКлиент.ВыполнитьКомандуПечатиРеестраДокументов";
	КомандаПечати.СписокФорм     = "ФормаСписка";
	КомандаПечати.Порядок        = 100;
	
КонецПроцедуры

// Формирует печатные формы.
//
// Параметры:
//  МассивОбъектов  - Массив    - ссылки на объекты, которые нужно распечатать;
//  ПараметрыПечати - Структура - дополнительные настройки печати;
//  КоллекцияПечатныхФорм - ТаблицаЗначений - сформированные табличные документы (выходной параметр).
//  ОбъектыПечати         - СписокЗначений  - значение - ссылка на объект;
//                                            представление - имя области в которой был выведен объект (выходной
//                                                            параметр);
//  ПараметрыВывода       - Структура       - дополнительные параметры сформированных табличных документов (выходной
//                                            параметр).
//
Процедура Печать(МассивОбъектов, ПараметрыПечати, КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода) Экспорт
	
	Если НЕ уатОбщегоНазначенияСервер.РазрешениеПечатиНепроведенногоДокумента(МассивОбъектов) Тогда
		Возврат;
	КонецЕсли;
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Поступление") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "Поступление",
			"Поступление агрегатов", ПечатьПоступление(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	
	уатОбщегоНазначенияСервер.УстановитьРедактированиеПечатныхФормДокумента(КоллекцияПечатныхФорм);
	уатУправлениеПечатью.ЗаполнитьПараметрыОтправки(ПараметрыВывода.ПараметрыОтправки, МассивОбъектов, КоллекцияПечатныхФорм);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

// СтандартныеПодсистемы.УправлениеДоступом

// Позволяет переопределить ограничение, указанное в модуле менеджера объекта метаданных.
//
// Параметры:
//  Ограничение - Структура:
//    * Текст                             - Строка - ограничение доступа для пользователей.
//                                          Если пустая строка, значит, доступ разрешен.
//    * ТекстДляВнешнихПользователей      - Строка - ограничение доступа для внешних пользователей.
//                                          Если пустая строка, значит, доступ запрещен.
//    * ПоВладельцуБезЗаписиКлючейДоступа - Неопределено - определить автоматически.
//                                        - Булево - если Ложь, то всегда записывать ключи доступа,
//                                          если Истина, тогда не записывать ключи доступа,
//                                          а использовать ключи доступа владельца (требуется,
//                                          чтобы ограничение было строго по объекту-владельцу).
//   * ПоВладельцуБезЗаписиКлючейДоступаДляВнешнихПользователей - Неопределено, Булево - также
//                                          как у параметра ПоВладельцуБезЗаписиКлючейДоступа.
//
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Организация)
	|	И ЗначениеРазрешено(Подразделение)";
	
	Ограничение.ТекстДляВнешнихПользователей = Ограничение.Текст;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

// СтандартныеПодсистемы.ВариантыОтчетов

// Определяет список команд отчетов.
//
// Параметры:
//   КомандыОтчетов - ТаблицаЗначений - Таблица с командами отчетов. Для изменения.
//       См. описание 1 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//   Параметры - Структура - Вспомогательные параметры. Для чтения.
//       См. описание 2 параметра процедуры ВариантыОтчетовПереопределяемый.ПередДобавлениемКомандОтчетов().
//
Процедура ДобавитьКомандыОтчетов(КомандыОтчетов, Параметры) Экспорт
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВариантыОтчетов

#КонецОбласти

#КонецОбласти


#Область СлужебныйПрограммныйИнтерфейс

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	мЗапрос = Новый Запрос;
	мЗапрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	мЗапрос.УстановитьПараметр("ссылка",ДокументСсылка);
	мЗапрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	уатПоступлениеАгрегатовШины.СерияНоменклатуры КАК СерияНоменклатуры,
	|	уатПоступлениеАгрегатовШины.Пробег КАК Пробег,
	|	уатПоступлениеАгрегатовШины.Цена КАК Цена,
	|	уатПоступлениеАгрегатовШины.НомерСтроки КАК НомерСтроки,
	|	уатПоступлениеАгрегатовШины.Ссылка КАК Ссылка,
	|	уатПоступлениеАгрегатовШины.Ссылка.МОЛ КАК МОЛ
	|ПОМЕСТИТЬ ТаблицаШинДокумента
	|ИЗ
	|	Документ.уатПоступлениеАгрегатов.Шины КАК уатПоступлениеАгрегатовШины
	|ГДЕ
	|	уатПоступлениеАгрегатовШины.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	уатПоступлениеАгрегатовАккумуляторы.Ссылка КАК Ссылка,
	|	уатПоступлениеАгрегатовАккумуляторы.НомерСтроки КАК НомерСтроки,
	|	уатПоступлениеАгрегатовАккумуляторы.СерияНоменклатуры КАК СерияНоменклатуры,
	|	уатПоступлениеАгрегатовАккумуляторы.Ссылка.МОЛ КАК МОЛ
	|ПОМЕСТИТЬ ТаблицаАккумуляторовДокумента
	|ИЗ
	|	Документ.уатПоступлениеАгрегатов.Аккумуляторы КАК уатПоступлениеАгрегатовАккумуляторы
	|ГДЕ
	|	уатПоступлениеАгрегатовАккумуляторы.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	уатПоступлениеАгрегатов.СерияНоменклатуры КАК СерияНоменклатуры,
	|	уатПоступлениеАгрегатов.НомерСтроки КАК НомерСтроки,
	|	уатПоступлениеАгрегатов.Ссылка КАК Ссылка,
	|	уатПоступлениеАгрегатов.Ссылка.МОЛ КАК МОЛ
	|ПОМЕСТИТЬ ТаблицаПрочихАгрегатовДокумента
	|ИЗ
	|	Документ.уатПоступлениеАгрегатов.ПрочиеАгрегаты КАК уатПоступлениеАгрегатов
	|ГДЕ
	|	уатПоступлениеАгрегатов.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТаблицаАккумуляторовДокумента.Ссылка.Склад КАК Склад,
	|	ТаблицаАккумуляторовДокумента.СерияНоменклатуры КАК СерияНоменклатуры,
	|	ТаблицаАккумуляторовДокумента.МОЛ КАК МОЛ
	|ИЗ
	|	ТаблицаАккумуляторовДокумента КАК ТаблицаАккумуляторовДокумента
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТаблицаПрочихАгрегатовДокумента.Ссылка.Склад,
	|	ТаблицаПрочихАгрегатовДокумента.СерияНоменклатуры,
	|	ТаблицаПрочихАгрегатовДокумента.МОЛ
	|ИЗ
	|	ТаблицаПрочихАгрегатовДокумента КАК ТаблицаПрочихАгрегатовДокумента
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	ТаблицаШинДокумента.Ссылка.Склад,
	|	ТаблицаШинДокумента.СерияНоменклатуры,
	|	ТаблицаШинДокумента.МОЛ
	|ИЗ
	|	ТаблицаШинДокумента КАК ТаблицаШинДокумента";
	
	МассивРезультатов = мЗапрос.ВыполнитьПакет();
	
	мЗапрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТаблицаШинДокумента.Ссылка КАК Регистратор,
	|	ТаблицаШинДокумента.СерияНоменклатуры КАК СерияНоменклатуры,
	|	ТаблицаШинДокумента.Пробег КАК Пробег,
	|	ТаблицаШинДокумента.Ссылка.Дата КАК Период,
	|	ТаблицаШинДокумента.Ссылка.Организация КАК Организация
	|ИЗ
	|	ТаблицаШинДокумента КАК ТаблицаШинДокумента
	|ГДЕ
	|	ТаблицаШинДокумента.Пробег <> 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	1 КАК Количество,
	|	ТаблицаШинДокумента.Ссылка КАК Регистратор,
	|	ТаблицаШинДокумента.Ссылка.Дата КАК Период,
	|	ТаблицаШинДокумента.Ссылка.Склад КАК Склад,
	|	ТаблицаШинДокумента.СерияНоменклатуры КАК СерияНоменклатуры,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	ТаблицаШинДокумента.МОЛ КАК МОЛ
	|ИЗ
	|	ТаблицаШинДокумента КАК ТаблицаШинДокумента
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	1,
	|	ТаблицаАккумуляторовДокумента.Ссылка,
	|	ТаблицаАккумуляторовДокумента.Ссылка.Дата,
	|	ТаблицаАккумуляторовДокумента.Ссылка.Склад,
	|	ТаблицаАккумуляторовДокумента.СерияНоменклатуры,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход),
	|	ТаблицаАккумуляторовДокумента.МОЛ
	|ИЗ
	|	ТаблицаАккумуляторовДокумента КАК ТаблицаАккумуляторовДокумента
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	1,
	|	ТаблицаПрочихАгрегатовДокумента.Ссылка,
	|	ТаблицаПрочихАгрегатовДокумента.Ссылка.Дата,
	|	ТаблицаПрочихАгрегатовДокумента.Ссылка.Склад,
	|	ТаблицаПрочихАгрегатовДокумента.СерияНоменклатуры,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход),
	|	ТаблицаПрочихАгрегатовДокумента.МОЛ
	|ИЗ
	|	ТаблицаПрочихАгрегатовДокумента КАК ТаблицаПрочихАгрегатовДокумента";
	
	мЗапрос.УстановитьПараметр("Ссылка"          , ДокументСсылка);

	МассивРезультатов = мЗапрос.ВыполнитьПакет();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаИзносаПробегаШин", МассивРезультатов[0].Выгрузить());
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаОстатковАгрегатов", МассивРезультатов[1].Выгрузить());
	
	//СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаПартии", ТаблицаПартии);
	
КонецПроцедуры // ИнициализироватьДанныеДокумента()

Процедура ВыполнитьКонтроль(ДокументСсылка, ДополнительныеСвойства, Отказ, УдалениеПроведения = Ложь) Экспорт
	
	Заголовок = уатОбщегоНазначенияТиповые.уатПредставлениеДокументаПриПроведении(ДокументСсылка);
	
	мЗапрос = Новый Запрос;
	мЗапрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	уатПоступлениеАгрегатовШины.СерияНоменклатуры
	|ПОМЕСТИТЬ АгрегатыДокумента
	|ИЗ
	|	Документ.уатПоступлениеАгрегатов.Шины КАК уатПоступлениеАгрегатовШины
	|ГДЕ
	|	уатПоступлениеАгрегатовШины.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	уатПоступлениеАгрегатовАккумуляторы.СерияНоменклатуры
	|ИЗ
	|	Документ.уатПоступлениеАгрегатов.Аккумуляторы КАК уатПоступлениеАгрегатовАккумуляторы
	|ГДЕ
	|	уатПоступлениеАгрегатовАккумуляторы.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	уатПоступлениеАгрегатовПрочиеАгрегаты.СерияНоменклатуры
	|ИЗ
	|	Документ.уатПоступлениеАгрегатов.ПрочиеАгрегаты КАК уатПоступлениеАгрегатовПрочиеАгрегаты
	|ГДЕ
	|	уатПоступлениеАгрегатовПрочиеАгрегаты.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	АгрегатыДокумента.СерияНоменклатуры,
	|	уатОстаткиАгрегатовОстатки.Склад,
	|	уатАгрегатыТССрезПоследних.ТС,
	|	уатАгрегатыТССрезПоследних.МестоУстановки
	|ИЗ
	|	АгрегатыДокумента КАК АгрегатыДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.уатОстаткиАгрегатов.Остатки(&МоментВремени, ) КАК уатОстаткиАгрегатовОстатки
	|		ПО АгрегатыДокумента.СерияНоменклатуры = уатОстаткиАгрегатовОстатки.СерияНоменклатуры
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.уатАгрегатыТС.СрезПоследних(&МоментВремени, ) КАК уатАгрегатыТССрезПоследних
	|		ПО АгрегатыДокумента.СерияНоменклатуры = уатАгрегатыТССрезПоследних.СерияНоменклатуры
	|ГДЕ
	|	((НЕ уатОстаткиАгрегатовОстатки.Склад ЕСТЬ NULL )
	|			ИЛИ (НЕ уатАгрегатыТССрезПоследних.СерияНоменклатуры ЕСТЬ NULL ))"; 
	
	мЗапрос.УстановитьПараметр("Ссылка"       , ДокументСсылка);
	мЗапрос.УстановитьПараметр("МоментВремени", Новый Граница(ДокументСсылка.Дата, ВидГраницы.Исключая));
	
	МассивРезультатов = мЗапрос.ВыполнитьПакет();
	
	ВыборкаКонтроля = МассивРезультатов[1].Выбрать();
	
	Пока ВыборкаКонтроля.следующий() Цикл
		Если ЗначениеЗаполнено(ВыборкаКонтроля.Склад) Тогда
			Если ВыборкаКонтроля.СерияНоменклатуры.ТипАгрегата = Справочники.уатТипыАгрегатов.Шина Тогда
				ТекстНСТР = НСтр("en='Tire ""%1"" already at warehouse ""%2""';ru='Шина ""%1"" уже имеется на складе ""%2""'");
				ТекстНСТР = СтрШаблон(ТекстНСТР, ВыборкаКонтроля.СерияНоменклатуры.СерийныйНомер, ВыборкаКонтроля.Склад);
			ИначеЕсли ВыборкаКонтроля.СерияНоменклатуры.ТипАгрегата = Справочники.уатТипыАгрегатов.Аккумулятор Тогда
				ТекстНСТР = НСтр("en='Battery ""%1"" already exists in the warehouse ""%2""';ru='Аккумулятор ""%1"" уже имеется на складе ""%2""'");
				ТекстНСТР = СтрШаблон(ТекстНСТР, ВыборкаКонтроля.СерияНоменклатуры.СерийныйНомер, ВыборкаКонтроля.Склад);
			Иначе
				ТекстНСТР = НСтр("en='Car part (%1) ""%2"" already exists at warehouse ""%3""';ru='Агрегат (%1) ""%2"" уже имеется на складе ""%3""'");
				ТекстНСТР = СтрШаблон(ТекстНСТР, ВыборкаКонтроля.СерияНоменклатуры.ТипАгрегата, ВыборкаКонтроля.СерияНоменклатуры.СерийныйНомер, ВыборкаКонтроля.Склад);
			КонецЕсли;
		Иначе
			ПредставлениеТС = Строка(ВыборкаКонтроля.ТС);
			Если ВыборкаКонтроля.СерияНоменклатуры.ТипАгрегата = Справочники.уатТипыАгрегатов.Шина Тогда
				ТекстНСТР = НСтр("en='Tire ""%1"" is already installed on vehicle ""%2""';ru='Шина ""%1"" уже установлена на ТС ""%2""'");
				ТекстНСТР = СтрШаблон(ТекстНСТР, ВыборкаКонтроля.СерияНоменклатуры.СерийныйНомер, ПредставлениеТС);
			ИначеЕсли ВыборкаКонтроля.СерияНоменклатуры.ТипАгрегата = Справочники.уатТипыАгрегатов.Аккумулятор Тогда
				ТекстНСТР = НСтр("en='Battery ""%1"" is already installed on the ""%2""';ru='Аккумулятор ""%1"" уже установлен на ТС ""%2""'");
				ТекстНСТР = СтрШаблон(ТекстНСТР, ВыборкаКонтроля.СерияНоменклатуры.СерийныйНомер, ПредставлениеТС);
			Иначе
				ТекстНСТР = НСтр("en='Car part (%1) ""%2"" is already installed on vehicle ""%3""';ru='Агрегат (%1) ""%2"" уже установлен на ТС ""%3""'");
				ТекстНСТР = СтрШаблон(ТекстНСТР, ВыборкаКонтроля.СерияНоменклатуры.ТипАгрегата, ВыборкаКонтроля.СерияНоменклатуры.СерийныйНомер, ПредставлениеТС);
			КонецЕсли;
		КонецЕсли;
		
		уатОбщегоНазначенияТиповые.СообщитьОбОшибке(ТекстНСТР, Отказ, Заголовок);	
	КонецЦикла;
КонецПроцедуры

// Получает дополнительные реквизиты для отображения в отчете "Реестр документов"
// 
// Возвращаемое значение:
//  Структура - доп. реквизитов
//
Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Структура("Информация", "Контрагент");
	Возврат Результат;
	
КонецФункции

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Функция ПечатьПоступление(МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_ПоступлениеАгрегатов";
	
	ПервыйДокумент = Истина;
	
	Для Каждого ТекущийДокумент Из МассивОбъектов Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	уатПоступлениеАгрегатовШины.Цена,
		|	уатПоступлениеАгрегатовШины.СерияНоменклатуры.Модель КАК Модель,
		|	уатПоступлениеАгрегатовШины.СерияНоменклатуры.СерийныйНомер КАК СерийныйНомер
		|ИЗ
		|	Документ.уатПоступлениеАгрегатов.Шины КАК уатПоступлениеАгрегатовШины
		|ГДЕ
		|	уатПоступлениеАгрегатовШины.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	уатПоступлениеАгрегатовАккумуляторы.СерияНоменклатуры.Модель КАК Модель,
		|	уатПоступлениеАгрегатовАккумуляторы.СерияНоменклатуры.СерийныйНомер КАК СерийныйНомер
		|ИЗ
		|	Документ.уатПоступлениеАгрегатов.Аккумуляторы КАК уатПоступлениеАгрегатовАккумуляторы
		|ГДЕ
		|	уатПоступлениеАгрегатовАккумуляторы.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	уатПоступлениеАгрегатовПрочиеАгрегаты.СерияНоменклатуры.Модель КАК Модель,
		|	уатПоступлениеАгрегатовПрочиеАгрегаты.СерияНоменклатуры.СерийныйНомер КАК СерийныйНомер
		|ИЗ
		|	Документ.уатПоступлениеАгрегатов.ПрочиеАгрегаты КАК уатПоступлениеАгрегатовПрочиеАгрегаты
		|ГДЕ
		|	уатПоступлениеАгрегатовПрочиеАгрегаты.Ссылка = &Ссылка";
		Запрос.УстановитьПараметр("Ссылка", ТекущийДокумент.Ссылка);
		ТЗШины         = Запрос.ВыполнитьПакет()[0].Выгрузить();
		ТЗАккумуляторы = Запрос.ВыполнитьПакет()[1].Выгрузить();
		ТЗПрочие       = Запрос.ВыполнитьПакет()[2].Выгрузить();
		
		ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПоступлениеАгрегатов_Поступление";
		Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.уатПоступлениеАгрегатов.ПФ_MXL_Поступление");
		
		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ОбластьМакета.Параметры.ТекстЗаголовка = уатОбщегоНазначенияТиповые.уатСформироватьЗаголовокДокумента(ТекущийДокумент, НСтр("en='Receipt of car parts';ru='Поступление агрегатов'"));
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("ШапкаОрганизация");
		СписокТребуемыхПараметров           = "НаименованиеДляПечатныхФорм";
		СведенияОбОбъекте                   = уатОбщегоНазначенияСервер.СведенияОЮрФизЛице(ТекущийДокумент.Ссылка.Организация);
		ОбластьМакета.Параметры.Организация = уатОбщегоНазначенияТиповыеСервер.ОписаниеОрганизации(СведенияОбОбъекте, СписокТребуемыхПараметров);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		Если ЗначениеЗаполнено(ТекущийДокумент.Подразделение) Тогда
			ОбластьМакета = Макет.ПолучитьОбласть("ШапкаПодразделение");
			ОбластьМакета.Параметры.Подразделение = ТекущийДокумент.Подразделение;
			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЕсли;
		
		ОбластьМакета = Макет.ПолучитьОбласть("ШапкаПрочее");
		ОбластьМакета.Параметры.Склад       = ТекущийДокумент.Ссылка.Склад;
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		Если ТЗШины.Количество() Тогда
			ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицыШины");
			ТабличныйДокумент.Вывести(ОбластьМакета);
			Сумма = 0;
			ОбластьМакета = Макет.ПолучитьОбласть("СтрокаШины");
			Для Каждого ВыборкаСтрок Из ТЗШины Цикл
				ОбластьМакета.Параметры.Заполнить(ВыборкаСтрок);
				ОбластьМакета.Параметры.НомерСтроки = ТЗШины.Индекс(ВыборкаСтрок) + 1;
				Сумма = Сумма + ВыборкаСтрок.Цена;
				
				ТабличныйДокумент.Вывести(ОбластьМакета);
			КонецЦикла;
			
			ОбластьМакета = Макет.ПолучитьОбласть("Итого");
			ОбластьМакета.Параметры.Всего = уатОбщегоНазначенияТиповые.уатФорматСумм(Сумма);
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
			// Вывести Сумму прописью
			ОбластьМакета                          = Макет.ПолучитьОбласть("СуммаПрописью");
			СуммаКПрописи                          = Сумма;
			ОбластьМакета.Параметры.ИтоговаяСтрока = "Всего наименований " + ТЗШины.Количество()
			+ ", на сумму " + уатОбщегоНазначенияТиповые.уатФорматСумм(СуммаКПрописи, ТекущийДокумент.Ссылка.ВалютаДокумента);
			ОбластьМакета.Параметры.СуммаПрописью  = уатОбщегоНазначенияТиповые.уатСформироватьСуммуПрописью(СуммаКПрописи, ТекущийДокумент.Ссылка.ВалютаДокумента);
			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЕсли;
		
		Если ТЗАккумуляторы.Количество() Тогда
			ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицыАккумуляторы");
			ТабличныйДокумент.Вывести(ОбластьМакета);
			ОбластьМакета = Макет.ПолучитьОбласть("СтрокаАккумуляторы");
			Для Каждого ВыборкаСтрок Из ТЗАккумуляторы Цикл
				ОбластьМакета.Параметры.Заполнить(ВыборкаСтрок);
				ОбластьМакета.Параметры.НомерСтроки = ТЗАккумуляторы.Индекс(ВыборкаСтрок) + 1;
				
				ТабличныйДокумент.Вывести(ОбластьМакета);
			КонецЦикла;
			Если ТЗПрочие.Количество() Тогда
				ОбластьМакета = Макет.ПолучитьОбласть("ПодвалАккумуляторы");
				ТабличныйДокумент.Вывести(ОбластьМакета);
			КонецЕсли;
		КонецЕсли;
		
		Если ТЗПрочие.Количество() Тогда
			ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицыПрочие");
			ТабличныйДокумент.Вывести(ОбластьМакета);
			ОбластьМакета = Макет.ПолучитьОбласть("СтрокаПрочие");
			Для Каждого ВыборкаСтрок Из ТЗПрочие Цикл
				ОбластьМакета.Параметры.Заполнить(ВыборкаСтрок);
				ОбластьМакета.Параметры.НомерСтроки = ТЗПрочие.Индекс(ВыборкаСтрок) + 1;
				
				ТабличныйДокумент.Вывести(ОбластьМакета);
			КонецЦикла;
		КонецЕсли;
		
		ОбластьМакета = Макет.ПолучитьОбласть("Подписи");
		//ОбластьМакета.Параметры.Ответственный = ТекущийДокумент.Ответственный;
		ОбластьМакета.Параметры.Отпустил = уатОбщегоНазначенияТиповые.уатФамилияИнициалыФизЛица(ТекущийДокумент.Отпустил);
		ОбластьМакета.Параметры.Получил  = уатОбщегоНазначенияТиповые.уатФамилияИнициалыФизЛица(ТекущийДокумент.Получил);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ТекущийДокумент);
		
	КонецЦикла;
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабличныйДокумент;
	
КонецФункции // ПечатнаяФорма()

// Процедура - Заполнить структуру получателей печатных форм
//
// Параметры:
//  СтруктураДанныхОбъектаПечати - Структура - Структура данных получателей печатной формы
//
Процедура ЗаполнитьСтруктуруПолучателейПечатныхФорм(СтруктураДанныхОбъектаПечати) Экспорт
	
	СтруктураДанныхОбъектаПечати.ОсновнойПолучатель = "Контрагент";
	 
	СтруктураДанныхОбъектаПечати.МассивРеквизитовПолучателей.Добавить("Контрагент");
	СтруктураДанныхОбъектаПечати.МассивРеквизитовПолучателей.Добавить("КонтактноеЛицо");
	СтруктураДанныхОбъектаПечати.МассивРеквизитовПолучателей.Добавить("Грузоотправитель");
	СтруктураДанныхОбъектаПечати.МассивРеквизитовПолучателей.Добавить("Грузополучатель");
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли