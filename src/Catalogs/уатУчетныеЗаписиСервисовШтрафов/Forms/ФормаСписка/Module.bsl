#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	уатЗащищенныеФункцииСервер.уатСправочникФормаСпискаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	уатЗащищенныеФункцииКлиент.уатСправочникФормаСпискаПриОткрытии(Отказ, ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти