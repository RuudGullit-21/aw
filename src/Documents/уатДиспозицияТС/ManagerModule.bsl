#Если Сервер Или ТолстыйКлиентОбычноеПриложение Или ВнешнееСоединение Тогда

#Область ПрограммныйИнтерфейс

#Область ДляВызоваИзДругихПодсистем

// СтандартныеПодсистемы.ВерсионированиеОбъектов

// Определяет настройки объекта для подсистемы ВерсионированиеОбъектов.
//
// Параметры:
//  Настройки	 - Структура - настройки подсистемы.
//
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

Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	мЗапрос = Новый Запрос;
	мЗапрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	уатДиспозицияТС.ТС,
	|	уатДиспозицияТС.Ссылка КАК Регистратор,
	|	уатДиспозицияТС.Местоположение,
	|	уатДиспозицияТС.Заказ,
	|	уатДиспозицияТС.Контрагент,
	|	уатДиспозицияТС.ДатаОкончания,
	|	уатДиспозицияТС.Состояние,
	|	уатДиспозицияТС.ДатаНачала КАК Период
	|ИЗ
	|	Документ.уатДиспозицияТС КАК уатДиспозицияТС
	|ГДЕ
	|	уатДиспозицияТС.Ссылка = &Ссылка";
	мЗапрос.УстановитьПараметр("Ссылка",ДокументСсылка);
	
	ТаблицаДокумента = мЗапрос.Выполнить().Выгрузить();

	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСостоянийТС", ТаблицаДокумента);
КонецПроцедуры

Процедура ВыполнитьКонтроль(ДокументСсылка, ДополнительныеСвойства, Отказ, УдалениеПроведения = Ложь) Экспорт
	
	
КонецПроцедуры

#КонецОбласти

#КонецЕсли