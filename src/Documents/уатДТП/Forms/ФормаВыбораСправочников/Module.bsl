
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если НЕ Параметры.Свойство("ИмяОбъектаВыбора") Тогда
		СтандартнаяОбработка = Ложь;
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если Параметры.ИмяОбъектаВыбора = "Список" Тогда
		Если НЕ Параметры.Свойство("СписокОбъектов") Тогда
			СтандартнаяОбработка = Ложь;
			Отказ = Истина;
			Возврат;
		КонецЕсли;
		Заголовок = Параметры.Заголовок;
	Иначе
		СтандартнаяОбработка = Ложь;
		Отказ = Истина;
		Возврат;
	КонецЕсли;
	
	Если ТипЗнч(Параметры.СписокОбъектов) = Тип("СписокЗначений") Тогда
		Для Каждого ТекСтрока Из Параметры.СписокОбъектов Цикл
			НоваяСтрока               = Список.Добавить();
			НоваяСтрока.Представление = ТекСтрока.Представление;
			НоваяСтрока.Значение      = ТекСтрока.Значение;
			
		КонецЦикла;
	Иначе
		НоваяСтрока               = Список.Добавить();
		НоваяСтрока.Представление = Параметры.СписокОбъектов;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Закрыть(Элементы.Список.ТекущиеДанные.Значение);
КонецПроцедуры

#КонецОбласти
