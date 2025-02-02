
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	уатЗащищенныеФункцииКлиент.уатРегистрФормаСпискаПриОткрытии(Отказ, ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	уатЗащищенныеФункцииСервер.уатРегистрФормаСпискаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	УстановитьВидимость();
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьВидимость()
	ЭтоКОРП = уатОбщегоНазначенияПовтИсп.ВариантПоставкиКОРП();
	
	Элементы.Грузоотправитель.Видимость = ЭтоКОРП;
	Элементы.Грузополучатель.Видимость = ЭтоКОРП;
	Элементы.ПунктОтправления.Видимость = ЭтоКОРП;
	Элементы.ПунктНазначения.Видимость = ЭтоКОРП;
	Элементы.ДнейДоОтправления.Видимость = ЭтоКОРП;
	Элементы.ДнейВПути.Видимость = ЭтоКОРП;
	Элементы.FTL.Видимость = ЭтоКОРП;
КонецПроцедуры

#КонецОбласти
