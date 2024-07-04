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
	// необходима для подключения внешних ПФ
	Заглушка = Истина;
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
	
	СформироватьТаблицуСчетчикиТС(ДокументСсылка, СтруктураДополнительныеСвойства);
	СформироватьТаблицуПрохожденияТО(ДокументСсылка, СтруктураДополнительныеСвойства);
	
КонецПроцедуры // ИнициализироватьДанныеДокумента()

Процедура ВыполнитьКонтроль(ДокументСсылка, ДополнительныеСвойства, Отказ, УдалениеПроведения = Ложь) Экспорт
	//Зарезервировано
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицуСчетчикиТС(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	тблСчетчикиТС = Новый ТаблицаЗначений();
	тблСчетчикиТС.Колонки.Добавить("Регистратор");
	тблСчетчикиТС.Колонки.Добавить("Период");
	тблСчетчикиТС.Колонки.Добавить("ТС");
	тблСчетчикиТС.Колонки.Добавить("ТипСчетчика");
	тблСчетчикиТС.Колонки.Добавить("Значение");
	
	Для Каждого ТекСтрокаСпидометр Из ДокументСсылка.Спидометр Цикл
		Если ТекСтрокаСпидометр.ПоказанияСпидометра > 0 Тогда
			НоваяСтрока = тблСчетчикиТС.Добавить();
			НоваяСтрока.Период = ДокументСсылка.Дата;
			НоваяСтрока.Регистратор = ДокументСсылка;
			НоваяСтрока.ТС = ТекСтрокаСпидометр.ТС;
			НоваяСтрока.ТипСчетчика = Перечисления.уатТипыСчетчиковТС.Спидометр;
			НоваяСтрока.Значение = ТекСтрокаСпидометр.ПоказанияСпидометра;
		КонецЕсли;
		
		Если ТекСтрокаСпидометр.ПоказанияСчетчикаМЧ > 0 Тогда
			НоваяСтрока = тблСчетчикиТС.Добавить();
			НоваяСтрока.Период = ДокументСсылка.Дата;
			НоваяСтрока.Регистратор = ДокументСсылка;
			НоваяСтрока.ТС = ТекСтрокаСпидометр.ТС;
			НоваяСтрока.ТипСчетчика = Перечисления.уатТипыСчетчиковТС.СчетчикМЧ;
			НоваяСтрока.Значение = ТекСтрокаСпидометр.ПоказанияСчетчикаМЧ;
		КонецЕсли;
	КонецЦикла;
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСчетчиковТС", тблСчетчикиТС);
	
КонецПроцедуры // СформироватьТаблицуАгрегатыТС()

Процедура СформироватьТаблицуПрохожденияТО(ДокументСсылка, СтруктураДополнительныеСвойства)
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	уатВводНачальныхПоказанийИсторияПрохожденияТО.ДатаТО КАК Период,
	|	уатВводНачальныхПоказанийИсторияПрохожденияТО.Ссылка КАК Регистратор,
	|	уатВводНачальныхПоказанийИсторияПрохожденияТО.ТС КАК ТС,
	|	уатВводНачальныхПоказанийИсторияПрохожденияТО.ВидОбслуживания КАК ВидТО,
	|	уатВводНачальныхПоказанийИсторияПрохожденияТО.ПараметрВыработкиТО КАК ПараметрВыработки,
	|	ВЫБОР
	|		КОГДА уатВводНачальныхПоказанийИсторияПрохожденияТО.ПараметрВыработкиТО.Временный
	|			ТОГДА уатВводНачальныхПоказанийИсторияПрохожденияТО.ВыработкаПриТО * 3600
	|		ИНАЧЕ уатВводНачальныхПоказанийИсторияПрохожденияТО.ВыработкаПриТО
	|	КОНЕЦ КАК Выработка
	|ИЗ
	|	Документ.уатВводНачальныхПоказаний.ИсторияПрохожденияТО КАК уатВводНачальныхПоказанийИсторияПрохожденияТО
	|ГДЕ
	|	уатВводНачальныхПоказанийИсторияПрохожденияТО.Ссылка = &Ссылка
	|	И уатВводНачальныхПоказанийИсторияПрохожденияТО.ВидОбслуживания.ИспользоватьВПланированииТО";
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаПрохожденияТО", Запрос.Выполнить().Выгрузить());
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли