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
	КомандаПечати.МенеджерПечати = "Документ.уатОперацииСАгрегатами";
	КомандаПечати.Идентификатор = "ОперацииСАгрегатами";
	КомандаПечати.Представление = НСтр("en='Operation with car parts';ru='Операции с агрегатами'");
	
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
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ОперацииСАгрегатами") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ОперацииСАгрегатами",
			"Операции с агрегатами", ПечатьОперации(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	
	уатОбщегоНазначенияСервер.УстановитьРедактированиеПечатныхФормДокумента(КоллекцияПечатныхФорм);
	
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
	мЗапрос.УстановитьПараметр("дата", ДокументСсылка.Дата);
	мЗапрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	уатОперацииСАгрегатамиПрочиеАгрегаты.НомерСтроки КАК НомерСтроки,
	|	уатОперацииСАгрегатамиПрочиеАгрегаты.ТС КАК ТС,
	|	уатОперацииСАгрегатамиПрочиеАгрегаты.СерияНоменклатуры КАК СерияНоменклатуры,
	|	уатОперацииСАгрегатамиПрочиеАгрегаты.Состояние КАК Состояние,
	|	уатОперацииСАгрегатамиПрочиеАгрегаты.Ссылка КАК Ссылка,
	|	уатОперацииСАгрегатамиПрочиеАгрегаты.Ссылка.МОЛ КАК МОЛ
	|ПОМЕСТИТЬ ТаблицаДокумента
	|ИЗ
	|	Документ.уатОперацииСАгрегатами.ПрочиеАгрегаты КАК уатОперацииСАгрегатамиПрочиеАгрегаты
	|ГДЕ
	|	уатОперацииСАгрегатамиПрочиеАгрегаты.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ТаблицаДокумента.СерияНоменклатуры КАК СерияНоменклатуры,
	|	ТаблицаДокумента.Ссылка.СкладОтправитель КАК Склад
	|ИЗ
	|	ТаблицаДокумента КАК ТаблицаДокумента";
	
	МассивРезультатов = мЗапрос.ВыполнитьПакет();
	
	// управляемая блокировка
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.уатОстаткиАгрегатов");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = МассивРезультатов[1];
	Для каждого КолонкаРезультатЗапроса Из МассивРезультатов[1].Колонки Цикл
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных(КолонкаРезультатЗапроса.Имя, КолонкаРезультатЗапроса.Имя);
	КонецЦикла;
	Блокировка.Заблокировать();

	мЗапрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                |	""0 - Таблица таблица состав ТС"" КАК СлужебноеПолеИмяТаблицы,
	                |	ТаблицаДокумента.Ссылка КАК Регистратор,
	                |	ТаблицаДокумента.Ссылка.Дата КАК Период,
	                |	ТаблицаДокумента.СерияНоменклатуры КАК СерияНоменклатуры,
	                |	ТаблицаДокумента.ТС КАК ТС,
	                |	ТаблицаДокумента.Состояние КАК СостояниеАгрегата,
	                |	ТаблицаДокумента.МОЛ КАК МОЛ
	                |ИЗ
	                |	ТаблицаДокумента КАК ТаблицаДокумента
	                |ГДЕ
	                |	ТаблицаДокумента.Состояние = ЗНАЧЕНИЕ(Перечисление.уатСостоянияАгрегатов.УстановленоВРаботе)
	                |
	                |ОБЪЕДИНИТЬ ВСЕ
	                |
	                |ВЫБРАТЬ
	                |	""0 - Таблица таблица состав ТС"",
	                |	ТаблицаДокумента.Ссылка,
	                |	ТаблицаДокумента.Ссылка.Дата,
	                |	ТаблицаДокумента.СерияНоменклатуры,
	                |	ТаблицаДокумента.ТС,
	                |	ТаблицаДокумента.Состояние,
	                |	ЕСТЬNULL(уатАгрегатыТССрезПоследних.МОЛ, ЗНАЧЕНИЕ(Справочник.Сотрудники.ПустаяСсылка))
	                |ИЗ
	                |	ТаблицаДокумента КАК ТаблицаДокумента
	                |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.уатАгрегатыТС.СрезПоследних(
	                |				&Дата,
	                |				СерияНоменклатуры В
	                |					(ВЫБРАТЬ
	                |						ТаблицаДокумента.СерияНоменклатуры
	                |					ИЗ
	                |						ТаблицаДокумента)) КАК уатАгрегатыТССрезПоследних
	                |		ПО ТаблицаДокумента.СерияНоменклатуры = уатАгрегатыТССрезПоследних.СерияНоменклатуры
	                |ГДЕ
	                |	ТаблицаДокумента.Состояние = ЗНАЧЕНИЕ(Перечисление.уатСостоянияАгрегатов.Снято)
	                |;
	                |
	                |////////////////////////////////////////////////////////////////////////////////
	                |ВЫБРАТЬ РАЗРЕШЕННЫЕ
	                |	""1 - Таблица остатков агрегатов на складах"" КАК СлужебноеПолеИмяТаблицы,
	                |	ТаблицаДокумента.Ссылка КАК Регистратор,
	                |	ТаблицаДокумента.Ссылка.Дата КАК Период,
	                |	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	                |	ТаблицаДокумента.СерияНоменклатуры КАК СерияНоменклатуры,
	                |	ТаблицаДокумента.Ссылка.СкладПолучатель КАК Склад,
	                |	1 КАК Количество,
	                |	ТаблицаДокумента.МОЛ КАК МОЛ
	                |ИЗ
	                |	ТаблицаДокумента КАК ТаблицаДокумента
	                |ГДЕ
	                |	ТаблицаДокумента.Состояние = ЗНАЧЕНИЕ(Перечисление.уатСостоянияАгрегатов.Снято)
	                |
	                |ОБЪЕДИНИТЬ ВСЕ
	                |
	                |ВЫБРАТЬ
	                |	""1 - Таблица остатков агрегатов на складах"",
	                |	ТаблицаДокумента.Ссылка,
	                |	ТаблицаДокумента.Ссылка.Дата,
	                |	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход),
	                |	ТаблицаДокумента.СерияНоменклатуры,
	                |	ТаблицаДокумента.Ссылка.СкладОтправитель,
	                |	1,
	                |	ЕСТЬNULL(уатОстаткиАгрегатовОстатки.МОЛ, ЗНАЧЕНИЕ(Справочник.Сотрудники.ПустаяСсылка))
	                |ИЗ
	                |	ТаблицаДокумента КАК ТаблицаДокумента
	                |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрНакопления.уатОстаткиАгрегатов.Остатки(
	                |				&Дата,
	                |				СерияНоменклатуры В
	                |					(ВЫБРАТЬ
	                |						ТаблицаДокумента.СерияНоменклатуры
	                |					ИЗ
	                |						ТаблицаДокумента)) КАК уатОстаткиАгрегатовОстатки
	                |		ПО ТаблицаДокумента.СерияНоменклатуры = уатОстаткиАгрегатовОстатки.СерияНоменклатуры
	                |ГДЕ
	                |	ТаблицаДокумента.Состояние = ЗНАЧЕНИЕ(Перечисление.уатСостоянияАгрегатов.УстановленоВРаботе)";
	
	МассивРезультатов = мЗапрос.ВыполнитьПакет();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаАгрегатовТС"       , МассивРезультатов[0].Выгрузить());
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаОстатковАгрегатов" , МассивРезультатов[1].Выгрузить());
	
КонецПроцедуры // ИнициализироватьДанныеДокумента()

Процедура ВыполнитьКонтроль(ДокументСсылка, ДополнительныеСвойства, Отказ, УдалениеПроведения = Ложь) Экспорт
	
	Заголовок = уатОбщегоНазначенияТиповые.уатПредставлениеДокументаПриПроведении(ДокументСсылка);
	
	мЗапрос = Новый Запрос;
	мЗапрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ПрочиеАгрегаты.СерияНоменклатуры,
	|	ПрочиеАгрегаты.Состояние,
	|	ПрочиеАгрегаты.ТС
	|ПОМЕСТИТЬ ТаблицаДокумента
	|ИЗ
	|	Документ.уатОперацииСАгрегатами.ПрочиеАгрегаты КАК ПрочиеАгрегаты
	|ГДЕ
	|	ПрочиеАгрегаты.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	""1 - Таблица проверки что нигде уже не установлено"" КАК СлужебноеПолеИмяТаблицы,
	|	уатАгрегатыТССрезПоследних.СерияНоменклатуры КАК СерияНоменклатуры,
	|	уатАгрегатыТССрезПоследних.ТС КАК ТС,
	|	уатАгрегатыТССрезПоследних.МестоУстановки
	|ИЗ
	|	ТаблицаДокумента КАК ТаблицаДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.уатАгрегатыТС.СрезПоследних(&МоментВремениИсключая, ) КАК уатАгрегатыТССрезПоследних
	|		ПО ТаблицаДокумента.СерияНоменклатуры = уатАгрегатыТССрезПоследних.СерияНоменклатуры
	|ГДЕ
	|	(НЕ уатАгрегатыТССрезПоследних.СерияНоменклатуры ЕСТЬ NULL )
	|	И уатАгрегатыТССрезПоследних.СостояниеАгрегата <> ЗНАЧЕНИЕ(Перечисление.уатСостоянияАгрегатов.Снято)
	|	И ТаблицаДокумента.Состояние = ЗНАЧЕНИЕ(Перечисление.уатСостоянияАгрегатов.УстановленоВРаботе)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	""2 - Таблица проверки остатков на складе"" КАК СлужебноеПолеИмяТаблицы,
	|	ТаблицаДокумента.СерияНоменклатуры,
	|	уатОстаткиАгрегатовОстатки.Склад
	|ИЗ
	|	ТаблицаДокумента КАК ТаблицаДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.уатОстаткиАгрегатов.Остатки(
	|				&МоментВремениВключая,
	|				Склад = &СкладОтправитель
	|					И СерияНоменклатуры В
	|						(ВЫБРАТЬ
	|							ТаблицаДокумента.СерияНоменклатуры
	|						ИЗ
	|							ТаблицаДокумента)) КАК уатОстаткиАгрегатовОстатки
	|		ПО ТаблицаДокумента.СерияНоменклатуры = уатОстаткиАгрегатовОстатки.СерияНоменклатуры
	|ГДЕ
	|	ТаблицаДокумента.Состояние <> ЗНАЧЕНИЕ(Перечисление.уатСостоянияАгрегатов.Снято)
	|	И уатОстаткиАгрегатовОстатки.КоличествоОстаток < 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	""3 - Таблица проверки, что снимаем агрегат, который не установлен на ТС"" КАК СлужебноеПолеИмяТаблицы,
	|	ТаблицаДокумента.СерияНоменклатуры КАК СерияНоменклатуры,
	|	ТаблицаДокумента.ТС КАК ТС,
	|	ТаблицаДокумента.Состояние КАК Состояние,
	|	уатАгрегатыТССрезПоследних.ТС КАК АгрегатыТС_ТС,
	|	уатАгрегатыТССрезПоследних.СостояниеАгрегата КАК АгрегатыТС_Состояние
	|ИЗ
	|	ТаблицаДокумента КАК ТаблицаДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.уатАгрегатыТС.СрезПоследних(&МоментВремениИсключая, ) КАК уатАгрегатыТССрезПоследних
	|		ПО ТаблицаДокумента.СерияНоменклатуры = уатАгрегатыТССрезПоследних.СерияНоменклатуры
	|			И ТаблицаДокумента.ТС = уатАгрегатыТССрезПоследних.ТС";
	
	мЗапрос.УстановитьПараметр("Ссылка"          , ДокументСсылка);
	мЗапрос.УстановитьПараметр("МоментВремениИсключая", Новый Граница(ДокументСсылка.МоментВремени(),ВидГраницы.Исключая));
	мЗапрос.УстановитьПараметр("МоментВремениВключая" , Новый Граница(ДокументСсылка.МоментВремени(),ВидГраницы.Включая));
	мЗапрос.УстановитьПараметр("СкладОтправитель", ДокументСсылка.СкладОтправитель);
	мЗапрос.УстановитьПараметр("СкладПолучатель" , ДокументСсылка.СкладПолучатель);
	
	МассивРезультатов = мЗапрос.ВыполнитьПакет();
	
	ВыборкаКонтроля = МассивРезультатов[1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаКонтроля.следующий() Цикл
		ТекстНСТР = НСтр("en='Car part ""%1"" (%2) is already installed on vehicle ""%3""';ru='Агрегат ""%1"" (%2) уже установлен на ТС ""%3""'");
		ТекстНСТР = СтрШаблон(ТекстНСТР, ВыборкаКонтроля.СерияНоменклатуры.СерийныйНомер,
			ВыборкаКонтроля.СерияНоменклатуры.Модель, Строка(ВыборкаКонтроля.ТС));
		уатОбщегоНазначенияТиповые.СообщитьОбОшибке(ТекстНСТР, Отказ, Заголовок, СтатусСообщения.Внимание);
	КонецЦикла;
	
	ВыборкаКонтроля = МассивРезультатов[2].Выбрать();
	Пока ВыборкаКонтроля.Следующий() Цикл
		ТекстНСТР = НСтр("en='For car part ""%1"" (%2) received negative remains at warehouse ""%3""';ru='Для агрегата ""%1"" (%2) получены отрицательные остатки на складе ""%3""'");
		ТекстНСТР = СтрШаблон(ТекстНСТР, ВыборкаКонтроля.СерияНоменклатуры.СерийныйНомер, ВыборкаКонтроля.СерияНоменклатуры.Модель, ВыборкаКонтроля.Склад);
		уатОбщегоНазначенияТиповые.СообщитьОбОшибке(ТекстНСТР, Отказ, Заголовок, СтатусСообщения.Внимание);
	КонецЦикла;
	
	ВыборкаКонтроля = МассивРезультатов[3].Выбрать();
	Пока ВыборкаКонтроля.Следующий() Цикл
		Если ВыборкаКонтроля.Состояние = Перечисления.уатСостоянияАгрегатов.Снято И
			(ВыборкаКонтроля.АгрегатыТС_ТС = NULL ИЛИ ВыборкаКонтроля.АгрегатыТС_Состояние = Перечисления.уатСостоянияАгрегатов.Снято) Тогда
			
			ТекстНСТР = НСтр("en='Car part ""%1"" (%2) is not installed on vehicle ""%3""';ru='Агрегат ""%1"" (%2) не установлен на ТС ""%3""'");
			ТекстНСТР = СтрШаблон(ТекстНСТР, ВыборкаКонтроля.СерияНоменклатуры.СерийныйНомер,
				ВыборкаКонтроля.СерияНоменклатуры.Модель, Строка(ВыборкаКонтроля.ТС));
			уатОбщегоНазначенияТиповые.СообщитьОбОшибке(ТекстНСТР, Отказ, Заголовок, СтатусСообщения.Внимание);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

Функция ПечатьОперации(МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_ОперацииСАгрегатами";
	
	ПервыйДокумент = Истина;
	
	Для Каждого ТекущийДокумент Из МассивОбъектов Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	уатОперацииСАгрегатамиПрочиеАгрегаты.ТС,
		|	уатОперацииСАгрегатамиПрочиеАгрегаты.Состояние,
		|	уатОперацииСАгрегатамиПрочиеАгрегаты.СерияНоменклатуры.Модель КАК Модель,
		|	уатОперацииСАгрегатамиПрочиеАгрегаты.СерияНоменклатуры.СерийныйНомер КАК СерийныйНомер
		|ИЗ
		|	Документ.уатОперацииСАгрегатами.ПрочиеАгрегаты КАК уатОперацииСАгрегатамиПрочиеАгрегаты
		|ГДЕ
		|	уатОперацииСАгрегатамиПрочиеАгрегаты.Ссылка = &Ссылка";
		Запрос.УстановитьПараметр("Ссылка", ТекущийДокумент.Ссылка);
		ТЗ = Запрос.Выполнить().Выгрузить();
		
		ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ОперацииСАгрегатами_Операции";
		Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.уатОперацииСАгрегатами.ПФ_MXL_ОперацииСАгрегатами");
		
		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ОбластьМакета.Параметры.ТекстЗаголовка = уатОбщегоНазначенияТиповые.уатСформироватьЗаголовокДокумента(
			ТекущийДокумент, НСтр("en='Operation with car parts';ru='Операции с агрегатами'"));
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
		ОбластьМакета.Параметры.СкладПолучатель  = ТекущийДокумент.Ссылка.СкладПолучатель;
		ОбластьМакета.Параметры.СкладОтправитель = ТекущийДокумент.Ссылка.СкладОтправитель;
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицы");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Строка");
		Для Каждого ВыборкаСтрок Из ТЗ Цикл
			
			ОбластьМакета.Параметры.Заполнить(ВыборкаСтрок);
			ОбластьМакета.Параметры.НомерСтроки = ТЗ.Индекс(ВыборкаСтрок) + 1;
			
			ТабличныйДокумент.Вывести(ОбластьМакета);
		
		КонецЦикла;
		
		ОбластьМакета = Макет.ПолучитьОбласть("Подписи");
		//ОбластьМакета.Параметры.Ответственный = ТекущийДокумент.Ссылка.Ответственный;
		ОбластьМакета.Параметры.Отпустил = уатОбщегоНазначенияТиповые.уатФамилияИнициалыФизЛица(ТекущийДокумент.Отпустил);
		ОбластьМакета.Параметры.Получил  = уатОбщегоНазначенияТиповые.уатФамилияИнициалыФизЛица(ТекущийДокумент.Получил);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ТекущийДокумент);
		
	КонецЦикла;
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабличныйДокумент;
	
КонецФункции // ПечатнаяФорма()

#КонецОбласти

#КонецЕсли