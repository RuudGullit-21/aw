#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	уатЗащищенныеФункцииСервер.уатДокументФормаСпискаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтотОбъект, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	уатЗащищенныеФункцииКлиент.уатДокументФормаСпискаПриОткрытии(Отказ, ЭтотОбъект, ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	Если ИмяСобытия = "ФормаПодбораЭПД_Выбор" Тогда
		Элементы.Список.Обновить();
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаСервереБезКонтекста
Процедура СписокПриПолученииДанныхНаСервере(ИмяЭлемента, Настройки, Строки)
	КлючиСтрок = Строки.ПолучитьКлючи();
	
	Запрос = Новый Запрос();
	Запрос.УстановитьПараметр("массивЭПД", КлючиСтрок);
	
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
	               |	уатСвязанныеДокументыЭПД.ЗаказНаТС КАК СвязанныйДокумент,
	               |	уатСвязанныеДокументыЭПД.ЭПД КАК ЭПД
	               |ИЗ
	               |	РегистрСведений.уатСвязанныеДокументыЭПД КАК уатСвязанныеДокументыЭПД
	               |ГДЕ
	               |	уатСвязанныеДокументыЭПД.ЭПД В(&массивЭПД)
	               |	И уатСвязанныеДокументыЭПД.ЗаказНаТС <> НЕОПРЕДЕЛЕНО
	               |	И уатСвязанныеДокументыЭПД.ЗаказНаТС <> ЗНАЧЕНИЕ(Документ.уатЗаказГрузоотправителя.ПустаяСсылка)
	               |	И НЕ уатСвязанныеДокументыЭПД.ЗаказНаТС ЕСТЬ NULL 
	               |
	               |ОБЪЕДИНИТЬ ВСЕ
	               |
	               |ВЫБРАТЬ
	               |	уатСвязанныеДокументыЭПД.Рейс,
	               |	уатСвязанныеДокументыЭПД.ЭПД
	               |ИЗ
	               |	РегистрСведений.уатСвязанныеДокументыЭПД КАК уатСвязанныеДокументыЭПД
	               |ГДЕ
	               |	уатСвязанныеДокументыЭПД.ЭПД В(&массивЭПД)
	               |	И уатСвязанныеДокументыЭПД.Рейс <> НЕОПРЕДЕЛЕНО
	               |	И уатСвязанныеДокументыЭПД.Рейс <> ЗНАЧЕНИЕ(Документ.уатМаршрутныйЛист.ПустаяСсылка)
	               |	И уатСвязанныеДокументыЭПД.Рейс <> ЗНАЧЕНИЕ(Документ.уатПутевойЛист.ПустаяСсылка) 
	               |	И уатСвязанныеДокументыЭПД.Рейс <> ЗНАЧЕНИЕ(Документ.уатЗаказПеревозчику_уэ.ПустаяСсылка)
	               |	И НЕ уатСвязанныеДокументыЭПД.Рейс ЕСТЬ NULL";  
	Основания = Запрос.Выполнить().Выгрузить();
	
	Для Каждого ТекущаяСтрока Из Строки Цикл
		Данные  = ТекущаяСтрока.Значение.Данные;
		ОтборЭД = Новый Структура("ЭПД", Данные.Ссылка);
		ОснованияЭД = Основания.НайтиСтроки(ОтборЭД); 
		
		Представление = "";
		КоличествоОснований = ОснованияЭД.Количество();
		Если КоличествоОснований = 0 Тогда  
			Представление = "";
		ИначеЕсли КоличествоОснований = 1 Тогда
			Представление = Строка(ОснованияЭД[0].СвязанныйДокумент);
			Данные.СвязанныйДокументИзображение = 3;
		Иначе
			ШаблонСтроки = НСтр("ru = ';%1 документ;;%1 документа;%1 документов;%1 документов'");
			Представление = СтрокаСЧислом(ШаблонСтроки, КоличествоОснований, ВидЧисловогоЗначения.Количественное);
			Данные.СвязанныйДокументИзображение = 3;
		КонецЕсли;  
		Данные.СвязанныйДокумент            = Представление;
	КонецЦикла; 
	
КонецПроцедуры 

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	Если Поле = Элементы.ПредставлениеСостояния Тогда
		// ЭлектронноеВзаимодействие.ОбменСКонтрагентами
		ОбменСКонтрагентамиКлиент.СостояниеЭДОНажатие_ФормаСписка(ВыбраннаяСтрока, СтандартнаяОбработка);
		// Конец ЭлектронноеВзаимодействие.ОбменСКонтрагентами
	ИначеЕсли Поле = Элементы.СвязанныйДокумент Тогда 
		СтандартнаяОбработка = Ложь;
		
		ДокументыОснования = ПолучитьДокументыОснования(ВыбраннаяСтрока);
		Если ДокументыОснования.Количество() = 1 Тогда
			ПоказатьЗначение(Неопределено, ДокументыОснования[0].ДокументОснование);
		ИначеЕсли ДокументыОснования.Количество() > 1 Тогда
			ПараметрыФормы = Новый Структура;
			
			МассивДокументов = Новый Массив;
			Для Каждого СтрТаб Из ДокументыОснования Цикл
				МассивДокументов.Добавить(СтрТаб.ДокументОснование);	
			КонецЦикла;
			
			ПараметрыФормы.Вставить("МассивДокументов", МассивДокументов); 
			
			ОписаниеДокументыОснование_Закрытие = Новый ОписаниеОповещения("ДокументыОснование_Закрытие", ЭтотОбъект);

			ОткрытьФорму("Документ.ЭлектроннаяТранспортнаяНакладная.Форма.ДокументыОснования",
			ПараметрыФормы, ЭтотОбъект,,,,ОписаниеДокументыОснование_Закрытие,РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);	
		Иначе
			Возврат;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервереБезКонтекста
Функция ПолучитьДокументыОснования(Ссылка)
	
	МассивДокументов = Новый Массив();

	Если ТипЗнч(Ссылка) = Тип("ДокументСсылка.ЭлектроннаяТранспортнаяНакладная") Тогда
		Запрос = Новый Запрос();
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	ЭлектроннаяТранспортнаяНакладнаяДокументыОснования.ДокументОснование КАК ДокументОснование
		|ИЗ
		|	Документ.ЭлектроннаяТранспортнаяНакладная.ДокументыОснования КАК ЭлектроннаяТранспортнаяНакладнаяДокументыОснования
		|ГДЕ
		|	ЭлектроннаяТранспортнаяНакладнаяДокументыОснования.Ссылка = &Ссылка"; 
	Иначе
		Запрос = Новый Запрос();
		Запрос.УстановитьПараметр("Ссылка", Ссылка);
		Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ РАЗЛИЧНЫЕ
		|	ЭлектронныйПутевойЛистДокументыОснования.ДокументОснование КАК ДокументОснование
		|ИЗ
		|	Документ.ЭлектронныйПутевойЛист.ДокументыОснования КАК ЭлектронныйПутевойЛистДокументыОснования
		|ГДЕ
		|	ЭлектронныйПутевойЛистДокументыОснования.Ссылка = &Ссылка"; 
	КонецЕсли;
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		МассивДокументов.Добавить(Новый Структура("ДокументОснование", Выборка.ДокументОснование));
	КонецЦикла;
	
	Возврат МассивДокументов;
	
КонецФункции

&НаКлиенте
Процедура ДокументыОснование_Закрытие(Результат, ДополнительныеПараметры) Экспорт

	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
	ДокументыОснование_ЗакрытиеСервер(ТекущиеДанные.Ссылка, Результат, ДополнительныеПараметры);
	Элементы.Список.Обновить();
	
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ДокументыОснование_ЗакрытиеСервер(ЭТрн, Результат, ДополнительныеПараметры)

	Если ТипЗнч(Результат) = Тип("Массив") Тогда   
		ДокОбъект = ЭТрн.ПолучитьОбъект();
		ДокОбъект.ДокументыОснования.Очистить();
		Для Каждого Документ Из Результат Цикл
			НовСтр = ДокОбъект.ДокументыОснования.Добавить();	
			НовСтр.ДокументОснование = Документ;	
		КонецЦикла;
		Попытка
			ДокОбъект.Записать();
		Исключение
		КонецПопытки;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


