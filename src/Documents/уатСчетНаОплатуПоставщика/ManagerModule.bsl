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
	КомандаПечати.МенеджерПечати = "Документ.уатСчетНаОплатуПоставщика";
	КомандаПечати.Идентификатор = "СчетНаОплатуПоставщика";
	КомандаПечати.Представление = НСтр("en='Account';ru='Счет'");
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор  = "Реестр";
	КомандаПечати.Представление  = НСтр("en='Document register';ru='Реестр документов'");
	КомандаПечати.ЗаголовокФормы = НСтр("en='Register of documents ""Invoice for supplier""';ru='Реестр документов ""Счет на оплату поставщика""'");
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
	
	ПараметрыВывода.ДоступнаПечатьПоКомплектно = Истина;
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СчетНаОплатуПоставщика") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "СчетНаОплатуПоставщика",
			"Cчет на оплату поставщика", ПечатнаяФорма(МассивОбъектов, ОбъектыПечати));
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
	|	ЗначениеРазрешено(Организация)";
	
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

Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Структура("Информация", "Контрагент");
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область ОбработчикиСобытий

Процедура ОбработкаПолученияПредставления(Данные, Представление, СтандартнаяОбработка)
	
	// Для внешнего пользователя (перевозчика) Счет на оплату поставщика отображается как Счет на оплату
	Если уатОбщегоНазначенияСервер.АвторизованВнещнийПеревозчик() Тогда
		СтандартнаяОбработка = Ложь;
		Представление = СтрШаблон(НСтр("ru = 'Счет на оплату %1 от %2'"), Данные.Номер, Данные.Дата)
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПечатнаяФорма(МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_СчетНаОплатуПоставщика";
	
	Тип = "Счет";
	
	ПервыйДокумент = Истина;
	
	Для Каждого ТекущийДокумент Из МассивОбъектов Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_СчетНаОплатуПоставщика_СчетНаОплатуПоставщика";
		Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.уатСчетНаОплатуПоставщика.ПФ_MXL_СчетНаОплатуПоставщика");
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ТекущийДокумент", ТекущийДокумент.Ссылка);
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Номер,
		|	Дата,
		|	ДоговорКонтрагента,
		|	Контрагент КАК Поставщик,
		|	Организация,
		|	СуммаДокумента,
		|	ВалютаДокумента,
		|	УчитыватьНДС,
		|	СуммаВключаетНДС
		|ИЗ
		|	Документ.уатСчетНаОплатуПоставщика КАК СчетНаОплатуПоставщика
		|
		|ГДЕ
		|	СчетНаОплатуПоставщика.Ссылка = &ТекущийДокумент";
		Шапка = Запрос.Выполнить().Выбрать();
		Шапка.Следующий();
		
		ОбластьШапки  = Макет.ПолучитьОбласть("ШапкаТаблицы");
		ОбластьСтроки = Макет.ПолучитьОбласть("Строка");
		
		Запрос.УстановитьПараметр("ТекущийДокумент", ТекущийДокумент.Ссылка);
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЗаказПоставщику.Номенклатура КАК Номенклатура,
		|	ЗаказПоставщику.Товар КАК Товар,
		|	ЗаказПоставщику.Количество КАК Количество,
		|	ЗаказПоставщику.НомерСтроки КАК НомерСтроки,
		|	ЗаказПоставщику.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	ЗаказПоставщику.Цена КАК Цена,
		|	ЗаказПоставщику.Сумма КАК Сумма,
		|	ЗаказПоставщику.СуммаНДС КАК СуммаНДС
		|ИЗ
		|	(ВЫБРАТЬ
		|		уатСчетНаОплатуПоставщикаТовары.Номенклатура КАК Номенклатура,
		|		ВЫРАЗИТЬ(уатСчетНаОплатуПоставщикаТовары.Номенклатура.НаименованиеПолное КАК СТРОКА(1000)) КАК Товар,
		|		уатСчетНаОплатуПоставщикаТовары.Цена КАК Цена,
		|		уатСчетНаОплатуПоставщикаТовары.СтавкаНДС КАК СтавкаНДС,
		|		СУММА(уатСчетНаОплатуПоставщикаТовары.Количество) КАК Количество,
		|		СУММА(уатСчетНаОплатуПоставщикаТовары.Сумма) КАК Сумма,
		|		СУММА(уатСчетНаОплатуПоставщикаТовары.СуммаНДС) КАК СуммаНДС,
		|		МИНИМУМ(уатСчетНаОплатуПоставщикаТовары.НомерСтроки) КАК НомерСтроки,
		|		уатСчетНаОплатуПоставщикаТовары.ЕдиницаИзмерения КАК ЕдиницаИзмерения
		|	ИЗ
		|		Документ.уатСчетНаОплатуПоставщика.Товары КАК уатСчетНаОплатуПоставщикаТовары
		|	ГДЕ
		|		уатСчетНаОплатуПоставщикаТовары.Ссылка = &ТекущийДокумент
		|	
		|	СГРУППИРОВАТЬ ПО
		|		уатСчетНаОплатуПоставщикаТовары.Номенклатура,
		|		уатСчетНаОплатуПоставщикаТовары.Цена,
		|		уатСчетНаОплатуПоставщикаТовары.СтавкаНДС,
		|		уатСчетНаОплатуПоставщикаТовары.ЕдиницаИзмерения,
		|		ВЫРАЗИТЬ(уатСчетНаОплатуПоставщикаТовары.Номенклатура.НаименованиеПолное КАК СТРОКА(1000))
		|	
		|	ОБЪЕДИНИТЬ ВСЕ
		|	
		|	ВЫБРАТЬ
		|		уатСчетНаОплатуПоставщикаУслуги.Номенклатура,
		|		ВЫРАЗИТЬ(уатСчетНаОплатуПоставщикаУслуги.Содержание КАК СТРОКА(1000)),
		|		уатСчетНаОплатуПоставщикаУслуги.Цена,
		|		уатСчетНаОплатуПоставщикаУслуги.СтавкаНДС,
		|		СУММА(уатСчетНаОплатуПоставщикаУслуги.Количество),
		|		СУММА(уатСчетНаОплатуПоставщикаУслуги.Сумма),
		|		СУММА(уатСчетНаОплатуПоставщикаУслуги.СуммаНДС),
		|		МИНИМУМ(уатСчетНаОплатуПоставщикаУслуги.НомерСтроки),
		|		ВЫБОР
		|			КОГДА уатСчетНаОплатуПоставщикаУслуги.Номенклатура.ЕдиницаХраненияОстатков.Представление ЕСТЬ NULL
		|				ТОГДА уатСчетНаОплатуПоставщикаУслуги.Номенклатура.ЕдиницаИзмерения.Представление
		|			ИНАЧЕ уатСчетНаОплатуПоставщикаУслуги.Номенклатура.ЕдиницаХраненияОстатков.Представление
		|		КОНЕЦ
		|	ИЗ
		|		Документ.уатСчетНаОплатуПоставщика.Услуги КАК уатСчетНаОплатуПоставщикаУслуги
		|	ГДЕ
		|		уатСчетНаОплатуПоставщикаУслуги.Ссылка = &ТекущийДокумент
		|	
		|	СГРУППИРОВАТЬ ПО
		|		уатСчетНаОплатуПоставщикаУслуги.Номенклатура,
		|		уатСчетНаОплатуПоставщикаУслуги.Цена,
		|		уатСчетНаОплатуПоставщикаУслуги.СтавкаНДС,
		|		ВЫРАЗИТЬ(уатСчетНаОплатуПоставщикаУслуги.Содержание КАК СТРОКА(1000)),
		|		ВЫБОР
		|			КОГДА уатСчетНаОплатуПоставщикаУслуги.Номенклатура.ЕдиницаХраненияОстатков.Представление ЕСТЬ NULL
		|				ТОГДА уатСчетНаОплатуПоставщикаУслуги.Номенклатура.ЕдиницаИзмерения.Представление
		|			ИНАЧЕ уатСчетНаОплатуПоставщикаУслуги.Номенклатура.ЕдиницаХраненияОстатков.Представление
		|		КОНЕЦ) КАК ЗаказПоставщику";
		
		ЗапросТовары = Запрос.Выполнить().Выгрузить();
		
		Руководители = уатОбщегоНазначенияТиповые.уатОтветственныеЛицаОрганизаций(Шапка.Организация, Шапка.Дата,);
		Руководитель = Руководители.Руководитель;
		Бухгалтер    = Руководители.ГлавныйБухгалтер;
		
		// Выводим шапку накладной
		
		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ОбластьМакета.Параметры.ТекстЗаголовка = уатОбщегоНазначенияТиповые.уатСформироватьЗаголовокДокумента(Шапка,
			"Счет на оплату поставщика");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Поставщик");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ОбластьМакета.Параметры.ПредставлениеПоставщика  = уатОбщегоНазначенияТиповыеСервер.ОписаниеОрганизации(
			уатОбщегоНазначенияСервер.СведенияОЮрФизЛице(Шапка.Поставщик, Шапка.Дата),
			"НаименованиеДляПечатныхФорм,ИНН,КПП,ЮридическийАдрес,Телефоны,");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Покупатель");
		ОбластьМакета.Параметры.ПредставлениеПолучателя = уатОбщегоНазначенияТиповыеСервер.ОписаниеОрганизации(
			уатОбщегоНазначенияСервер.СведенияОЮрФизЛице(Шапка.Организация, Шапка.Дата),
			"НаименованиеДляПечатныхФорм,ИНН,КПП,ЮридическийАдрес,Телефоны,");
		ОбластьМакета.Параметры.Получатель = Шапка.Организация;
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// Вывести табличную часть
		ТабличныйДокумент.Вывести(ОбластьШапки);
		
		Сумма    = 0;
		СуммаНДС = 0;
		СтавкиНДС = ОбщегоНазначения.ВыгрузитьКолонку(ТекущийДокумент.Услуги, "СтавкаНДС", Истина);
		Для каждого ВыборкаСтрокТовары Из ЗапросТовары Цикл
			
			ОбластьСтроки.Параметры.Заполнить(ВыборкаСтрокТовары);
			КоличествоОкр = Окр(ВыборкаСтрокТовары.Количество,3);
			ОбластьСтроки.Параметры.Количество = КоличествоОкр;
			ОбластьСтроки.Параметры.НомерСтроки = ЗапросТовары.Индекс(ВыборкаСтрокТовары) + 1;
			ОбластьСтроки.Параметры.Товар = СокрЛП(уатОбщегоНазначенияСервер.ПолучитьНаименованиеУслугиДляПечати(ВыборкаСтрокТовары.Номенклатура,ВыборкаСтрокТовары.Товар));
			ТабличныйДокумент.Вывести(ОбластьСтроки);
			Сумма    = Сумма    + ВыборкаСтрокТовары.Сумма;
			СуммаНДС = СуммаНДС + ВыборкаСтрокТовары.СуммаНДС;
			
		КонецЦикла;
		
		// Вывести Итого
		ОбластьМакета = Макет.ПолучитьОбласть("Итого");
		ОбластьМакета.Параметры.Всего = уатОбщегоНазначенияТиповые.уатФорматСумм(Сумма);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// Вывести ИтогоНДС
		Если Шапка.УчитыватьНДС Тогда
			ОбластьМакета = Макет.ПолучитьОбласть("ИтогоНДС");
			Если СуммаНДС <> 0 Тогда
				ДанныеПечатиИтоговНДС = уатОбщегоНазначенияТиповые.уатДанныеПечатиИтоговНДС(СуммаНДС, СтавкиНДС, Шапка.СуммаВключаетНДС, ":"); 
				ОбластьМакета.Параметры.НДС = ДанныеПечатиИтоговНДС.НДС;
				ОбластьМакета.Параметры.ВсегоНДС = ДанныеПечатиИтоговНДС.ВсегоНДС;
			Иначе
				ДанныеПечатиИтоговНДС = уатОбщегоНазначенияТиповые.уатДанныеПечатиИтоговНДС(0, СтавкиНДС, Шапка.СуммаВключаетНДС, ":"); 
				ОбластьМакета.Параметры.НДС = ДанныеПечатиИтоговНДС.НДС;
				ОбластьМакета.Параметры.ВсегоНДС = ДанныеПечатиИтоговНДС.ВсегоНДС;
			КонецЕсли;
			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЕсли;
		
		// Вывести Сумму прописью
		ОбластьМакета = Макет.ПолучитьОбласть("СуммаПрописью");
		СуммаКПрописи = Сумма + ?(НЕ Шапка.УчитыватьНДС ИЛИ Шапка.СуммаВключаетНДС, 0, СуммаНДС);
		ОбластьМакета.Параметры.ИтоговаяСтрока ="Всего наименований " + ЗапросТовары.Количество()
		+ ", на сумму " + уатОбщегоНазначенияТиповые.уатФорматСумм(СуммаКПрописи, Шапка.ВалютаДокумента);
		ОбластьМакета.Параметры.СуммаПрописью = уатОбщегоНазначенияТиповые.уатСформироватьСуммуПрописью(СуммаКПрописи,
			Шапка.ВалютаДокумента);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// Вывести подписи
		ОбластьМакета = Макет.ПолучитьОбласть("Подписи");
		ОбластьМакета.Параметры.ФИОРуководителя = "/"+ Руководитель + "/";
		ОбластьМакета.Параметры.ФИОБухгалтера   = "/"+ Бухгалтер    + "/";
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