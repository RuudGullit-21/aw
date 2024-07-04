#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	уатЗащищенныеФункцииСервер.уатРегистрФормаСпискаПриСозданииНаСервере(Отказ, СтандартнаяОбработка,ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	стрНастройкиМобильногоПриложения = уатМобильноеПриложениеВодителяСерверПовтИсп.ПолучитьНастройкиМобильногоПриложения();
	Элементы.ИспользоватьПутевыеЛисты.Видимость    = стрНастройкиМобильногоПриложения.useWaybills;
	Элементы.ИспользоватьМаршрутныеЛисты.Видимость = стрНастройкиМобильногоПриложения.useRouteLists;
	Элементы.ИспользоватьЗаявкиНаРемонт.Видимость  = стрНастройкиМобильногоПриложения.useOrdersForRepair;
	Элементы.ИспользоватьЧат.Видимость             = стрНастройкиМобильногоПриложения.useChat;

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	уатЗащищенныеФункцииКлиент.уатРегистрФормаСпискаПриОткрытии(Отказ, ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
