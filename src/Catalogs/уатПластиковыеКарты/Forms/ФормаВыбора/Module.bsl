
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	уатЗащищенныеФункцииСервер.уатСправочникФормаСпискаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	Список.ТекстЗапроса = СтрЗаменить(Список.ТекстЗапроса, "__СОСТОЯНИЕ_НЕДЕЙСТВУЕТ_", НСтр("ru='не действует'"));
	
	ТекОрг = уатОбщегоНазначенияПовтИсп.ПолучитьЗначениеПоУмолчаниюПользователя(ПользователиКлиентСервер.АвторизованныйПользователь(), "ОсновнаяОрганизация");
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ДниДоОкончанияДействияТопливныхКарт",
		уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(ТекОрг, ПредопределенноеЗначение(
		"ПланВидовХарактеристик.уатПраваИНастройки.ДниДоОкончанияДействияТопливныхКарт")));
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ТекущаяДата", НачалоДня(ТекущаяДата()));
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ДатаОкончания", ТекущаяДата());
	
	Если Параметры.Отбор.Свойство("КомуВыдана") Тогда
		МассивТипов = Новый Массив();
		МассивТипов.Добавить(Тип("СправочникСсылка.уатТС"));
		МассивТипов.Добавить(Тип("СправочникСсылка.Сотрудники"));
		МассивТипов.Добавить(Тип("СписокЗначений"));
		Элементы.ОтборКомуВыдана.ОграничениеТипа = Новый ОписаниеТипов(МассивТипов);

		ОтборКомуВыдана = Новый СписокЗначений;
		ОтборКомуВыдана.ТипЗначения = Новый ОписаниеТипов("СправочникСсылка.уатТС");
		ОтборКомуВыдана = Параметры.Отбор.КомуВыдана;
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "КомуВыдана", Параметры.Отбор.КомуВыдана);
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("КемВыдана") Тогда
		ОтборКемВыдана = Параметры.Отбор.КемВыдана;
	КонецЕсли;
	
	Если Параметры.Отбор.Свойство("Статус") Тогда
		Параметры.Отбор.Удалить("Статус");
	КонецЕсли;
	
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
	
	УстановитьОтборНеАктуальные();
	УстановитьОтборАннулированные();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтборКомуВыданаПриИзменении(Элемент)
	Если ТипЗнч(ОтборКомуВыдана) = Тип("СписокЗначений") Тогда
		ВидСравненияОтбора = ВидСравненияКомпоновкиДанных.ВСписке;
	Иначе
		ВидСравненияОтбора = ВидСравненияКомпоновкиДанных.Равно;
	КонецЕсли;
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "КомуВыдана", ОтборКомуВыдана, ЗначениеЗаполнено(ОтборКомуВыдана), ВидСравненияОтбора);
КонецПроцедуры

&НаКлиенте
Процедура ОтборКемВыданаПриИзменении(Элемент)
	ОтборыСписковКлиентСервер.ИзменитьЭлементОтбораСписка(Список, "КемВыдана", ОтборКемВыдана, ЗначениеЗаполнено(ОтборКемВыдана));
КонецПроцедуры

&НаКлиенте
Процедура ОтборКомуВыданаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	Если ТипЗнч(ОтборКомуВыдана) = Тип("СписокЗначений") Тогда
		СтандартнаяОбработка = Ложь;
		ПараметрыФормы = Новый Структура("Список", ОтборКомуВыдана);
		ОповещЗакрытие = Новый ОписаниеОповещения("КомуВыданаСписокВыбор", ЭтотОбъект);
		ОткрытьФорму("Справочник.уатПластиковыеКарты.Форма.СписокЗначений",ПараметрыФормы, Элемент,,,,ОповещЗакрытие);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОтборКомуВыданаОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	Если ВыбранноеЗначение = Тип("СписокЗначений") Тогда
		СтандартнаяОбработка = Ложь;
		ПараметрыФормы = Новый Структура("Список", ОтборКомуВыдана);
		ОповещЗакрытие = Новый ОписаниеОповещения("КомуВыданаСписокВыбор", ЭтотОбъект);
		ОткрытьФорму("Справочник.уатПластиковыеКарты.Форма.СписокЗначений",ПараметрыФормы, Элемент,,,,ОповещЗакрытие);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьАннулированныеПриИзменении(Элемент)
	УстановитьОтборАннулированные();
КонецПроцедуры

&НаКлиенте
Процедура ОтображатьНеАктуальныеПриИзменении(Элемент)
	УстановитьОтборНеАктуальные();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура КомуВыданаСписокВыбор(ВыбранноеЗначение, СтандартнаяОбработка) Экспорт
	Если ВыбранноеЗначение = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	ОтборКомуВыдана = ВыбранноеЗначение;
	ОтборКомуВыданаПриИзменении(Элементы.ОтборКомуВыдана);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборНеАктуальные()
	Если ОтображатьНеАктуальные Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ДатаОкончания", Дата(1,1,1));
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ДатаОкончания", НачалоДня(ТекущаяДата()));
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура УстановитьОтборАннулированные()
	Если ОтображатьАннулированные Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "СтатусДействует",,,, Ложь);
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "СтатусДействует",
			Ложь, ВидСравненияКомпоновкиДанных.НеРавно,, Истина);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
