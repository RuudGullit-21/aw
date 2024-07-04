
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	АдресСервиса      = "";
	
	Если Параметры.Свойство("АдресСервиса") Тогда 
		АдресСервиса = Параметры.АдресСервиса;
	КонецЕсли;
	
	Если Параметры.Свойство("ВнешняяСистема") Тогда 
		ВнешняяСистема = Параметры.ВнешняяСистема;
	КонецЕсли;

	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьТокен(Команда)
	
	Токен       = "";
	ТекстОшибки = "";
	Если ВнешняяСистема = ПредопределенноеЗначение("Справочник.уатВнешниеСистемы.АвтоГРАФ") Тогда
		СтруктураПараметровУчетнойЗаписи = Новый Структура("АдресСервиса, Логин, Пароль",
			АдресСервиса, Логин, Пароль);
		Токен = уатМониторинг.АвтоГРАФ5_СозданиеТокена(СтруктураПараметровУчетнойЗаписи);
	КонецЕсли;

	Если Токен = "" Тогда 
		ТекстОшибки = НСтр("en='Session token is not received and could not be installed.';ru='Токен сессии не получен и не может быть установлен.'")
		+ Символы.ПС + ТекстОшибки;
		ПоказатьПредупреждение(, ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	Закрыть(Токен);
	
КонецПроцедуры

#КонецОбласти
