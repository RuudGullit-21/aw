
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Автотест = Истина;
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("МассивТипов") Тогда
		Список.ЗагрузитьЗначения(Параметры.МассивТипов);
	КонецЕсли;

КонецПроцедуры

#КонецОбласти


#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОК(Команда)
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Закрыть(ТекущиеДанные.Значение);
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ТекущиеДанные = Элементы.Список.ТекущиеДанные;
	Закрыть(ТекущиеДанные.Значение);
КонецПроцедуры


#КонецОбласти

