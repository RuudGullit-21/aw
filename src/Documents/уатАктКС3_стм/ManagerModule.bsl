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
	КомандаПечати.МенеджерПечати = "Документ.уатАктКС3_стм";
	КомандаПечати.Идентификатор = "КС3";
	КомандаПечати.Представление = НСтр("en='Act KS-3';ru='Акт КС-3'");
	
	// Реестр документов
	КомандаПечати = КомандыПечати.Добавить();
	КомандаПечати.Идентификатор  = "Реестр";
	КомандаПечати.Представление  = НСтр("en='Document register';ru='Реестр документов'");
	КомандаПечати.ЗаголовокФормы = НСтр("en='Register of documents "" Act KS-3""';ru='Реестр документов ""Акт КС-3""'");
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
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "КС3") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "КС3", "Акт КС-3", ПечатьКС3(МассивОбъектов, ОбъектыПечати));
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

Функция ПечатьКС3(МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_ПечатьКС3";
	
	ПервыйДокумент = Истина;
	
	Для Каждого ТекущийДокумент Из МассивОбъектов Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ПечатьКС3";
		Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.уатАктКС3_стм.ПФ_MXL_КС3");
		
		ЗапросШапка = Новый Запрос;
		ЗапросШапка.УстановитьПараметр("ТекущийДокумент", ТекущийДокумент.Ссылка);
		ЗапросШапка.Текст =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	Номер,
		|	Дата,
		|	ДоговорКонтрагента,
		|	Контрагент КАК Получатель,
		|	Организация КАК Поставщик,
		|	Организация,
		|	СуммаЗаОтчетныйПериод
		|ИЗ
		|	Документ.уатАктКС3_стм КАК уатАктКС3
		|
		|ГДЕ
		|	уатАктКС3.Ссылка = &ТекущийДокумент";
		Шапка = ЗапросШапка.Выполнить().Выбрать();
		Шапка.Следующий();
		
		ПечатьПрефиксовВключена = уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(ТекущийДокумент.Организация, ПредопределенноеЗначение("ПланВидовХарактеристик.уатПраваИНастройки.ВыводитьПрефиксПриПечати"));
			
		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ПредставлениеПоставщика = уатОбщегоНазначенияТиповыеСервер.ОписаниеОрганизации(уатОбщегоНазначенияСервер.СведенияОЮрФизЛице(Шапка.Организация, Шапка.Дата), "НаименованиеДляПечатныхФорм,ЮридическийАдрес,Телефоны");
		ОбластьМакета.Параметры.ПредставлениеПоставщика = ПредставлениеПоставщика;
		ПредставлениеПолучателя = уатОбщегоНазначенияТиповыеСервер.ОписаниеОрганизации(уатОбщегоНазначенияСервер.СведенияОЮрФизЛице(Шапка.Получатель, Шапка.Дата), "НаименованиеДляПечатныхФорм,ЮридическийАдрес,Телефоны");
		ОбластьМакета.Параметры.ПредставлениеПолучателя = ПредставлениеПолучателя;
		ОбластьМакета.Параметры.ОбъектСтроительства = ТекущийДокумент.ОбъектСтроительства;
		ОбластьМакета.Параметры.КодПоОКПО = ТекущийДокумент.Организация.КодПоОКПО;
		ОбластьМакета.Параметры.КодПоОКПОЗаказчика = ТекущийДокумент.Контрагент.КодПоОКПО;
		ОбластьМакета.Параметры.Дата = ТекущийДокумент.Дата;
		
		Если ПечатьПрефиксовВключена Тогда
			ОбластьМакета.Параметры.Номер = ТекущийДокумент.Номер;
		Иначе
			ОбластьМакета.Параметры.Номер = уатОбщегоНазначенияКлиентСервер.НомерДокументаНаПечать(ТекущийДокумент.Номер, Истина, Истина);
		КонецЕсли;
		
		ОбластьМакета.Параметры.ДатаНач = ?(ТекущийДокумент.ДатаНач>'00010101',Формат(ТекущийДокумент.ДатаНач,"ДФ=""дд.ММ.гг """)+"г.","");
		ОбластьМакета.Параметры.ДатаКон = ?(ТекущийДокумент.ДатаКон>'00010101',Формат(ТекущийДокумент.ДатаКон,"ДФ=""дд.ММ.гг """)+"г.","");
		ОбластьМакета.Параметры.Заказчик = Шапка.Получатель;
		ОбластьМакета.Параметры.Подрядчик = Шапка.Организация;
		
		Попытка    // если УАТ не объединено с типовыми конфигурациями
			ОбластьМакета.Параметры.ДоговорНомер = ТекущийДокумент.ДоговорКонтрагента.Номер;
			Если ТекущийДокумент.ДоговорКонтрагента.Дата > '00010101' Тогда
				ОбластьМакета.Параметры.День  = Формат(ТекущийДокумент.ДоговорКонтрагента.Дата,"ДФ=""дд""");
				ОбластьМакета.Параметры.Месяц = Формат(ТекущийДокумент.ДоговорКонтрагента.Дата,"ДФ=""ММ""");
				ОбластьМакета.Параметры.Год   = Формат(ТекущийДокумент.ДоговорКонтрагента.Дата,"ДФ=""гг""");
			Иначе
				ОбластьМакета.Параметры.День="";
				ОбластьМакета.Параметры.Месяц="";
				ОбластьМакета.Параметры.Год="";
			КонецЕсли; 
		Исключение
		КонецПопытки; 
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Таблица");
		ОбластьМакета.Параметры.СуммаЗаОтчетныйПериод  = уатОбщегоНазначенияТиповые.уатФорматСумм(ТекущийДокумент.СуммаЗаОтчетныйПериод-ТекущийДокумент.НДСЗаОтчетныйПериод);
		ОбластьМакета.Параметры.НДСЗаОтчетныйПериод    = уатОбщегоНазначенияТиповые.уатФорматСумм(ТекущийДокумент.НДСЗаОтчетныйПериод);
		ОбластьМакета.Параметры.Всего                  = уатОбщегоНазначенияТиповые.уатФорматСумм(ТекущийДокумент.СуммаЗаОтчетныйПериод);
		ОбластьМакета.Параметры.СуммаСНачалаГода       = уатОбщегоНазначенияТиповые.уатФорматСумм(ТекущийДокумент.СуммаСНачалаГода-ТекущийДокумент.НДССНачалаГода);
		ОбластьМакета.Параметры.НДССНачалаГода         = уатОбщегоНазначенияТиповые.уатФорматСумм(ТекущийДокумент.НДССНачалаГода);
		ОбластьМакета.Параметры.СуммаСНачалаПроведения = уатОбщегоНазначенияТиповые.уатФорматСумм(ТекущийДокумент.СуммаСНачалаПроведения-ТекущийДокумент.НДССНачалаПроведения);
		ОбластьМакета.Параметры.НДССНачалаПроведения   = уатОбщегоНазначенияТиповые.уатФорматСумм(ТекущийДокумент.НДССНачалаПроведения);
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("Подвал");
				
		СтруктураОтветствЛица = уатОбщегоНазначенияТиповые.уатОтветственныеЛицаОрганизаций(ТекущийДокумент.Организация, ТекущийДокумент.Дата);
		Если СтруктураОтветствЛица.Руководитель <> Неопределено Тогда
			ОбластьМакета.Параметры.Должность = СтруктураОтветствЛица.РуководительДолжность;
			ОбластьМакета.Параметры.ФИОРуководителя = СтруктураОтветствЛица.Руководитель;
		Иначе
			ОбластьМакета.Параметры.ФИОРуководителя = ТекущийДокумент.Организация;
		КонецЕсли;
		
		// заполняем должность и наименование заказчика
		ДанныеКонтрагента = уатОбщегоНазначения_проф.ПолучитьДолжностьИНаименованиеКонтрагента(ТекущийДокумент.Контрагент);
		Если ДанныеКонтрагента.Наименование = "" Тогда 
			ОбластьМакета.Параметры.ФИОЗаказчика = ТекущийДокумент.Контрагент.Наименование;
		Иначе 
			ОбластьМакета.Параметры.ФИОЗаказчика       = ДанныеКонтрагента.Наименование;
			ОбластьМакета.Параметры.ДолжностьЗаказчика = ДанныеКонтрагента.Должность;
		КонецЕсли;
		
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ТекущийДокумент);
		
	КонецЦикла;
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабличныйДокумент;
	
КонецФункции // ПечатьКС3()

// Заполняет структуру данными о получателях печатных форм.
// Параметры:
// 	СтруктураДанныхОбъектаПечати - см. ФормированиеПечатныхФорм.ЗаполнитьДанныеСтруктурыПолучателяПоТипуОбъекта.СтруктураДанныхОбъектаПечати
// 


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