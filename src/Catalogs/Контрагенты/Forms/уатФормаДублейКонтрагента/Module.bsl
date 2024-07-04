
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("Дубли") Тогда
		Для Каждого Дубль Из Параметры.Дубли Цикл
			НоваяСтрока = Контрагенты.Добавить();
			ЗаполнитьЗначенияСвойств(НоваяСтрока, Дубль.Значение);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти