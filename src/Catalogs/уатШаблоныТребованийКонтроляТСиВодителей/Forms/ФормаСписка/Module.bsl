
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	уатЗащищенныеФункцииСервер.уатСправочникФормаСпискаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПравоДоступа("Редактирование", Метаданные.Справочники.уатТребованияКонтроляТС) Тогда 
		Элементы.ФормаИзменитьВыделенные.Видимость = Ложь;
		Элементы.СписокКонтекстноеМенюИзменитьВыделенные.Видимость = Ложь;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
    ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
    // Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
	Если НЕ ПравоДоступа("Изменение", Метаданные.Справочники.уатШаблоныТребованийКонтроляТСиВодителей) Тогда
		Элементы.Стандартный.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	уатЗащищенныеФункцииКлиент.уатСправочникФормаСпискаПриОткрытии(Отказ, ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ИзменитьВыделенные(Команда)
	
	ГрупповоеИзменениеОбъектовКлиент.ИзменитьВыделенные(Элементы.Список, Список);
	
КонецПроцедуры

&НаКлиенте
Процедура СоздатьСтандартныйШаблонКонтроляТС(Команда)
	СоздатьСтандартныйШаблон(1);
КонецПроцедуры

&НаКлиенте
Процедура СоздатьСтандартныйШаблонМедосмотра(Команда)
	СоздатьСтандартныйШаблон(2);
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура СоздатьСтандартныйШаблон(ВидОсмотра)
	ДопПараметры = Новый Структура("ВидОсмотра", ВидОсмотра);
	Оповещ = Новый ОписаниеОповещения("СоздатьСтандартныйШаблонВопрос", ЭтотОбъект, ДопПараметры);
	ТекстВопроса = СтрШаблон("Создаваемый шаблон будет заполнен стандартными требованиями "
		+ "к предрейсовому/послерейсовому %1 согласно законодательства РФ, "
		+ "при этом отсутствующие требования будут добавлены в справочник.
		|Продолжить?", ?(ВидОсмотра = 1, "контролю ТС", "медосмотру водителей"));
		
	ПоказатьВопрос(Оповещ, ТекстВопроса, РежимДиалогаВопрос.ОКОтмена);
КонецПроцедуры

&НаКлиенте
Процедура СоздатьСтандартныйШаблонВопрос(Рез, ДопПараметры) Экспорт
	Если Рез <> КодВозвратаДиалога.ОК Тогда
		Возврат;
	КонецЕсли;
	
	мсвТребований = СоздатьСтандартныеТребования(ДопПараметры.ВидОсмотра);
	
	ПараметрыФормы = Новый Структура("мсвТребований", мсвТребований);
	ОткрытьФорму("Справочник.уатШаблоныТребованийКонтроляТСиВодителей.ФормаОбъекта", ПараметрыФормы);
КонецПроцедуры

&НаСервереБезКонтекста
Функция СоздатьСтандартныеТребования(ВидОсмотра)
	мсвТребований = Новый Массив;
	
	Если ВидОсмотра = 1 Тогда
		ИмяМакета = "ПереченьОбязательныхТребованийКонтроляТС";
	Иначе
		ИмяМакета = "ПереченьОбязательныхТребованийМедосмотра";
	КонецЕсли;
	МакетТребований = Справочники.уатШаблоныТребованийКонтроляТСиВодителей.ПолучитьМакет(ИмяМакета);
	
	ОбластьДанных = МакетТребований.ПолучитьОбласть("Строки|Колонки");
	Для Сч = 1 По ОбластьДанных.ВысотаТаблицы Цикл
		НаименованиеТребования      = ОбластьДанных.Область(Сч, 1, Сч, 1).Текст;
		ОписаниеТребования          = ОбластьДанных.Область(Сч, 2, Сч, 2).Текст;
		ТипЗначенийТребованияСтрока = ОбластьДанных.Область(Сч, 3, Сч, 3).Текст;
		
		Если ТипЗначенийТребованияСтрока = "Булево" Тогда
			ТипЗначенийТребования = Перечисления.уатТипыЗначенийТребованийКонтроляТСиВодителей.Булево;
		ИначеЕсли ТипЗначенийТребованияСтрока = "Число" Тогда
			ТипЗначенийТребования = Перечисления.уатТипыЗначенийТребованийКонтроляТСиВодителей.Число;
		Иначе
			ТипЗначенийТребования = Перечисления.уатТипыЗначенийТребованийКонтроляТСиВодителей.Строка;
		КонецЕсли;
		
		ТребованиеСсылка = Справочники.уатТребованияКонтроляТС.НайтиПоНаименованию(НаименованиеТребования);
		Если НЕ ЗначениеЗаполнено(ТребованиеСсылка) Тогда
			НовоеТребование = Справочники.уатТребованияКонтроляТС.СоздатьЭлемент();
			НовоеТребование.Наименование = НаименованиеТребования;
			НовоеТребование.Содержание = ОписаниеТребования;
			НовоеТребование.ТипЗначенияТребования = ТипЗначенийТребования;
			НовоеТребование.Записать();
			ТребованиеСсылка = НовоеТребование.Ссылка;
		КонецЕсли;
		
		мсвТребований.Добавить(ТребованиеСсылка);
	КонецЦикла;
	
	Возврат мсвТребований;
КонецФункции

#КонецОбласти
