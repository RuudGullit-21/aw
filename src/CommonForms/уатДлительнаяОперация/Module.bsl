
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Если Параметры.Свойство("СтандартнаяКартинка") 
		И Параметры.СтандартнаяКартинка Тогда
		Элементы.ДекорацияДлительнаяОперация.Картинка = БиблиотекаКартинок.ДлительнаяОперация48;
	КонецЕсли;
	
	Если ЗначениеЗаполнено(Параметры.ИдентификаторЗадания) Тогда
		ИдентификаторЗадания = Параметры.ИдентификаторЗадания;
	КонецЕсли;
	
	Элементы.ГруппаПрогресс.ТекущаяСтраница = Элементы.БезПрогресса;
	
	ТекстСтатуса = НСтр("en='Please wait...';ru='Пожалуйста, подождите...'");
	
КонецПроцедуры

&НаКлиенте
Процедура ПриЗакрытии(ЗавершениеРаботы)
	
	Если Не ЗавершениеРаботы Тогда 
		ПриЗакрытииНаСервере()
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОповещения(ИмяСобытия, Параметр, Источник)
	
	Если ИмяСобытия = "ПоказатьПрогрессДлительнойОперации" Тогда
		Элементы.ГруппаПрогресс.ТекущаяСтраница = Элементы.СПрогрессом;
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура ОтменитьВыполнение(Команда)
	
	Закрыть(Новый Структура("ОтменитьВыполнение"));
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура ПриЗакрытииНаСервере()
	
	Если ЗначениеЗаполнено(ИдентификаторЗадания) Тогда 
		ДлительныеОперации.ОтменитьВыполнениеЗадания(ИдентификаторЗадания);
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти
