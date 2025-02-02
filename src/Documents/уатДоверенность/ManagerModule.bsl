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
	КомандаПечати.МенеджерПечати = "Документ.уатДоверенность";
	КомандаПечати.Идентификатор = "М2";
	КомандаПечати.Представление = НСтр("en='Letter of attorney (M-2)';ru='Доверенность (М-2)'");
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Документ.уатДоверенность";
	КомандаПечати.Идентификатор = "М2а";
	КомандаПечати.Представление = НСтр("en='letter of attorney (M-2A)';ru='Доверенность (М-2а)'");
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор  = "Реестр";
	КомандаПечати.Представление  = НСтр("en='Document register';ru='Реестр документов'");
	КомандаПечати.ЗаголовокФормы = НСтр("en='Register of documents ""letter of attorney""';ru='Реестр документов ""Доверенность""'");
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
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "М2") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "М2", "Доверенность (М-2)", ПечатнаяФорма(МассивОбъектов, ОбъектыПечати, "М2"));
		
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "М2а") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "М2а", "Доверенность (М-2а)", ПечатнаяФорма(МассивОбъектов, ОбъектыПечати, "М2а"));
		
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

#КонецОбласти

#КонецОбласти

#Область СлужебныйПрограммныйИнтерфейс

Функция НайтиЕдиницуШтука() Экспорт
	
	Возврат Справочники.КлассификаторЕдиницИзмерения.НайтиПоКоду("796");
	
КонецФункции

Функция ПолучитьПолноеНаименованиеКонтрагента(Контрагент) Экспорт
	
	Если ЗначениеЗаполнено(Контрагент) Тогда
		Возврат Строка(Контрагент.НаименованиеПолное);
	Иначе
		Возврат "";	
	КонецЕсли;
	
КонецФункции

Функция ПолучитьПредставлениеОснования(Основание) Экспорт
	
	Если ЗначениеЗаполнено(Основание) Тогда
		Возврат уатОбщегоНазначенияТиповые.уатСформироватьЗаголовокДокумента(Основание, СокрЛП(Основание.Метаданные().Представление()));
	Иначе
		Возврат "";
	КонецЕсли;
	
