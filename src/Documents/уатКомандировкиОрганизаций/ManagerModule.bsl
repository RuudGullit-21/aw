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
//  КомандыПечати	 - ТаблицаЗначений	 - состав полей см. в функции УправлениеПечатью.СоздатьКоллекциюКомандПечати
//
Процедура ДобавитьКомандыПечати(КомандыПечати) Экспорт
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Документ.уатКомандировкиОрганизаций";
	КомандаПечати.Идентификатор = "Т10_от_5_1_2004";
	КомандаПечати.Представление = НСтр("en='Form T-10';ru='Форма Т-10'");
	
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
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "Т10_от_5_1_2004") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "Т10_от_5_1_2004",
			"Командировочное удостоверение", ПечатьТ10(МассивОбъектов, ОбъектыПечати));
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


#Область СлужебныеПроцедурыИФункции

Функция ПечатьТ10(МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_КомандировкиОрганизаций";
	
	ПервыйДокумент = Истина;
	
	мВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	
	Для Каждого ТекущийДокумент Из МассивОбъектов Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_КомандировкиОрганизации_Т10";
		Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.уатКомандировкиОрганизаций.ПФ_MXL_Т10_от_5_1_2004");
		
		// получаем данные для печати
		тблВыборкаДляШапки = СформироватьЗапросДляПечати("ПоРеквизитамДокумента", ТекущийДокумент);
		тблВыборкаРаботники = СформироватьЗапросДляПечати("ПоТабличнойЧастиДокумента", ТекущийДокумент);
		
		
		ОбластьМакетаШапка  = Макет.ПолучитьОбласть("Шапка");        // Шапка документа
		ОбластьМакетаПодвал = Макет.ПолучитьОбласть("Подвал");       // Подвал документа
		ОбластьМакета       = Макет.ПолучитьОбласть("Работник");     // строка работника
		ОборотШапка         = Макет.ПолучитьОбласть("ШапкаОтметок"); // оборот удостоверения - отметки от прибытии-выбытии
		ОборотОтметки       = Макет.ПолучитьОбласть("Отметки");
		
		// выводим данные о руководителях организации
		Если тблВыборкаДляШапки.Количество() > 0 Тогда
			ВыборкаДляШапки = тблВыборкаДляШапки[0];
			
			ПечатьПрефиксовВключена = уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(ТекущийДокумент.Организация, ПредопределенноеЗначение("ПланВидовХарактеристик.уатПраваИНастройки.ВыводитьПрефиксПриПечати"));
			Если ПечатьПрефиксовВключена Тогда
				НомерДокДляПечати = ВыборкаДляШапки.НомерДок;
			Иначе
				НомерДокДляПечати = уатОбщегоНазначенияКлиентСервер.НомерДокументаНаПечать(ВыборкаДляШапки.НомерДок, Истина, Истина);
				ВыборкаДляШапки.НомерДок = НомерДокДляПечати;
			КонецЕсли;

			ОбластьМакетаШапка.Параметры.Заполнить(ВыборкаДляШапки); // Шапка документа.
			СписокТребуемыхПараметров	= "НаименованиеДляПечатныхФорм";
			СведенияОбОбъекте			= уатОбщегоНазначенияСервер.СведенияОЮрФизЛице(ТекущийДокумент.Организация);
			ОбластьМакетаШапка.Параметры.НазваниеОрганизации		= уатОбщегоНазначенияТиповыеСервер.ОписаниеОрганизации(СведенияОбОбъекте, СписокТребуемыхПараметров);
			ОбластьМакетаПодвал.Параметры.Заполнить(ВыборкаДляШапки); // Для подвала.
			ОбластьМакета.Параметры.Заполнить(ВыборкаДляШапки); // область работника	
		КонецЕсли;
		
		НомерФормы = 0;
		ПечататьПостфикс = тблВыборкаРаботники.Количество() > 1;
		// Начинаем формировать выходной документ
		Для Каждого ВыборкаРаботники Из тблВыборкаРаботники Цикл
			
			// Каждый приказ на отдельной странице.
			Если ТабличныйДокумент.ВысотаТаблицы > 0 Тогда
				ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			КонецЕсли;
			
			// Шапка документа.
			Если ПечататьПостфикс Тогда
				НомерФормы = НомерФормы + 1;
				ОбластьМакетаШапка.Параметры.НомерДок = НомерДокДляПечати + "/" + НомерФормы
			КонецЕсли;
			ТабличныйДокумент.Вывести(ОбластьМакетаШапка);
			
			// Данные по работнику.
			ОбластьМакета.Параметры.Заполнить(ВыборкаРаботники);
			Если  ВыборкаРаботники.ВидДокумента = Справочники.ВидыДокументовФизическихЛиц.ПаспортРФ тогда
				ОбластьМакета.Параметры.РеквизитыПаспорта = Строка( ВыборкаРаботники.ВидДокумента) + " " + "Серия паспорта :" + Строка(ВыборкаРаботники.СерияПаспорта) + " " + "Номер паспорта :"   + Строка(ВыборкаРаботники.НомерПаспорта) ;
			КонецЕсли;
			// уберем из табельного номера префикс
			ОбластьМакета.Параметры.ТабельныйНомер = ВыборкаРаботники.ТабельныйНомер;
			
			// в этой форме продолжительность командировки указывается без времени в пути
			Продолжительность = ?(ЗначениеЗаполнено(ВыборкаРаботники.ДатаОкончания), Цел((ВыборкаРаботники.ДатаОкончания
				- ВыборкаРаботники.ДатаНачала + 1) / 86400) + 1 - ВыборкаРаботники.ВремяНахожденияВПути,0);
			Если Продолжительность > 0 Тогда
				ОбластьМакета.Параметры.Продолжительность = Продолжительность;
			КонецЕсли;
			
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
			// Подвал документа.
			ТабличныйДокумент.Вывести(ОбластьМакетаПодвал);
			// выводим оборот удостоверения
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			ТабличныйДокумент.Вывести(ОборотШапка);
			ТабличныйДокумент.Вывести(ОборотОтметки);
			ТабличныйДокумент.Вывести(ОборотОтметки);
			ТабличныйДокумент.Вывести(ОборотОтметки);
			ТабличныйДокумент.Вывести(ОборотОтметки);
			
		КонецЦикла;
		
		// если не было ни одного работника - выводим пустой бланк
		Если ТабличныйДокумент.ВысотаТаблицы = 0 Тогда
			ТабличныйДокумент.Вывести(ОбластьМакетаШапка);
			ТабличныйДокумент.Вывести(ОбластьМакета);
			ТабличныйДокумент.Вывести(ОбластьМакетаПодвал);
			// выводим оборот удостоверения
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
			ТабличныйДокумент.Вывести(ОборотШапка);
			ТабличныйДокумент.Вывести(ОборотОтметки);
			ТабличныйДокумент.Вывести(ОборотОтметки);
			ТабличныйДокумент.Вывести(ОборотОтметки);
			ТабличныйДокумент.Вывести(ОборотОтметки);
		КонецЕсли;
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ТекущийДокумент);
		
	КонецЦикла;
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабличныйДокумент;
	
КонецФункции // ПечатнаяФорма()

// Формирует запрос по документу и связанным регистрам сведений
//
// Параметры: 
//	Режим	- строка, может принимать значения:
//				"ПоРеквизитамДокумента"
//				"ПоТабличнойЧастиДокумента"
//
// Возвращаемое значение:
//	Результат запроса с данными об организации или о работниках из табличной части
//
Функция СформироватьЗапросДляПечати(Режим, ТекДок)

	Запрос = Новый Запрос;

	// Установим параметры запроса
	Запрос.УстановитьПараметр("ДокументСсылка",	ТекДок.Ссылка);
	Запрос.УстановитьПараметр("Руководитель", Перечисления.ОтветственныеЛицаОрганизаций.Руководитель);
	Запрос.УстановитьПараметр("ДатаДокумента",	ТекДок.Дата);
    Запрос.УстановитьПараметр("ПустаяДата",		'00010101');

	Если Режим = "ПоРеквизитамДокумента" Тогда
		
		Запрос.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	КомандировкиОрганизаций.Дата КАК ДатаДок,
		|	КомандировкиОрганизаций.Номер КАК НомерДок,
		|	КомандировкиОрганизаций.Организация.НаименованиеПолное КАК НазваниеОрганизации,
		|	КомандировкиОрганизаций.СтранаНазначения,
		|	КомандировкиОрганизаций.ОрганизацияНазначения,
		|	КомандировкиОрганизаций.ОснованиеКомандировки,
		|	КомандировкиОрганизаций.Организация.Префикс,
		|	КомандировкиОрганизаций.Организация.КодПоОКПО КАК КодПоОКПО
		|ИЗ
		|	Документ.уатКомандировкиОрганизаций КАК КомандировкиОрганизаций
		|ГДЕ
		|	КомандировкиОрганизаций.Ссылка = &ДокументСсылка";
				
	ИначеЕсли Режим = "ПоТабличнойЧастиДокумента" Тогда

		Запрос.УстановитьПараметр("Организация", ТекДок.Организация);
		
		Если уатРаботаСМетаданными.уатЕстьРегистрСведений("ФИОФизическихЛиц") Тогда
			Запрос.Текст =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	ЕСТЬNULL(ФИОФизЛицСрезПоследних.Фамилия + "" "" + ФИОФизЛицСрезПоследних.Имя + "" "" + ФИОФизЛицСрезПоследних.Отчество, уатКомандировкиОрганизацийРаботникиОрганизации.Сотрудник.Наименование) КАК Работник,
			|	уатКомандировкиОрганизацийРаботникиОрганизации.НомерСтроки КАК НомерСтроки,
			|	ЕСТЬNULL(ДокументыФизическихЛицСрезПоследних.ВидДокумента, """") КАК ВидДокумента,
			|	уатКомандировкиОрганизацийРаботникиОрганизации.ДатаНачала,
			|	уатКомандировкиОрганизацийРаботникиОрганизации.ДатаОкончания,
			|	уатКомандировкиОрганизацийРаботникиОрганизации.Цель,
			|	уатКомандировкиОрганизацийРаботникиОрганизации.ВремяНахожденияВПути,
			|	уатКадроваяИсторияСотрудников.Должность КАК Должность,
			|	уатКадроваяИсторияСотрудников.Подразделение КАК ПодразделениеРаботника,
			|	уатКомандировкиОрганизацийРаботникиОрганизации.Сотрудник.Код КАК ТабельныйНомер,
			|	ДокументыФизическихЛицСрезПоследних.Номер КАК НомерПаспорта,
			|	ДокументыФизическихЛицСрезПоследних.Серия КАК СерияПаспорта
			|ИЗ
			|	Документ.уатКомандировкиОрганизаций.РаботникиОрганизации КАК уатКомандировкиОрганизацийРаботникиОрганизации
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.уатКадроваяИсторияСотрудников.СрезПоследних(&ДатаДокумента, Организация = &Организация) КАК уатКадроваяИсторияСотрудников
			|		ПО уатКомандировкиОрганизацийРаботникиОрганизации.Сотрудник = уатКадроваяИсторияСотрудников.Сотрудник
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ФИОФизическихЛиц.СрезПоследних(
			|				&ДатаДокумента,
			|				ФизическоеЛицо В
			|					(ВЫБРАТЬ
			|						уатКомандировкиОрганизацийРаботникиОрганизации.Сотрудник.ФизическоеЛицо
			|					ИЗ
			|						Документ.уатКомандировкиОрганизаций.РаботникиОрганизации КАК уатКомандировкиОрганизацийРаботникиОрганизации
			|					ГДЕ
			|						уатКомандировкиОрганизацийРаботникиОрганизации.Ссылка = &ДокументСсылка)) КАК ФИОФизЛицСрезПоследних
			|		ПО уатКомандировкиОрганизацийРаботникиОрганизации.Сотрудник.ФизическоеЛицо = ФИОФизЛицСрезПоследних.ФизическоеЛицо
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДокументыФизическихЛиц.СрезПоследних(, ВидДокумента = ЗНАЧЕНИЕ(Справочник.ВидыДокументовФизическихЛиц.ПаспортРФ)) КАК ДокументыФизическихЛицСрезПоследних
			|		ПО уатКомандировкиОрганизацийРаботникиОрганизации.Сотрудник.ФизическоеЛицо = ДокументыФизическихЛицСрезПоследних.Физлицо
			|ГДЕ
			|	уатКомандировкиОрганизацийРаботникиОрганизации.Ссылка = &ДокументСсылка
			|
			|УПОРЯДОЧИТЬ ПО
			|	НомерСтроки";
			
		Иначе
			Запрос.Текст =
			"ВЫБРАТЬ РАЗРЕШЕННЫЕ
			|	уатКомандировкиОрганизацийРаботникиОрганизации.Сотрудник.Наименование КАК Работник,
			|	уатКомандировкиОрганизацийРаботникиОрганизации.НомерСтроки КАК НомерСтроки,
			|	ЕСТЬNULL(ДокументыФизическихЛицСрезПоследних.ВидДокумента, """") КАК ВидДокумента,
			|	уатКомандировкиОрганизацийРаботникиОрганизации.ДатаНачала,
			|	уатКомандировкиОрганизацийРаботникиОрганизации.ДатаОкончания,
			|	уатКомандировкиОрганизацийРаботникиОрганизации.Цель,
			|	уатКомандировкиОрганизацийРаботникиОрганизации.ВремяНахожденияВПути,
			|	уатКадроваяИсторияСотрудников.Должность КАК Должность,
			|	уатКадроваяИсторияСотрудников.Подразделение КАК ПодразделениеРаботника,
			|	уатКомандировкиОрганизацийРаботникиОрганизации.Сотрудник.Код КАК ТабельныйНомер,
			|	ДокументыФизическихЛицСрезПоследних.Номер КАК НомерПаспорта,
			|	ДокументыФизическихЛицСрезПоследних.Серия КАК СерияПаспорта
			|ИЗ
			|	Документ.уатКомандировкиОрганизаций.РаботникиОрганизации КАК уатКомандировкиОрганизацийРаботникиОрганизации
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.уатКадроваяИсторияСотрудников.СрезПоследних(&ДатаДокумента, Организация = &Организация) КАК уатКадроваяИсторияСотрудников
			|		ПО уатКомандировкиОрганизацийРаботникиОрганизации.Сотрудник = уатКадроваяИсторияСотрудников.Сотрудник
			|		И уатКомандировкиОрганизацийРаботникиОрганизации.Ссылка.Организация = уатКадроваяИсторияСотрудников.Организация
			|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ДокументыФизическихЛиц.СрезПоследних(, ВидДокумента = ЗНАЧЕНИЕ(Справочник.ВидыДокументовФизическихЛиц.ПаспортРФ)) КАК ДокументыФизическихЛицСрезПоследних
			|		ПО уатКомандировкиОрганизацийРаботникиОрганизации.Сотрудник.ФизическоеЛицо = ДокументыФизическихЛицСрезПоследних.Физлицо
			|ГДЕ
			|	уатКомандировкиОрганизацийРаботникиОрганизации.Ссылка = &ДокументСсылка
			|
			|УПОРЯДОЧИТЬ ПО
			|	НомерСтроки";
			
		КонецЕсли;

	Иначе
		Возврат Неопределено;
		
	КонецЕсли;

	тбл = Запрос.Выполнить().Выгрузить();
	
	// добавление информации об ответственных лицах
	Если Режим = "ПоРеквизитамДокумента" Тогда
		тбл.Колонки.Добавить("ДолжностьРуководителя");
		тбл.Колонки.Добавить("ФИОРуководителя");
		тбл.Колонки.Добавить("ОтветственноеЛицо");
		Для Каждого ТекСтрока Из тбл Цикл
			СтруктураОтветствЛица = уатОбщегоНазначенияТиповые.уатОтветственныеЛицаОрганизаций(ТекДок.Организация, ТекДок.Дата);
			ТекСтрока.ДолжностьРуководителя = СтруктураОтветствЛица.РуководительДолжность;
			ТекСтрока.ФИОРуководителя = СтруктураОтветствЛица.Руководитель;
			ТекСтрока.ОтветственноеЛицо = Перечисления.ОтветственныеЛицаОрганизаций.Руководитель;
		КонецЦикла;
	КонецЕсли;
	
	Возврат тбл;

КонецФункции // СформироватьЗапросДляПечати()

#КонецОбласти

#КонецЕсли