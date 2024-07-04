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
	КомандаПечати.МенеджерПечати = "Документ.уатИзменениеCчетчиковТС";
	КомандаПечати.Идентификатор = "ИзменениеСчетчиков";
	КомандаПечати.Представление = НСтр("ru = 'Изменение счетчиков'; en = 'Repair list'");
	
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
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ИзменениеСчетчиков") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ИзменениеСчетчиков",
			"Изменение счетчиков", ПечатьИзменениеСчетчиковТС(МассивОбъектов, ОбъектыПечати));
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
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	""0 - ТаблицаСчетчиковТС"" КАК СлужебноеПолеИмяТаблицы,
	|	уатИзменениеCчетчиковТС.Ссылка КАК Регистратор,
	|	уатИзменениеCчетчиковТС.Дата КАК Период,
	|	ЗНАЧЕНИЕ(Перечисление.уатТипыСчетчиковТС.Спидометр) КАК ТипСчетчика,
	|	уатИзменениеCчетчиковТС.ПоказанияОдометра КАК Значение,
	|	уатИзменениеCчетчиковТС.ТС КАК ТС
	|ИЗ
	|	Документ.уатИзменениеCчетчиковТС КАК уатИзменениеCчетчиковТС
	|ГДЕ
	|	уатИзменениеCчетчиковТС.Ссылка = &Ссылка
	|	И уатИзменениеCчетчиковТС.ОдометрИзменен = ИСТИНА
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""0 - ТаблицаСчетчиковТС"",
	|	уатИзменениеCчетчиковТС.Ссылка,
	|	уатИзменениеCчетчиковТС.Дата,
	|	ЗНАЧЕНИЕ(Перечисление.уатТипыСчетчиковТС.СчетчикМЧ),
	|	уатИзменениеCчетчиковТС.ПоказанияСчетчикаМЧ,
	|	уатИзменениеCчетчиковТС.ТС
	|ИЗ
	|	Документ.уатИзменениеCчетчиковТС КАК уатИзменениеCчетчиковТС
	|ГДЕ
	|	уатИзменениеCчетчиковТС.Ссылка = &Ссылка
	|	И уатИзменениеCчетчиковТС.СчетчикМЧИзменен = ИСТИНА
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	""1 - ВыработкаТС"" КАК СлужебноеПолеИмяТаблицы,
	|	уатИзменениеCчетчиковТС.Ссылка КАК Регистратор,
	|	уатИзменениеCчетчиковТС.Дата КАК Период,
	|	уатИзменениеCчетчиковТС.ТС КАК ТС,
	|	уатИзменениеCчетчиковТС.Организация КАК Организация,
	|	уатИзменениеCчетчиковТС.ПараметрВыработки КАК ПараметрВыработки,
	|	уатИзменениеCчетчиковТС.ПоказанияВыработки КАК Количество
	|ИЗ
	|	Документ.уатИзменениеCчетчиковТС КАК уатИзменениеCчетчиковТС
	|ГДЕ
	|	уатИзменениеCчетчиковТС.Ссылка = &Ссылка
	|	И уатИзменениеCчетчиковТС.ВыработкаИзменена = ИСТИНА
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	ВЫБОР
	|		КОГДА уатТС.Модель.НаличиеСпидометра
	|			ТОГДА уатТС.НачальныйПробег
	|		ИНАЧЕ уатТС.НачальныйПробег * 3600
	|	КОНЕЦ + ВЫБОР
	|		КОГДА уатВыработкаОбороты.КоличествоОборот ЕСТЬ NULL
	|				ИЛИ уатВыработкаОбороты.КоличествоОборот = NULL
	|			ТОГДА 0
	|		ИНАЧЕ уатВыработкаОбороты.КоличествоОборот
	|	КОНЕЦ КАК КоличествоОборот,
	|	ЕСТЬNULL(уатМоделиТСНормативыОбслуживания.ПараметрВыработки, ЗНАЧЕНИЕ(Справочник.уатПараметрыВыработки.ПустаяСсылка)) КАК ПараметрВыработки,
	|	уатМоделиТСНормативыОбслуживания.ВидОбслуживания КАК ВидОбслуживания,
	|	уатВыработкаОбороты.ТС КАК ТС
	|ИЗ
	|	Справочник.уатТС КАК уатТС
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.уатМоделиТС.НормативыОбслуживания КАК уатМоделиТСНормативыОбслуживания
	|		ПО уатТС.Модель = уатМоделиТСНормативыОбслуживания.Ссылка
	|			И (уатТС.Ссылка = &ТС)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.уатВыработкаТС.Обороты(, &ДатаКон, , ТС = &ТС) КАК уатВыработкаОбороты
	|		ПО уатТС.Ссылка = уатВыработкаОбороты.ТС
	|			И (уатВыработкаОбороты.ПараметрВыработки = уатМоделиТСНормативыОбслуживания.ПараметрВыработки)
	|ГДЕ
	|	уатМоделиТСНормативыОбслуживания.ВидОбслуживания = &ВидОбслуживания
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	&ПараметрВыработки КАК ПараметрВыработки,
	|	ВЫБОР
	|		КОГДА уатТС.Модель.НаличиеСпидометра
	|			ТОГДА уатТС.НачальныйПробег
	|		ИНАЧЕ уатТС.НачальныйПробег * 3600
	|	КОНЕЦ + ЕСТЬNULL(уатВыработкаТСОбороты.КоличествоОборот, 0) КАК ТекущаяВыработка
	|ИЗ
	|	Справочник.уатТС КАК уатТС
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.уатВыработкаТС.Обороты(
	|				,
	|				&ДатаКон,
	|				,
	|				ТС = &ТС
	|					И ПараметрВыработки = &ПараметрВыработки) КАК уатВыработкаТСОбороты
	|		ПО уатТС.Ссылка = уатВыработкаТСОбороты.ТС
	|ГДЕ
	|	уатТС.Ссылка = &ТС";
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.УстановитьПараметр("ДатаКон", ДокументСсылка.Дата);
	Запрос.УстановитьПараметр("ТС", ДокументСсылка.ТС);
	Запрос.УстановитьПараметр("ВидОбслуживания", ДокументСсылка.ПараметрВыработки);
	
	Если ДокументСсылка.ТС.Модель.НаличиеСпидометра Тогда 
		Запрос.УстановитьПараметр("ПараметрВыработки", Справочники.уатПараметрыВыработки.ПробегОбщий);
	Иначе 
		Запрос.УстановитьПараметр("ПараметрВыработки", Справочники.уатПараметрыВыработки.ВремяВРаботе);
	КонецЕсли;
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	Если ДокументСсылка.ВыработкаИзменена Тогда
		// Подготовка значений для регистра выработки
		ТекущаяВыработка = 0;
		Выборка = МассивРезультатов[3].Выбрать();
		
		Если Выборка.Следующий() Тогда
			ТекущаяВыработка = Выборка.ТекущаяВыработка;
			Если ДокументСсылка.ПараметрВыработки.Временный Тогда
				ТекущаяВыработка = ТекущаяВыработка / 3600;
			КонецЕсли;
		Иначе
			ВыборкаБезПлана = МассивРезультатов[4].Выбрать();
			Если ВыборкаБезПлана.Следующий() Тогда 
				ТекущаяВыработка = ВыборкаБезПлана.ТекущаяВыработка;
				Если ДокументСсылка.ПараметрВыработки.Временный Тогда
					ТекущаяВыработка = ТекущаяВыработка / 3600;
				КонецЕсли;
			КонецЕсли;
		КонецЕсли;
		
		ТаблицаВыработкиТС = МассивРезультатов[1].Выгрузить();
		НоваяВыработка = ТаблицаВыработкиТС[0].Количество;
		
		НоваяВыработка = НоваяВыработка - ТекущаяВыработка;
		Если ДокументСсылка.ПараметрВыработки.Временный Тогда
			НоваяВыработка = НоваяВыработка * 3600;
		КонецЕсли;
		
		ТаблицаВыработкиТС[0].Количество = НоваяВыработка;
	Иначе
		ТаблицаВыработкиТС = МассивРезультатов[1].Выгрузить();
	КонецЕсли;
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаВыработкиТС"		 , ТаблицаВыработкиТС);
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСчетчиковТС"		 , МассивРезультатов[0].Выгрузить());
	
