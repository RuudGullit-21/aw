
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	уатЗащищенныеФункцииСервер.уатРегистрФормаСпискаПриСозданииНаСервере(Отказ, СтандартнаяОбработка,ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Запись.Договор) И НЕ ЗначениеЗаполнено(Запись.Контрагент) Тогда
		Запись.Контрагент = Запись.Договор.Владелец;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	уатЗащищенныеФункцииКлиент.уатРегистрФормаСпискаПриОткрытии(Отказ, ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	
	Оповестить("ЗаписьНастроекЗаполненияПоУслугам");
	
КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если НЕ ТекущийОбъект.Выбран() Тогда
		Запрос = Новый Запрос(
		"ВЫБРАТЬ
		|	уатНастройкиЗаполненияПоУслугам.Договор КАК Договор,
		|	уатНастройкиЗаполненияПоУслугам.Шаблон КАК Шаблон
		|ИЗ
		|	РегистрСведений.уатНастройкиЗаполненияПоУслугам КАК уатНастройкиЗаполненияПоУслугам
		|ГДЕ
		|	уатНастройкиЗаполненияПоУслугам.Договор = &Договор");
		Запрос.УстановитьПараметр("Договор", Запись.Договор);
		
		Выборка = Запрос.Выполнить().Выбрать();
		
		Если Выборка.Следующий() Тогда	
			ТекстОшибки =
				СтрШаблон("Для договора ""%1"" уже указан шаблон заполнения ""%2"" (можно указать только один шаблон)!",
				Запись.Договор, Выборка.Шаблон);
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(ТекстОшибки);
			Отказ = Истина;
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
