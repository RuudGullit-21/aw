
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	уатЗащищенныеФункцииСервер.уатСправочникФормаЭлементаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, Объект, ЭтотОбъект, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	Если Не ПравоДоступа("Редактирование", Метаданные.Справочники.уатТарифыТС) Тогда 
		Элементы.СпособРасчета.Доступность = Ложь;
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	уатЗащищенныеФункцииКлиент.уатСправочникФормаЭлементаПриОткрытии(Отказ, ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ОтобразитьПродолжительностьРаботы();
	
	Если ЗначениеЗаполнено(Объект.Обед) Тогда
		СпособРасчета = 1;
	КонецЕсли;
	УстановитьВидимостьДоступность();
КонецПроцедуры

&НаКлиенте
Процедура НачалоОбедаПриИзменении(Элемент)
	Если ЗначениеЗаполнено(Объект.НачалоОбеда)
		И ЗначениеЗаполнено(Объект.КонецОбеда)
		И Объект.НачалоОбеда > Объект.КонецОбеда Тогда 
		
		Объект.КонецОбеда = Объект.НачалоОбеда;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура КонецОбедаПриИзменении(Элемент)
	Если ЗначениеЗаполнено(Объект.КонецОбеда)
		И ЗначениеЗаполнено(Объект.НачалоОбеда)
		И Объект.НачалоОбеда > Объект.КонецОбеда Тогда 
		
		Объект.НачалоОбеда = Объект.КонецОбеда;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура НачалоРаботыПриИзменении(Элемент)
	ОтобразитьПродолжительностьРаботы();
КонецПроцедуры

&НаКлиенте
Процедура КонецРаботыПриИзменении(Элемент)
	ОтобразитьПродолжительностьРаботы();
КонецПроцедуры

&НаКлиенте
Процедура СпособРасчетаПриИзменении(Элемент)
	Если СпособРасчета = 0 Тогда //по интервалу
		Объект.Обед = '00010101';
	Иначе //по продолжительности
		Объект.НачалоОбеда = '00010101';
		Объект.КонецОбеда = '00010101';
	КонецЕсли;
	
	Модифицированность = Истина;
	
	УстановитьВидимостьДоступность();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиенте
Процедура ОтобразитьПродолжительностьРаботы()
	КонецРаботыВрем = ?(Объект.НачалоРаботы <= Объект.КонецРаботы, Объект.КонецРаботы, Объект.КонецРаботы + 24*3600);
	Продолжительность = '00010101' + (КонецРаботыВрем - Объект.НачалоРаботы);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьВидимостьДоступность()
	Если СпособРасчета = 0 Тогда
		Элементы.Обед.Видимость = Ложь;
		Элементы.НачалоОбеда.Видимость = Истина;
		Элементы.КонецОбеда.Видимость = Истина;
	Иначе
		Элементы.Обед.Видимость = Истина;
		Элементы.НачалоОбеда.Видимость = Ложь;
		Элементы.КонецОбеда.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти