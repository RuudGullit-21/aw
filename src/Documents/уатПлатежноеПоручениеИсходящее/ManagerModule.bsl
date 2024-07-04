#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.Печать

// Заполняет список команд печати.
// 
// Параметры:
//   КомандыПечати - ТаблицаЗначений - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Документ.уатПлатежноеПоручениеИсходящее";
	КомандаПечати.Идентификатор = "ПлатежноеПоручение";
	КомандаПечати.Представление = НСтр("en='Payment order';ru='Платежное поручение'");
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор  = "Реестр";
	КомандаПечати.Представление  = НСтр("en='Document register';ru='Реестр документов'");
	КомандаПечати.ЗаголовокФормы = НСтр("en='Registry of document ""Outgoing payment order""';ru='Реестр документов ""Платежное поручение исходящее""'");
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
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПлатежноеПоручение") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ПлатежноеПоручение",
			"Платежное поручение", ПечатьППИсх(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	
	уатОбщегоНазначенияСервер.УстановитьРедактированиеПечатныхФормДокумента(КоллекцияПечатныхФорм);
	уатУправлениеПечатью.ЗаполнитьПараметрыОтправки(ПараметрыВывода.ПараметрыОтправки, МассивОбъектов, КоллекцияПечатныхФорм);
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.Печать

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки - Структура - настройки подсистемы.
Процедура ПриОпределенииНастроекВерсионированияОбъектов(Настройки) Экспорт
	
	Настройки.ПриПолученииСлужебныхРеквизитов = Ложь;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов

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
	
	Если НЕ ДокументСсылка.Оплачено Тогда
		Возврат;
	КонецЕсли;
		
	флПодотчетник = (ДокументСсылка.ВидОперации = Перечисления.уатВидыОперацийПлатежноеПоручениеИсходящее.ВыдачаПодотчетнику);
	флМноговалютныйУчет = ПолучитьФункциональнуюОпцию("уатМноговалютныйУчет");
	ВидОперацииПрочее = (ДокументСсылка.ВидОперации = Перечисления.уатВидыОперацийПлатежноеПоручениеИсходящее.РасходДенежныхСредствПрочее);
	
	Запрос = Новый Запрос(
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	""Взаиморасчеты"" КАК ИмяРегистра,
	|	РасшифровкаПлатежаДок.Ссылка КАК Регистратор,
	|	РасшифровкаПлатежаДок.Ссылка.Дата КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	РасшифровкаПлатежаДок.Ссылка.Организация КАК Организация,
	|	РасшифровкаПлатежаДок.Ссылка.Контрагент КАК Контрагент,
	|	РасшифровкаПлатежаДок.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	ВЫБОР
	|		КОГДА РасшифровкаПлатежаДок.ДоговорКонтрагента.ВедениеВзаиморасчетов = ЗНАЧЕНИЕ(Перечисление.ВедениеВзаиморасчетовПоДоговорам.ПоСчетам)
	|				ИЛИ РасшифровкаПлатежаДок.ДоговорКонтрагента.ВедениеВзаиморасчетов = ЗНАЧЕНИЕ(Перечисление.ВедениеВзаиморасчетовПоДоговорам.ПоНакладным)
	|				ИЛИ РасшифровкаПлатежаДок.ДоговорКонтрагента.ВедениеВзаиморасчетов = ЗНАЧЕНИЕ(Перечисление.ВедениеВзаиморасчетовПоДоговорам.ПоЗаказамНаТС)
	|			ТОГДА РасшифровкаПлатежаДок.Сделка
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК Сделка,
	|	ВЫБОР
	|		КОГДА &ВидОперацииПрочее
	|				ИЛИ &флПодотчетник
	|				ИЛИ НЕ &МноговалютныйУчет
	|			ТОГДА РасшифровкаПлатежаДок.Ссылка.ВалютаДокумента
	|		ИНАЧЕ РасшифровкаПлатежаДок.ВалютаВзаиморасчетов
	|	КОНЕЦ КАК Валюта,
	|	ВЫБОР
	|		КОГДА &ВидОперацииПрочее
	|				ИЛИ &флПодотчетник
	|				ИЛИ НЕ &МноговалютныйУчет
	|			ТОГДА &КурсДокумента
	|		ИНАЧЕ РасшифровкаПлатежаДок.КурсВзаиморасчетов
	|	КОНЕЦ КАК КурсВзаиморасчетов,
	|	ВЫБОР
	|		КОГДА &ВидОперацииПрочее
	|				ИЛИ &флПодотчетник
	|				ИЛИ НЕ &МноговалютныйУчет
	|			ТОГДА &КратностьДокумента
	|		ИНАЧЕ РасшифровкаПлатежаДок.КратностьВзаиморасчетов
	|	КОНЕЦ КАК КратностьВзаиморасчетов,
	|	РасшифровкаПлатежаДок.СуммаПлатежа КАК СуммаПлатежа,
	|	ВЫБОР
	|		КОГДА &МноговалютныйУчет
	|			ТОГДА РасшифровкаПлатежаДок.СуммаВзаиморасчетов
	|		ИНАЧЕ РасшифровкаПлатежаДок.СуммаПлатежа
	|	КОНЕЦ КАК СуммаВзаиморасчетов,
	|	0 КАК СуммаУпр,
	|	РасшифровкаПлатежаДок.СтавкаНДС КАК СтавкаНДС,
	|	РасшифровкаПлатежаДок.СуммаНДС КАК СуммаНДС,
	|	РасшифровкаПлатежаДок.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств
	|ИЗ
	|	Документ.уатПлатежноеПоручениеИсходящее.РасшифровкаПлатежа КАК РасшифровкаПлатежаДок
	|ГДЕ
	|	РасшифровкаПлатежаДок.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	""ДвижениеДС"" КАК ИмяРегистра,
	|	РасшифровкаПлатежаДок.Ссылка КАК Регистратор,
	|	РасшифровкаПлатежаДок.Ссылка КАК ДокументДвижения,
	|	РасшифровкаПлатежаДок.Ссылка.Дата КАК Период,
	|	РасшифровкаПлатежаДок.Ссылка.БанковскийСчет КАК БанковскийСчетКасса,
	|	ЗНАЧЕНИЕ(Перечисление.уатФормыОплаты.Безналичные) КАК ВидДенежныхСредств,
	|	ЗНАЧЕНИЕ(Перечисление.ВидыДвиженийПриходРасход.Расход) КАК ПриходРасход,
	|	РасшифровкаПлатежаДок.Ссылка.Организация КАК Организация,
	|	ВЫБОР
	|		КОГДА &флПодотчетник
	|			ТОГДА РасшифровкаПлатежаДок.Ссылка.ПодотчетноеЛицо
	|		ИНАЧЕ РасшифровкаПлатежаДок.Ссылка.Контрагент
	|	КОНЕЦ КАК Контрагент,
	|	ВЫБОР
	|		КОГДА &флПодотчетник
	|			ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ РасшифровкаПлатежаДок.ДоговорКонтрагента
	|	КОНЕЦ КАК ДоговорКонтрагента,
	|	ВЫБОР
	|		КОГДА РасшифровкаПлатежаДок.ДоговорКонтрагента.ВедениеВзаиморасчетов = ЗНАЧЕНИЕ(Перечисление.ВедениеВзаиморасчетовПоДоговорам.ПоСчетам)
	|				ИЛИ РасшифровкаПлатежаДок.ДоговорКонтрагента.ВедениеВзаиморасчетов = ЗНАЧЕНИЕ(Перечисление.ВедениеВзаиморасчетовПоДоговорам.ПоНакладным)
	|				ИЛИ РасшифровкаПлатежаДок.ДоговорКонтрагента.ВедениеВзаиморасчетов = ЗНАЧЕНИЕ(Перечисление.ВедениеВзаиморасчетовПоДоговорам.ПоЗаказамНаТС)
	|			ТОГДА РасшифровкаПлатежаДок.Сделка
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК Сделка,
	|	РасшифровкаПлатежаДок.Ссылка.ВалютаДокумента КАК Валюта,
	|	РасшифровкаПлатежаДок.СуммаПлатежа КАК Сумма,
	|	0 КАК СуммаУпр,
	|	РасшифровкаПлатежаДок.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств
	|ИЗ
	|	Документ.уатПлатежноеПоручениеИсходящее.РасшифровкаПлатежа КАК РасшифровкаПлатежаДок
	|ГДЕ
	|	РасшифровкаПлатежаДок.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""ДвижениеДС"",
	|	РасшифровкаПлатежаДок.Ссылка,
	|	РасшифровкаПлатежаДок.Ссылка,
	|	РасшифровкаПлатежаДок.Ссылка.Дата,
	|	РасшифровкаПлатежаДок.Ссылка.СчетПолучателя,
	|	ЗНАЧЕНИЕ(Перечисление.уатФормыОплаты.Безналичные),
	|	ЗНАЧЕНИЕ(Перечисление.ВидыДвиженийПриходРасход.Приход),
	|	РасшифровкаПлатежаДок.Ссылка.Организация,
	|	НЕОПРЕДЕЛЕНО,
	|	НЕОПРЕДЕЛЕНО,
	|	НЕОПРЕДЕЛЕНО,
	|	РасшифровкаПлатежаДок.Ссылка.ВалютаДокумента,
	|	РасшифровкаПлатежаДок.СуммаПлатежа,
	|	0,
	|	РасшифровкаПлатежаДок.СтатьяДвиженияДенежныхСредств
	|ИЗ
	|	Документ.уатПлатежноеПоручениеИсходящее.РасшифровкаПлатежа КАК РасшифровкаПлатежаДок
	|ГДЕ
	|	РасшифровкаПлатежаДок.Ссылка = &Ссылка
	|	И РасшифровкаПлатежаДок.Ссылка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.уатВидыОперацийПлатежноеПоручениеИсходящее.ПереводНаДругойСчет)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	""ОстаткиДС"" КАК ИмяРегистра,
	|	РасшифровкаПлатежаДок.Ссылка КАК Регистратор,
	|	РасшифровкаПлатежаДок.Ссылка КАК ДокументДвижения,
	|	РасшифровкаПлатежаДок.Ссылка.Дата КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	РасшифровкаПлатежаДок.Ссылка.Организация КАК Организация,
	|	РасшифровкаПлатежаДок.Ссылка.БанковскийСчет КАК БанковскийСчетКасса,
	|	ЗНАЧЕНИЕ(Перечисление.уатФормыОплаты.Безналичные) КАК ВидДенежныхСредств,
	|	РасшифровкаПлатежаДок.СуммаПлатежа КАК Сумма,
	|	0 КАК СуммаУпр,
	|	РасшифровкаПлатежаДок.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств
	|ИЗ
	|	Документ.уатПлатежноеПоручениеИсходящее.РасшифровкаПлатежа КАК РасшифровкаПлатежаДок
	|ГДЕ
	|	РасшифровкаПлатежаДок.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""ОстаткиДС"",
	|	РасшифровкаПлатежаДок.Ссылка,
	|	РасшифровкаПлатежаДок.Ссылка,
	|	РасшифровкаПлатежаДок.Ссылка.Дата,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход),
	|	РасшифровкаПлатежаДок.Ссылка.Организация,
	|	РасшифровкаПлатежаДок.Ссылка.СчетПолучателя,
	|	ЗНАЧЕНИЕ(Перечисление.уатФормыОплаты.Безналичные),
	|	РасшифровкаПлатежаДок.СуммаПлатежа КАК Сумма,
	|	0 КАК СуммаУпр,
	|	РасшифровкаПлатежаДок.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств
	|ИЗ
	|	Документ.уатПлатежноеПоручениеИсходящее.РасшифровкаПлатежа КАК РасшифровкаПлатежаДок
	|ГДЕ
	|	РасшифровкаПлатежаДок.Ссылка = &Ссылка
	|	И РасшифровкаПлатежаДок.Ссылка.ВидОперации = ЗНАЧЕНИЕ(Перечисление.уатВидыОперацийПлатежноеПоручениеИсходящее.ПереводНаДругойСчет)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	""ОстаткиДСуПодотчетныхЛиц"" КАК ИмяРегистра,
	|	РасшифровкаПлатежаДок.Ссылка КАК Регистратор,
	|	РасшифровкаПлатежаДок.Ссылка КАК ДокументДвижения,
	|	РасшифровкаПлатежаДок.Ссылка.Дата КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	РасшифровкаПлатежаДок.Ссылка.Организация КАК Организация,
	|	РасшифровкаПлатежаДок.Ссылка.ПодотчетноеЛицо КАК ПодотчетноеЛицо,
	|	РасшифровкаПлатежаДок.Ссылка.ВалютаДокумента КАК Валюта,
	|	РасшифровкаПлатежаДок.СуммаПлатежа КАК Сумма,
	|	0 КАК СуммаУпр,
	|	РасшифровкаПлатежаДок.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств
	|ИЗ
	|	Документ.уатПлатежноеПоручениеИсходящее.РасшифровкаПлатежа КАК РасшифровкаПлатежаДок
	|ГДЕ
	|	РасшифровкаПлатежаДок.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	""ПлатежныйКалендарь"" КАК ИмяРегистра,
	|	РасшифровкаПлатежаДок.Ссылка КАК Регистратор,
	|	РасшифровкаПлатежаДок.Ссылка.Дата КАК Период,
	|	РасшифровкаПлатежаДок.Ссылка.Организация КАК Организация,
	|	ЗНАЧЕНИЕ(Перечисление.уатПолучателиУслуг.НашаОрганизация) КАК ПолучательУслуг,
	|	РасшифровкаПлатежаДок.Ссылка.Контрагент КАК Контрагент,
	|	РасшифровкаПлатежаДок.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	РасшифровкаПлатежаДок.Сделка КАК ЗаказНаТС,
	|	ВЫБОР
	|		КОГДА РасшифровкаПлатежаДок.ДоговорКонтрагента.ВедениеВзаиморасчетов = ЗНАЧЕНИЕ(Перечисление.ВедениеВзаиморасчетовПоДоговорам.ПоСчетам)
	|				ИЛИ РасшифровкаПлатежаДок.ДоговорКонтрагента.ВедениеВзаиморасчетов = ЗНАЧЕНИЕ(Перечисление.ВедениеВзаиморасчетовПоДоговорам.ПоНакладным)
	|				ИЛИ РасшифровкаПлатежаДок.ДоговорКонтрагента.ВедениеВзаиморасчетов = ЗНАЧЕНИЕ(Перечисление.ВедениеВзаиморасчетовПоДоговорам.ПоЗаказамНаТС)
	|			ТОГДА РасшифровкаПлатежаДок.Сделка
	|		ИНАЧЕ НЕОПРЕДЕЛЕНО
	|	КОНЕЦ КАК Сделка,
	|	ВЫБОР
	|		КОГДА &ВидОперацииПрочее
	|				ИЛИ &флПодотчетник
	|				ИЛИ НЕ &МноговалютныйУчет
	|			ТОГДА РасшифровкаПлатежаДок.Ссылка.ВалютаДокумента
	|		ИНАЧЕ РасшифровкаПлатежаДок.ВалютаВзаиморасчетов
	|	КОНЕЦ КАК Валюта,
	|	ВЫБОР
	|		КОГДА &ВидОперацииПрочее
	|				ИЛИ &флПодотчетник
	|				ИЛИ НЕ &МноговалютныйУчет
	|			ТОГДА &КурсДокумента
	|		ИНАЧЕ РасшифровкаПлатежаДок.КурсВзаиморасчетов
	|	КОНЕЦ КАК КурсВзаиморасчетов,
	|	ВЫБОР
	|		КОГДА &ВидОперацииПрочее
	|				ИЛИ &флПодотчетник
	|				ИЛИ НЕ &МноговалютныйУчет
	|			ТОГДА &КратностьДокумента
	|		ИНАЧЕ РасшифровкаПлатежаДок.КратностьВзаиморасчетов
	|	КОНЕЦ КАК КратностьВзаиморасчетов,
	|	ВЫБОР
	|		КОГДА &МноговалютныйУчет
	|			ТОГДА РасшифровкаПлатежаДок.СуммаВзаиморасчетов
	|		ИНАЧЕ РасшифровкаПлатежаДок.СуммаПлатежа
	|	КОНЕЦ КАК СуммаРасход,
	|	0 КАК СуммаРасходУпр
	|ИЗ
	|	Документ.уатПлатежноеПоручениеИсходящее.РасшифровкаПлатежа КАК РасшифровкаПлатежаДок
	|ГДЕ
	|	РасшифровкаПлатежаДок.Ссылка = &Ссылка
	|	И (РасшифровкаПлатежаДок.ДоговорКонтрагента.ВедениеВзаиморасчетов = ЗНАЧЕНИЕ(Перечисление.ВедениеВзаиморасчетовПоДоговорам.ПоСчетам)
	|			ИЛИ РасшифровкаПлатежаДок.ДоговорКонтрагента.ВедениеВзаиморасчетов = ЗНАЧЕНИЕ(Перечисление.ВедениеВзаиморасчетовПоДоговорам.ПоНакладным)
	|			ИЛИ РасшифровкаПлатежаДок.ДоговорКонтрагента.ВедениеВзаиморасчетов = ЗНАЧЕНИЕ(Перечисление.ВедениеВзаиморасчетовПоДоговорам.ПоЗаказамНаТС))
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	РасшифровкаПлатежаДок.Ссылка КАК Регистратор,
	|	РасшифровкаПлатежаДок.Ссылка КАК ДокументДвижения,
	|	РасшифровкаПлатежаДок.Ссылка.Дата КАК Период,
	|	РасшифровкаПлатежаДок.Ссылка.Организация КАК Организация,
	|	РасшифровкаПлатежаДок.Сделка КАК Сделка,
	|	РасшифровкаПлатежаДок.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
	|	ВЫБОР
	|		КОГДА &флПодотчетник
	|			ТОГДА РасшифровкаПлатежаДок.Ссылка.ПодотчетноеЛицо
	|		ИНАЧЕ РасшифровкаПлатежаДок.Ссылка.Контрагент
	|	КОНЕЦ КАК Контрагент,
	|	ВЫБОР
	|		КОГДА &флПодотчетник
	|			ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ РасшифровкаПлатежаДок.ДоговорКонтрагента
	|	КОНЕЦ КАК ДоговорКонтрагента,
	|	РасшифровкаПлатежаДок.ДокументПланированияПлатежа КАК ЗаявкаНаРасходование,
	|	СУММА(РасшифровкаПлатежаДок.СуммаВзаиморасчетов) КАК СуммаВзаиморасчетов,
	|	СУММА(РасшифровкаПлатежаДок.СуммаПлатежа) КАК Сумма,
	|	0 КАК СуммаУпр
	|ПОМЕСТИТЬ ДокументуатПлатежноеПоручениеИсходящее
	|ИЗ
	|	Документ.уатПлатежноеПоручениеИсходящее.РасшифровкаПлатежа КАК РасшифровкаПлатежаДок
	|ГДЕ
	|	РасшифровкаПлатежаДок.Ссылка = &Ссылка
	|	И РасшифровкаПлатежаДок.ДокументПланированияПлатежа ССЫЛКА Документ.уатЗаявкаНаРасходованиеДС
	|	И РасшифровкаПлатежаДок.ДокументПланированияПлатежа <> ЗНАЧЕНИЕ(Документ.уатЗаявкаНаРасходованиеДС.ПустаяСсылка)
	|
	|СГРУППИРОВАТЬ ПО
	|	РасшифровкаПлатежаДок.Ссылка,
	|	РасшифровкаПлатежаДок.Сделка,
	|	РасшифровкаПлатежаДок.ДокументПланированияПлатежа,
	|	РасшифровкаПлатежаДок.СтатьяДвиженияДенежныхСредств,
	|	ВЫБОР
	|		КОГДА &флПодотчетник
	|			ТОГДА НЕОПРЕДЕЛЕНО
	|		ИНАЧЕ РасшифровкаПлатежаДок.ДоговорКонтрагента
	|	КОНЕЦ,
	|	РасшифровкаПлатежаДок.Ссылка.Дата,
	|	РасшифровкаПлатежаДок.Ссылка.Организация,
	|	ВЫБОР
	|		КОГДА &флПодотчетник
	|			ТОГДА РасшифровкаПлатежаДок.Ссылка.ПодотчетноеЛицо
	|		ИНАЧЕ РасшифровкаПлатежаДок.Ссылка.Контрагент
	|	КОНЕЦ,
	|	РасшифровкаПлатежаДок.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	""ЗаявкиНаРасходованиеДС"" КАК ИмяРегистра,
	|	РасшифровкаПлатежаДок.Регистратор КАК Регистратор,
	|	РасшифровкаПлатежаДок.ДокументДвижения КАК ДокументДвижения,
	|	РасшифровкаПлатежаДок.Период КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	РасшифровкаПлатежаДок.Организация КАК Организация,
	|	РасшифровкаПлатежаДок.Сделка КАК Сделка,
	|	РасшифровкаПлатежаДок.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
	|	РасшифровкаПлатежаДок.Контрагент КАК Контрагент,
	|	РасшифровкаПлатежаДок.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	РасшифровкаПлатежаДок.ЗаявкаНаРасходование КАК ЗаявкаНаРасходование,
	|	РасшифровкаПлатежаДок.ЗаявкаНаРасходование.ВалютаДокумента КАК ВалютаЗаявки,
	|	РасшифровкаПлатежаДок.ЗаявкаНаРасходование.КурсДокумента КАК КурсЗаявки,
	|	РасшифровкаПлатежаДок.ЗаявкаНаРасходование.КратностьДокумента КАК КратностьЗаявки,
	|	РасшифровкаПлатежаДок.Сумма КАК Сумма,
	|	РасшифровкаПлатежаДок.Сумма КАК СуммаВзаиморасчетов,
	|	РасшифровкаПлатежаДок.Сумма КАК СуммаУпр
	|ИЗ
	|	ДокументуатПлатежноеПоручениеИсходящее КАК РасшифровкаПлатежаДок");
		
	Запрос.УстановитьПараметр("Ссылка",             ДокументСсылка);
	Запрос.УстановитьПараметр("флПодотчетник",      флПодотчетник);
	Запрос.УстановитьПараметр("ВидОперацииПрочее",  ВидОперацииПрочее);
	Запрос.УстановитьПараметр("КурсДокумента",      СтруктураДополнительныеСвойства.КурсДокумента);
	Запрос.УстановитьПараметр("КратностьДокумента", СтруктураДополнительныеСвойства.КратностьДокумента);
	Запрос.УстановитьПараметр("ПериодОстатки",      ДокументСсылка.Дата);
	Запрос.УстановитьПараметр("МноговалютныйУчет",  флМноговалютныйУчет);
	
	МассивРезультатов = Запрос.ВыполнитьПакет();
	
	// взаиморасчеты
	ТаблицаВзаиморасчетов = МассивРезультатов[0].Выгрузить();
	Для Каждого ТекСтрока Из ТаблицаВзаиморасчетов Цикл
		ТекСтрока.СуммаУпр = уатОбщегоНазначенияТиповые.ПересчитатьИзВалютыВВалюту(ТекСтрока.СуммаВзаиморасчетов,
			ТекСтрока.Валюта,                  СтруктураДополнительныеСвойства.ВалютаУпрУчета,
			ТекСтрока.КурсВзаиморасчетов,      СтруктураДополнительныеСвойства.КурсУпр,
			ТекСтрока.КратностьВзаиморасчетов, СтруктураДополнительныеСвойства.КратностьУпр);
	КонецЦикла;
	//ТабВзаиморасчетов.Свернуть("ВидДвижения, Период, Регистратор, ДоговорКонтрагента, Сделка, Организация, Контрагент, Валюта", "СуммаВзаиморасчетов, СуммаУпр");
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаВзаиморасчетов", ТаблицаВзаиморасчетов);
	
	// ДДС
	ТаблицаДвижениеДС = МассивРезультатов[1].Выгрузить();
	Для Каждого ТекСтрока Из ТаблицаДвижениеДС Цикл
		ТекСтрока.СуммаУпр = уатОбщегоНазначенияТиповые.ПересчитатьИзВалютыВВалюту(ТекСтрока.Сумма,
			ДокументСсылка.ВалютаДокумента,                     СтруктураДополнительныеСвойства.ВалютаУпрУчета,
			СтруктураДополнительныеСвойства.КурсДокумента,      СтруктураДополнительныеСвойства.КурсУпр,
			СтруктураДополнительныеСвойства.КратностьДокумента, СтруктураДополнительныеСвойства.КратностьУпр);
	КонецЦикла;
	//ТаблицаДвижениеДС.Свернуть("ВидДвижения, Период, Регистратор, Валюта, БанковскийСчетКасса, ВидДенежныхСредств, ПриходРасход, СтатьяДвиженияДенежныхСредств, ДокументДвижения, Контрагент, ДоговорКонтрагента, Сделка, Организация","Сумма, СуммаУпр");
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаДвижениеДС", ТаблицаДвижениеДС);
	
	// Остатки ДС	
	ТаблицаОстаткиДС = МассивРезультатов[2].Выгрузить();
	Для Каждого ТекСтрока Из ТаблицаОстаткиДС Цикл
		ТекСтрока.СуммаУпр = уатОбщегоНазначенияТиповые.ПересчитатьИзВалютыВВалюту(ТекСтрока.Сумма,
			ДокументСсылка.ВалютаДокумента,                     СтруктураДополнительныеСвойства.ВалютаУпрУчета,
			СтруктураДополнительныеСвойства.КурсДокумента,      СтруктураДополнительныеСвойства.КурсУпр,
			СтруктураДополнительныеСвойства.КратностьДокумента, СтруктураДополнительныеСвойства.КратностьУпр);
	КонецЦикла;
	//ТаблицаОстаткиДС.Свернуть("ВидДвижения, Период, Регистратор, Организация, БанковскийСчетКасса, ВидДенежныхСредств, СтатьяДвиженияДенежныхСредств", "Сумма, СуммаУпр");
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаОстаткиДС", ТаблицаОстаткиДС);
	
	// Остатки ДС у подотчетных лиц
	Если флПодотчетник Тогда
		ТаблицаОстаткиДСУПодотчетныхЛиц = МассивРезультатов[3].Выгрузить();
		Для Каждого ТекСтрока Из ТаблицаОстаткиДСУПодотчетныхЛиц Цикл
			ТекСтрока.СуммаУпр = уатОбщегоНазначенияТиповые.ПересчитатьИзВалютыВВалюту(ТекСтрока.Сумма,
				ДокументСсылка.ВалютаДокумента,                     СтруктураДополнительныеСвойства.ВалютаУпрУчета,
				СтруктураДополнительныеСвойства.КурсДокумента,      СтруктураДополнительныеСвойства.КурсУпр,
				СтруктураДополнительныеСвойства.КратностьДокумента, СтруктураДополнительныеСвойства.КратностьУпр);
		КонецЦикла;
		//ТаблицаОстаткиДСУПодотчетныхЛиц.Свернуть("ВидДвижения, Период, Регистратор, Организация, ПодотчетноеЛицо, Валюта", "Сумма, СуммаУпр");
		СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаОстаткиДСУПодотчетныхЛиц", ТаблицаОстаткиДСУПодотчетныхЛиц);
	КонецЕсли;
	
	// Платежный календарь
	ТаблицаПлатежныйКалендарь = МассивРезультатов[4].Выгрузить();
	Для Каждого ТекСтрока Из ТаблицаПлатежныйКалендарь Цикл
		ТекСтрока.СуммаРасходУпр = уатОбщегоНазначенияТиповые.ПересчитатьИзВалютыВВалюту(ТекСтрока.СуммаРасход,
			ТекСтрока.Валюта,                  СтруктураДополнительныеСвойства.ВалютаУпрУчета,
			ТекСтрока.КурсВзаиморасчетов,      СтруктураДополнительныеСвойства.КурсУпр,
			ТекСтрока.КратностьВзаиморасчетов, СтруктураДополнительныеСвойства.КратностьУпр);
	КонецЦикла;
	ТаблицаПлатежныйКалендарь.Свернуть("Период, Регистратор, Организация, Контрагент, ДоговорКонтрагента, Сделка, ЗаказНаТС, Валюта, ПолучательУслуг", "СуммаРасход, СуммаРасходУпр");
	уатПроведение_проф.РаспределитьПлатежныйКалендарьПоГрафикуОплаты(ТаблицаПлатежныйКалендарь, ДокументСсылка);
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаПлатежныйКалендарь", ТаблицаПлатежныйКалендарь);
	
	// Заявки на расходование ДС
	ТаблицаЗаявокНаРасходованиеДС = МассивРезультатов[6].Выгрузить();
	Для Каждого ТекСтрока Из ТаблицаЗаявокНаРасходованиеДС Цикл
		Если ДокументСсылка.ВалютаДокумента <> СтруктураДополнительныеСвойства.ВалютаУпрУчета Тогда
			ТекСтрока.СуммаУпр = уатОбщегоНазначенияТиповые.ПересчитатьИзВалютыВВалюту(ТекСтрока.Сумма,
				ДокументСсылка.ВалютаДокумента,                     СтруктураДополнительныеСвойства.ВалютаУпрУчета,
				СтруктураДополнительныеСвойства.КурсДокумента,      СтруктураДополнительныеСвойства.КурсУпр,
				СтруктураДополнительныеСвойства.КратностьДокумента, СтруктураДополнительныеСвойства.КратностьУпр);
		КонецЕсли;
		Если ДокументСсылка.ВалютаДокумента <> ТекСтрока.ВалютаЗаявки Тогда
			ТекСтрока.Сумма = уатОбщегоНазначенияТиповые.ПересчитатьИзВалютыВВалюту(ТекСтрока.Сумма,
				ДокументСсылка.ВалютаДокумента,                     ТекСтрока.ВалютаЗаявки,
				СтруктураДополнительныеСвойства.КурсДокумента,      ТекСтрока.КурсЗаявки,
				СтруктураДополнительныеСвойства.КратностьДокумента, ТекСтрока.КратностьЗаявки);
			ТекСтрока.СуммаВзаиморасчетов = ТекСтрока.Сумма;
		КонецЕсли;
	КонецЦикла;
	//ТаблицаЗаявокНаРасходованиеДС.Свернуть("ВидДвижения, Период, Регистратор, ДоговорКонтрагента, ЗаявкаНаРасходование, Контрагент, Организация, Сделка, СтатьяДвиженияДенежныхСредств", "Сумма, СуммаВзаиморасчетов, СуммаУпр");
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаЗаявокНаРасходованиеДС", ТаблицаЗаявокНаРасходованиеДС);
	
КонецПроцедуры // ИнициализироватьДанныеДокумента()

Процедура ВыполнитьКонтроль(ДокументСсылка, ДополнительныеСвойства, Отказ, УдалениеПроведения = Ложь) Экспорт
	
	
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

Функция ПечатьППИсх(МассивОбъектов, ОбъектыПечати)  
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_ППИсходящее";
	
	ПервыйДокумент = Истина;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("МассивПП", МассивОбъектов);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	уатПлатежноеПоручениеИсходящее.Ссылка КАК Ссылка,
	|	уатПлатежноеПоручениеИсходящее.Организация КАК Организация,
	|	уатПлатежноеПоручениеИсходящее.Номер КАК Номер,
	|	уатПлатежноеПоручениеИсходящее.БанковскийСчет КАК БанковскийСчет,
	|	уатПлатежноеПоручениеИсходящее.Дата КАК Дата,
	|	уатПлатежноеПоручениеИсходящее.ВидПлатежа КАК ВидПлатежа,
	|	уатПлатежноеПоручениеИсходящее.СуммаДокумента КАК СуммаДокумента,
	|	уатПлатежноеПоручениеИсходящее.Контрагент КАК Контрагент,
	|	уатПлатежноеПоручениеИсходящее.СчетКонтрагента КАК СчетКонтрагента,
	|	уатПлатежноеПоручениеИсходящее.ОчередностьПлатежа КАК ОчередностьПлатежа,
	|	уатПлатежноеПоручениеИсходящее.НазначениеПлатежа КАК НазначениеПлатежа,
	|	уатПлатежноеПоручениеИсходящее.ИдентификаторПлатежа КАК ИдентификаторПлатежа,
	|	уатПлатежноеПоручениеИсходящее.ДокументОснование КАК ДокументОснование
	|ИЗ
	|	Документ.уатПлатежноеПоручениеИсходящее КАК уатПлатежноеПоручениеИсходящее
	|ГДЕ
	|	уатПлатежноеПоручениеИсходящее.Ссылка В(&МассивПП)";
		
	ДокументПП = Запрос.Выполнить().Выбрать();
	
	Пока ДокументПП.Следующий() Цикл 
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ТабличныйДокумент.ИмяПараметровПечати = "ПараметрыПечати_ППИсходящее";
		Макет = УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_ПлатежноеПоручение");
		
		Если Не ЗначениеЗаполнено(ДокументПП.Организация) Тогда
			ТекстНСТР = НСтр("en='Company is not specified in payment order ""%1""!';ru='Не указана организация в платежном поручении ""%1""!'");
			ТекстНСТР = СтрШаблон(ТекстНСТР, ДокументПП.Ссылка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР);
			Прервать;
		КонецЕсли;
		
		ПечатьПрефиксовВключена = уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(ДокументПП.Организация, ПредопределенноеЗначение("ПланВидовХарактеристик.уатПраваИНастройки.ВыводитьПрефиксПриПечати"));
		Если ПечатьПрефиксовВключена Тогда
			НомерПечать = ДокументПП.Номер;
		Иначе 
			НомерПечать = уатОбщегоНазначенияКлиентСервер.НомерДокументаНаПечать(ДокументПП.Номер, Истина, Истина);
		КонецЕсли;
		
		Если Прав(НомерПечать, 3)="000" Тогда
			ТекстНСТР = НСтр("en='Payment order number ""%1"" can not end with ""000""!';ru='Номер платежного поручения ""%1"" не может оканчиваться на ""000""!'");
			ТекстНСТР = СтрШаблон(ТекстНСТР, ДокументПП.Ссылка);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстНСТР);
			Возврат Неопределено;
		КонецЕсли;
		
		Обл = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
		
		МесяцПрописью   = ДокументПП.БанковскийСчет.МесяцПрописью;
		СуммаБезКопеек  = ДокументПП.БанковскийСчет.СуммаБезКопеек;
		ФорматДаты      = "ДФ=" + ?(МесяцПрописью = 1,"'дд ММММ гггг'","'дд.ММ.гггг'");
		БанкОрганизации = ?(НЕ ЗначениеЗаполнено(ДокументПП.БанковскийСчет.БанкДляРасчетов), ДокументПП.БанковскийСчет.Банк, 
			ДокументПП.БанковскийСчет.БанкДляРасчетов);
		БанкКонтрагента = ?(НЕ ЗначениеЗаполнено(ДокументПП.СчетКонтрагента.БанкДляРасчетов), ДокументПП.СчетКонтрагента.Банк, 
			ДокументПП.СчетКонтрагента.БанкДляРасчетов);
		
		Обл.Параметры.НаименованиеНомер       = НСтр("en='PAYMENT ORDER №';ru='ПЛАТЕЖНОЕ ПОРУЧЕНИЕ № '") + НомерПечать;
		Обл.Параметры.ДатаДокумента           = Формат(ДокументПП.Дата, ФорматДаты);
		Обл.Параметры.ВидПлатежа              = ДокументПП.ВидПлатежа;
		Обл.Параметры.СуммаЧислом             = ФорматироватьСумму(ДокументПП.СуммаДокумента, СуммаБезКопеек);
		Обл.Параметры.СуммаПрописью           = ФорматироватьСуммуПрописи(ДокументПП.СуммаДокумента, СуммаБезКопеек, ДокументПП.БанковскийСчет);
		
		Обл.Параметры.ПлательщикИНН                = "ИНН " + ДокументПП.Организация.ИНН;
		Обл.Параметры.ПлательщикКПП                = "КПП " + ДокументПП.Организация.КПП;
		Обл.Параметры.Плательщик                   = ДокументПП.Организация.НаименованиеПолное;
		Обл.Параметры.БанкПлательщика              = "" + БанкОрганизации + " " + БанкОрганизации.Город;
		Обл.Параметры.БанкПолучателя               = "" + БанкКонтрагента + " " + БанкКонтрагента.Город;
		Обл.Параметры.ПолучательИНН                = "ИНН " + ДокументПП.Контрагент.ИНН;
		Обл.Параметры.ПолучательКПП                = "КПП " + ДокументПП.Контрагент.КПП;
		Обл.Параметры.Получатель                   = ДокументПП.Контрагент.НаименованиеПолное;
		
		Обл.Параметры.ИдентификаторПлатежа = ДокументПП.ИдентификаторПлатежа;
		
		Если ТипЗнч(ДокументПП.ДокументОснование) = Тип("ДокументСсылка.уатШтраф") Тогда
			Обл.Параметры.КодБК = ?(ЗначениеЗаполнено(ДокументПП.ДокументОснование.КодБК), ДокументПП.ДокументОснование.КодБК,
				ДокументПП.Контрагент.КБК);
			
			Обл.Параметры.КодОКАТО = ?(ЗначениеЗаполнено(ДокументПП.ДокументОснование.КодПоОКТМО), ДокументПП.ДокументОснование.КодПоОКТМО,
				ДокументПП.Контрагент.КодПоОКТМО);
				
			Если НЕ ЗначениеЗаполнено(ДокументПП.ИдентификаторПлатежа) Тогда // для старых документов, когда не было ИдентификаторПлатежа в ППИ
				Обл.Параметры.ИдентификаторПлатежа = ДокументПП.ДокументОснование.НомерПостановления;
			КонецЕсли;
		КонецЕсли;
		
		Если НЕ ЗначениеЗаполнено(ДокументПП.БанковскийСчет.БанкДляРасчетов) Тогда
			СтрКорреспондент = "";
		Иначе
			СтрКорреспондент = " р/с " + ДокументПП.БанковскийСчет.НомерСчета+ " в " + ДокументПП.БанковскийСчет.Банк + " " 
				+ ДокументПП.БанковскийСчет.Банк.Город;
		КонецЕсли;
		
		Обл.Параметры.НомерСчетаПлательщика   = ВернутьРасчетныйСчет(ДокументПП.БанковскийСчет);
		Обл.Параметры.БикБанкаПлательщика     = БанкОрганизации.Код;
		Обл.Параметры.СчетБанкаПлательщика    = БанкОрганизации.КоррСчет;
		
		Обл.Параметры.БикБанкаПолучателя      = БанкКонтрагента.Код;
		Обл.Параметры.СчетБанкаПолучателя     = БанкКонтрагента.КоррСчет;
		Обл.Параметры.НомерСчетаПолучателя    = ВернутьРасчетныйСчет(ДокументПП.СчетКонтрагента);
		
		Обл.Параметры.НазначениеПлатежа       = СокрЛП(ДокументПП.НазначениеПлатежа);
		Обл.Параметры.Очередность             = ДокументПП.ОчередностьПлатежа;
		Обл.Параметры.СрокПлатежа             = "";
		
		ТабличныйДокумент.Вывести(Обл);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ДокументПП.Ссылка);
		
	КонецЦикла;
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабличныйДокумент;
	
КонецФункции // ПечатнаяФорма()

// Форматирует сумму прописью документа
//
// Параметры:
//  СуммаДок - число - реквизит, который надо представить прописью 
//  СуммаБезКопеек - булево - флаг представления суммы без копеек
//
// Возвращаемое значение
//  Отформатированную строку
//
Функция ФорматироватьСуммуПрописи(СуммаДок, СуммаБезКопеек, БанковскийСчет)
	
	Результат     = СуммаДок;
	ЦелаяЧасть    = Цел(СуммаДок);
	ФорматСтрока  = "Л=ru_RU; ДП=Ложь";
	ПарамПредмета = БанковскийСчет.ВалютаДенежныхСредств.ПараметрыПрописи;
	
	Если (Результат - ЦелаяЧасть) = 0 Тогда
		Если СуммаБезКопеек Тогда
			Результат = ЧислоПрописью(Результат,ФорматСтрока,ПарамПредмета);
			Результат = Лев(Результат,Найти(Результат,"0")-1);
		Иначе
			Результат = ЧислоПрописью(Результат,ФорматСтрока,ПарамПредмета);
		КонецЕсли;
	Иначе
		Результат = ЧислоПрописью(Результат,ФорматСтрока,ПарамПредмета);
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции // ФорматироватьСуммуПрописи()

// Форматирует сумму  документа
//
// Параметры:
//  СуммаДок - число - реквизит, который надо отформатировать
//  СуммаБезКопеек - булево - флаг представления суммы без копеек
//
// Возвращаемое значение
//  Отформатированную строку
//
Функция ФорматироватьСумму(СуммаДок,СуммаБезКопеек)
	
	Результат  = СуммаДок;
	ЦелаяЧасть = Цел(СуммаДок);
	
	Если (Результат - ЦелаяЧасть) = 0 Тогда
		Если СуммаБезКопеек Тогда
			Результат = Формат(Результат,"ЧДЦ=2; ЧРД='='; ЧГ=0");
			Результат = Лев(Результат,Найти(Результат,"="));
		Иначе
			Результат = Формат(Результат,"ЧДЦ=2; ЧРД='-'; ЧГ=0");
		КонецЕсли;
	Иначе
		Результат = Формат(Результат,"ЧДЦ=2; ЧРД='-'; ЧГ=0");
	КонецЕсли;
	
	Возврат Результат;
	
КонецФункции // ФорматироватьСумму()

// Определяет номер расчетного счета по
// переданному банковскому счету
//
// Параметры:
//  СчетКонтра - справочник.БанковскиеСчета
//
// Возвращаемое значение
//  Номер расчетного счета
//
Функция ВернутьРасчетныйСчет(СчетКонтрагента)
	
	БанкДляРасчетов = СчетКонтрагента.БанкДляРасчетов;
	Результат       = ?(Не ЗначениеЗаполнено(БанкДляРасчетов), СчетКонтрагента.НомерСчета, СчетКонтрагента.Банк.КоррСчет);
	
	Возврат Результат;
	
КонецФункции // ВернутьРасчетныйСчет()

// Процедура - Заполнить структуру получателей печатных форм
//
// Параметры:
//  СтруктураДанныхОбъектаПечати - Структура - Структура данных получателей печатной формы
//
Процедура ЗаполнитьСтруктуруПолучателейПечатныхФорм(СтруктураДанныхОбъектаПечати) Экспорт
	
	СтруктураДанныхОбъектаПечати.ОсновнойПолучатель = "Контрагент";
	 
	СтруктураДанныхОбъектаПечати.МассивРеквизитовПолучателей.Добавить("Контрагент");
	СтруктураДанныхОбъектаПечати.МассивРеквизитовПолучателей.Добавить("ПодотчетноеЛицо");
	СтруктураДанныхОбъектаПечати.МассивРеквизитовПолучателей.Добавить("КонтактноеЛицо");
	СтруктураДанныхОбъектаПечати.МассивРеквизитовПолучателей.Добавить("Грузоотправитель");
	СтруктураДанныхОбъектаПечати.МассивРеквизитовПолучателей.Добавить("Грузополучатель");
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли