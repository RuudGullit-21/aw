
#Область ОбработчикиСобытийФормы

&НаКлиенте
Процедура ПередЗаписью(Отказ, ПараметрыЗаписи)
	
	Если НЕ ЗначениеЗаполнено(Объект.Родитель) Тогда
	    Сообщение 		= Новый СообщениеПользователю();
	    Сообщение.Текст = "Не заполнена группа для элемента справочника!";
	    Сообщение.Сообщить();
		Отказ = Истина;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.Индекс) И Объект.Индекс <> 0 Тогда
	    Сообщение 		= Новый СообщениеПользователю();
	    Сообщение.Текст = "Не заполнен индекс!";
	    Сообщение.Сообщить();
		Отказ = Истина;
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если ЗначениеЗаполнено(Объект.Родитель) Тогда
		Объект.Индекс = Объект.Родитель.Индекс;
	КонецЕсли;
			
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура РодительПриИзменении(Элемент)
	
	РодительПриИзмененииНаСервере();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура РодительПриИзмененииНаСервере()
	
	Если ЗначениеЗаполнено(Объект.Родитель) Тогда
		Объект.Индекс = Объект.Родитель.Индекс;
	КонецЕсли;

КонецПроцедуры

#КонецОбласти