КонецФункции

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Функция ПечатнаяФорма(МассивОбъектов, ОбъектыПечати, НазваниеМакета)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_Доверенность";
	
	ПервыйДокумент = Истина;
	
	Для Каждого ТекущийДокумент Из МассивОбъектов Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		Запрос = Новый Запрос();
		Запрос.УстановитьПараметр("ТекущийДокумент", ТекущийДокумент.Ссылка);
		Запрос.Текст = 
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Доверенность.Номер КАК НомерДокумента,
		|	Доверенность.Дата КАК ДатаДокумента,
		|	Доверенность.Организация КАК Руководители,
		|	Доверенность.Организация,
		|	Доверенность.ДоверенноеЛицо,
		|	Доверенность.ДоверенноеЛицо.Наименование КАК ФамилияИмяОтчествоДоверенного,
		|	Доверенность.БанковскийСчетОрганизации КАК БанковскийСчет,
		|	Доверенность.Контрагент КАК Поставщик,
		|	Доверенность.НаПолучениеОт КАК ПоставщикПредставление,
		|	Доверенность.ДатаДействия КАК СрокДействия,
		|	Доверенность.ПоДокументу КАК РеквизитыДокументаНаПолучение,
		|	Доверенность.Товары.(
		|		НомерСтроки КАК Номер,
		|		НаименованиеТовара КАК Ценности,
		|		НаименованиеТовара КАК ЦенностиПредставление,
		|		ЕдиницаКлассификатор КАК ЕдиницаИзмерения,
		|		ЕдиницаКлассификатор.Представление КАК ЕдиницаИзмеренияПредставление,
		|		Количество
		|	)
		|ИЗ
		|	Документ.уатДоверенность КАК Доверенность
		|ГДЕ
		|	Доверенность.Ссылка = &ТекущийДокумент";
		Шапка = Запрос.Выполнить().Выбрать();
		Шапка.Следующий();
		ВыборкаСтрокТовары = Шапка.Товары.Выбрать();
		
		ТабличныйДокумент.ИмяПараметровПечати = "ПараметрыПечати_Доверенность_Доверенность";
		Макет = УправлениеПечатью.МакетПечатнойФормы("ОбщийМакет.ПФ_MXL_М2");
			
		Если ТекущийДокумент.ТипДоверенногоЛица = 0 Тогда
			Если ЗначениеЗаполнено(ТекущийДокумент.ДоверенноеЛицо) Тогда
				ТекФизЛицо = ТекущийДокумент.ДоверенноеЛицо.ФизическоеЛицо;	
			Иначе
				ТекФизЛицо = Справочники.Сотрудники.ПустаяСсылка();
			КонецЕсли;
		Иначе
			Если ЗначениеЗаполнено(ТекущийДокумент.ДоверенноеЛицо) Тогда
				ТекФизЛицо = ТекущийДокумент.ДоверенноеЛицо;	
			Иначе
				ТекФизЛицо = Справочники.ФизическиеЛица.ПустаяСсылка();
			КонецЕсли;
		КонецЕсли;
		
		ДанныеОФизЛице = уатОбщегоНазначенияТиповыеСервер.ДанныеФизЛица(ТекущийДокумент.Организация, ТекФизЛицо, ТекущийДокумент.Дата);
		ФамилияИмяОтчествоДоверенного = СокрЛП(ДанныеОФизЛице.Фамилия) + " " + СокрЛП(ДанныеОФизЛице.Имя) + " " + СокрЛП(ДанныеОФизЛице.Отчество);
		Должность                     = СокрЛП(ДанныеОФизЛице.Должность);
		
		ПечатьПрефиксовВключена = уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(ТекущийДокумент.Организация, ПредопределенноеЗначение("ПланВидовХарактеристик.уатПраваИНастройки.ВыводитьПрефиксПриПечати"));
		Если ПечатьПрефиксовВключена Тогда
			НомерНаПечать = ТекущийДокумент.Номер;
		Иначе
			НомерНаПечать = уатОбщегоНазначенияКлиентСервер.НомерДокументаНаПечать(ТекущийДокумент.Номер, Истина, Истина);
		КонецЕсли;
		
		Если НазваниеМакета = "М2" тогда
			ОбластьМакета = Макет.ПолучитьОбласть("Отрез");
			ОбластьМакета.Параметры.Заполнить(Шапка);
			ОбластьМакета.Параметры.НомерДокумента = НомерНаПечать;
			ОбластьМакета.Параметры.ФИОДоверенного = "" + ?(ПустаяСтрока(Должность), "", Должность + ", " + Символы.ПС) + (ФамилияИмяОтчествоДоверенного);
			ТабличныйДокумент.Вывести(ОбластьМакета);
			НазваниеФормы = "Типовая межотраслевая форма № М-2";
		Иначе
			НазваниеФормы = "Типовая межотраслевая форма № М-2а";
		КонецЕсли;
		
		Руководители = уатОбщегоНазначенияТиповые.уатОтветственныеЛицаОрганизаций(ТекущийДокумент.Организация, ТекущийДокумент.Дата);
		Руководитель = Руководители.Руководитель;
		Бухгалтер    = Руководители.ГлавныйБухгалтер;
		
		СведенияОбОрганизации = уатОбщегоНазначенияСервер.СведенияОЮрФизЛице(Шапка.Организация, Шапка.ДатаДокумента,, Шапка.БанковскийСчет);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Шапка");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ОбластьМакета.Параметры.НомерДокумента               = НомерНаПечать;
		ОбластьМакета.Параметры.НазваниеФормы                = НазваниеФормы;
		ОбластьМакета.Параметры.ОрганизацияПредставление     = уатОбщегоНазначенияТиповыеСервер.ОписаниеОрганизации(СведенияОбОрганизации, "НаименованиеДляПечатныхФорм,ИНН,КПП,ЮридическийАдрес,Телефоны,");
		ОбластьМакета.Параметры.РеквизитыСчета               = уатОбщегоНазначенияТиповыеСервер.ОписаниеОрганизации(СведенияОбОрганизации, "НомерСчета,Банк,БИК,КоррСчет,");
		ОбластьМакета.Параметры.РеквизитыПотребителя         = уатОбщегоНазначенияТиповыеСервер.ОписаниеОрганизации(СведенияОбОрганизации, "НаименованиеДляПечатныхФорм,ИНН,КПП,ЮридическийАдрес,Телефоны,");
		Попытка //попытка сделана для корректной работе в УПП, т.к. там обе области называются РеквизитыПотребителя
			ОбластьМакета.Параметры.РеквизитыПлательщика      = уатОбщегоНазначенияТиповыеСервер.ОписаниеОрганизации(СведенияОбОрганизации, "НаименованиеДляПечатныхФорм,ИНН,КПП,ЮридическийАдрес,Телефоны,");
		Исключение
		КонецПопытки;
		ОбластьМакета.Параметры.ОрганизацияКодПоОКПО          = СведенияОбОрганизации.КодПоОКПО;
		ОбластьМакета.Параметры.ПаспортСерия                  = ДанныеОФизЛице.ДокументСерия;
		ОбластьМакета.Параметры.ПаспортНомер                  = ДанныеОФизЛице.ДокументНомер;
		ОбластьМакета.Параметры.ПаспортВыдан                  = ДанныеОФизЛице.ДокументКемВыдан;
		ОбластьМакета.Параметры.ПаспортДатаВыдачи             = ДанныеОФизЛице.ДокументДатаВыдачи;
		ОбластьМакета.Параметры.ФамилияИмяОтчествоДоверенного = ФамилияИмяОтчествоДоверенного;
		ОбластьМакета.Параметры.ДолжностьДоверенного          = Должность;
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("ЗаголовокТаблицы");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Строка");
		
		Пока ВыборкаСтрокТовары.Следующий() Цикл
			
			ОбластьМакета.Параметры.Заполнить(ВыборкаСтрокТовары);
			ОбластьМакета.Параметры.КоличествоПрописью = ?(ВыборкаСтрокТовары.Количество = 0,
			"",
			Строка(ВыборкаСтрокТовары.Количество) + " (" + КоличествоПрописью(ВыборкаСтрокТовары.Количество) + ")");
			ТабличныйДокумент.Вывести(ОбластьМакета);
			
		КонецЦикла;
		
		ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		
		Если ЗначениеЗаполнено(Руководитель) Тогда
			ОбластьМакета.Параметры.ФИОРуководителя       = Руководитель;
			ОбластьМакета.Параметры.Руководитель          = Руководитель;
		КонецЕсли;
		
		Если ЗначениеЗаполнено(Бухгалтер) Тогда
			ОбластьМакета.Параметры.ФИОГлавногоБухгалтера = Бухгалтер;
			ОбластьМакета.Параметры.ГлавныйБухгалтер      = Бухгалтер;
		КонецЕсли;
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ТекущийДокумент);
		
	КонецЦикла;
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабличныйДокумент;
	
