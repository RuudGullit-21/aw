
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	уатЗащищенныеФункцииСервер.уатСправочникФормаЭлементаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, Объект, ЭтотОбъект, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	// СтандартныеПодсистемы.ВерсионированиеОбъектов
	ВерсионированиеОбъектов.ПриСозданииНаСервере(ЭтотОбъект);
	// Конец СтандартныеПодсистемы.ВерсионированиеОбъектов
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	уатЗащищенныеФункцииКлиент.уатСправочникФормаЭлементаПриОткрытии(Отказ, ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормы_Услуги

&НаКлиенте
Процедура УслугиПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	Если НоваяСтрока И НЕ Копирование Тогда
		Элементы.Услуги.ТекущиеДанные.Количество = 1;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СформироватьНаименование(Команда)
	
	СформироватьНаименованиеСервер();
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура СформироватьНаименованиеСервер()
	
	Стр = "";
	Для Каждого ТекСтрока Из Объект.Услуги Цикл
		Стр = Стр + ?(Стр = "", "", ", ") + ТекСтрока.Номенклатура.Наименование;
	КонецЦикла;
	
	Объект.Наименование = Стр;
	
КонецПроцедуры

#КонецОбласти
