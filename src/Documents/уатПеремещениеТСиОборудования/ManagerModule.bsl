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
	КомандаПечати.МенеджерПечати = "Документ.уатПеремещениеТСиОборудования";
	КомандаПечати.Идентификатор = "ПеремещениеТСиОборудования";
	КомандаПечати.Представление = НСтр("en='Movement';ru='Перемещение'");
	
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
	
	Если УправлениеПечатью.НужноПечататьМакет(КоллекцияПечатныхФорм, "ПеремещениеТСиОборудования") Тогда
		УправлениеПечатью.ВывестиТабличныйДокументВКоллекцию(КоллекцияПечатныхФорм, "ПеремещениеТСиОборудования",
			"Перемещение ТС и оборудования", ПечатьПеремещениеТСиОборудования(МассивОбъектов, ОбъектыПечати));
	КонецЕсли;
	
	уатОбщегоНазначенияСервер.УстановитьРедактированиеПечатныхФормДокумента(КоллекцияПечатныхФорм);
	
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

#КонецОбласти

#КонецОбласти


#Область СлужебныйПрограммныйИнтерфейс

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	СформироватьТаблицуТС(ДокументСсылка, СтруктураДополнительныеСвойства);
	СформироватьТаблицуГСМ(ДокументСсылка, СтруктураДополнительныеСвойства);
КонецПроцедуры // ИнициализироватьДанныеДокумента()

Процедура ВыполнитьКонтроль(ДокументСсылка, ДополнительныеСвойства, Отказ, УдалениеПроведения = Ложь) Экспорт
	//Зарезервировано
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

// Формирует таблицу значений, содержащую данные для проведения по регистру Местонахождение ТС.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицуТС(ДокументСсылка, СтруктураДополнительныеСвойства)
	тблМестонахожденияТС = Новый ТаблицаЗначений;
	тблМестонахожденияТС.Колонки.Добавить("Регистратор");
	тблМестонахожденияТС.Колонки.Добавить("Период");
	тблМестонахожденияТС.Колонки.Добавить("ТС");
	тблМестонахожденияТС.Колонки.Добавить("Организация");
	тблМестонахожденияТС.Колонки.Добавить("Подразделение");
	тблМестонахожденияТС.Колонки.Добавить("Колонна");
	
	Для Каждого ТекСтрокаТС Из ДокументСсылка.ТС Цикл
		НоваяСтрока = тблМестонахожденияТС.Добавить();
		НоваяСтрока.Период = ТекСтрокаТС.ДатаВвода;
		НоваяСтрока.Регистратор = ДокументСсылка;
		НоваяСтрока.ТС = ТекСтрокаТС.ТС;
		НоваяСтрока.Организация = ДокументСсылка.Организация;
		НоваяСтрока.Подразделение = ДокументСсылка.Подразделение;
		НоваяСтрока.Колонна = ДокументСсылка.Колонна;
	КонецЦикла;
	
	// управляемая блокировка
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.уатМестонахождениеТС");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = тблМестонахожденияТС;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ТС", "ТС");
	Блокировка.Заблокировать();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаМестонахожденияТС", тблМестонахожденияТС);
КонецПроцедуры // СформироватьТаблицуАгрегатыТС()

