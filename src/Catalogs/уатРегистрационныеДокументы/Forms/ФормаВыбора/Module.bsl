
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
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьНеАктуальныеПриИзменении(Элемент)
	УстановитьОтборНеАктуальные();
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

#КонецОбласти
