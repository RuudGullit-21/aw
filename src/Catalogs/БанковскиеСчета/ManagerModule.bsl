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

// СтандартныеПодсистемы.ЗагрузкаДанныхИзФайла

// Запрещает/разрешает загрузку данных в этот справочник из подсистемы "ЗагрузкаДанныхИзФайла".
// 
// Возвращаемое значение:
//  Булево - флаг использования
//
Функция ИспользоватьЗагрузкуДанныхИзФайла() Экспорт
	Возврат Истина;
КонецФункции

// Конец СтандартныеПодсистемы.ЗагрузкаДанныхИзФайла

// СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

// См. ЗапретРедактированияРеквизитовОбъектовПереопределяемый.ПриОпределенииОбъектовСЗаблокированнымиРеквизитами.
Функция ПолучитьБлокируемыеРеквизитыОбъекта() Экспорт
	
	БлокируемыеРеквизиты = Новый Массив();
	
	БлокируемыеРеквизиты.Добавить("Владелец");
	БлокируемыеРеквизиты.Добавить("ВалютаДенежныхСредств");
	БлокируемыеРеквизиты.Добавить("ИностранныйБанк; ИностранныйБанк");
	
	Возврат БлокируемыеРеквизиты;
	
КонецФункции

// Конец СтандартныеПодсистемы.ЗапретРедактированияРеквизитовОбъектов

// СтандартныеПодсистемы.УправлениеДоступом

// См. УправлениеДоступомПереопределяемый.ПриЗаполненииСписковСОграничениемДоступа.
Процедура ПриЗаполненииОграниченияДоступа(Ограничение) Экспорт
	
	Ограничение.Текст =
	"РазрешитьЧтениеИзменение
	|ГДЕ
	|	ЗначениеРазрешено(Владелец)";
	
	Ограничение.ТекстДляВнешнихПользователей = Ограничение.Текст;
	
КонецПроцедуры

// Конец СтандартныеПодсистемы.УправлениеДоступом

#КонецОбласти

#КонецОбласти


#Область СлужебныйПрограммныйИнтерфейс

// Возвращает количество банковских счетов с указанным владельцем
//
// Параметры:
//  Владелец - Справочник	 - Контрагент, Организация
// 
// Возвращаемое значение:
//  Количество - банковских счетов
//
Функция ПолучитьКоличествоПодчиненныхЭлементовПоВладельцу(Владелец) Экспорт

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	БанковскиеСчета.Ссылка
	|ИЗ
	|	Справочник.БанковскиеСчета КАК БанковскиеСчета
	|ГДЕ
	|	БанковскиеСчета.Владелец = &Владелец";
	Запрос.УстановитьПараметр("Владелец", Владелец);

	Выборка = Запрос.Выполнить().Выбрать();
	
	Возврат Выборка.Количество();

КонецФункции

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

// Получает список найденных банков в справочнике Банки по реквизитам
//
// Параметры:
//  Поле      - Реквизит поиска
//  Значение  - Значение реквизита поиска
//
// Возвращемое значение:
//  Список значений - банки, удовлетворяющие условию поиска
//
Функция ПолучитьСписокБанковПоРеквизитам(Знач Поле, Знач Значение) Экспорт
	
	СписокБанков = Новый СписокЗначений();
	Если Поле = "" Тогда 
		Возврат СписокБанков;
	КонецЕсли;
	
	Запрос = Новый Запрос();
	
	Запрос.УстановитьПараметр("СтрокаПодбора", "" + Значение + "%");
	
	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	Банки.Ссылка КАК Ссылка,
	|	Банки." + Поле + " КАК ПолеПоиска,
	|	Банки.Наименование КАК Наименование
	|ИЗ
	|	Справочник.Банки КАК Банки
	|ГДЕ
	|	НЕ Банки.ЭтоГруппа
	|	И Банки." + Поле + " ПОДОБНО &СтрокаПодбора";
	
	Выборка = Запрос.Выполнить().Выбрать();
	
	Пока Выборка.Следующий() Цикл 
		врПозицияОтсечения = СтрДлина(Значение);
		тПредставление = Новый ФорматированнаяСтрока(
			Новый ФорматированнаяСтрока(Лев(Выборка.ПолеПоиска, врПозицияОтсечения),, ЦветаСтиля.уатЦветТекстаПриАвтоподборе), 
			Новый ФорматированнаяСтрока(Прав(Выборка.ПолеПоиска, СтрДлина(Выборка.ПолеПоиска)-врПозицияОтсечения)),
			Новый ФорматированнаяСтрока("("+Выборка.Наименование+")"));
		СписокБанков.Добавить(Выборка.Ссылка, тПредставление);
	КонецЦикла;
	
	Возврат СписокБанков;
	
КонецФункции // ПолучитьСписокБанковПоРеквизитам()

#КонецОбласти

#КонецЕсли