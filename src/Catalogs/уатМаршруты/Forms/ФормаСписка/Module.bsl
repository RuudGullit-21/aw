
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	уатЗащищенныеФункцииСервер.уатСправочникФормаСпискаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПравоДоступа("Редактирование", Метаданные.Справочники.уатМаршруты) Тогда 
		Элементы.ФормаИзменитьВыделенные.Видимость = Ложь;
		Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = Ложь;
	КонецЕсли;
	
	Список.ТекстЗапроса = СтрЗаменить(Список.ТекстЗапроса, "__СОСТОЯНИЕ_НЕДЕЙСТВУЕТ_", НСтр("ru='не действует'"));
	
	СтруктураНастроек = ВосстановитьНастройки();
	НастройкиНекорректны = (СтруктураНастроек = Неопределено ИЛИ ТипЗнч(СтруктураНастроек) <> Тип("Структура"));
	
	// отображение просроченных пластиковых карт
	Если НастройкиНекорректны ИЛИ (НЕ СтруктураНастроек.Свойство("ОтображатьНеДействующие")) Тогда
		ОтображатьНеДействующие = Ложь;
	Иначе
		ОтображатьНеДействующие = СтруктураНастроек.ОтображатьНеДействующие;
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
	УстановитьОтборНеДействующие();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ОтображатьНеДействующиеПриИзменении(Элемент)
	УстановитьОтборНеДействующие();
	СохранитьНастройки();
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список, Список);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура УстановитьОтборНеДействующие()
	Если ОтображатьНеДействующие Тогда
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Статус",,,, Ложь);
	Иначе
		ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбора(Список.Отбор, "Статус",
			ПредопределенноеЗначение("Перечисление.уатСтатусыДействия.НеДействует"), ВидСравненияКомпоновкиДанных.НеРавно,, Истина);
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ВосстановитьНастройки()
	СтруктураНастроек = ХранилищеНастроекДанныхФорм.Загрузить("Справочник.уатМаршруты.Форма.ФормаСписка", "ОбщиеНастройки");
	Возврат СтруктураНастроек;
КонецФункции

&НаСервере
Процедура СохранитьНастройки()
	УстановитьПривилегированныйРежим(Истина);
	СтруктураНастроек = Новый Структура;
	СтруктураНастроек.Вставить("ОтображатьНеДействующие", ОтображатьНеДействующие);
	ХранилищеНастроекДанныхФорм.Сохранить("Справочник.уатМаршруты.Форма.ФормаСписка", "ОбщиеНастройки", СтруктураНастроек);
КонецПроцедуры

#КонецОбласти
