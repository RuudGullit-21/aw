
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	уатЗащищенныеФункцииСервер.уатСправочникФормаЭлементаПриСозданииНаСервере(Отказ, СтандартнаяОбработка, Объект, ЭтотОбъект, ДопПараметрыОткрытие);
	Если Отказ тогда
		Возврат;
	КонецЕсли;
	
	Если Не Объект.Ссылка.Пустая() Тогда
		Если Объект.Ссылка = Справочники.уатТипыАгрегатов.Аккумулятор Или 
			Объект.Ссылка = Справочники.уатТипыАгрегатов.Аптечка Или 
			Объект.Ссылка = Справочники.уатТипыАгрегатов.Шина Тогда
			Элементы.ПараметрВыработки.Видимость = Ложь;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	уатЗащищенныеФункцииКлиент.уатСправочникФормаЭлементаПриОткрытии(Отказ, ДопПараметрыОткрытие);
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
КонецПроцедуры

#КонецОбласти