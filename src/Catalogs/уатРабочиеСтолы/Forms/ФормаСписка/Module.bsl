
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	уатЗащищенныеФункцииСервер.уатДокументФормаСпискаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ЭтотОбъект, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	ОбщегоНазначенияКлиентСервер.УстановитьПараметрДинамическогоСписка(Список, "ЭтоКОРП", уатОбщегоНазначенияПовтИсп.ВариантПоставкиКОРП());

КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	уатЗащищенныеФункцииКлиент.уатДокументФормаСпискаПриОткрытии(Отказ, ЭтотОбъект, ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти


#Область ОбработчикиСобытийЭлементовТаблицыФормы

&НаКлиенте
Процедура СписокПриИзменении(Элемент)
	ТекДанные = Элементы.Список.ТекущиеДанные;
	Если Не ТекДанные = Неопределено Тогда
		Оповестить("РабочиеСтолы_Запись", ТекДанные.Ссылка);
	КонецЕсли;
КонецПроцедуры

#КонецОбласти
