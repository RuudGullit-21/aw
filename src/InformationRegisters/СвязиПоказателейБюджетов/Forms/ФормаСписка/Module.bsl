#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список, "ТекстТранслируется", НСтр("en='транслируется';ru='транслируется'"));
		
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список, "ТекстПрочие", НСтр("en='Other';ru='Прочие'"));
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список, "Приход", НСтр("en='Income';ru='Приход'"));
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(
		Список, "Расход", НСтр("en='Expense';ru='Расход'"));
	
КонецПроцедуры

#КонецОбласти