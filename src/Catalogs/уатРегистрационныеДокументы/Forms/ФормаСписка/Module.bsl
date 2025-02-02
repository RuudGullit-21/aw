
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	уатЗащищенныеФункцииСервер.уатСправочникФормаСпискаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКоманды.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
    ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	СтруктураНастроек = ВосстановитьНастройки();
	НастройкиНекорректны = (СтруктураНастроек = Неопределено ИЛИ ТипЗнч(СтруктураНастроек) <> Тип("Структура"));
	
	// отображение просроченных пластиковых карт
	Если НастройкиНекорректны ИЛИ (НЕ СтруктураНастроек.Свойство("ОтображатьВАрхиве")) Тогда
		ОтображатьВАрхиве = Ложь;
	Иначе
		ОтображатьВАрхиве = СтруктураНастроек.ОтображатьВАрхиве;
	КонецЕсли;
	
	Если НастройкиНекорректны ИЛИ (НЕ СтруктураНастроек.Свойство("ОтображатьНеАктуальные")) Тогда
		ОтображатьНеАктуальные = Ложь;
	Иначе
		ОтображатьНеАктуальные = СтруктураНастроек.ОтображатьНеАктуальные;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	уатЗащищенныеФункцииКлиент.уатСправочникФормаСпискаПриОткрытии(Отказ, ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;

	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ДатаОкончания", НачалоДня(ТекущаяДата()));
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ТекущаяДата", НачалоДня(ТекущаяДата()));
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ДниДоОкончанияДействияДокументовТС",
		уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(уатОбщегоНазначенияПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(
		ПользователиКлиентСервер.АвторизованныйПользователь(),
		"ОсновнаяОрганизация"), ПредопределенноеЗначение(
		"ПланВидовХарактеристик.уатПраваИНастройки.ДниДоОкончанияДействияДокументовТС")));
		
	УстановитьОтборВАрхиве();
	УстановитьОтборНеАктуальные();

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтображатьВАрхивеПриИзменении(Элемент)
	УстановитьОтборВАрхиве();
	СохранитьНастройки();
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьНеАктуальныеПриИзменении(Элемент)
	УстановитьОтборНеАктуальные();
	СохранитьНастройки();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_Список

&НаКлиенте
Процедура СписокПриАктивизацииСтроки(Элемент)
	// СтандартныеПодсистемы.ПодключаемыеКоманды
	ПодключаемыеКомандыКлиент.НачатьОбновлениеКоманд(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ПодключаемыеКоманды
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ВыполнитьКоманду(Команда)
	ПодключаемыеКомандыКлиент.НачатьВыполнениеКоманды(ЭтотОбъект, Команда, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ВосстановитьНастройки()
	СтруктураНастроек = ХранилищеНастроекДанныхФорм.Загрузить("Справочник.уатРегистрационныеДокументы.Форма.ФормаСписка", "ОбщиеНастройки");
	Возврат СтруктураНастроек;
КонецФункции

&НаСервере
Процедура СохранитьНастройки()
	УстановитьПривилегированныйРежим(Истина);
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("ОтображатьВАрхиве", ОтображатьВАрхиве);
	СтруктураНастроек.Вставить("ОтображатьНеАктуальные", ОтображатьНеАктуальные);
	ХранилищеНастроекДанныхФорм.Сохранить("Справочник.уатРегистрационныеДокументы.Форма.ФормаСписка", "ОбщиеНастройки", СтруктураНастроек);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборВАрхиве()
	Если ОтображатьВАрхиве Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Статус",,,, Ложь);
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Статус",
		ПредопределенноеЗначение("Перечисление.уатСтатусыдействия.НеДействует"), ВидСравненияКомпоновкиДанных.НеРавно,, Истина);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборНеАктуальные()
	Если ОтображатьНеАктуальные Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ДатаОкончания", Дата(1,1,1));
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ДатаОкончания", НачалоДня(ТекущаяДата()));
	КонецЕсли;
КонецПроцедуры

// СтандартныеПодсистемы.ПодключаемыеКоманды
&НаКлиенте
Процедура Подключаемый_ПродолжитьВыполнениеКомандыНаСервере(ПараметрыВыполнения, ДополнительныеПараметры) Экспорт
    ВыполнитьКомандуНаСервере(ПараметрыВыполнения);
КонецПроцедуры

&НаСервере
Процедура ВыполнитьКомандуНаСервере(ПараметрыВыполнения)
    ПодключаемыеКоманды.ВыполнитьКоманду(ЭтотОбъект, ПараметрыВыполнения, Элементы.Список);
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ОбновитьКоманды()
    ПодключаемыеКомандыКлиентСервер.ОбновитьКоманды(ЭтотОбъект, Элементы.Список);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ПодключаемыеКоманды

#КонецОбласти