КонецФункции // ПечатнаяФорма()

// Стандартная для данной конфигурации функция форматирования прописи количества
//
// Параметры:
//  Количество	 - 	 - число, которое мы хотим форматировать
// 
// Возвращаемое значение:
//  Отформатированная - должным образом строковое представление количества.
//
Функция КоличествоПрописью(Количество)

	ЦелаяЧасть   = Цел(Количество);
	ДробнаяЧасть = Окр(Количество - ЦелаяЧасть, 3);

	Если ДробнаяЧасть = Окр(ДробнаяЧасть,0) Тогда
		ПараметрыПрописи = ", , , , , , , , 0";
	ИначеЕсли ДробнаяЧасть = Окр(ДробнаяЧасть, 1) Тогда
		ПараметрыПрописи = "целая, целых, целых, ж, десятая, десятых, десятых, м, 1";
	ИначеЕсли ДробнаяЧасть = Окр(ДробнаяЧасть, 2) Тогда
		ПараметрыПрописи = "целая, целых, целых, ж, сотая, сотых, сотых, м, 2";
	Иначе
		ПараметрыПрописи = "целая, целых, целых, ж, тысячная, тысячных, тысячных, м, 3";
	КонецЕсли;

	Возврат ЧислоПрописью(Количество, ,ПараметрыПрописи);

КонецФункции // КоличествоПрописью()

// Получает дополнительные реквизиты для отображения в отчете "Реестр документов"
// 
// Возвращаемое значение:
//  Структура - доп. реквизитов
//
Функция ПолучитьДополнительныеРеквизитыДляРеестра() Экспорт
	
	Результат = Новый Структура("Информация", "ДоверенноеЛицо");
	Возврат Результат;
	
КонецФункции

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