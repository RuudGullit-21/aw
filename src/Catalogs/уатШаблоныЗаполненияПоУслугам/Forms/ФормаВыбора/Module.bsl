
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	уатЗащищенныеФункцииСервер.уатСправочникФормаСпискаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	ВариантПоставкиСТД  = уатОбщегоНазначенияПовтИсп.ВариантПоставкиСТД();
	ВариантПоставкиПРОФ = уатОбщегоНазначенияПовтИсп.ВариантПоставкиПРОФ();
	Если ВариантПоставкиСТД Тогда
		Элементы.ИспользоватьДанныеЗаказПеревозчику.Видимость = Ложь;
		Элементы.ИспользоватьДанныеМаршрутныйЛист.Видимость   = Ложь;
	КонецЕсли;
	Если ВариантПоставкиСТД Или ВариантПоставкиПРОФ Тогда
		Элементы.ИспользоватьДанныеРекламаций.Видимость       = Ложь;
	КонецЕсли;
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ВариантПоставкиСТД", ВариантПоставкиСТД);
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	уатЗащищенныеФункцииКлиент.уатСправочникФормаСпискаПриОткрытии(Отказ, ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