КонецПроцедуры // ИнициализироватьДанныеДокумента()

// Получает дополнительные реквизиты для отображения в отчете "Реестр документов"
// 
// Возвращаемое значение:
//  Структура - доп. реквизитов
//
Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Структура("Информация", "ТС");
	Возврат Результат;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПечатьИзменениеСчетчиковТС(МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_ИзменениеСчетчиков";
	
	ПервыйДокумент = Истина;
	
	Для Каждого ТекущийДокумент Из МассивОбъектов Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ТабличныйДокумент.ИмяПараметровПечати = "ПараметрыПечати_ИзменениеСчетчиков_ИзменениеСчетчиков";
		Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.уатИзменениеCчетчиковТС.ПФ_MXL_ИзменениеСчетчиков");
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	уатИзменениеCчетчиковТС.Дата КАК Дата,
		|	уатИзменениеCчетчиковТС.Номер КАК Номер,
		|	уатИзменениеCчетчиковТС.Организация КАК Организация,
		|	уатИзменениеCчетчиковТС.Подразделение КАК Подразделение,
		|	уатИзменениеCчетчиковТС.ПараметрВыработки КАК ПараметрВыработки,
		|	уатИзменениеCчетчиковТС.ТС КАК ТС
		|ИЗ
		|	Документ.уатИзменениеCчетчиковТС КАК уатИзменениеCчетчиковТС
		|ГДЕ
		|	уатИзменениеCчетчиковТС.Ссылка = &Ссылка
		|;
		|
		|////////////////////////////////////////////////////////////////////////////////
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	ЗНАЧЕНИЕ(Перечисление.уатТипыСчетчиковТС.Спидометр) КАК Счетчик,
		|	уатИзменениеCчетчиковТС.ПоказанияОдометра КАК НовоеЗначение,
		|	уатИзменениеCчетчиковТС.ТекущийОдометр КАК СтароеЗначение
		|ИЗ
		|	Документ.уатИзменениеCчетчиковТС КАК уатИзменениеCчетчиковТС
		|ГДЕ
		|	уатИзменениеCчетчиковТС.Ссылка = &Ссылка
		|	И уатИзменениеCчетчиковТС.ОдометрИзменен = ИСТИНА
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	ЗНАЧЕНИЕ(Перечисление.уатТипыСчетчиковТС.СчетчикМЧ),
		|	уатИзменениеCчетчиковТС.ПоказанияСчетчикаМЧ,
		|	уатИзменениеCчетчиковТС.ТекущийСчетчикМЧ
		|ИЗ
		|	Документ.уатИзменениеCчетчиковТС КАК уатИзменениеCчетчиковТС
		|ГДЕ
		|	уатИзменениеCчетчиковТС.Ссылка = &Ссылка
		|	И уатИзменениеCчетчиковТС.СчетчикМЧИзменен = ИСТИНА
		|
		|ОБЪЕДИНИТЬ ВСЕ
		|
		|ВЫБРАТЬ
		|	уатИзменениеCчетчиковТС.ПараметрВыработки,
		|	уатИзменениеCчетчиковТС.ПоказанияВыработки,
		|	уатИзменениеCчетчиковТС.ТекущаяВыработка
		|ИЗ
		|	Документ.уатИзменениеCчетчиковТС КАК уатИзменениеCчетчиковТС
		|ГДЕ
		|	уатИзменениеCчетчиковТС.Ссылка = &Ссылка
		|	И уатИзменениеCчетчиковТС.ВыработкаИзменена = ИСТИНА";
		

		Запрос.УстановитьПараметр("Ссылка", ТекущийДокумент);
		Шапка            = Запрос.ВыполнитьПакет()[0].Выгрузить();
		ТЗСчетчики       = Запрос.ВыполнитьПакет()[1].Выгрузить();

		
		ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
		ОбластьЗаголовок.Параметры.ТекстЗаголовка = уатОбщегоНазначенияТиповые.уатСформироватьЗаголовокДокумента(ТекущийДокумент, НСтр("ru = 'Изменение счетчиков'; en = 'Repair list'"));
		ТабличныйДокумент.Вывести(ОбластьЗаголовок);
		
		// шапка
		Для Каждого ТекСтрока Из Шапка Цикл
			Если ЗначениеЗаполнено(ТекСтрока.Подразделение) Тогда
				ОбластьОрганизацияПодразделение = Макет.ПолучитьОбласть("ОрганизацияПодразделение");
				ОбластьОрганизацияПодразделение.Параметры.Заполнить(ТекСтрока);
				СписокТребуемыхПараметров	= "НаименованиеДляПечатныхФорм";
				СведенияОбОбъекте			= уатОбщегоНазначенияСервер.СведенияОЮрФизЛице(ТекущийДокумент.Организация);
				ОбластьОрганизацияПодразделение.Параметры.Организация		= уатОбщегоНазначенияТиповыеСервер.ОписаниеОрганизации(СведенияОбОбъекте, СписокТребуемыхПараметров);
				ТабличныйДокумент.Вывести(ОбластьОрганизацияПодразделение);
			Иначе
				ОбластьОрганизация = Макет.ПолучитьОбласть("Организация");
				ОбластьОрганизация.Параметры.Заполнить(ТекСтрока);
				СписокТребуемыхПараметров	= "НаименованиеДляПечатныхФорм";
				СведенияОбОбъекте			= уатОбщегоНазначенияСервер.СведенияОЮрФизЛице(ТекущийДокумент.Организация);
				ОбластьОрганизация.Параметры.Организация		= уатОбщегоНазначенияТиповыеСервер.ОписаниеОрганизации(СведенияОбОбъекте, СписокТребуемыхПараметров);
				ТабличныйДокумент.Вывести(ОбластьОрганизация);    	
			КонецЕсли;
			ОбластьРеквизитыШапки1 = Макет.ПолучитьОбласть("РеквизитыШапки1");
			ОбластьРеквизитыШапки1.Параметры.Заполнить(ТекСтрока);
			ТабличныйДокумент.Вывести(ОбластьРеквизитыШапки1);
			
		КонецЦикла;
		
		// счетчики
		Если ТЗСчетчики.Количество() Тогда
			ОбластьШапкаСчетчики = Макет.ПолучитьОбласть("ШапкаСчетчики");
			ТабличныйДокумент.Вывести(ОбластьШапкаСчетчики);
			
			НомерСтроки = 1;
			Для Каждого ТекСтрока Из ТЗСчетчики Цикл
				ОбластьСтрокаСчетчики = Макет.ПолучитьОбласть("СтрокаСчетчики");
				ОбластьСтрокаСчетчики.Параметры.Заполнить(ТекСтрока);
				ОбластьСтрокаСчетчики.Параметры.Разница = Строка(ТекСтрока.НовоеЗначение - ТекСтрока.СтароеЗначение) + " км";
				ОбластьСтрокаСчетчики.Параметры.НомерСтроки = НомерСтроки;
				ТабличныйДокумент.Вывести(ОбластьСтрокаСчетчики);
				НомерСтроки = НомерСтроки + 1;
			КонецЦикла;
			ОбластьПодвалСчетчики = Макет.ПолучитьОбласть("ПодвалСчетчики");
			ТабличныйДокумент.Вывести(ОбластьПодвалСчетчики);
		КонецЕсли;
		
		ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Портрет;
		ТабличныйДокумент.ПолеСлева = 0;
		ТабличныйДокумент.ПолеСправа = 0;
		ТабличныйДокумент.ИмяПараметровПечати = "ИзменениеСчетчиков";
		
		ТабличныйДокумент.ОтображатьСетку = Ложь;
		ТабличныйДокумент.Защита = Ложь;
		ТабличныйДокумент.ТолькоПросмотр = Ложь;
		ТабличныйДокумент.ОтображатьЗаголовки = Ложь;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ТекущийДокумент);
		
	КонецЦикла;
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабличныйДокумент;
	
КонецФункции // ПечатнаяФорма()

#КонецОбласти

#КонецЕсли