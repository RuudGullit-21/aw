

#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("ДополнительныеГруппировки") Тогда
		ДополнительныеГруппировки = Параметры.ДополнительныеГруппировки;
	Иначе
		ДополнительныеГруппировки = Новый СписокЗначений;
	КонецЕсли;
	
	ЗаполитьСписокГруппировок(ДополнительныеГруппировки);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы_Список

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		Возврат;
	КонецЕсли;
    ОповеститьОВыборе(ТекущиеДанные.Ссылка);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
    ОповеститьОВыборе(ТекущиеДанные.Ссылка);
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

Процедура ЗаполитьСписокГруппировок(ДополнительныеГруппировки);
	
	Список.Очистить();
	
	Запрос = Новый Запрос("ВЫБРАТЬ
	|	СправочникуатПараметрыВыработки.Ссылка КАК Ссылка,
	|	СправочникуатПараметрыВыработки.Представление КАК Представление
	|ИЗ
	|	Справочник.уатПараметрыВыработки КАК СправочникуатПараметрыВыработки
	|ГДЕ
	|	СправочникуатПараметрыВыработки.ПометкаУдаления = ЛОЖЬ
	|	И СправочникуатПараметрыВыработки.Ссылка <> ЗНАЧЕНИЕ(Справочник.уатПараметрыВыработки.СкладскаяОбработка)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	уатГруппировкиТарифов.Ссылка,
	|	ПРЕДСТАВЛЕНИЕ(уатГруппировкиТарифов.Ссылка)
	|ИЗ
	|	Перечисление.уатГруппировкиТарифов КАК уатГруппировкиТарифов
	|ГДЕ
	|	уатГруппировкиТарифов.Ссылка В(&ДополнительныеГруппировки)");
	Запрос.УстановитьПараметр("ДополнительныеГруппировки", ДополнительныеГруппировки);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = Список.Добавить();
		НоваяСтрока.Ссылка = Выборка.Ссылка;
		НоваяСтрока.Представление = Выборка.Представление;
	КонецЦикла;
	
	Список.Сортировать("Представление");
	
КонецПроцедуры

#КонецОбласти
