
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если НЕ Параметры.Свойство("ТипПресета") Тогда
		СтандартнаяОбработка = Ложь;
		Отказ = Истина;
		Возврат;
	КонецЕсли;

	ТипПресета = Параметры.ТипПресета;
	Группа     = "мои";
	
	ОбновитьСписокПресетов();
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если СписокПресетов.Количество() <> 0 Тогда
		МассивПресетов = СписокПресетов.НайтиСтроки(Новый Структура("Группа", Группа));
		Если МассивПресетов.Количество() <> 0 Тогда
			Элементы.СписокПресетов.ТекущаяСтрока = МассивПресетов[0].ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура СписокПресетовВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;
	ТекущиеДанные = Элементы.СписокПресетов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено Тогда
		ОповеститьОВыборе("");
		Возврат;
	КонецЕсли; 
	ОповеститьОВыборе(ТекущиеДанные.Наименование);
КонецПроцедуры

&НаКлиенте
Процедура ГруппаПриИзменении(Элемент)
	Если СписокПресетов.Количество() <> 0 Тогда
		МассивПресетов = СписокПресетов.НайтиСтроки(Новый Структура("Группа", Группа));
		Если МассивПресетов.Количество() <> 0 Тогда
			Элементы.СписокПресетов.ТекущаяСтрока = МассивПресетов[0].ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти 


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	ТекущиеДанные = Элементы.СписокПресетов.ТекущиеДанные;
	Если ТекущиеДанные = Неопределено
		ИЛИ ТекущиеДанные.Группа <> Группа Тогда
		ОповеститьОВыборе("");
		Возврат;
	КонецЕсли; 
	ОповеститьОВыборе(ТекущиеДанные.Наименование);
КонецПроцедуры

&НаКлиенте
Процедура Обновить(Команда)
	ОбновитьСписокПресетов();
	Если СписокПресетов.Количество() <> 0 Тогда
		МассивПресетов = СписокПресетов.НайтиСтроки(Новый Структура("Группа", Группа));
		Если МассивПресетов.Количество() <> 0 Тогда
			Элементы.СписокПресетов.ТекущаяСтрока = МассивПресетов[0].ПолучитьИдентификатор();
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ОбновитьСписокПресетов()  
	СписокПресетов.Очистить();
	
	ТекстОшибки    = "";
	МассивПресетов = уатВнешнийМаршрутизаторСервер_уэ.ПолучитьСписокПресетов(ТипПресета, ТекстОшибки);
	Если ЗначениеЗаполнено(ТекстОшибки) Тогда
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
	КонецЕсли;
		
	Для Каждого ТекПресет Из МассивПресетов Цикл
		НоваяСтрока = СписокПресетов.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекПресет);
	КонецЦикла;
КонецПроцедуры

#КонецОбласти