#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ПоказательБюджетов = Параметры.ПоказательБюджетов;
	
	ОбщегоНазначенияКлиентСервер.УстановитьЭлементОтбораДинамическогоСписка(Список, "ПоказательБюджетов", ПоказательБюджетов);
	
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


#Область ОбработчикиСобытийЭлементовТаблицыФормыСписок

&НаКлиенте
Процедура СписокПередНачаломДобавления(Элемент, Отказ, Копирование, Родитель, Группа)
	
	Отказ = Истина;
	
	ЗначенияЗаполнения = Новый Структура;
	ЗначенияЗаполнения.Вставить("СвязанныйПоказательБюджетов", ПоказательБюджетов);
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("ЗначенияЗаполнения", ЗначенияЗаполнения);
	ПараметрыФормы.Вставить("КонтекстСвязанныйПоказательБюджетов", Истина);

	ОткрытьФорму("РегистрСведений.СвязиПоказателейБюджетов.Форма.ФормаЗаписи", 
		ПараметрыФормы,
		ЭтотОбъект);
	
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	ОткрытьФормуЗаписи();
	
КонецПроцедуры

&НаКлиенте
Процедура СписокПередНачаломИзменения(Элемент, Отказ)
	
	Отказ = Истина;
	ОткрытьФормуЗаписи();
	
КонецПроцедуры

#КонецОбласти


#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОткрытьФормуЗаписи()
	
	ПараметрыФормы = Новый Структура;
	ПараметрыФормы.Вставить("Ключ", Элементы.Список.ТекущаяСтрока);
	ПараметрыФормы.Вставить("КонтекстСвязанныйПоказательБюджетов", Истина);
	
	ОткрытьФорму("РегистрСведений.СвязиПоказателейБюджетов.Форма.ФормаЗаписи",
		ПараметрыФормы,
		ЭтотОбъект);
	
КонецПроцедуры
	
#КонецОбласти


