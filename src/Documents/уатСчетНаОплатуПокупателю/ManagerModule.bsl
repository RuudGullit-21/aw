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
	КомандаПечати.МенеджерПечати = "Документ.уатСчетНаОплатуПокупателю";
	КомандаПечати.Идентификатор  = "СчетНаОплатуПокупателю";
	КомандаПечати.Представление  = НСтр("en='Invoice to buyer';ru='Счет на оплату покупателю'");
	КомандаПечати.Порядок        = 1;
	
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.МенеджерПечати = "Документ.уатСчетНаОплатуПокупателю";
	КомандаПечати.Идентификатор = "СчетНаОплатуПокупателюФаксимиле";
	КомандаПечати.Представление = НСтр("en='Invoice to buyer';ru='Счет на оплату покупателю (факсимиле)'");
	КомандаПечати.ПроверкаПроведенияПередПечатью = Ложь;
	КомандаПечати.Порядок         = 2;
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор  = "Реестр";
	КомандаПечати.Представление  = НСтр("en='Document register';ru='Реестр документов'");
	КомандаПечати.ЗаголовокФормы = НСтр("en='Register of documents ""Invoice to buyer""';ru='Реестр документов ""Счет на оплату покупателю""'");
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
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПредварительныйПросмотрПечатнойФормыСчетНаОплату") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ПредварительныйПросмотрПечатнойФормыСчетНаОплату",
			"Счет на оплату покупателю", ПечатьПредварительныйПросмотрСчетаНаОплату(ПараметрыПечати.Подпись, ОбъектыПечати, "СчетЗаказ"));
	КонецЕсли;

	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СчетНаОплатуПокупателю") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "СчетНаОплатуПокупателю",
			"Счет на оплату покупателю", ПечатнаяФорма(МассивОбъектов, ОбъектыПечати));
			
	ИначеЕсли УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "СчетНаОплатуПокупателюФаксимиле") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "СчетНаОплатуПокупателюФаксимиле",
			"Счет на оплату покупателю", ПечатнаяФорма(МассивОбъектов, ОбъектыПечати, Истина));
			
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


#Область СлужебныеПроцедурыИФункции

Функция ПечатнаяФорма(МассивОбъектов, ОбъектыПечати, Факсимиле = Ложь)
	Перем Ошибки;
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_СчетНаОплатуПокупателюФаксимиле";
	
	Тип = "Счет";
	
	ПервыйДокумент = Истина;
	
	Для Каждого ТекущийДокумент Из МассивОбъектов Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_СчетНаОплатуПокупателю_СчетНаОплатуПокупателю";
		Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.уатСчетНаОплатуПокупателю.ПФ_MXL_СчетНаОплатуПокупателю");
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ТекущийДокумент", ТекущийДокумент.Ссылка);
		Запрос.Текст ="
		|ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Номер,
		|	Дата,
		|	ДоговорКонтрагента,
		|	Организация,
		|	Контрагент КАК Получатель,
		|	Организация КАК Руководители,
		|	Организация КАК Поставщик,
		|	СуммаДокумента,
		|	ВалютаДокумента,
		|	УчитыватьНДС,
		|	СуммаВключаетНДС
		|ИЗ
		|	Документ.уатСчетНаОплатуПокупателю КАК СчетНаОплатуПокупателю
		|
		|ГДЕ
		|	СчетНаОплатуПокупателю.Ссылка = &ТекущийДокумент";
		
		Шапка = Запрос.Выполнить().Выбрать();
		Шапка.Следующий();
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ТекущийДокумент", ТекущийДокумент.Ссылка);
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	СчетНаОплату.Номенклатура,
		|	ВЫБОР
		|		КОГДА СчетНаОплату.Содержание ЕСТЬ NULL 
		|				ИЛИ ВЫРАЗИТЬ(СчетНаОплату.Содержание КАК СТРОКА(1000)) = """"
		|			ТОГДА ВЫРАЗИТЬ(СчетНаОплату.Номенклатура.НаименованиеПолное КАК СТРОКА(1000))
		|		ИНАЧЕ СчетНаОплату.Содержание
		|	КОНЕЦ КАК Товар,
		|	СчетНаОплату.Номенклатура.Код КАК Код,
		|	СчетНаОплату.Номенклатура.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	СчетНаОплату.Количество,
		|	СчетНаОплату.Цена,
		|	СчетНаОплату.Сумма,
		|	СчетНаОплату.СуммаНДС,
		|	СчетНаОплату.СтавкаНДС,
		|	СчетНаОплату.НомерСтроки КАК НомерСтроки
		|ИЗ
		|	Документ.уатСчетНаОплатуПокупателю." + ?(ТекущийДокумент.СверткаУслугРегл, "УслугиРегл", "Услуги") + " КАК СчетНаОплату
		|ГДЕ
		|	СчетНаОплату.Ссылка = &ТекущийДокумент
		|
		|УПОРЯДОЧИТЬ ПО
		|	НомерСтроки";
		ЗапросТовары = Запрос.Выполнить().Выгрузить();
		
		// Выводим шапку накладной
		
		СведенияОПоставщике = уатОбщегоНазначенияСервер.СведенияОЮрФизЛице(Шапка.Поставщик, Шапка.Дата);
		Если Тип = "Счет" Тогда
			ОбластьМакета = ?(Факсимиле, Макет.ПолучитьОбласть("ЗаголовокСчетаСЛоготипом"), Макет.ПолучитьОбласть("ЗаголовокСчета"));
			Если Факсимиле Тогда
				ПодписиИФаксимиле = Новый Соответствие; // Ключ - имя каринки в области, Значение - имя реквизита
				ПодписиИФаксимиле.Вставить("Логотип", "ФайлЛоготип");
				уатОбщегоНазначения.ЗаполнитьФаксимилеВОбластиМакета(ОбластьМакета, Шапка.Организация, ПодписиИФаксимиле, Ошибки);
			КонецЕсли;
			
			ОбластьМакета.Параметры.Заполнить(Шапка);
			ОбластьМакета.Параметры.ИНН = СведенияОПоставщике.ИНН;
			ОбластьМакета.Параметры.КПП = СведенияОПоставщике.КПП;
			Если ЗначениеЗаполнено(ТекущийДокумент.СтруктурнаяЕдиница) Тогда
				Банк       = ТекущийДокумент.СтруктурнаяЕдиница.Банк;
				БИК        = Банк.Код;
				КоррСчет   = Банк.КоррСчет;
				ГородБанка = Банк.Город;
				НомерСчета = ТекущийДокумент.СтруктурнаяЕдиница.НомерСчета;
				
				ОбластьМакета.Параметры.БИКБанкаПолучателя               = БИК;
				ОбластьМакета.Параметры.БанкПолучателя                   = Банк;
				ОбластьМакета.Параметры.БанкПолучателяПредставление      = СокрЛП(Банк) + " " + ГородБанка;
				ОбластьМакета.Параметры.СчетБанкаПолучателя              = КоррСчет;
				ОбластьМакета.Параметры.СчетБанкаПолучателяПредставление = КоррСчет;
				ОбластьМакета.Параметры.СчетПолучателяПредставление      = НомерСчета;
				ОбластьМакета.Параметры.СчетПолучателя                   = НомерСчета;
				ОбластьМакета.Параметры.ПредставлениеПоставщика          = ТекущийДокумент.СтруктурнаяЕдиница.ТекстКорреспондента;
			КонецЕсли;
			Если уатОбщегоНазначения.уатЗначениеНеЗаполнено(ОбластьМакета.Параметры.ПредставлениеПоставщика) Тогда
				ОбластьМакета.Параметры.ПредставлениеПоставщика = уатОбщегоНазначенияТиповыеСервер.ОписаниеОрганизации(
					СведенияОПоставщике, "НаименованиеДляПечатныхФорм,");
			КонецЕсли;
			ТабличныйДокумент.Вывести(ОбластьМакета);
		КонецЕсли; 
		
		ОбластьМакета = ?(Факсимиле, Макет.ПолучитьОбласть("ЗаголовокСчетаСЛоготипом"), Макет.ПолучитьОбласть("Заголовок"));

		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ОбластьМакета.Параметры.ТекстЗаголовка = уатОбщегоНазначенияТиповые.уатСформироватьЗаголовокДокумента(Шапка,
			НСтр("en='Invoice';ru='Счет на оплату'"));
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Поставщик");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ОбластьМакета.Параметры.ПредставлениеПоставщика = уатОбщегоНазначенияТиповыеСервер.ОписаниеОрганизации(
			уатОбщегоНазначенияСервер.СведенияОЮрФизЛице(Шапка.Организация, Шапка.Дата),
			"НаименованиеДляПечатныхФорм,ИНН,КПП,ЮридическийАдрес,Телефоны,");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		СведенияОПолучателе = уатОбщегоНазначенияСервер.СведенияОЮрФизЛице(Шапка.Получатель, Шапка.Дата);
		ОбластьМакета = Макет.ПолучитьОбласть("Покупатель");
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ОбластьМакета.Параметры.ПредставлениеПолучателя = уатОбщегоНазначенияТиповыеСервер.ОписаниеОрганизации(
			уатОбщегоНазначенияСервер.СведенияОЮрФизЛице(Шапка.Получатель, Шапка.Дата),
			"НаименованиеДляПечатныхФорм,ИНН,КПП,ЮридическийАдрес,Телефоны,");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьОснование = Макет.ПолучитьОбласть("Основание");
		ОбластьОснование.Параметры.Основание = ТекущийДокумент.ДоговорКонтрагента;
		ТабличныйДокумент.Вывести(ОбластьОснование);
		
		ОбластьНомера = Макет.ПолучитьОбласть("ШапкаТаблицы|НомерСтроки");
		ОбластьДанных = Макет.ПолучитьОбласть("ШапкаТаблицы|Данные");
		ОбластьСуммы  = Макет.ПолучитьОбласть("ШапкаТаблицы|Сумма");
		
		ТабличныйДокумент.Вывести(ОбластьНомера);
		
		ТабличныйДокумент.Присоединить(ОбластьДанных);
		ТабличныйДокумент.Присоединить(ОбластьСуммы);
		
		ОбластьКолонкаТовар = Макет.Область("Товар");
		
		ОбластьНомера = Макет.ПолучитьОбласть("Строка|НомерСтроки");
		ОбластьДанных = Макет.ПолучитьОбласть("Строка|Данные");
		ОбластьСуммы  = Макет.ПолучитьОбласть("Строка|Сумма");
		
		Сумма    = 0;
		СуммаНДС = 0;
		СтавкиНДС = ОбщегоНазначения.ВыгрузитьКолонку(ЗапросТовары, "СтавкаНДС", Истина);
		
		Для каждого ВыборкаСтрокТовары Из ЗапросТовары Цикл 
			
			Если уатОбщегоНазначения.уатЗначениеНеЗаполнено(ВыборкаСтрокТовары.Номенклатура) Тогда
				ТекстНСТР = НСтр("en='In one of the rows value of products and services not filled - string when printing is missing.';ru='В одной из строк не заполнено значение номенклатуры - строка при печати пропущена.'");
				уатОбщегоНазначенияТиповые.СообщитьОбОшибке(ТекстНСТР, , , СтатусСообщения.Важное);
				Продолжить;
			КонецЕсли;
			
			ОбластьНомера.Параметры.НомерСтроки = ЗапросТовары.Индекс(ВыборкаСтрокТовары) + 1;
			ТабличныйДокумент.Вывести(ОбластьНомера);
			
			
			ОбластьДанных.Параметры.Заполнить(ВыборкаСтрокТовары);
			КоличествоОкр = Окр(ВыборкаСтрокТовары.Количество,3);
			ОбластьДанных.Параметры.Количество = КоличествоОкр;
			ОбластьДанных.Параметры.Товар = СокрП(уатОбщегоНазначенияСервер.ПолучитьНаименованиеУслугиДляПечати(ВыборкаСтрокТовары.Номенклатура,ВыборкаСтрокТовары.Товар));
			ТабличныйДокумент.Присоединить(ОбластьДанных);
			
			ОбластьСуммы.Параметры.Заполнить(ВыборкаСтрокТовары);
			ТабличныйДокумент.Присоединить(ОбластьСуммы);
			Сумма          = Сумма       + ВыборкаСтрокТовары.Сумма;
			СуммаНДС       = СуммаНДС    + ВыборкаСтрокТовары.СуммаНДС;
			
		КонецЦикла;
		
		// Вывести Итого
		ОбластьНомера = Макет.ПолучитьОбласть("Итого|НомерСтроки");
		ОбластьДанных = Макет.ПолучитьОбласть("Итого|Данные");
		ОбластьСуммы  = Макет.ПолучитьОбласть("Итого|Сумма");
		
		ТабличныйДокумент.Вывести(ОбластьНомера);
		
		ТабличныйДокумент.Присоединить(ОбластьДанных);
		ОбластьСуммы.Параметры.Всего = уатОбщегоНазначенияТиповые.уатФорматСумм(Сумма);
		ТабличныйДокумент.Присоединить(ОбластьСуммы);
		
		// Вывести ИтогоНДС
		Если Шапка.УчитыватьНДС Тогда
			ОбластьНомера = Макет.ПолучитьОбласть("ИтогоНДС|НомерСтроки");
			ОбластьДанных = Макет.ПолучитьОбласть("ИтогоНДС|Данные");
			ОбластьСуммы  = Макет.ПолучитьОбласть("ИтогоНДС|Сумма");
			
			ТабличныйДокумент.Вывести(ОбластьНомера);
			
			Если СуммаНДС <> 0 Тогда
				ДанныеПечатиНДС = уатОбщегоНазначенияТиповые.уатДанныеПечатиИтоговНДС(СуммаНДС, СтавкиНДС, Шапка.СуммаВключаетНДС, ":");
				ОбластьДанных.Параметры.НДС = ДанныеПечатиНДС.НДС;
				ОбластьСуммы.Параметры.ВсегоНДС = ДанныеПечатиНДС.ВсегоНДС;
			Иначе
				ДанныеПечатиНДС = уатОбщегоНазначенияТиповые.уатДанныеПечатиИтоговНДС(0, СтавкиНДС, Шапка.СуммаВключаетНДС, ":"); 
				ОбластьДанных.Параметры.НДС = ДанныеПечатиНДС.НДС;
				ОбластьСуммы.Параметры.ВсегоНДС = ДанныеПечатиНДС.ВсегоНДС;
			КонецЕсли;	
			
			ТабличныйДокумент.Присоединить(ОбластьДанных);
			ТабличныйДокумент.Присоединить(ОбластьСуммы);
		КонецЕсли;
		
		// Вывести Сумму прописью
		ОбластьМакета = Макет.ПолучитьОбласть("СуммаПрописью");
		СуммаКПрописи = Сумма + ?(Шапка.УчитыватьНДС И НЕ Шапка.СуммаВключаетНДС, СуммаНДС, 0);
		ОбластьМакета.Параметры.ИтоговаяСтрока ="Всего наименований " + ЗапросТовары.Количество()
		+ ", на сумму " + уатОбщегоНазначенияТиповые.уатФорматСумм(СуммаКПрописи, Шапка.ВалютаДокумента);
		ОбластьМакета.Параметры.СуммаПрописью = уатОбщегоНазначенияТиповые.уатСформироватьСуммуПрописью(
			СуммаКПрописи, Шапка.ВалютаДокумента);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// Вывести подписи
		Если Тип = "Счет" Тогда
			ОбластьМакета = ?(Факсимиле, Макет.ПолучитьОбласть("ПодвалСчетаФаксимиле"), Макет.ПолучитьОбласть("ПодвалСчета"));
			
			ОбластьМакета.Параметры.ФИООтветственный = "/" + ТекущийДокумент.Ответственный + "/";
			
			Руководители = уатОбщегоНазначенияТиповые.уатОтветственныеЛицаОрганизаций(Шапка.Руководители, Шапка.Дата,);
			Если Руководители <> Неопределено Тогда
				ОбластьМакета.Параметры.ФИОРуководителя  = "/" + Руководители.Руководитель  + "/";
				ОбластьМакета.Параметры.ФИОБухгалтера    = "/" + Руководители.ГлавныйБухгалтер     + "/";
			КонецЕсли;
			
			Если Факсимиле Тогда
				ПодписиИФаксимиле = Новый Соответствие; // Ключ - имя каринки в области, Значение - имя реквизита
				ПодписиИФаксимиле.Вставить("ПодписьРуководителя", ?(Руководители <> Неопределено, Руководители.РуководительСсылка, Справочники.ФизическиеЛица.ПустаяСсылка()));
				ПодписиИФаксимиле.Вставить("ПечатьОрганизации", "ФайлФаксимильнаяПечать");
				ПодписиИФаксимиле.Вставить("ПодписьБухгалтера", ?(Руководители <> Неопределено, Руководители.ГлавныйБухгалтерСсылка, Справочники.ФизическиеЛица.ПустаяСсылка()));
				ПодписиИФаксимиле.Вставить("ПодписьМенеджера", ТекущийДокумент.Ответственный);
				уатОбщегоНазначения.ЗаполнитьФаксимилеВОбластиМакета(ОбластьМакета, Шапка.Организация, ПодписиИФаксимиле, Ошибки);
			Конецесли;

		Иначе
			ОбластьМакета = Макет.ПолучитьОбласть("ПодвалЗаказа");
		КонецЕсли; 
		ОбластьМакета.Параметры.Заполнить(Шапка);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ТекущийДокумент);
		
	КонецЦикла;
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабличныйДокумент;
	
КонецФункции // ПечатнаяФорма()

// Процедура формирования предварительной печатной формы документа (образец)
//
// Вызывается из карточки "Организации" для просмотра размещения логотипов
//
Функция ПечатьПредварительныйПросмотрСчетаНаОплату(Организация, ОбъектыПечати, ИмяМакета) Экспорт
	
	Перем Ошибки;
	
	ЭтоОрганизация    = ТипЗнч(Организация) = Тип("СправочникСсылка.Организации");
	ТабличныйДокумент = Новый ТабличныйДокумент;
	
	ЗначениеДаты = ТекущаяДата();
	НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
	ТабличныйДокумент.КлючПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_" + ИмяМакета + "_" + ИмяМакета;
	Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.уатСчетНаОплатуПокупателю.ПФ_MXL_СчетНаОплатуПокупателю");
	
	ОбластьМакета = Макет.ПолучитьОбласть("ЗаголовокСчетаСЛоготипом");
	Если ЭтоОрганизация Тогда
		ПодписиИФаксимиле = Новый Соответствие; // Ключ - имя каринки в области, Значение - имя реквизита
		ПодписиИФаксимиле.Вставить("Логотип", "ФайлЛоготип");
		уатОбщегоНазначения.ЗаполнитьФаксимилеВОбластиМакета(ОбластьМакета, Организация, ПодписиИФаксимиле, Ошибки);
	КонецЕсли;
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета       = Макет.ПолучитьОбласть("ЗаголовокСчета");
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
	ОбластьМакета.Параметры.ТекстЗаголовка = Нстр("ru = 'Счет на оплату № -000001 от'")  + " " + Формат(ЗначениеДаты, "ДФ='дд ММММ гггг'");
	ТабличныйДокумент.Вывести(ОбластьМакета);

	ОбластьМакета = Макет.ПолучитьОбласть("Поставщик");
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета = Макет.ПолучитьОбласть("Покупатель");
	ТабличныйДокумент.Вывести(ОбластьМакета);

	ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета = Макет.ПолучитьОбласть("Строка");
	ДанныеПечатиСтрока = Новый Структура;
	ДанныеПечатиСтрока.Вставить("НомерСтроки", 1);
	ДанныеПечатиСтрока.Вставить("Товар", "Товар");
	ДанныеПечатиСтрока.Вставить("ЕдиницаИзмерения", "шт");
	ДанныеПечатиСтрока.Вставить("Цена", 120);
	ДанныеПечатиСтрока.Вставить("Количество", 10);
	ДанныеПечатиСтрока.Вставить("Сумма", 1200);
	
	ОбластьМакета.Параметры.Заполнить(ДанныеПечатиСтрока);

	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета = Макет.ПолучитьОбласть("Итого");
	ОбластьМакета.Параметры.Всего = уатОбщегоНазначенияТиповые.уатФорматСумм(1200);
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета = Макет.ПолучитьОбласть("ИтогоНДС");
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета = Макет.ПолучитьОбласть("СуммаПрописью");
	СуммаКПрописи = 1200;
	ОбластьМакета.Параметры.ИтоговаяСтрока ="Всего наименований 1, на сумму "
	+ уатОбщегоНазначенияТиповые.уатФорматСумм(СуммаКПрописи);
	ОбластьМакета.Параметры.СуммаПрописью = уатОбщегоНазначенияТиповые.уатСформироватьСуммуПрописью(
	СуммаКПрописи, Новый Структура("ПараметрыПрописи", ""));
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	Руководители = уатОбщегоНазначенияТиповые.уатОтветственныеЛицаОрганизаций(Организация, ЗначениеДаты);
	
	Если ЭтоОрганизация Тогда
		ОбластьМакета = Макет.ПолучитьОбласть("ПодвалСчетаФаксимиле");
		ПодписиИФаксимиле = Новый Соответствие; // Ключ - имя каринки в области, Значение - имя реквизита
		ПодписиИФаксимиле.Вставить("ПодписьРуководителя", ?(Руководители <> Неопределено, Руководители.РуководительСсылка, Справочники.ФизическиеЛица.ПустаяСсылка()));
		ПодписиИФаксимиле.Вставить("ПечатьОрганизации", "ФайлФаксимильнаяПечать");
		ПодписиИФаксимиле.Вставить("ПодписьМенеджера", ?(Руководители <> Неопределено, Руководители.ГлавныйБухгалтерСсылка, Справочники.ФизическиеЛица.ПустаяСсылка()));
		ПодписиИФаксимиле.Вставить("ПодписьБухгалтера", ?(Руководители <> Неопределено, Руководители.ГлавныйБухгалтерСсылка, Справочники.ФизическиеЛица.ПустаяСсылка()));
		уатОбщегоНазначения.ЗаполнитьФаксимилеВОбластиМакета(ОбластьМакета, Организация, ПодписиИФаксимиле, Ошибки);
	Иначе
		ОбластьМакета = Макет.ПолучитьОбласть("ПодвалСчетаФаксимиле");
		ПодписиИФаксимиле = Новый Соответствие; // Ключ - имя каринки в области, Значение - имя реквизита
		ПодписиИФаксимиле.Вставить("ПодписьРуководителя", Организация);
		ПодписиИФаксимиле.Вставить("ПодписьБухгалтера",   Организация);
		ПодписиИФаксимиле.Вставить("ПодписьМенеджера",    Организация);
		ПодписиИФаксимиле.Вставить("ПечатьОрганизации",   "ФайлФаксимильнаяПечать");
		уатОбщегоНазначения.ЗаполнитьФаксимилеВОбластиМакета(ОбластьМакета, Организация, ПодписиИФаксимиле, Ошибки);
	КонецЕсли;
	
	ТабличныйДокумент.Вывести(ОбластьМакета);
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	Возврат ТабличныйДокумент;
	
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