// Формирует таблицу значений, содержащую данные для проведения по регистру Остатки ГСМ на ТС.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицуГСМ(ДокументСсылка, СтруктураДополнительныеСвойства)
	// запрос по ТС, которые учитываются при перемещении ГСМ
	ТекстЗапроса =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	уатПеремещениеТСиОборудованияТС.ТС КАК ТС,
	|	уатПеремещениеТСиОборудованияТС.ДатаВвода КАК ДатаВвода
	|ИЗ
	|	Документ.уатПеремещениеТСиОборудования.ТС КАК уатПеремещениеТСиОборудованияТС
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.уатМестонахождениеТС.СрезПоследних(&Дата, ) КАК уатМестонахождениеТС
	|		ПО уатПеремещениеТСиОборудованияТС.ТС = уатМестонахождениеТС.ТС
	|ГДЕ
	|	уатПеремещениеТСиОборудованияТС.Ссылка = &Ссылка
	|	И (уатМестонахождениеТС.Организация <> &Организация
	|			ИЛИ уатМестонахождениеТС.Колонна <> &Колонна
	|			ИЛИ уатМестонахождениеТС.Подразделение <> &Подразделение)";
	Запрос = Новый Запрос(ТекстЗапроса);
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.УстановитьПараметр("Дата", СтруктураДополнительныеСвойства.ДляПроведения.МоментВремени);
	Запрос.УстановитьПараметр("Организация", ДокументСсылка.Организация);
	Запрос.УстановитьПараметр("Подразделение", ДокументСсылка.Подразделение);
	Запрос.УстановитьПараметр("Колонна", ДокументСсылка.Колонна);
	тблТС = Запрос.Выполнить().Выгрузить();
	
	// управляемая блокировка
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.уатОстаткиГСМнаТС");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = ДокументСсылка.ТС;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ТС", "ТС");
	Блокировка.Заблокировать();
		
	// формирование таблицы расхода остатков ГСМ
	тблОстаткиГСМ = Новый ТаблицаЗначений;
	тблОстаткиГСМ.Колонки.Добавить("Регистратор");
	тблОстаткиГСМ.Колонки.Добавить("Период");
	тблОстаткиГСМ.Колонки.Добавить("ВидДвижения");
	тблОстаткиГСМ.Колонки.Добавить("Организация");
	тблОстаткиГСМ.Колонки.Добавить("Подразделение");
	тблОстаткиГСМ.Колонки.Добавить("Колонна");
	тблОстаткиГСМ.Колонки.Добавить("ТС");
	тблОстаткиГСМ.Колонки.Добавить("ГСМ");
	тблОстаткиГСМ.Колонки.Добавить("Партия");
	тблОстаткиГСМ.Колонки.Добавить("Количество");
	тблОстаткиГСМ.Колонки.Добавить("Стоимость");
	тблОстаткиГСМ.Колонки.Добавить("СтоимостьУпр");
	тблОстаткиГСМ.Колонки.Добавить("СуммаНДС");
	Для Каждого ТекСтрокаТС из тблТС Цикл
		// запрос по остаткам ГСМ
		ТекстЗапроса =
		"ВЫБРАТЬ РАЗРЕШЕННЫЕ
		|	уатОстаткиГСМнаТСОстатки.Колонна КАК Колонна,
		|	уатОстаткиГСМнаТСОстатки.ТС КАК ТС,
		|	уатОстаткиГСМнаТСОстатки.ГСМ КАК ГСМ,
		|	уатОстаткиГСМнаТСОстатки.Партия КАК Партия,
		|	уатОстаткиГСМнаТСОстатки.КоличествоОстаток КАК Количество,
		|	уатОстаткиГСМнаТСОстатки.СтоимостьОстаток КАК Стоимость,
		|	уатОстаткиГСМнаТСОстатки.СтоимостьУпрОстаток КАК СтоимостьУпр,
		|	уатОстаткиГСМнаТСОстатки.СуммаНДСОстаток КАК СуммаНДС,
		|	уатОстаткиГСМнаТСОстатки.Организация КАК Организация,
		|	уатОстаткиГСМнаТСОстатки.Подразделение КАК Подразделение
		|ИЗ
		|	РегистрНакопления.уатОстаткиГСМнаТС.Остатки(
		|			&МоментВремени,
		|			ТС = &ТС
		|				И (Организация <> &Организация
		|					ИЛИ Колонна <> &Колонна
		|					ИЛИ Подразделение <> &Подразделение)) КАК уатОстаткиГСМнаТСОстатки";
		Запрос = Новый Запрос(ТекстЗапроса);
		Запрос.Параметры.Вставить("МоментВремени", ТекСтрокаТС.ДатаВвода-1);
		Запрос.Параметры.Вставить("ТС", ТекСтрокаТС.ТС);
		Запрос.Параметры.Вставить("Колонна", ДокументСсылка.Колонна);
		Запрос.Параметры.Вставить("Организация", ДокументСсылка.Организация);
		Запрос.Параметры.Вставить("Подразделение", ДокументСсылка.Подразделение);
	
		тблОстаткиГСМнаТС = Запрос.Выполнить().Выгрузить();
		Для Каждого ТекСтрокаОстаткиГСМ Из тблОстаткиГСМнаТС Цикл
			НоваяСтрока = тблОстаткиГСМ.Добавить();
			НоваяСтрока.Регистратор = ДокументСсылка;
			НоваяСтрока.Период = ТекСтрокаТС.ДатаВвода;
			НоваяСтрока.ВидДвижения = ВидДвиженияНакопления.Расход;
			НоваяСтрока.Колонна = ТекСтрокаОстаткиГСМ.Колонна;
			НоваяСтрока.Организация = ТекСтрокаОстаткиГСМ.Организация;
			НоваяСтрока.Подразделение = ТекСтрокаОстаткиГСМ.Подразделение;
			НоваяСтрока.ТС = ТекСтрокаТС.ТС;
			НоваяСтрока.ГСМ = ТекСтрокаОстаткиГСМ.ГСМ;
			НоваяСтрока.Партия = ТекСтрокаОстаткиГСМ.Партия;
			НоваяСтрока.Количество = ТекСтрокаОстаткиГСМ.Количество;
			НоваяСтрока.Стоимость = ТекСтрокаОстаткиГСМ.Стоимость;
			НоваяСтрока.СтоимостьУпр = ТекСтрокаОстаткиГСМ.СтоимостьУпр;
			НоваяСтрока.СуммаНДС = ТекСтрокаОстаткиГСМ.СуммаНДС;
		КонецЦикла;
	КонецЦикла;
	
	// округляем до точности хранения остатков ГСМ в ТС
	мТочностьОстатковГСМ = уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(ДокументСсылка.Организация, ПланыВидовХарактеристик.уатПраваИНастройки.ТочностьОстатковТоплива);
	Для Каждого ТекСтрока Из тблОстаткиГСМ Цикл
		ТекСтрока.Количество = Окр(ТекСтрока.Количество, мТочностьОстатковГСМ);
	КонецЦикла;
	
	// формирование таблицы прихода остатков ГСМ
	Колич = тблОстаткиГСМ.Количество();
	Для Сч = 0 По Колич-1 Цикл
		НоваяСтрока = тблОстаткиГСМ.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, тблОстаткиГСМ[Сч]);
		НоваяСтрока.ВидДвижения = ВидДвиженияНакопления.Приход;
		НоваяСтрока.Колонна = ДокументСсылка.Колонна;
		НоваяСтрока.Организация = ДокументСсылка.Организация;
		НоваяСтрока.Подразделение = ДокументСсылка.Подразделение;
	КонецЦикла;
		
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаГСМ", тблОстаткиГСМ);
КонецПроцедуры // СформироватьТаблицуГСМ()

Функция ПечатьПеремещениеТСиОборудования(МассивОбъектов, ОбъектыПечати)
	
	ТабличныйДокумент = Новый ТабличныйДокумент;
	ТабличныйДокумент.КлючПараметровПечати = "ПараметрыПечати_уатПеремещениеТСиОборудования";
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	ПервыйДокумент = Истина;
	
	мВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();
	
	Для Каждого ТекущийДокумент Из МассивОбъектов Цикл
		
		Если Не ПервыйДокумент Тогда
			ТабличныйДокумент.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		ПервыйДокумент = Ложь;
		
		НомерСтрокиНачало = ТабличныйДокумент.ВысотаТаблицы + 1;
		
		ТабличныйДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_уатПеремещениеТСиОборудования";
		Макет = УправлениеПечатью.МакетПечатнойФормы("Документ.уатПеремещениеТСиОборудования.ПФ_MXL_ПеремещениеТСиОборудования");
		
		// Выводим шапку
		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ОбластьМакета.Параметры.ТекстЗаголовка = уатОбщегоНазначенияТиповые.уатСформироватьЗаголовокДокумента(ТекущийДокумент, "Перемещение ТС и оборудования");
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета = Макет.ПолучитьОбласть("РеквизитыОрганизации");
		СписокТребуемыхПараметров	= "НаименованиеДляПечатныхФорм";
		СведенияОбОбъекте			= уатОбщегоНазначенияСервер.СведенияОЮрФизЛице(ТекущийДокумент.Организация);
		ОбластьМакета.Параметры.Организация		= уатОбщегоНазначенияТиповыеСервер.ОписаниеОрганизации(СведенияОбОбъекте, СписокТребуемыхПараметров);
		ОбластьМакета.Параметры.Подразделение = ТекущийДокумент.Подразделение;
		ОбластьМакета.Параметры.Колонна = ТекущийДокумент.Колонна;
		ТабличныйДокумент.Вывести(ОбластьМакета);
		
		// формируем таблицы ТС и оборудования
		тблТС = ТекущийДокумент.ТС.Выгрузить().Скопировать();
		Сч = тблТС.Количество()-1;
		Пока Сч >= 0 Цикл
			Если НЕ тблТС[Сч].ТС.ВидМоделиТС = Перечисления.уатВидыМоделейТС.Автотранспорт Тогда
				тблТС.Удалить(Сч);
			КонецЕсли;
			Сч = Сч - 1;
		КонецЦикла;
		тблОборудование = ТекущийДокумент.ТС.Выгрузить().Скопировать();
		Сч = тблОборудование.Количество()-1;
		Пока Сч >= 0 Цикл
			Если тблОборудование[Сч].ТС.ВидМоделиТС = Перечисления.уатВидыМоделейТС.Автотранспорт Тогда
				тблОборудование.Удалить(Сч);
			КонецЕсли;
			Сч = Сч - 1;
		КонецЦикла;
		
		НомерСтроки = 1;
		// Выводим таблицу ТС
		Если тблТС.Количество() > 0 Тогда
			ТекОбласть = Макет.ПолучитьОбласть("ШапкаТаблицы");
			ТабличныйДокумент.Вывести(ТекОбласть);
			Для Каждого ТекСтрока Из тблТС Цикл
				ТекОбласть = Макет.ПолучитьОбласть("Строка");
				ТекОбласть.Параметры.Заполнить(ТекСтрока);
				ТекОбласть.Параметры.НомерСтроки = НомерСтроки;
				ТекОбласть.Параметры.ПредставлениеТС = Строка(ТекСтрока.ТС);
				МестоТС = уатОбщегоНазначения.МестонахождениеТС(ТекСтрока.ТС, ТекСтрока.ДатаВвода-1);
				ТекОбласть.Параметры.Заполнить(МестоТС);
				НомерСтроки = НомерСтроки + 1;
				ТабличныйДокумент.Вывести(ТекОбласть);
			КонецЦикла;
			
			ТекОбласть = Макет.ПолучитьОбласть("Итого");
			ТабличныйДокумент.Вывести(ТекОбласть);
		КонецЕсли;
		
		НомерСтроки = 1;
		// Выводим таблицу оборудования
		Если тблОборудование.Количество() > 0 Тогда
			ТекОбласть = Макет.ПолучитьОбласть("ШапкаТаблицыОборудование");
			ТабличныйДокумент.Вывести(ТекОбласть);
			Для Каждого ТекСтрока Из тблОборудование Цикл
				ТекОбласть = Макет.ПолучитьОбласть("СтрокаОборудование");
				ТекОбласть.Параметры.Заполнить(ТекСтрока);
				ТекОбласть.Параметры.НомерСтроки = НомерСтроки;
				ТекОбласть.Параметры.Оборудование = Строка(ТекСтрока.ТС);
				МестоТС = уатОбщегоНазначения.МестонахождениеТС(ТекСтрока.ТС, ТекСтрока.ДатаВвода-1);
				ТекОбласть.Параметры.Заполнить(МестоТС);
				НомерСтроки = НомерСтроки + 1;
				ТабличныйДокумент.Вывести(ТекОбласть);
			КонецЦикла;
			ТекОбласть = Макет.ПолучитьОбласть("ИтогоОборудование");
			ТабличныйДокумент.Вывести(ТекОбласть);
		КонецЕсли;
		
		// Вывести подписи
		ТекОбласть = Макет.ПолучитьОбласть("Подвал");
		ТекОбласть.Параметры.Ответственный = ТекущийДокумент.Ответственный;
		ТабличныйДокумент.Вывести(ТекОбласть);
		
		УправлениеПечатью.ЗадатьОбластьПечатиДокумента(ТабличныйДокумент, НомерСтрокиНачало, ОбъектыПечати, ТекущийДокумент);
		
	КонецЦикла;
	
	ТабличныйДокумент.АвтоМасштаб = Истина;
	
	Возврат ТабличныйДокумент;
	
КонецФункции // ПечатнаяФорма()

#КонецОбласти

#КонецЕсли