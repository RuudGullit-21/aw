
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("Раздел") Тогда
		ЗаполнитьСписокВыбораРазрезПланирования(Параметры.Раздел);
		Раздел = Параметры.Раздел;
	КонецЕсли;
	
	Если Параметры.Свойство("РазрезыПланирования") Тогда
		Для Каждого ТекСтрока Из Параметры.РазрезыПланирования Цикл
			НоваяСтрока = РазрезыПланирования.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
		КонецЦикла;
	КонецЕсли;
	
	Параметры.Свойство("ПараметрВыработки", ПараметрВыработки);
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РазрезыПланированияРазрезПланированияНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Элементы.РазрезыПланированияРазрезПланирования.СписокВыбора.Очистить();
	ДанныеВыбора = ПолучитьСписокВыбораРазрезПланирования(Раздел);

КонецПроцедуры

&НаКлиенте
Процедура РазрезыПланированияРазрезПланированияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	Конецесли;
	
	Элементы.РазрезыПланированияРазрезПланирования.СписокВыбора.Очистить();
	Элементы.РазрезыПланированияРазрезПланирования.СписокВыбора.Добавить(ВыбранноеЗначение);
	
	ТекущиеДанные = Элементы.РазрезыПланирования.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.РазрезПланирования = ВыбранноеЗначение;
	
КонецПроцедуры

&НаКлиенте
Процедура РазрезыПланированияВариантАналитикиОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	Конецесли;
	
	Элементы.РазрезыПланированияВариантАналитикиПредставление.СписокВыбора.Очистить();
	Элементы.РазрезыПланированияВариантАналитикиПредставление.СписокВыбора.Добавить(ВыбранноеЗначение);
	
	ТекущиеДанные = Элементы.РазрезыПланирования.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ТекущиеДанные.ВариантАналитики = ВыбранноеЗначение;

КонецПроцедуры

&НаКлиенте
Процедура РазрезыПланированияВариантАналитикиНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	Элементы.РазрезыПланированияВариантАналитикиПредставление.СписокВыбора.Очистить();
	
	ТекущиеДанные = Элементы.РазрезыПланирования.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СписокРазрезов = ПолучитьСписокРазрезов(ТекущиеДанные.РазрезПланирования);
	ДанныеВыбора   = СписокРазрезов;

КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ВыбратьРазрезы(Команда)
	
	мРазрезыПланирования = Новый Массив();
	
	Для Каждого ТекСтрока Из РазрезыПланирования Цикл 
		СтруктураЗаполнения = Новый Структура("РазрезПланирования, ВариантАналитики,
		|ПланированиеПоГруппам");
		ЗаполнитьЗначенияСвойств(СтруктураЗаполнения, ТекСтрока);
		мРазрезыПланирования.Добавить(СтруктураЗаполнения);
	КонецЦикла;
	
	Закрыть();
	Оповестить("ВыборРазрезовПланированияСценария",
		Новый Структура("РазрезыПланирования, ПараметрВыработки", мРазрезыПланирования, ПараметрВыработки));
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ЗаполнитьСписокВыбораРазрезПланирования(Раздел)
	
	СписокВыбораРазрезПланирования = Элементы.РазрезыПланированияРазрезПланирования.СписокВыбора;
	СписокВыбораРазрезПланирования.Очистить();
	
	СписокВыбораРазрезПланирования.Добавить(ПредопределенноеЗначение("Перечисление.уатРазрезыПланирования.Подразделение"));
	СписокВыбораРазрезПланирования.Добавить(ПредопределенноеЗначение("Перечисление.уатРазрезыПланирования.Колонна"));
	СписокВыбораРазрезПланирования.Добавить(ПредопределенноеЗначение("Перечисление.уатРазрезыПланирования.ТС"));
	СписокВыбораРазрезПланирования.Добавить(ПредопределенноеЗначение("Перечисление.уатРазрезыПланирования.ВидПеревозки"));
	СписокВыбораРазрезПланирования.Добавить(ПредопределенноеЗначение("Перечисление.уатРазрезыПланирования.Контрагент"));
	СписокВыбораРазрезПланирования.Добавить(ПредопределенноеЗначение("Перечисление.уатРазрезыПланирования.Маршрут"));
	СписокВыбораРазрезПланирования.Добавить(ПредопределенноеЗначение("Перечисление.уатРазрезыПланирования.ОбъектСтроительства"));
	СписокВыбораРазрезПланирования.Добавить(ПредопределенноеЗначение("Перечисление.уатРазрезыПланирования.НаправлениеПеревозки"));
	СписокВыбораРазрезПланирования.Добавить(ПредопределенноеЗначение("Перечисление.уатРазрезыПланирования.Договор"));
	
КонецПроцедуры

&НаКлиенте
Функция ПолучитьСписокРазрезов(РазрезПланирования)
	
	СписокВыбораВариантАналитики = Новый СписокЗначений();

	Если РазрезПланирования = ПредопределенноеЗначение("Перечисление.уатРазрезыПланирования.ТС") Тогда
		СписокВыбораВариантАналитики.Добавить(ПредопределенноеЗначение("Перечисление.уатВариантыАналитик.ТС"));
		СписокВыбораВариантАналитики.Добавить(ПредопределенноеЗначение("Перечисление.уатВариантыАналитик.ТипТС"));
		СписокВыбораВариантАналитики.Добавить(ПредопределенноеЗначение("Перечисление.уатВариантыАналитик.ПринадлежностьТС"));
		СписокВыбораВариантАналитики.Добавить(ПредопределенноеЗначение("Перечисление.уатВариантыАналитик.МодельТС"));
	ИначеЕсли РазрезПланирования = ПредопределенноеЗначение("Перечисление.уатРазрезыПланирования.Маршрут") Тогда
		СписокВыбораВариантАналитики.Добавить(ПредопределенноеЗначение("Перечисление.уатВариантыАналитик.Маршрут"));
		СписокВыбораВариантАналитики.Добавить(ПредопределенноеЗначение("Перечисление.уатВариантыАналитик.ПунктОтправления"));
		СписокВыбораВариантАналитики.Добавить(ПредопределенноеЗначение("Перечисление.уатВариантыАналитик.ПунктНазначения"));
	ИначеЕсли РазрезПланирования = ПредопределенноеЗначение("Перечисление.уатРазрезыПланирования.Статья") Тогда
		СписокВыбораВариантАналитики.Добавить(ПредопределенноеЗначение("Перечисление.уатВариантыАналитик.СтатьяДоходов"));
		СписокВыбораВариантАналитики.Добавить(ПредопределенноеЗначение("Перечисление.уатВариантыАналитик.СтатьяРасходов"));
	КонецЕсли;
	
	Возврат СписокВыбораВариантАналитики;
КонецФункции

&НаСервере
Функция ПолучитьСписокВыбораРазрезПланирования(Раздел)
	
	СписокВыбораРазрезПланирования = Новый СписокЗначений;
	
	ДобавитьВСписокВыбораРазрезаПланирования(СписокВыбораРазрезПланирования,
		ПредопределенноеЗначение("Перечисление.уатРазрезыПланирования.Подразделение"));
	ДобавитьВСписокВыбораРазрезаПланирования(СписокВыбораРазрезПланирования,
		ПредопределенноеЗначение("Перечисление.уатРазрезыПланирования.Колонна"));
	ДобавитьВСписокВыбораРазрезаПланирования(СписокВыбораРазрезПланирования,
		ПредопределенноеЗначение("Перечисление.уатРазрезыПланирования.ТС"));
	ДобавитьВСписокВыбораРазрезаПланирования(СписокВыбораРазрезПланирования,
		ПредопределенноеЗначение("Перечисление.уатРазрезыПланирования.ВидПеревозки"));
	ДобавитьВСписокВыбораРазрезаПланирования(СписокВыбораРазрезПланирования,
		ПредопределенноеЗначение("Перечисление.уатРазрезыПланирования.Контрагент"));
	ДобавитьВСписокВыбораРазрезаПланирования(СписокВыбораРазрезПланирования,
		ПредопределенноеЗначение("Перечисление.уатРазрезыПланирования.Маршрут"));
	ДобавитьВСписокВыбораРазрезаПланирования(СписокВыбораРазрезПланирования,
		ПредопределенноеЗначение("Перечисление.уатРазрезыПланирования.ОбъектСтроительства"));
	ДобавитьВСписокВыбораРазрезаПланирования(СписокВыбораРазрезПланирования,
		ПредопределенноеЗначение("Перечисление.уатРазрезыПланирования.НаправлениеПеревозки"));
	
	Возврат СписокВыбораРазрезПланирования;
	
КонецФункции

&НаСервере
Процедура ДобавитьВСписокВыбораРазрезаПланирования(СписокВыбораРазрезПланирования, Раздел)
	
	СтрокиРазделов = РазрезыПланирования.НайтиСтроки(Новый Структура("РазрезПланирования", Раздел));
	Если СтрокиРазделов.Количество() = 0 Тогда
		СписокВыбораРазрезПланирования.Добавить(Раздел);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
