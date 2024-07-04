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
	// необходима для подключения внешних ПФ
	Заглушка = Истина;
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
	|	ЗначениеРазрешено(ЦФО)";
	
	Ограничение.ТекстДляВнешнихПользователей = Ограничение.Текст;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти


#Область СлужебныйПрограммныйИнтерфейс

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	
	Запрос = Новый Запрос;
	МенеджерВремТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВремТаблиц;
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ 
	|	ЗаявкиКЗакрытию.Заявка КАК Заявка,
	|	ЗаявкиКЗакрытию.Заявка.ВидОперации КАК ВидОперации
	|ПОМЕСТИТЬ
	|	ЗаявкиКЗакрытию
	|ИЗ
	|	Документ.уатЗакрытиеЗаявокНаРасходованиеСредств.ЗаявкиНаРасходованиеСредств КАК ЗаявкиКЗакрытию
	|ГДЕ
	|	ЗаявкиКЗакрытию.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.Выполнить();
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.уатЗаявкиНаРасходованиеДС");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = ДокументСсылка.ЗаявкиНаРасходованиеСредств;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ЗаявкаНаРасходование", "Заявка");
	Блокировка.Заблокировать();
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	&Период КАК Период,
	|	&Регистратор КАК Регистратор,
	|	Значение(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	ЗаявкиКЗакрытию.Заявка КАК ЗаявкаНаРасходование,
	|	ЗаявкиКЗакрытию.ВидОперации КАК ВидОперации,
	|	ЗаявкиНаРасходованиеСредствОстатки.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	ЗаявкиНаРасходованиеСредствОстатки.Контрагент КАК Контрагент,
	|	ЗаявкиНаРасходованиеСредствОстатки.Организация КАК Организация,
	|	ЗаявкиНаРасходованиеСредствОстатки.Сделка КАК Сделка,
	|	ЗаявкиНаРасходованиеСредствОстатки.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
	|	ЗаявкиНаРасходованиеСредствОстатки.СуммаВзаиморасчетовОстаток КАК СуммаВзаиморасчетов,
	|	ЗаявкиНаРасходованиеСредствОстатки.СуммаУпрОстаток КАК СуммаУпр,
	|	ЗаявкиНаРасходованиеСредствОстатки.СуммаОстаток КАК Сумма
	|ИЗ
	|	РегистрНакопления.уатЗаявкиНаРасходованиеДС.Остатки(,
	|		ЗаявкаНаРасходование В (ВЫБРАТЬ РАЗЛИЧНЫЕ Заявка ИЗ ЗаявкиКЗакрытию)) КАК ЗаявкиНаРасходованиеСредствОстатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ 
	|			ЗаявкиКЗакрытию
	|		ПО ЗаявкиКЗакрытию.Заявка = ЗаявкиНаРасходованиеСредствОстатки.ЗаявкаНаРасходование
	|ГДЕ
	|	НЕ (ЗаявкиНаРасходованиеСредствОстатки.СуммаОстаток ЕСТЬ NULL
	|			ИЛИ (ЗаявкиНаРасходованиеСредствОстатки.СуммаОстаток = 0
	|				И ЗаявкиНаРасходованиеСредствОстатки.СуммаВзаиморасчетовОстаток = 0
	|				И ЗаявкиНаРасходованиеСредствОстатки.СуммаУпрОстаток = 0)) ";
	Запрос.УстановитьПараметр("Период", ДокументСсылка.Дата);
	Запрос.УстановитьПараметр("Регистратор", ДокументСсылка);
	
	ТаблицаЗаявокНаРасходованиеДС = Запрос.Выполнить().Выгрузить();

	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаЗаявокНаРасходованиеДС", ТаблицаЗаявокНаРасходованиеДС);
	
КонецПроцедуры // ИнициализироватьДанныеДокумента()

Процедура ВыполнитьКонтроль(ДокументСсылка, ДополнительныеСвойства, Отказ, УдалениеПроведения = Ложь) Экспорт
	
	// Документ всегда закрывает фактические остатки при проведении. Контроль не требуется. 
	
КонецПроцедуры // ВыполнитьКонтроль()

#КонецОбласти

#КонецЕсли