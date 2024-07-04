
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	ЕстьПравоИзменения = Справочники.МашиночитаемыеДоверенностиКонтрагентов.ЕстьПравоИзменения();
	Элементы.ФормаЗагрузитьПерезаполнитьИзФайла.Видимость = ЕстьПравоИзменения;
	
	Список.Параметры.УстановитьЗначениеПараметра("ТекущаяДата", ТекущаяДатаСеанса());
	Список.Параметры.УстановитьЗначениеПараметра(
		"БудетОтозвана", МашиночитаемыеДоверенностиКлиентСервер.ЗаголовокБудетОтозвана());
	Список.Параметры.УстановитьЗначениеПараметра("Да", НСтр("ru = 'Да'"));
	Список.Параметры.УстановитьЗначениеПараметра("Нет", НСтр("ru = 'Нет'"));
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Загрузить(Команда)
	
	ОписаниеОповещения = Новый ОписаниеОповещения("ЗагрузитьЗавершение", ЭтотОбъект);
	МашиночитаемыеДоверенностиКлиент.ПолучитьДанныеМЧД(ОписаниеОповещения, ЭтотОбъект, 
		Истина, Истина);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьПерезаполнитьИзФайла(Команда)
	
	ОбработчикЗавершения = Новый ОписаниеОповещения("ЗагрузитьПерезаполнитьИзФайлаЗавершение", ЭтотОбъект);
	
	ПараметрыЗагрузки = ФайловаяСистемаКлиент.ПараметрыЗагрузкиФайла();
	ПараметрыЗагрузки.ИдентификаторФормы = УникальныйИдентификатор;
	ПараметрыЗагрузки.Диалог.Фильтр = НСтр("ru = 'Архив'") + " (*.zip)|*.zip";
	ПараметрыЗагрузки.Диалог.Заголовок = НСтр("ru = 'Выберите архив с доверенностью и подписью'");
	
	ФайловаяСистемаКлиент.ЗагрузитьФайл(ОбработчикЗавершения, ПараметрыЗагрузки);
	
КонецПроцедуры

&НаКлиенте
Процедура ПометитьОтозванной(Команда)
	
	Если Элементы.Список.ТекущаяСтрока = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СсылкаНаЭлементСправочника = Элементы.Список.ТекущаяСтрока;
	ПараметрыФормы = Новый Структура("Ключ", СсылкаНаЭлементСправочника);	
	ОткрытьФорму("Справочник.МашиночитаемыеДоверенностиКонтрагентов.Форма.ФормаЭлемента", ПараметрыФормы);
	
	ТекстСообщения = НСтр("ru = 'Для изменения пометки отозвана выполните: Еще - Пометить отозванной/Вернуть в работу'");
	ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ЗагрузитьЗавершение(Результат, ДополнительныеПараметры) Экспорт
	
	Если Не ЗначениеЗаполнено(Результат.СсылкаНаДоверенность) И Результат.Свойство("ТекстОшибки") Тогда
		МашиночитаемыеДоверенностиКлиент.ПоказатьПредупреждениеПриЗагрузкеМЧД(Результат.ТекстОшибки);
		Возврат;
	КонецЕсли;

	Элементы.Список.Обновить();
	ОткрытьФорму(
		"Справочник.МашиночитаемыеДоверенностиКонтрагентов.ФормаОбъекта",
		Новый Структура("Ключ, ОбновитьСостояниеПриОткрытии", Результат.СсылкаНаДоверенность, Истина), ,
		Новый УникальныйИдентификатор);
	Если Результат.ОткрытьФормуДляОбновления Тогда
		ТекстСообщения = НСтр("ru = 'Для обновления выполните: Еще - Обновить из реестра ФНС.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	Иначе
		ТекстСообщения = НСтр("ru = 'Доверенность успешно загружена.'");
		ОбщегоНазначенияКлиент.СообщитьПользователю(ТекстСообщения);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьПерезаполнитьИзФайлаЗавершение(ПомещенныйФайл, ДополнительныеПараметры) Экспорт
	
	Если ПомещенныйФайл = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	АдресВоВременномХранилище = ПомещенныйФайл.Хранение;
	
	МашиночитаемыеДоверенностиКлиент.ЗагрузитьПерезаполнитьМЧДКонтрагентаИзФайла(АдресВоВременномХранилище);
	
КонецПроцедуры

#КонецОбласти
